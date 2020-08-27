import 'package:blog_app/views/create_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/services/crud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream blogsStream;
  CrudMethods crudMethods = new CrudMethods();


  Widget BlogList(){
    return Container(
      child: blogsStream != null ? Column(
        children: [
          StreamBuilder(
              stream: blogsStream,
              builder: (context,snapshot){
                return snapshot.data != null ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return BlogsTile(
                        imgUrl:snapshot.data.docs[index].data()['imgUrl'],
                        author: snapshot.data.docs[index].data()['authorName'],
                        title: snapshot.data.docs[index].data()['title'],
                        desc: snapshot.data.docs[index].data()['desc']
                    );
                  },
                ):CircularProgressIndicator();
              }
          )
        ],
      )
          :Container(
          child: CircularProgressIndicator()),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      crudMethods.getData().then((result){
        blogsStream = result;
      });
    });
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
      ),
      body: BlogList(),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
          },
        child: Icon(Icons.add),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


class BlogsTile extends StatelessWidget {
  String imgUrl,author,title,desc;

  BlogsTile({
    @required this.imgUrl,
    @required this.author,
    @required this.title,
    @required this.desc
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: Image.network(imgUrl)
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.2),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title,style:TextStyle(fontSize:50,fontWeight: FontWeight.bold)),
                  Text(desc,style:TextStyle(fontSize:15,fontWeight: FontWeight.bold)),
                  Text(author),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

