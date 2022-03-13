import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../styles.dart';
import 'detail_screen.dart';
import 'new_post.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({ Key? key }) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  final picker = ImagePicker();
  String appTitle = 'Wasteagram';
  num total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      body: listBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        child: createFAB(context),
        button: true,
        enabled: true,
        onTapHint: 'Select an image',
      )
    );
  }
  
  Widget createFAB(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () async {
          File image = await getImage();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => NewPost(image: image, ))
            )
          );
        },
      );
  }

  Widget listBody(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts')
        .orderBy('date', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.docs.isNotEmpty) {
          return createListView(context, snapshot);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget createListView(
    BuildContext context, 
    AsyncSnapshot<QuerySnapshot> snapshot) {
      return ListView.builder(
        
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var post = snapshot.data!.docs[index];
          total += post['quantity'];
          return Semantics(
            child: createListTile(context, post),
            enabled: true,
            link: true,
            onTapHint: 'Opens post details',
            );
        },
      );
    }

  Widget createListTile(BuildContext context, post) {
    var dateTime = DateTime.parse(post['date']);
    String dateTitle = DateFormat('EEEE, MMM. d').format(dateTime);
    
    return ListTile(
      title: Text(dateTitle, style: Styles.normalText),
      trailing: Text(post['quantity'].toString(), style: Styles.trailingText),
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: ((context) => DetailScreen(post: post))
          )
        );
      }
    );
  }

  Future<File> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return File(pickedFile!.path);
  }

}
