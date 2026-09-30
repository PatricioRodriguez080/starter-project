# Flutter Frontend
In this folder are all the [Flutter](https://docs.flutter.dev/) related files.
This folder is essentially the app and what the user sees. 
It has a dependency to the backend which ensures that there is data consistency.
You will be doing most of your work in this folder.

## Getting Started
Before you can run the app, you will need to add the Firebase options file to this project.
To do this, follow these steps:
1. Complete the [backend tutorial](../backend/README.md) to create a Firebase project which satisfies the requirements
2. Watch this [tutorial to setup Firebase for Flutter](https://youtu.be/Wa0rdbb53I8?list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC).
Nowadays the Firebase options file is generated with the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup):
`flutterfire configure --project=<your-project-id> --platforms=android`
(it creates `lib/firebase_options.dart` and `android/app/google-services.json`).

Once you have completed this appropriately, you can start to work with the project.

### Requirements
- Flutter (tested with Flutter 3.47.5 / Dart 3.13.4)
- Java 17 (required by the Android Gradle Plugin)

### Install the Project Dependencies (in pubspec.yaml)
`flutter pub get`
### Generate files for the local database (Floor):
`dart run build_runner build --delete-conflicting-outputs`
### Icons
The Android launcher icons are already included in `android/app/src/main/res/mipmap-*`, so no icons need to be generated.
(`flutter_launcher_icons` is not a dependency of this project.)

### How can I best understand this project?
In order to best understand this project and its underlying intricacies, we recommend that you watch this tutorial: [Flutter Clean Architecture Tutorial](https://www.youtube.com/watch?v=7V_P6dovixg).
This tutorial **literally builds this project from the ground up** so we really recommend you watch it before developing.

Furthermore, we will now leave the index of this project with all the documentation that must be read before contributing to the frontend.

# Index
1. [Contribution Guidelines](../docs/CONTRIBUTION_GUIDELINES.md)
2. [Architecture Violations](../docs/ARCHITECTURE_VIOLATIONS.md)
3. [Code Quality Violations](../docs/CODING_GUIDELINES.md)
4. [Our App Architecture](../docs/APP_ARCHITECTURE.md)
