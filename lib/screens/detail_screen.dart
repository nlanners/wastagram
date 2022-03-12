import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DetailScreen extends StatelessWidget {
  const DetailScreen({ Key? key, required this.post }) : super(key: key);

  final QueryDocumentSnapshot post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['date'])
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(post['imageURL']),
            Text('Quantity: ${post['quantity'].toString()}'),
            Text(
              'Location: {${post['latitude'].toString()}, ${post['longitude']}}'
              ),
          ],
        ),
      )
    );
  }
}