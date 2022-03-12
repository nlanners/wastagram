import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class NewPost extends StatefulWidget {
  NewPost({ Key? key, required this.image }) : super(key: key);

  File image;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.file(widget.image),
          TextFormField(keyboardType: const TextInputType.numberWithOptions()),
        ],
      )
    );
  }

  void uploadImage(pickedFile) async {
    Reference storageReference = 
      FirebaseStorage.instance.ref().child(basename(pickedFile.path));

    Task uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
      final url = await storageReference.getDownloadURL();
    });
  }
  
}