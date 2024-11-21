import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'RestaurantDetailsPage.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  List<Map<String, dynamic>> nearbyRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  void _loadUserLocation() async {
    Position position = await _getCurrentLocation();
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });

    _getNearbyRestaurants();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _getNearbyRestaurants() async {
    FirebaseFirestore.instance.collection('restaurants').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        double distance = Geolocator.distanceBetween(
          userLatitude, userLongitude,
          doc['location'].latitude, doc['location'].longitude,
        );
        if (distance <= 5000) { // Only show restaurants within 5 km
          setState(() {
            nearbyRestaurants.add({
              'name': doc['name'],
              'address': doc['address'],
              'distance': (distance / 1000).toStringAsFixed(2) + ' km',
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
              // Navigate to restaurant details page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantDetailsPage(restaurantId: nearbyRestaurants[index]['name'])),
              );
            },
          );
        },
      ),
    );
  }
}
