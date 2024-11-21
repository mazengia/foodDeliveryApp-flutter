import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  RestaurantDetailsPage({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurantId)),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('restaurants').doc(restaurantId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var restaurantData = snapshot.data?.data() as Map<String, dynamic>;

          return Column(
            children: [
              Text('Address: ${restaurantData['address']}'),
              Expanded(
                child: ListView.builder(
                  itemCount: restaurantData['menu'].length,
                  itemBuilder: (context, index) {
                    var item = restaurantData['menu'][index];
                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Text('${item['price']}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
