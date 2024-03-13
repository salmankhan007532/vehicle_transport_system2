import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:vehicle_transport_system2/models/facility.dart';
import 'package:vehicle_transport_system2/models/vehical.dart';
import 'package:vehicle_transport_system2/utils/constants.dart';

import '../utils/network_connection.dart';

class AddVehicalScreen extends StatefulWidget {
  const AddVehicalScreen({Key? key}) : super(key: key);

  @override
  State<AddVehicalScreen> createState() => _AddVehicalScreenState();
}

class _AddVehicalScreenState extends State<AddVehicalScreen> {
  late TextEditingController _vehicalNoController,
      _contactController,
      _vehicalNameController,
      _ownerNameController,
      _availableSeatsController,
      _rentController,
      _totalSeatsController;

  String facilities = '';
  bool imagePicked = false;
  File? imageFile;
  List<File>? imageFiles;

  List<Facility> facilitiesList = [
    Facility(name: 'WiFi', value: false),
    Facility(name: 'AC', value: false),
    Facility(name: 'Heater', value: false),
    Facility(name: 'Music', value: false),
    Facility(name: 'No', value: false),
  ];

  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;

  double latitude = 0.0;
  double longitude = 0.0;
  List<Object> photos = [];

  @override
  void initState() {
    super.initState();
    _vehicalNoController = TextEditingController();
    _contactController = TextEditingController();
    _vehicalNameController = TextEditingController();
    _ownerNameController = TextEditingController();
    _availableSeatsController = TextEditingController();
    _rentController = TextEditingController();
    _totalSeatsController = TextEditingController();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _vehicalNoController.dispose();
    _contactController.dispose();
    _vehicalNameController.dispose();
    _availableSeatsController.dispose();
    _rentController.dispose();
    _totalSeatsController.dispose();
  }

  _pickMultiplesImages() async {
    List<XFile>? xFiles = await ImagePicker().pickMultiImage();

    if (xFiles.isEmpty) return;

    imageFiles = [];
    for (var xFile in xFiles) {
      imageFiles?.add(File(xFile.path));
    }

    imagePicked = true;
    setState(() {});

  }

