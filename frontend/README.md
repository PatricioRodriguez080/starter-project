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

### Running the app with the Firebase Local Emulator Suite
The journalists' articles are stored in Firestore and their thumbnails in Cloud Storage. Since Cloud Storage requires
the Blaze plan on a real Firebase project (see [backend/README.md](../backend/README.md)), the app connects to the
**Firebase Local Emulator Suite by default**:
1. Start the emulators from the `backend` folder: `npm run emulators` (the data is kept between runs).
2. With the Android emulator (or a phone over USB) running: `npm run android:connect` (from the `backend` folder;
   it runs `adb reverse` for Firestore and Storage). On the Android emulator, FlutterFire already reaches the
   emulators of this computer, but this is still needed to load the thumbnails created by `npm run seed`
   (their URLs point to 127.0.0.1); on a phone it is always needed. Run it again every time the device restarts.
3. Run the app: `flutter run` (or `flutter run --release` to record videos: the debug build is slower).

Options (`--dart-define`):
- `USE_FIREBASE_EMULATORS=false`: use the real Firebase project instead of the emulators (Cloud Storage requires Blaze).
- `FIREBASE_EMULATORS_HOST=<ip>`: reach emulators running on another computer of the network.

### How can I best understand this project?
In order to best understand this project and its underlying intricacies, we recommend that you watch this tutorial: [Flutter Clean Architecture Tutorial](https://www.youtube.com/watch?v=7V_P6dovixg).
This tutorial **literally builds this project from the ground up** so we really recommend you watch it before developing.

Furthermore, we will now leave the index of this project with all the documentation that must be read before contributing to the frontend.

# Index
1. [Contribution Guidelines](../docs/CONTRIBUTION_GUIDELINES.md)
2. [Architecture Violations](../docs/ARCHITECTURE_VIOLATIONS.md)
3. [Code Quality Violations](../docs/CODING_GUIDELINES.md)
4. [Our App Architecture](../docs/APP_ARCHITECTURE.md)
