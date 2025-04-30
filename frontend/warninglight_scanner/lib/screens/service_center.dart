// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// const String googleAPIKey = "YOUR_GOOGLE_MAPS_API_KEY";

// class ServiceCenterMapPage extends StatefulWidget {
//   @override
//   _ServiceCenterMapPageState createState() => _ServiceCenterMapPageState();
// }

// class _ServiceCenterMapPageState extends State<ServiceCenterMapPage> {
//   Completer<GoogleMapController> _controller = Completer();
//   LatLng _currentLocation = LatLng(0, 0);
//   final Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     _currentLocation = LatLng(position.latitude, position.longitude);

//     _loadNearbyServiceCenters();

//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 14));
//   }

//   Future<void> _loadNearbyServiceCenters() async {
//     String url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation.latitude},${_currentLocation.longitude}&radius=5000&type=car_repair&key=$googleAPIKey';

//     final response = await http.get(Uri.parse(url));
//     final data = json.decode(response.body);

//     if (data["status"] == "OK") {
//       List results = data["results"];
//       setState(() {
//         _markers.clear();
//         for (var place in results) {
//           LatLng location = LatLng(place["geometry"]["location"]["lat"],
//               place["geometry"]["location"]["lng"]);
//           _markers.add(Marker(
//               markerId: MarkerId(place["place_id"]),
//               position: location,
//               infoWindow: InfoWindow(title: place["name"])));
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Nearby Service Centers")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLocation,
//           zoom: 14,
//         ),
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: _markers,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }
