import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles.dart';


class DetailScreen extends StatelessWidget {
  const DetailScreen({ Key? key, required this.post }) : super(key: key);

  final QueryDocumentSnapshot post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasteagram'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            date(post['date']),
            postImage(post['imageURL'], context),
            quantity(post['quantity']),
            location(post['latitude'], post['longitude'])
          ],
        ),
      )
    );
  }

  Widget postImage(String url, BuildContext context){
    return Semantics(
      image: true,
      label: 'Image of food waste',
      child: Image.network(
        url,
        height: photoHeight(context)
      ),
    );
  }

  Widget date(dateTime) {
    return Semantics(
      header: true,
      label: 'Date of post',
      child: Text(
        DateFormat('E, MMM. d, y').format(DateTime.parse(dateTime)),
        style: Styles.titleText
        ),
    );
  }

  Widget location(lat, long) {
    return Semantics(
      label: 'Location of post',
      child: Text(
        'Location: {$lat, $long}',
        style: Styles.subtitleText,
        ),
    );
  }

  Widget quantity(quant) {
    return Semantics(
      label: 'Quantity of food waste',
      child: Text(
        'Quantity: ${quant.toString()}',
        style: Styles.headerLarge
      ),
    );
  }

  double photoHeight(context) {
    return 2 * MediaQuery.of(context).size.height / 5;  
  }
  

}