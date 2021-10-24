import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _initialCameraPosition =
  CameraPosition(target: LatLng(41.015137, 28.979530), zoom: 11.5);
  GoogleMapController? _googleMapController;
  BitmapDescriptor? customMarker;
  List<Marker> allMarkers = [];
  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/icon.png');
  }

  @override
  void initState() {
    super.initState();
    Geolocator.requestPermission();
    getCustomMarker();
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter'da Google Maps Entegrasyonu",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        markers: Set.from(allMarkers),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController control){
          setState(() {
                allMarkers.add(Marker(
                  icon: customMarker!,
                  markerId: MarkerId('myMarker'),
                  draggable: false,
                  onTap: () {
                    print('Marker Tapped');
                  },
                  position: LatLng(41.015137, 28.979530)));
          });
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
