import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages_alag/camera_screen.dart';
import 'package:fluttershare/pages_alag/preview_screen1.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:uuid/uuid.dart';

class PreviewImageScreen extends StatefulWidget {
  final File imageFile;
  final bool isProfileEdit;
  final String currentUserId;
  final String fullName;
  PreviewImageScreen({this.imageFile, this.isProfileEdit, this.currentUserId, this.fullName});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {

  DateTime timestamp = DateTime.now();
  String postId = Uuid().v4();
  StorageReference storageRef = FirebaseStorage.instance.ref();
  bool isUploading =false;
  bool isLoading = false;
  String formatAddress = '';
  String description;
  bool isShowing = false;

  @override
  void initState() { 
    super.initState();
    getLocation();
  }

  getLocation()async{
    setState(() {
      isLoading = true;
    });
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    
    setState(() {
      formatAddress = formattedAddress;
      isLoading = false;

    print(formatAddress);
    });
  }
    updateProfilePic(postUrl){
    usersRef.document(widget.currentUserId).updateData({
      "photoUrl" : postUrl,
    });
  }

createPostInFirestore({String postUrl, String location, String description }) async {
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    User user = User.fromDocument(doc);
    postRef.document(widget.currentUserId).collection("usersPost")
    .document(postId).setData({
      "postId" : postId,
      "ownerId" : widget.currentUserId,
      "username" : user.username,
      "postUrl" : postUrl,
      "location" : formatAddress,
      "description" : description,
      "timestamp" : timestamp,
      "likes" : {},
      "dislike" : {},
      "saves" : {},
      "commentCount" : 0,
    });
  }

    handleSubmit(context)async{
    String postUrl = await uploadImage(widget.imageFile);
    widget.isProfileEdit ? await updateProfilePic(postUrl) : await createPostInFirestore(
      postUrl : postUrl,
      
      location: formatAddress,
      description: description,
    );
    //descriptionController.clear()
    //locationController.clear()
    setState(() {
      isUploading = false;
      postId = Uuid().v4();
    });
    
  }

  handleNavigation(context){
    return Navigator.pushReplacement(context, PageTransition(child: widget.isProfileEdit ? ProfilePage1(profileOfCurrentUserId: widget.currentUserId, isProfileOwner: true, isEditing: false,): Timeline(currentUserId: widget.currentUserId), type: PageTransitionType.fade));
  }
   
   
   
   Future<String> uploadImage(imageFile)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageUploadTask uploadTask = storageRef.child("POSTS").child("post_${postId}_${user.uid}.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  showDescription(context){
    setState(() {
      isShowing = true;
    });
  }

  showDescriptionBox(context){
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.058,
      right: MediaQuery.of(context).size.width * 0.058,
      bottom: MediaQuery.of(context).size.height * 0.039,
      child: AnimatedOpacity(
        opacity: isShowing ? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: ClipRRect(
           borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(39),
            ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(38))
              ),
              child: isUploading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CupertinoActivityIndicator(radius: 20,),
              )
              ), 
              ) ,) : Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.04),
                        child: TextFormField(
                          
                          onChanged: (val){
                            setState(() {
                              this.description = val.toString();
                            });
                          },
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Add Description ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: GradientButton(
                        increaseHeightBy: 10,
                        gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff1C6CAD),
                                  Color(0xff20425E),
                                ]
                              ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(38)),),
                        child: Text("Publish", style: TextStyle(
                            color: Colors.white,
                            
                            fontWeight: FontWeight.w400,
                            fontSize: 20
                          ),),
                        callback: ()async{
                          
                          setState(() {
                            isUploading = true;
                          });
                          await handleSubmit(context);
                          Navigator.pop(context);
                          handleNavigation(context);
                        },
                      ),
                    ),
                  ],
                ),
      ),
          ),
        ),
    )
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return !isUploading;
      },
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:  isUploading ? Text("") : IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 35,),
                        onPressed: () => Navigator.pushReplacement(context, PageTransition(child: CameraScreen(currentUserId: widget.currentUserId, isProfileEdit: widget.isProfileEdit,), type: PageTransitionType.fade)),
                      ),
                      centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.fullName, style: TextStyle(color: Colors.white, 
                                  fontSize: ResponsiveFlutter.of(context).fontSize(3),)
                                  ),
              Text(formatAddress, style: TextStyle(color: Colors.white, 
                                fontSize: ResponsiveFlutter.of(context).fontSize(2),)),
            ],
          ),
          backgroundColor: Color(0xff1f1f1f),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.89,
          decoration: BoxDecoration(
            color: Colors.blue,
            
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
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: widget.isProfileEdit ? MediaQuery.of(context).size.height * 0.34 : MediaQuery.of(context).size.height * 0.81,
                  width: MediaQuery.of(context).size.width * 0.88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(39),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000),
                        offset: Offset(0, 15),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(39),
                    child: InteractiveViewer(
                      child: Image.file(widget.imageFile, fit: BoxFit.fitHeight,), 
                      
                      )
                      ),
                )
                ),
                widget.isProfileEdit ? Text("") : showDescriptionBox(context),
            ],
          ),
        ),
        ),
        floatingActionButton: isShowing ? null : FloatingActionButton(
              onPressed:()async{
                if(widget.isProfileEdit && !isUploading){
                  setState(() {
                  isUploading = true;
                });
                  await handleSubmit(context);
                  handleNavigation(context);
                }
                if(!widget.isProfileEdit){
                  showDescription(context);
                }
                },
              child: widget.isProfileEdit && isUploading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CupertinoActivityIndicator(radius: 20,),
              )
              ), 
              ) ,) : Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
              backgroundColor: Color(0xFFFC9F48),
              ),
      ),
    );
  }

}