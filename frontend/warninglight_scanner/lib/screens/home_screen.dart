import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warninglight_scanner/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Handle the captured image (e.g., display it, upload it, etc.)
      print("Image captured: ${photo.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SCAN HERE"),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30.0,
              fontWeight: FontWeight.w900,
              color: lightColorScheme.primary,
            ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _openCamera,
          icon: const Icon(Icons.camera_alt),
          label: const Text("CLICK"),
          // Remove manual styling to use the theme's ElevatedButtonTheme
        ),
      ),
    );
  }
}