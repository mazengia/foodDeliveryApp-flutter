import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() => _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  double latitude = 37.4219999;  // Default, replace with actual data.
  double longitude = -122.0840575; // Default, replace with actual data.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerRestaurant() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Save restaurant data in Firestore
      await _firestore.collection('restaurants').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'location': GeoPoint(latitude, longitude),
        'owner_id': user.uid,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Restaurant Registered!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please login first')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Your Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Restaurant Name')),
            TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Restaurant Address')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerRestaurant,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
