import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMapPage extends StatefulWidget {
  @override
  _RestaurantMapPageState createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();

  @override
  void initState() {
    super.initState();
    _loadRestaurantLocations();
  }

  void _loadRestaurantLocations() async {
    FirebaseFirestore.instance.collection('restaurants').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var location = doc['location'];
        _markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: doc['name']),
        ));
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.4219999, -122.0840575), // Set the initial map position
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
