import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_transport_system2/models/vehical.dart';
import 'package:vehicle_transport_system2/screens/vehical_rating_screen.dart';
import 'package:vehicle_transport_system2/screens/single_vehical_location_screen.dart';
import 'package:vehicle_transport_system2/utils/constants.dart';

class VehicalDetailsScreen extends StatefulWidget {
  final Vehical vehical;

  const VehicalDetailsScreen({Key? key, required this.vehical}) : super(key: key);

  @override
  State<VehicalDetailsScreen> createState() => _VehicalDetailsScreenState();
}

class _VehicalDetailsScreenState extends State<VehicalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehical Details'),
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
        child: SingleChildScrollView(
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
              children: widget.vehical.photos
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
                widget.vehical.vehicalName,
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
                  Text(widget.vehical.vehicalNum,
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
                  Text(widget.vehical.vehicalName,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ])),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(children: [
                  const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  const Text(' Driver name: '),
                  Text(widget.vehical.ownerName,
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
                  Text(widget.vehical.contactNum,
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
                  Text(widget.vehical.availableSeats,
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
                  Text(widget.vehical.seatRent,
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
                    child: Text(widget.vehical.facilities,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(children: [
                  const Icon(
                    Icons.house,
                    color: Colors.grey,
                  ),
                  const Text(' Total seats: '),
                  Text(widget.vehical.totalseats,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await launch('tel:${widget.vehical.contactNum}');
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
                        return SingleVehicalLocationScreen(vehical: widget.vehical);
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
                        return VehicalRatingScreen(vehical: widget.vehical);
                      }));
                    },
                    label: const Text('Ratings'),
                    icon: const Icon(Icons.star_rate),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
