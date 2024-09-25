# notes_manager

A cross-platform mobile application for efficient task management, developed using both Flutter and React Native frameworks.

## Overview

This Task Management App is part of a comparative study between Flutter and React Native for small-scale mobile application development. The app allows users to create, edit, organize, and delete tasks with offline capabilities.

## Features

- Create, edit, and delete tasks
- Categorize tasks and set priorities
- Offline functionality with local data storage
- File attachment support for tasks
- Search and filter tasks
- Dark mode support
- Cross-platform compatibility (iOS and Android)

## Technologies Used

### Flutter Version
- Dart programming language
- Flutter SDK
- sqflite for local database
- Provider for state management

## Installation

### Flutter Version

1. Ensure you have Flutter installed on your machine
2. Clone the repository
3. Navigate to the Flutter project directory
4. Run `flutter pub get` to install dependencies
5. Connect a device or start an emulator
6. Run `flutter run` to start the app

## Project Structure

Both versions of the app follow the MVVM (Model-View-ViewModel) architecture pattern:

- `models/`: Contains data models (e.g., Task)
- `screens/`: UI components and screens
- `services/`: Business logic and data operations
- `utils/`: Utility functions and helpers

## Testing

The project includes unit, integration, and performance tests for both Flutter and React Native versions. To run the tests:

### Flutter
```
flutter test
```

### React Native
```
npm test
```
## Contributing

Contributions to improve the app or extend the comparison study are welcome. Please feel free to submit issues or pull requests.

## Acknowledgements

This project was developed as part of an MSc Software Engineering dissertation, comparing Flutter and React Native for small-scale mobile application development.

## Contact

Praise Ojerinola - Ojerinolapraise@gmail.com

Project Link: [https://github.com/praiseojay/task-management-app](https://github.com/praiseOjay/notes_manager.git)
