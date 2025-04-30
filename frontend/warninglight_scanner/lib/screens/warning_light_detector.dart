import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'result.dart'; // Add this import

class WarningLightDetector extends StatefulWidget {
  const WarningLightDetector({Key? key}) : super(key: key);

  @override
  State<WarningLightDetector> createState() => _WarningLightDetectorState();
}

class _WarningLightDetectorState extends State<WarningLightDetector> {
  File? _image;
  String? _result;
  bool _loading = false;

  // Method to capture image from camera
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = null;
      });
      // Process the image automatically after capture
      _uploadImage();
    }
  }

  // Add methods for car brand selection and service center directions
  void _showCarBrandDialog(BuildContext context) {
    // Indian car brands
    final brands = [
      'Maruti Suzuki', 
      'Hyundai', 
      'Tata Motors', 
      'Mahindra', 
      'Honda', 
      'Toyota', 
      'Kia', 
      'MG', 
      'Skoda', 
      'Volkswagen',
      'Other'
    ];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Engine Overheating Detected'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Which car brand do you own?'),
                const SizedBox(height: 16),
                ...brands.map((brand) => ListTile(
                  title: Text(brand),
                  onTap: () {
                    Navigator.pop(context);
                    _showNearbyDealers(context, brand);
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNearbyDealers(BuildContext context, String brand) {
    // Service center data for common cities in India
    // In a real app, this would come from an API based on user's location
    final Map<String, Map<String, String>> cityDealers = {
      'Delhi': {
        'Maruti Suzuki': 'Nexa Dealership, Connaught Place',
        'Hyundai': 'Hyundai Capital, Karol Bagh',
        'Tata Motors': 'Tata Landmark Showroom, Lajpat Nagar',
        'Toyota': 'Toyota Lexus Delhi, South Extension',
      },
      'Mumbai': {
        'Maruti Suzuki': 'Vitesse Nexa, Andheri West',
        'Hyundai': 'Hyundai Shreenath, Goregaon',
        'Honda': 'Honda Aryan, Worli',
        'Toyota': 'Toyota Lakozy, Santacruz',
      },
      'Bangalore': {
        'Maruti Suzuki': 'Nexa Pratham Motors, Indiranagar',
        'Hyundai': 'Trident Hyundai, Electronic City',
        'Tata Motors': 'KHT Tata, Marathahalli',
        'Mahindra': 'PPS Mahindra, Whitefield',
      },
      'Chennai': {
        'Maruti Suzuki': 'ABT Maruti, Anna Nagar',
        'Hyundai': 'Hyundai Paramount, Guindy',
        'Honda': 'Landmark Honda, OMR Road',
        'Toyota': 'Harsha Toyota, Velachery',
      },
    };

    // Cities to show
    final cities = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai', 'Other'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Your City'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose your city to find nearby $brand dealers:'),
                const SizedBox(height: 16),
                ...cities.map((city) => ListTile(
                  title: Text(city),
                  onTap: () {
                    Navigator.pop(context);
                    if (city == 'Other') {
                      _openDealerWebsite(context, brand);
                    } else {
                      _showDealerDetails(context, brand, city, cityDealers[city]?[brand]);
                    }
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDealerDetails(BuildContext context, String brand, String city, String? dealerName) {
    final dealerAddress = dealerName ?? 'Nearest $brand Dealer';
    final mapQuery = Uri.encodeComponent('$dealerAddress in $city, India');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$brand Dealer in $city'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dealer: ${dealerName ?? 'Search for nearest dealer'}'),
              const SizedBox(height: 16),
              const Text('Your engine is overheating. Please visit the nearest service center immediately.'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Get Directions'),
              onPressed: () {
                _launchMaps(mapQuery);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _openDealerWebsite(BuildContext context, String brand) {
    // Official websites for common car brands in India
    final Map<String, String> brandWebsites = {
      'Maruti Suzuki': 'https://www.marutisuzuki.com/dealer-locator',
      'Hyundai': 'https://www.hyundai.com/in/en/find-a-dealer',
      'Tata Motors': 'https://cars.tatamotors.com/dealer-locator',
      'Mahindra': 'https://auto.mahindra.com/dealer-locator',
      'Honda': 'https://www.hondacarindia.com/honda-services/dealer-locator',
      'Toyota': 'https://www.toyotabharat.com/dealer-locator/',
      'Kia': 'https://www.kia.com/in/buy/find-a-dealer.html',
      'MG': 'https://www.mgmotor.co.in/tools/dealer-locator',
      'Skoda': 'https://www.skoda-auto.co.in/dealers',
      'Volkswagen': 'https://www.volkswagen.co.in/en/dealer-search.html',
    };
    
    final website = brandWebsites[brand] ?? 'https://www.google.com/search?q=$brand+dealer+near+me+india';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Find $brand Dealers'),
          content: const Text('Would you like to open the official dealer locator website?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _launchUrl(website);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchMaps(String query) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    setState(() => _loading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.58.28.254:8000/predict/'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        
        try {
          // Parse the JSON response
          final jsonResponse = json.decode(respStr);
          String userFriendlyMessage = '';
          String? detectedClass;
          double? confidence;
          
          if (jsonResponse['result'] == 'success' && 
              jsonResponse['detections'] != null && 
              jsonResponse['detections'].isNotEmpty) {
            
            detectedClass = jsonResponse['detections'][0]['class'];
            confidence = jsonResponse['detections'][0]['confidence'];
            
            // Check if confidence is below threshold
            if (confidence == null || confidence < 0.60) {
              userFriendlyMessage = 'No Warning Sign Detected, Please Scan a clear Image.';
              detectedClass = null;
            } else {
              // Custom messages based on detection class
              switch (detectedClass) {
                case 'battery':
                  userFriendlyMessage = "Your vehicle's battery condition is weak or there may be a problem with regenerative charging. Please check the battery and its connections, or drive to the nearest battery store or service station.";
                  break;
                case 'check_engine':
                  userFriendlyMessage = 'Check engine light detected. Your vehicle needs maintenance soon. This light could indicate various issues from minor problems like a loose gas cap to more serious engine issues. It\'s recommended to get your vehicle diagnosed at a service center.';
                  break;
                case 'airbag':
                  userFriendlyMessage = 'Airbag warning detected. Your vehicle\'s safety systems may be compromised. This warning should not be ignored as it indicates a fault in the airbag system. Please have your vehicle inspected by a certified technician immediately.';
                  break;
                case 'oil':
                  userFriendlyMessage = 'Low oil pressure detected. Stop driving immediately and check oil levels. Continuing to drive with this warning light on can cause severe engine damage. If oil levels are normal, there may be an issue with the oil pump or pressure sensor.';
                  break;
                case 'lowfuel':
                  userFriendlyMessage = 'Your car is running out of fuel. Please refill the car with the respective fuel as soon as possible. Running on extremely low fuel levels can damage the fuel pump and may cause your vehicle to stop unexpectedly.';
                  break;
                case 'temperature':
                case 'enginehot':  
                  userFriendlyMessage = 'Engine overheating detected. Pull over safely and let the engine cool down. Do not open the radiator cap until the engine has completely cooled. Check coolant levels when safe to do so. This could indicate low coolant, a cooling system leak, or a malfunctioning thermostat.';
                  break;
                default:
                  userFriendlyMessage = 'Warning light detected: $detectedClass. Please consult your vehicle manual for specific information about this warning.';
              }
            }
          } else {
            userFriendlyMessage = 'No warning lights detected.';
          }
          
          setState(() => _loading = false);
          
          // Navigate to result screen instead of updating current screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetectionResultScreen(
                resultMessage: userFriendlyMessage,
                image: _image,
                detectedClass: detectedClass,
                confidence: confidence,
              ),
            ),
          );
          
        } catch (e) {
          setState(() {
            _loading = false;
            _result = 'Error parsing result: $e';
          });
        }
      } else {
        setState(() {
          _loading = false;
          _result = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _result = 'Connection error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method remains unchanged
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Warning Light Detector',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 223, 173, 65),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 223, 173, 65),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Base color
          image: DecorationImage(
            image: const AssetImage('assets/images/interior.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7), // Adjust opacity here (0.0-1.0)
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Camera capture button
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scan Here'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                // Show image preview if available
                if (_image != null)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 223, 173, 65),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "Captured Image",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 223, 173, 65),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 220,
                            height: 220,
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Show loading indicator or result
                if (_loading)
                  const CircularProgressIndicator()
                else if (_result != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _result!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}