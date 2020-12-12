import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'my_app.dart';
import 'user_email_create.dart';
import 'welcome.dart';
import 'welcome_location_get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StartingApp());
}

class StartingApp extends StatelessWidget {
  const StartingApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getUserPosition(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Welcome()
              : snapshot.data
                  ? WelcomeLocationGet()
                  : MyApp();
        },
      ),
    );
  }
}

Future<bool> getUserPosition() async {
  // Check Geo Permisions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return null;
  } else if (permission == LocationPermission.denied) {
    // Request Geo Permisions
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    // Check if service enable
    bool isLocationServiceEnabled;
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      await Geolocator.getCurrentPosition();
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    // Recheck service
    if (isLocationServiceEnabled) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
