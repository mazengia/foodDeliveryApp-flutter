 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'getCurrentLocation.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  List<Map<String, dynamic>> nearbyRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  void _loadUserLocation() async {
    Position position = await getCurrentLocation();
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });

    // Query restaurants from Firestore
    _getNearbyRestaurants();
  }

  void _getNearbyRestaurants() async {
    FirebaseFirestore.instance
        .collection('restaurants')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        double distance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          doc['location'].latitude,
          doc['location'].longitude,
        );
        if (distance <= 5000) {
          // Filter restaurants within 5 km
          setState(() {
            nearbyRestaurants.add({
              'name': doc['name'],
              'address': doc['address'],
              'distance': (distance / 1000).toStringAsFixed(2) + " km",
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Restaurants')),
      body: ListView.builder(
        itemCount: nearbyRestaurants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(nearbyRestaurants[index]['name']),
            subtitle: Text('Distance: ${nearbyRestaurants[index]['distance']}'),
            onTap: () {
              // Navigate to restaurant details or order page
            },
          );
        },
      ),
    );
  }
}
