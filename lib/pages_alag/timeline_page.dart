
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/service_and_classes/post.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';


final usersRef = Firestore.instance.collection("users");
final timelineRef = Firestore.instance.collection("timeline");
final followingRef = Firestore.instance.collection("followings");
//Offset offset = Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.84);
final activityFeedRef = Firestore.instance.collection("feeds");
final commentRef = Firestore.instance.collection("comments");
final requestRef = Firestore.instance.collection("requests");
final followerRef = Firestore.instance.collection("followers");

class Timeline extends StatefulWidget {
  final String currentUserId;
 
  Timeline({this.currentUserId});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Post> post = [];
  List<String> fullname = [];
  List<String> username = [];
  //List<String> location = [];
  List<String> postId = [];
  List<String> postUrl = [];
  List<String> userId = [];
  int tIndex = 0;
  bool isLoading = false;
  List<String> postLocation = [];
  // bool _visible = true;
 // var visiblity = Visible().visiblity;
 QuerySnapshot snapshot1;
 SvgPicture menuSvg = SvgPicture.asset("assets/images/menu.svg");

  @override
  void initState() { 
    super.initState();
    getTimeline();
  }

  getTimeline()async{
    setState(() {
      isLoading = true;
    });
    snapshot1 = await followingRef.document(widget.currentUserId).collection("usersFollowing").getDocuments();
    QuerySnapshot snapshot = await timelineRef.document(widget.currentUserId).collection("timelinePost").orderBy("timestamp", descending: true).getDocuments();
    post = await snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    await snapshot.documents.forEach((doc) async{
      fullname?.add(doc['fullName']);
      username?.add(doc['username']);
      //location.add(doc['location']);
      postId?.add(doc['postId']);
      postLocation.add(doc['location']);
      postUrl?.add(doc['postUrl']);
      userId?.add(doc['ownerId']);
    });
    print(fullname);
    print(postId);
    print(postUrl); 
    setState(() {
      isLoading = false;
    });
  }


  buildTimeline(){
      return FutureBuilder(
        future: usersRef.document(widget.currentUserId).get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Shimmer.fromColors(
              baseColor: Colors.grey[500].withOpacity(0.1),
              highlightColor: Colors.grey[500].withOpacity(0.3),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.014,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.014,
                        color: Colors.grey,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                        child: Container(
                          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0556),
                          height: MediaQuery.of(context).size.height * 0.845,
                          width: MediaQuery.of(context).size.width * 0.93,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(39)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            );
          }
          User user = User.fromDocument(snapshot.data);
          return post.isEmpty ? Container(
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
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      GestureDetector(
                        onTap: () => Navigator.push(context, PageTransition(child: ProfilePage1(isEditing: false, isProfileOwner: true, profileOfCurrentUserId: widget.currentUserId,), type: PageTransitionType.fade)),
                        child: Text(user.username,
                        style: TextStyle(color: Colors.white, 
                            fontSize: ResponsiveFlutter.of(context).fontSize(3),)),
                      ),
                      Text(user.location ?? "your location",
                      style: TextStyle(color: Colors.white, 
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),)),
                      Container(
                        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0556),
                        height: MediaQuery.of(context).size.height * 0.845,
                        width: MediaQuery.of(context).size.width * 0.93,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(39),
                          backgroundBlendMode: BlendMode.lighten,
                          color: Colors.white,
                          boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 15),
                                        blurRadius: 20,
                                            ),
                                    ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            snapshot1.documents.length == 0 ? Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                              child: AutoSizeText("Alright! Lets start by finding some firends 😁. Click on the menu button to search",
                                style: TextStyle(
                                  fontFamily: "Helvetica",
                                  fontSize: ResponsiveFlutter.of(context).fontSize(3),
                                  fontWeight: FontWeight.w500
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ) : SvgPicture.asset("assets/images/No_feed.svg",
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Stack(
            children: [
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                  GestureDetector(
                    onTap: () => Navigator.push(context, PageTransition(child: ProfilePage1(profileOfCurrentUserId: userId[tIndex],isProfileOwner: (userId[tIndex] == widget.currentUserId), isEditing: false,), type: PageTransitionType.fade, duration: Duration(milliseconds: 300))),
                    child: Text(username[tIndex],style: TextStyle(color: Colors.white, 
                    fontSize: ResponsiveFlutter.of(context).fontSize(3),))),
                    
                  //Text(location[usernameIndex], style: TextStyle(color: Colors.white),),
                 Text(postLocation[tIndex] ?? postId[tIndex], style: TextStyle(color: Colors.white),),

                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                    child: CarouselSlider(
                      // carouselController: _carouselController,
                        options: CarouselOptions(
                          onScrolled: (val){
                            setState(() {
                              tIndex = val.toInt();
                            });
                          },
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height * 1.2,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          // autoPlayInterval: Duration(seconds: 10),
                        ),
                        items: post,
                      ),
                  )
                  
                ],
        ),
              ),
            ],
          ); 
        }, 
      );
  }
  
 //CarouselController _carouselController = new CarouselController();
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        //backgroundColor: Color(0xff363637),
        body: RefreshIndicator(
          onRefresh: () => getTimeline(),
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
            child: Center(
              child: SafeArea(
              child: Stack(
                children: [
                  buildTimeline(),
                  bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.8),),
                  
                  // Positioned(
                  //   bottom: MediaQuery.of(context).size.height * 0.3,
                  //   left: MediaQuery.of(context).size.width * 0.04,
                  //   child: GestureDetector(
                  //     onVerticalDragUpdate: (details){
                  //       int sensitivity = 2;
                  //       if(details.delta.dy > sensitivity){

                  //       }
                  //     },
                  //     onHorizontalDragUpdate: (details){
                  //       // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                  //       int sensitivity = 8;
                  //       if (details.delta.dx > sensitivity) {
                  //         // Right Swipe
                  //         _carouselController.previousPage();
                            
                  //       } else if(details.delta.dx < -sensitivity){
                  //           //Left Swipe
                  //           _carouselController.nextPage();
                            
                  //       }
                  //     },
                  //     onTap: (){
                  //       setState(() {
                  //         _visible = !_visible;
                  //       });
                  //     },
                  //     child: Container(
                  //       height: MediaQuery.of(context).size.height * 0.27,
                  //       width: MediaQuery.of(context).size.width * 0.92,
                  //       color: Colors.transparent,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )),
          ),
        )
        
      ),
    );
  }
}
