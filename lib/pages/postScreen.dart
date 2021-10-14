
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/post.dart';
import 'package:shimmer/shimmer.dart';

class PostScreen extends StatefulWidget {
  final String postUrl;
  final String ownerId;
  final String postId;
  final String profileOfCurrentUserId;
  final bool timelineRef;
  PostScreen({this.postUrl, this.ownerId, this.postId, this.profileOfCurrentUserId,this.timelineRef});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final postRef = Firestore.instance.collection("posts");
  List<Post> post = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() { 
    super.initState();
    widget.timelineRef ? getTimeline() : getPost();
  }

  getPost()async{
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef.document(widget.profileOfCurrentUserId).collection("usersPost").where("postId", isEqualTo: widget.postId).getDocuments();
    setState(() {
      post = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
      isLoading = false;
    });
  }
 
  getTimeline()async{
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef.document(widget.ownerId).collection("usersPost").where("postId", isEqualTo: widget.postId).getDocuments();
    setState(() {
      post = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:  SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff1f1f1f),
                          Color(0xff29323c),
                          // Color(0xff414345),
                          // Color(0xff414345),
                        ]
                      )
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 35,),
              onPressed: () => Navigator.pop(context),
            ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                isLoading ? Shimmer.fromColors(
                baseColor: Colors.grey[500].withOpacity(0.1),
                highlightColor: Colors.grey[500].withOpacity(0.3),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                      height: MediaQuery.of(context).size.height * 0.845,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ) : SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: post,
                ),
        ),
              ],
            ),
          ),
        ),
      )
    );
  }
}