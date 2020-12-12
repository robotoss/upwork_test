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

class StartingApp extends StatefulWidget {
  @override
  _StartingAppState createState() => _StartingAppState();
}

class _StartingAppState extends State<StartingApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserPosition(),
      builder: (context, snapshot) {
        return Builder(
          builder: (context) {
            return MaterialApp(
              home: snapshot.data == null
                  ? Welcome()
                  : snapshot.data
                      ? WelcomeLocationGet()
                      : MyApp(),
            );
          },
        );
      },
    );
  }
}

Future<bool> getUserPosition() async {
  // Check Geo Permisions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return null;
  } else if (permission == LocationPermission.denied) {
    // Запрашиваю разрешение на работу с гео
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    bool isLocationServiceEnabled;
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      await Geolocator.getCurrentPosition();
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    if (isLocationServiceEnabled) {
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 3),
      );
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
