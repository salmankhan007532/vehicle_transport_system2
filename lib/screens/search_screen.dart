import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_transport_system2/screens/single_vehical_location_screen.dart';
import 'package:vehicle_transport_system2/utils/constants.dart';

import '../models/vehical.dart';
import 'vehical_rating_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Vehical> vehical;

  const SearchScreen({Key? key, required this.vehical}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController nameController;
  Vehical? searchedVehical;

  Future searchHostel( String vehicalName) async {
    searchedVehical = null;
    for( var vehical in widget.vehical){
      print(vehicalName);

      if(vehical.vehicalName == vehicalName){
        searchedVehical = vehical;
        print(vehicalName);
        break;
      }
    }
    setState(() {});

    if(searchedVehical == null ){
      Fluttertoast.showToast(msg: 'Not Found');
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Vehical'),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: 'Vehical Name'
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    String hostelName = nameController.text.trim();
                    if(hostelName.isEmpty){
                      Fluttertoast.showToast(msg: 'Please provide Vehical name');
                      return;
                    }
        
                    searchHostel(hostelName);
        
                  }, icon: const Icon(Icons.search))
                ],
              ),
              const SizedBox(height: 10,),
        
              Expanded(child: searchedVehical == null ? const SizedBox.shrink() :
        
              SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageSlideshow(
                        width: double.infinity,
                        height: 300,
                        initialPage: 0,
                        indicatorColor: Colors.white,
                        indicatorBackgroundColor: Colors.grey,
                        autoPlayInterval: 5000,
                        isLoop: true,
                        children: searchedVehical!.photos
                            .map(
                              (e) => GestureDetector(
                            onTap: () {
                              print(e);
                            },
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: e as String,
                              placeholder: (context, url) => const SizedBox.shrink(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      // ClipRRect(
                      //     borderRadius: const BorderRadius.only(
                      //         topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      //     child: Image.network(
                      //       widget.hostel.photos[0] as String,
                      //       width: double.infinity,
                      //       height: 250,
                      //       fit: BoxFit.cover,
                      //     )),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Text(
                          searchedVehical!.vehicalName,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.location_city,
                              color: Colors.grey,
                            ),
                            const Text(' Vehical No: '),
                            Text(searchedVehical!.vehicalNum,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.roofing,
                              color: Colors.grey,
                            ),
                            const Text(' Vehical Name: '),
                            Text(searchedVehical!.vehicalName,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            const Text(' Driver Name: '),
                            Text(searchedVehical!.ownerName,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            const Text(' Contact: '),
                            Text(searchedVehical!.contactNum,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.bed,
                              color: Colors.grey,
                            ),
                            const Text(' Seats Available: '),
                            Text(searchedVehical!.availableSeats,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.done_all,
                              color: Colors.grey,
                            ),
                            const Text(' Seat Rent: '),
                            Text(searchedVehical!.seatRent,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.map,
                              color: Colors.grey,
                            ),
                            const Text(' Facilities: '),
                            Expanded(
                              child: Text(searchedVehical!.facilities,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(children: [
                            const Icon(
                              Icons.house,
                              color: Colors.grey,
                            ),
                            const Text(' Total seats: '),
                            Text(searchedVehical!.totalseats,
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await launch('tel:${searchedVehical!.contactNum}');
                              },
                              label: const Text('Call'),
                              icon: const Icon(Icons.call),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) {
                                      return SingleVehicalLocationScreen(vehical: searchedVehical!);
                                    }));
                                  },
                                  label: const Text('Location'),
                                  icon: const Icon(Icons.location_on),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return VehicalRatingScreen(vehical: searchedVehical!);
                                }));
                              },
                              label: const Text('Ratings'),
                              icon: const Icon(Icons.star_rate),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
              ),
            ],
          ),
        ),
      ),

    );
  }
}
