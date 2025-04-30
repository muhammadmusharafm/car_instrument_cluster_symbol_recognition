import 'dart:async'; // For TimeoutException
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this for Clipboard
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class DetectionResultScreen extends StatefulWidget {
  final String resultMessage;
  final File? image;
  final String? detectedClass;
  final double? confidence;

  const DetectionResultScreen({
    Key? key, 
    required this.resultMessage, 
    this.image,
    this.detectedClass,
    this.confidence,
  }) : super(key: key);

  @override
  State<DetectionResultScreen> createState() => _DetectionResultScreenState();
}

class _DetectionResultScreenState extends State<DetectionResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detection Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 223, 173, 65),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 223, 173, 65),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.image != null)
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
                          "Scanned Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 223, 173, 65),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          widget.image!,
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              if (widget.detectedClass != null && widget.detectedClass != "unknown")
                Text(
                  "Warning Light Detected: ${widget.detectedClass!.toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 173, 65),
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.resultMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (widget.detectedClass == "temperature" || widget.detectedClass == "enginehot")
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showCarBrandDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 223, 173, 65),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Find Nearby Service Centers"),
                  ),
                ),
              // Add disclaimer at the bottom
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Text(
                  "Disclaimer: This app may occasionally provide inaccurate results. Always consult your vehicle manual or a professional mechanic when in doubt.",
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Implement the car brand dialog
  void _showCarBrandDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Car Brand'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBrandButton(context, 'Maruti Suzuki'),
                _buildBrandButton(context, 'Hyundai'),
                _buildBrandButton(context, 'Tata Motors'),
                _buildBrandButton(context, 'Mahindra'),
                _buildBrandButton(context, 'Honda'),
                _buildBrandButton(context, 'Toyota'),
                _buildBrandButton(context, 'Kia'),
                _buildBrandButton(context, 'Ford'),
                _buildBrandButton(context, 'Volkswagen'),
                _buildBrandButton(context, 'MG'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Create brand buttons that directly launch maps with directions
  Widget _buildBrandButton(BuildContext context, String brand) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 223, 173, 65),
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: () {
          Navigator.pop(context);  // Close brand selection dialog
          _directlyGetDirectionsToServiceCenter(context, brand);
        },
        child: Text(brand),
      ),
    );
  }

  // Direct approach to get directions - doesn't require position first
  Future<void> _directlyGetDirectionsToServiceCenter(BuildContext context, String brand) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Opening maps..."),
            ],
          ),
        );
      },
    );
    
    try {
      // Try multiple URL formats for better compatibility
      final String searchTerm = "$brand authorized service center near me";
      final List<String> urlOptions = [
        // Option 1: Standard Google Maps search
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(searchTerm)}",
        
        // Option 2: Maps app URL scheme (works better on some devices)
        "geo:0,0?q=${Uri.encodeComponent(searchTerm)}",
        
        // Option 3: Direct Google Maps URL
        "https://maps.google.com/maps?q=${Uri.encodeComponent(searchTerm)}"
      ];
      
      // Dismiss loading dialog after a short delay regardless of launch result
      Future.delayed(const Duration(seconds: 2), () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Close loading dialog
        }
      });
      
      // Try each URL option in sequence
      bool launched = false;
      for (final urlString in urlOptions) {
        final Uri uri = Uri.parse(urlString);
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          launched = true;
          break;
        }
      }
      
      if (!launched) {
        // If no option worked, show options dialog
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _showMapFailureOptions(context, brand);
          }
        });
      }
    } catch (e) {
      // Close the loading dialog if there's an error
      Future.delayed(const Duration(seconds: 1), () {
        try {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // Close loading dialog
          }
        } catch (dialogError) {
          // Dialog might already be closed
        }
        
        if (mounted) {
          _showMapFailureOptions(context, brand);
        }
      });
    }
  }

  // Additional method to show options when map launch fails
  void _showMapFailureOptions(BuildContext context, String brand) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Maps Not Opening"),
          content: const Text("We couldn't open maps automatically. Please try one of these options:"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Offer to copy search term to clipboard
                Clipboard.setData(ClipboardData(text: "$brand authorized service center near me"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Search term copied to clipboard"))
                );
              },
              child: const Text("Copy Search Term"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Try opening browser instead
                launchUrl(
                  Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent("$brand authorized service center near me")}"),
                  mode: LaunchMode.externalApplication
                );
              },
              child: const Text("Search in Browser"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}