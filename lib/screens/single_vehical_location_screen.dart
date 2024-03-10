import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_transport_system2/models/vehical.dart';

class SingleVehicalLocationScreen extends StatefulWidget {
  final Vehical vehical;

  const SingleVehicalLocationScreen({Key? key, required this.vehical})
      : super(key: key);

  @override
  State<SingleVehicalLocationScreen> createState() =>
      _SingleVehicalLocationScreenState();
}

class _SingleVehicalLocationScreenState
    extends State<SingleVehicalLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng vehicalLatLng = const LatLng(34.0151, 71.5249);

  static CameraPosition vehicalCameraPosition = const CameraPosition(
    target: LatLng(34.0151, 71.5249),
    zoom: 14.4746,
  );


  @override
  void initState() {
    super.initState();
    vehicalLatLng = LatLng(widget.vehical.latitude, widget.vehical.longitude);
    vehicalCameraPosition = CameraPosition(target: vehicalLatLng, zoom: 14.4746);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehical.vehicalName),
      ),
      body: GoogleMap(
        initialCameraPosition: vehicalCameraPosition,
        markers: {
          Marker(
              markerId: MarkerId(widget.vehical.vehicalId),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              position: vehicalLatLng,
              infoWindow: InfoWindow(
                  title: widget.vehical.vehicalName,
                  snippet: widget.vehical.vehicalNum)),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }


}