  _pickImageFrom({required ImageSource source}) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    imagePicked = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehical Record'),
      ),
      body: Container(
        height: double.infinity,
            width: double.infinity,
            decoration:  const BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Constants.bluecolor1, Constants.bluecolor2],
            ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Vehical Details',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _vehicalNoController,
                  decoration: InputDecoration(
                      hintText: 'Enter Vehical No',
                      labelText: 'Vehical No',
                      prefixIcon: const Icon(Icons.house),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _vehicalNameController,
                  decoration: InputDecoration(
                      hintText: 'Enter Vehical Name',
                      labelText: 'Vehical Name',
                      prefixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(
                      hintText: 'Enter Owner Name',
                      labelText: 'Driver Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  controller: _contactController,
                  decoration: InputDecoration(
                      hintText: 'Enter Contact Number',
                      labelText: 'Contact No',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _availableSeatsController,
                  decoration: InputDecoration(
                      hintText: 'Enter Available Seats',
                      labelText: 'Seats Available',
                      prefixIcon: const Icon(Icons.bed),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _rentController,
                  decoration: InputDecoration(
                      hintText: 'Enter Rent per Seat',
                      labelText: 'Seat Rent',
                      prefixIcon: const Icon(Icons.format_align_justify),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Facilities'),
                                  content: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height:
                                        MediaQuery.of(context).size.height * 0.5,
                                    margin: const EdgeInsets.all(20),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return ListView.builder(
                                            itemCount: facilitiesList.length,
                                            itemBuilder: (context, index) {
                                              //Facility facility = facilitiesList[index];
        
                                              return CheckboxListTile(
                                                  title: Text(
                                                      facilitiesList[index].name),
                                                  value:
                                                      facilitiesList[index].value,
                                                  onChanged: (isChecked) {
                                                    print(isChecked);
                                                    setState(() {
                                                      facilitiesList[index]
                                                          .value = isChecked!;
                                                    });
                                                  });
                                            });
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
        
                                          setState(() {
                                            facilities = '';
                                            for (var facility in facilitiesList) {
                                              if (facility.value) {
                                                facilities += '${facility.name},';
                                              }
                                            }
                                          });
                                        },
                                        child: const Text('CANCEL')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
        
                                          setState(() {
                                            facilities = '';
                                            for (var facility in facilitiesList) {
                                              if (facility.value) {
                                                facilities += '${facility.name},';
                                              }
                                            }
                                          });
                                        },
                                        child: const Text('OK')),
                                  ],
                                );
                              });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Facilities'),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(child: Text(facilities)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _totalSeatsController,
                  decoration: InputDecoration(
                      hintText: 'Enter Total Seats',
                      labelText: 'Total Seats',
                      prefixIcon: const Icon(Icons.roofing),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _pickMultiplesImages();
                          },
                          child: const Text('Vehical Photo - Tap to Select')),
                      const SizedBox(
                        height: 10,
                      ),
                      imagePicked == false
                          ? const SizedBox.shrink()
                          : Expanded(
                            child: GridView.builder(
                                itemCount: imageFiles!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return Image.file(imageFiles![index], fit: BoxFit.cover,);
                                }),
                          )
                      /* GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.photo,
                                      ),
                                      title: const Text('From Gallery'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _pickImageFrom(
                                            source: ImageSource.gallery);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.camera_alt,
                                      ),
                                      title: const Text('From Camera'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _pickImageFrom(
                                            source: ImageSource.camera);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: imagePicked
                            ? Image.file(
                                imageFile!,
                                width: double.infinity,
                                height: 110,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.jpeg',
                                width: double.infinity,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                      ) */
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (validate()) {
                          if (await NetworkConnection.isNotConnected()) {
                            Fluttertoast.showToast(
                                msg:
                                    'You are Offline\nConnect to Internet and try again');
                            return;
                          }
        
                          ProgressDialog progressDialog = ProgressDialog(
                            context,
                            title: const Text('Saving'),
                            message: const Text('Please wait'),
                          );
        
                          progressDialog.show();
        
                          // upload images to storage
                          try {
                            // var fileName = DateTime.now().toIso8601String();
                            //
                            // UploadTask uploadTask = FirebaseStorage.instance
                            //     .ref()
                            //     .child('hostel_images')
                            //     .child(fileName)
                            //     .putFile(imageFile!);
                            //
                            // TaskSnapshot snapshot = await uploadTask;
                            // String hostelPhotoUrl =
                            //     await snapshot.ref.getDownloadURL();
                            // print(hostelPhotoUrl);
        
        
                            await Future.forEach(imageFiles!, (File image) async {
        
                              var fileName = 'vehical${Random().nextInt(1000000)}';
        
                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child('vehical')
                                  .child(fileName);
                              final UploadTask uploadTask = ref.putFile(image);
                              final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                              final url = await taskSnapshot.ref.getDownloadURL();
                              photos.add(url);
                            });
        
                            print(photos);
        
                            // Save Hostel record in RTDB
        
                            DatabaseReference vehicalReference =
                                FirebaseDatabase.instance.ref().child('vehical');
                            String? hostelId = vehicalReference.push().key;
        
                            if (hostelId == null) {
                              Fluttertoast.showToast(
                                  msg: 'Something went wrong, try again',
                                  backgroundColor: Colors.red);
                              return;
                            }
        
                            Vehical vehical = Vehical(
                              vehicalId: hostelId,
                              vehicalNum: _vehicalNoController.text.trim(),
                              vehicalName: _vehicalNameController.text.trim(),
                              ownerName: _ownerNameController.text.trim(),
                              ownerId: FirebaseAuth.instance.currentUser!.uid,
                              contactNum: _contactController.text.trim(),
                              availableSeats:
                                  _availableSeatsController.text.trim(),
                              seatRent: _rentController.text.trim(),
                              facilities: facilities,
                              totalseats: _totalSeatsController.text.trim(),
                              photos: photos,
                              latitude: latitude,
                              longitude: longitude,
                            );
        
                            await vehicalReference
                                .child(hostelId)
                                .set(vehical.toMap());
        
                            Fluttertoast.showToast(
                                msg: 'Vehical Record Saved',
                                backgroundColor: Colors.green);
                            progressDialog.dismiss();
                            Navigator.of(context).pop();
                          } catch (e) {
                            progressDialog.dismiss();
        
                            print(e.toString());
                          }
                        }
                      },
                      child: const Text('Add')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    var vehicalNum = _vehicalNoController.text.trim();
    String vehicalName = _vehicalNameController.text.trim();
    String ownerName = _ownerNameController.text.trim();
    String contactNum = _contactController.text.trim();
    String seatsAvailable = _availableSeatsController.text.trim();
    String rentPerSeat = _rentController.text.trim();
    String totaSeats = _totalSeatsController.text.trim();

    if (vehicalNum.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide Vehical no', backgroundColor: Colors.red);
      return false;
    }
    if (vehicalName.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide Vehical no', backgroundColor: Colors.red);
      return false;
    }

    if (ownerName.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide owner name', backgroundColor: Colors.red);
      return false;
    }

    if (contactNum.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide contact number', backgroundColor: Colors.red);
      return false;
    }

    if (seatsAvailable.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide available seats', backgroundColor: Colors.red);
      return false;
    }

    if (rentPerSeat.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide rent per seat', backgroundColor: Colors.red);
      return false;
    }

    if (totaSeats.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide total Seats', backgroundColor: Colors.red);
      return false;
    }

    RegExp regExp = RegExp(r'[0-9]');
    if (vehicalNum.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide Vehical no', backgroundColor: Colors.red);
      return false;
    }

    if (ownerName.contains(regExp)) {
      Fluttertoast.showToast(
          msg: 'Invalid Drivr Name', backgroundColor: Colors.red);
      return false;
    }

    if (contactNum.length < 11) {
      Fluttertoast.showToast(
          msg: 'Invalid contact no', backgroundColor: Colors.red);
      return false;
    }

    if (imageFiles == null) {
      Fluttertoast.showToast(
          msg: 'Please Select Vehical Photo', backgroundColor: Colors.red);
      return false;
    }

    if (latitude == 0.0 || longitude == 0.0) {
      Fluttertoast.showToast(
          msg: 'Vehical Location Not Available, Try Again Later',
          backgroundColor: Colors.red);
      return false;
    }

    return true;
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
