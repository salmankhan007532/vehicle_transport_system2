import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_transport_system2/screens/vehical_details_screen.dart';
import 'package:vehicle_transport_system2/screens/search_screen.dart';
import 'package:vehicle_transport_system2/widgets/n_drawer.dart';

import '../models/vehical.dart';
import 'landing_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng pshLatLng = const LatLng(34.0151, 71.5249);
  List<Vehical> vehical = [];

  static const CameraPosition peshawar = CameraPosition(
    target: LatLng(34.0151, 71.5249),
    zoom: 10.4746,
  );

  Set<Marker> markers = {};
  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  double latitude = 0.0;
  double longitude = 0.0;

  Future getAllHostels() async {
    DatabaseReference hostelRef =
        FirebaseDatabase.instance.ref().child('vehical');
    var snapshot = await hostelRef.once();
    var vehicalSnapshot = snapshot.snapshot.value;

    if (vehicalSnapshot == null) {
      print('***********************************');
      print('No vehical');
      return;
    }

    var vehicalFullMap = Map<String, dynamic>.from(vehicalSnapshot as Map);

    for (var vehicalMap in vehicalFullMap.values) {
      markers.add(Marker(
        markerId: MarkerId('${vehicalMap['vehicallId']}'),
        position: LatLng(vehicalMap['latitude'], vehicalMap['longitude']),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icon/marker.png'),
        infoWindow: InfoWindow(
            title: '${vehicalMap['VehicalName']}',
            onTap: () {
              Vehical hostel = Vehical.fromMap(Map<String, dynamic>.from(vehicalMap));
              //Fluttertoast.showToast(msg: hostel.ownerName);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return VehicalDetailsScreen(vehical: hostel);
              }));
            }),
      ));

      Vehical vehicall = Vehical.fromMap(Map<String, dynamic>.from(vehicalMap));
      vehical.add(vehicall);
    }

    print(vehical.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    getAllHostels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NDrawer(),

      appBar: AppBar(
        title: const Text('Vehical'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return SearchScreen(vehical:vehical);
            }));
          }, icon: const Icon(Icons.search),),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Confirmation !!!'),
                        content: const Text('Are you sure to Log Out ? '),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop();

                              await FirebaseAuth.instance.signOut();
                              SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                              await sharedPrefs.clear();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const LandingScreen();
                              }));
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: GoogleMap(
        //mapType: MapType.hybrid,
        initialCameraPosition: peshawar,
        markers: markers,
        //{
        //    Marker(markerId: MarkerId('unique'), position: pshLatLng,
        //    infoWindow: InfoWindow(title: 'Peshawar', snippet: 'Current Location')
        //    ),
        // },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _gpsService();
    }

    permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );

    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      Fluttertoast.showToast(msg: 'No permissions granted');
      return;
    }

    final position = await _geoLocatorPlatform.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    print('**********************************');
    print('Latitude $latitude');
    print('Longitude $longitude');
    print('**********************************');

    markers.add(Marker(
      markerId: const MarkerId('current location'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(title: 'Current Location'),
      // TODO: place a custom icon
    ));

    CameraPosition currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 12.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    setState(() {});
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await _geoLocatorPlatform.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Can't get current location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    const AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                    _gpsService();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  /*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await _geoLocatorPlatform.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else {
      return true;
    }
  }
}
