import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../models/post_form_dto.dart';
import '../styles.dart';

class NewPost extends StatefulWidget {
  const NewPost({ 
    Key? key, 
    required this.image,  
    }) : super(key: key);
  
  final File image;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  final _formKey = GlobalKey<FormState>();
  late int quantity;
  late Future<LocationData> currentLocation;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    currentLocation = retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        centerTitle: true,
      ),
      bottomNavigationBar: submitButton(),
      body: FutureBuilder(
        future: currentLocation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return createForm();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } 
      ),
    );
  }
  
  Future<LocationData> retrieveLocation() async {
    Location location = Location();
    var serviceEnabled = await location.serviceEnabled();
    
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Navigator.pop(context);
      }
    }

    var _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.pop(context);
      }
    }

    return location.getLocation();
  }

  Future<String> uploadImage(image) async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = 
      FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    final url = await storageReference.getDownloadURL();
    return url;
  }

  Widget submitButton() {
    return Semantics(
      button: true,
      onTapHint: 'Submit post',
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()){
    
            setState(() { _isLoading = true; });
    
            _formKey.currentState!.save();
    
            var location = await currentLocation;
            Map<String, dynamic> valueMap = {
              'quantity': quantity,
              'imageURL': await uploadImage(widget.image),
              'date': DateTime.now(),
              'latitude': location.latitude,
              'longitude': location.longitude
            };
            
            PostFormDTO formValues = PostFormDTO.fromMap(valueMap);
    
            FirebaseFirestore.instance.collection('posts')
              .add(formValues.sendValues());
    
            Navigator.pop(context);
          }
        },
        child: 
          _isLoading ? const CircularProgressIndicator(color: Colors.white,) : 
            const Icon(Icons.cloud_upload, size: 100, ),
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(submitButtonHeight())
        )
      ),
    );
    
  }

  Widget enterWastedItems() {
    return Semantics(
      textField: true,
      hint: 'Enter number of items wasted',
      child: SizedBox(
        width: textBoxWidth(),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: Styles.normalText,
          decoration: const InputDecoration(hintText: 'Number of Wasted Items'),
          keyboardType: const TextInputType.numberWithOptions(),
          onSaved: (value) {
            quantity = int.parse(value!);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a quantity';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget pickedImage() {
    Map pickedPhotoSize = photoSize();
    return Semantics(
      child: SizedBox(
        width: pickedPhotoSize['width'],
        height: pickedPhotoSize['height'],
        child: Image.file(widget.image)
      ),
      image: true,
      label: 'Image selected by user'
    );
  }

  Widget createForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(50.0),
          children: [
            pickedImage(),
            SizedBox(height: spacerHeight()),
            enterWastedItems(),
          ],
        ),
      )
    );
  }

  double spacerHeight() {
    return MediaQuery.of(context).size.height / 15;
  }

  Map<String, double> photoSize() {
    return {
      'height': 2 * MediaQuery.of(context).size.height / 5,
      'width': 3 * MediaQuery.of(context).size.width / 5
    };
  }

  double textBoxWidth() {
    return MediaQuery.of(context).size.width / 1.5;
  }

  double submitButtonHeight() {
    return MediaQuery.of(context).size.height / 7;
  }

}