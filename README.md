```markdown
# Photo Capturing App 📸

A Flutter application for capturing and saving photos with comments.

## Features

- **Photo Capture** - Use device camera
- **Local Storage** - Photos saved to device storage  
- **Comments** - Add text to each photo
- **Timestamps** - Automatic date and time tracking
- **Photo Management** - View and delete saved photos

## Tech Stack

- Flutter SDK
- Camera - Camera functionality
- Shared Preferences - Local storage
- HTTP - Server upload

## Installation

```bash
git clone https://github.com/Rujiani/photo_capturing.git
cd photo_capturing
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── home_page.dart         # Main screen
├── main_page.dart         # Camera screen
├── api_service.dart       # API communication
└── photo_repository.dart  # Local storage
```

## Usage

1. Launch the app
2. Navigate to camera screen
3. Take a photo
4. Add a comment
5. Save or upload to server

## API

Update the API URL in `api_service.dart`:

```dart
Uri.parse('https://your-api.com/upload_photo/')
```
