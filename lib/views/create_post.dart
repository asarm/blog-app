import 'dart:io';
import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String author,title,desc;
  bool isLoading = false;
  CrudMethods crudMethods = new CrudMethods();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> uploadBlog()async{
    if(_image != null){
      setState(() {
        isLoading = true;
      });
        StorageReference firabaseStorage = FirebaseStorage.instance.ref()
            .child("blogImages")
            .child("${randomAlphaNumeric(9)}.jpg");
        final StorageUploadTask task = firabaseStorage.putFile(_image);

        var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
        print("The url is $downloadUrl");

        Map<String,String> blogMap = {
          "imgUrl":downloadUrl,
          "authorName":author,
          "title":title,
          "desc":desc
        };

        CrudMethods().addData(blogMap).then((value) => Navigator.pop(context));

    }else{}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My",style: TextStyle(
                fontSize: 23
            ),
            ),
            Text("Blog",style: TextStyle(
                fontSize: 23,color: Colors.blue
            ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
              padding:EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.file_upload)
            ),
          )
        ],
      ),
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ):
      Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: _image != null ? Container(
                width:  MediaQuery.of(context).size.width,
                height: 150,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_image,fit: BoxFit.cover,)),
              ) :
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.add_a_photo,color: Colors.black45,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                  decoration: InputDecoration(
                  hintText: "Author",
              ),
                    onChanged: (val){
                      author = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                    onChanged: (val){
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                    onChanged: (val){
                      desc = val;
                    },
                  )
                ],
              ),
              )
          ],
        ),
      ),
    );
  }
}
