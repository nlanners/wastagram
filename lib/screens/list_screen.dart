import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'detail_screen.dart';
import 'new_post.dart';






class ListScreen extends StatefulWidget {
  const ListScreen({ Key? key }) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Wastagram'))
      ),
      body: listBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: createFAB(context)
    );
  }


  Widget createFAB(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.post_add),
        onPressed: () async {
          File image = await getImage();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => NewPost(image: image,))
            )
          );
        },
      );
  }

  Future<File> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
    
  }

  Widget listBody(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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

  Widget createListView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var post = snapshot.data!.docs[index];
        return createListTile(context, post);
      },
    );
  }

  Widget createListTile(BuildContext context, post) {
    return ListTile(
      title: Text(post['date']),
      subtitle: Text(post['quantity'].toString()),
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

}
