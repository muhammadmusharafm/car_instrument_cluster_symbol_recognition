# Warning Light Scanner

## Overview
The Warning Light Scanner is a Flutter mobile application that allows users to upload images for processing. The application communicates with a backend service to analyze the uploaded images and returns prediction results to the user.

## Features
- User-friendly interface for uploading images.
- Integration with device camera and gallery for image selection.
- Display of prediction results after image processing.

## Project Structure
```
warninglight_scanner
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── screens
│   │   ├── home_screen.dart     # Main interface with navigation
│   │   ├── upload_screen.dart   # Screen for image upload
│   │   └── result_screen.dart    # Screen for displaying results
│   ├── widgets
│   │   ├── image_picker_widget.dart  # Widget for image picking
│   │   └── result_display_widget.dart # Widget for displaying results
│   └── services
│       └── api_service.dart     # Service for API calls
├── pubspec.yaml                 # Project configuration
└── README.md                    # Project documentation
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd warninglight_scanner
   ```
3. Install the dependencies:
   ```
   flutter pub get
   ```
4. Initialize Firebase for your project by following the Firebase setup instructions for Flutter.
5. Run the application:
   ```
   flutter run
   ```

## Usage
- Launch the application on your mobile device or emulator.
- Navigate to the upload screen to select an image from your device.
- After selecting an image, submit it for processing.
- View the prediction results on the results screen.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for details.