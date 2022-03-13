import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../models/post_form_dto.dart';

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
  PostFormDTO formValues = PostFormDTO();
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
        title: const Text('New Post')
      ),
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
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()){

          setState(() { _isLoading = true; });

          _formKey.currentState!.save();

          var location = await currentLocation;
          formValues.imageURL = await uploadImage(widget.image);
          formValues.dateTime = DateTime.now();
          formValues.latitude = location.latitude!;
          formValues.longitude = location.longitude!;

          FirebaseFirestore.instance.collection('posts')
            .add(formValues.sendValues());

          Navigator.pop(context);
        }
      },
      child: 
        _isLoading ? const CircularProgressIndicator(color: Colors.white,) : 
          const Icon(Icons.cloud_upload, size: 100, ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        fixedSize: Size(
          MediaQuery.of(context).size.width, 
          MediaQuery.of(context).size.height/6)
      )
    );
    
  }

  Widget enterWastedItems() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Number of Wasted Items'),
      keyboardType: const TextInputType.numberWithOptions(),
      onSaved: (value) {
        formValues.quantity = int.parse(value!);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a quantity';
        } else {
          return null;
        }
      },
    );
  }

  Widget pickedImage() {
    return SizedBox(
      width: 200,
      height: 300,
      child: Image.file(widget.image)
    );
  }

  Widget createForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          pickedImage(),
          enterWastedItems(),
          submitButton()
        ],
      )
    );
  }

}