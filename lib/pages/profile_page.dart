import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/Authenticate/details3.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class ProfilePage extends StatefulWidget {
  final String profileId;

  ProfilePage({this.profileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profilePicId = Uuid().v4();
  bool isUploading = false;// inserted after
  File file;
  bool isUpdating = false;
  double appHeight;

  @override
  void initState() { 
    super.initState();
    updateUserInFirestore();
  }

  updateUserInFirestore()async{
    setState(() {
      isUpdating = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentSnapshot doc = await usersRef.document(user.uid).get();

  if(doc.exists)  {
    // navigate further details library
    // modal route for multiple arguments
    final ScreenArguments arg = ModalRoute.of(context).settings.arguments;
    
    // set initial data gathered from signup process to newly created user

    await usersRef.document(user.uid).updateData({
      "selfieUrl" : arg.selfieUrl,
    });
  }
  setState(() {
    isUpdating = false;
  });
  }


  buildNoRow(int count, String label){
    return SizedBox(
      height: 17,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AutoSizeText(count.toString(), maxLines: 1,style: TextStyle(fontSize: 12, fontFamily: "Poppins",color: Colors.white, fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(left: 2),
            child: AutoSizeText(label, maxLines: 1,style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5), fontFamily: "Poppins",color: Colors.white, fontStyle: FontStyle.italic),),
          )
        ],
      ),
    );
  }
// inserted after
    compressImage()async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedFileImage = File('$path/img_$profilePicId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedFileImage;
    });
  }

Future<String> uploadImage(imageFile)async{
  setState(() {
    isUploading = true;
  });// inserted after
   FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageUploadTask uploadTask = storageRef.child("PROFILE_PICS").child("post_${profilePicId}_${user.uid}.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
intro(){
  return FutureBuilder(
    future: usersRef.document(widget.profileId).get(),
    builder: (context, snapshot){
      if(!snapshot.hasData){
        return Container(
              height: double.maxFinite,
              width: double.maxFinite,
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
              child: Shimmer.fromColors(
          baseColor: Colors.grey[500].withOpacity(0.1),
          highlightColor: Colors.grey[500].withOpacity(0.3),
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),)
                        ),
                ),
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      )

                    ],
                  ),
                ],),

                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(3),
                      height: MediaQuery.of(context).size.height * 0.275,
                      width: MediaQuery.of(context).size.width * 0.084,
                      
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    )),
                )

              ],),
          )
        ),
            );
      }
      User user = User.fromDocument(snapshot.data);
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: appHeight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30)
              )
            ),
            
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.13, left: MediaQuery.of(context).size.width * 0.275),
              title: user.photoUrl == "https://firebasestorage.googleapis.com/v0/b/krib2downgrade.appspot.com/o/Screenshot%202021-08-19%20at%206.57.39%20PM.png?alt=media&token=79a95b0a-8c06-4de1-ac14-9a2e7f6bde99" ? TextButton(
                child: AutoSizeText("Add Profile Pic", 
                style: TextStyle(color: Colors.black),
                maxLines: 1,
                ),
                onPressed: ()async{
                  File file = await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    this.file = file;
                    
                  });
                  await compressImage();// inserted after
                  String profileUrl = await uploadImage(file);
                  usersRef.document(widget.profileId).updateData({
                    "photoUrl" : profileUrl,
                  });
                  // inserted after
                  setState(() {
                    isUploading = false;
                    profilePicId = new Uuid().v4();
                  });
                },
              ) : AutoSizeText(''),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: file == null ? NetworkImage(user.photoUrl) : FileImage(file),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: appHeight, left: MediaQuery.of(context).size.width * 0.055),
                  child: AutoSizeText(user?.username, style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(3),
                    fontWeight: FontWeight.bold,
                    color: user.photoUrl == "https://firebasestorage.googleapis.com/v0/b/krib2downgrade.appspot.com/o/Screenshot%202021-08-19%20at%206.57.39%20PM.png?alt=media&token=79a95b0a-8c06-4de1-ac14-9a2e7f6bde99" ? Colors.black : Colors.white
                  ),
                  maxLines: 1,
                  ),
                ),
              ),
              
            ),

            
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.055, MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.width * 0.055, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(user.location ?? "your location", style: TextStyle(color: Colors.white, fontSize: 15,),),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                               child: AutoSizeText(
                                  user.bio ?? "Bio",
                                   style: TextStyle(
                                  color: Colors.grey[350],
                                  fontFamily: "Poppins", 
                                  fontSize: 8
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ) 
                                )
                            )
                          ]
                              ),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.036,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AutoSizeText("0", style: TextStyle(fontSize: 23, fontFamily: "Poppins",color: Colors.white, fontWeight: FontWeight.bold),),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, bottom: MediaQuery.of(context).size.height * 0.005),
                                    child: AutoSizeText("Followers", style: TextStyle(fontSize: 12, fontFamily: "Poppins",color: Colors.grey[350],),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.036,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AutoSizeText("0", style: TextStyle(fontSize: 23, fontFamily: "Poppins",color: Colors.white, fontWeight: FontWeight.bold),),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, bottom: MediaQuery.of(context).size.height * 0.005),
                                    child: AutoSizeText("Following", style: TextStyle(fontSize: 12, fontFamily: "Poppins",color: Colors.grey[350],),),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ]
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                  child: Center(
                    child: Text("No Post Yet", style: TextStyle(color: Colors.white, fontFamily: "Poppins"),),
                  ),
                ),
              ]
            )
          ),
        ],
      );
    },
    
  );
  
}

  
  @override
  Widget build(BuildContext context) {
    appHeight = MediaQuery.of(context).size.height * 0.31;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xff363637),
        body: Container(
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
          child: Stack(
            children: [
              intro(),
              Positioned(
                bottom: 25,
                right: 15,
                child: FloatingActionButton(onPressed: isUpdating? (){}: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Timeline(currentUserId: widget.profileId)));
                },
                backgroundColor: Color(0xFFFC9F48),
                child: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}



 