import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_transport_system2/screens/vehical_list_screen.dart';
import 'package:vehicle_transport_system2/screens/landing_screen.dart';
import 'package:vehicle_transport_system2/screens/map_screen.dart';
import 'package:vehicle_transport_system2/utils/constants.dart';

String? userType;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  userType = sharedPreferences.getString(Constants.userType);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LandingScreen()
          : userType == Constants.vehicalOwner
              ? const VehicalsListScreen()
              : const MapScreen(),
    );
  }
}
