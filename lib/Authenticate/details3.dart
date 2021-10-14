
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttershare/pages/profile_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:uuid/uuid.dart';


final _auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser;

final StorageReference storageRef = FirebaseStorage.instance.ref();

class Details3 extends StatefulWidget {
  @override
  _Details3State createState() => _Details3State();
}

class _Details3State extends State<Details3> {
  bool isUploading = false;
  File file;
  String formatAddress;
  bool isDownloading = false;
  bool isLoading = false;
  var uuid = Uuid();
  final usersRef = Firestore.instance.collection("users");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String selfieUrl;


@override
void initState() { 
  super.initState();
  updateUserInFirestore();
}

updateUserInFirestore()async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentSnapshot doc = await usersRef.document(user.uid).get();

  if(doc.exists)  {
    // navigate further details library
    // modal route for multiple arguments
    final ScreenArguments arg = ModalRoute.of(context).settings.arguments;
    
    // set initial data gathered from signup process to newly created user

   await usersRef.document(user.uid).updateData({
      "aadharNumber" : arg.aadharNumber,
      "aadharUrl" : arg.aadharUrl,
    });
  }
  }

  handleSubmit()async{
    setState(() {
      isUploading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    StorageUploadTask uploadTask = storageRef.child("SELFIE").child("selfie_${uuid.v4()}_${user.uid}.jpg").putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    setState(() {
      selfieUrl = downloadUrl;
      isUploading = false;
    });
    print(selfieUrl);
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Color(0xff363637),
      body: SafeArea(
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
                child: Stack(
            children: [
                // isLoading ? Positioned.fill(
                //   child: Container(
                //     color: Colors.black.withOpacity(0.3),
                //     child: Center(child: CircularProgressIndicator(),)),
                // ) : Text(''),
                Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                        AutoSizeText(
                          'KRIB',
                          style: TextStyle(
                            fontFamily: 'Lovelo-LineLight',
                            fontSize: 18,
                            color: const Color(0xffffffff),
                            letterSpacing: -0.36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AutoSizeText(
                          'Somewhere on Internet',
                          style: TextStyle(
                            fontFamily: 'SFProText-Semibold',
                            fontSize: 10,
                            color: const Color(0xffffffff),
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                   margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.015, 0,0),
                      height: MediaQuery.of(context).size.height * 0.87,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                color: const Color(0xff000000),
                offset: Offset(0, 15),
                blurRadius: 20,
                                ),
                        ],
                        
                      ),
                      
                    )
            ],
          ),
        ),
        ),
        
     Positioned(
        left: MediaQuery.of(context).size.width * 0.1,
        top: MediaQuery.of(context).size.height * 0.12,
        right: MediaQuery.of(context).size.width * 0.1,
         child: AutoSizeText.rich(
    TextSpan(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
          color: const Color(0xff5c5a5a),
          letterSpacing: 0.24,
        ),
        children: [
          TextSpan(
            text: 'Last step, please smile \nfor a ',
            style: TextStyle(
                fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'selfie',
            style: TextStyle(
                color: const Color(0xffe33846),
                fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '. This for \n',
            style: TextStyle(
                fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'verification',
            style: TextStyle(
                color: const Color(0xffe33846),
                fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' purposes.\n ',
            style: TextStyle(
                fontWeight: FontWeight.w600,
            ),
          ),
        ],
    ),
    
    textAlign: TextAlign.left,
  ),
     ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height * 0.3,
          right: MediaQuery.of(context).size.width * 0.1,
          child: file == null && !isUploading? initialContainer() : loadingContainer(),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width * 0.1,
          bottom: MediaQuery.of(context).size.height * 0.08,
            child: FloatingActionButton(
            onPressed: isUploading ? (){}: ()async{
              setState(() {
                isDownloading = true;
              });
                if(file != null && !isUploading){
                FirebaseUser user =  await _auth.currentUser();
                // await createUserInFirestore();
                Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
                Placemark placemark = placemarks[0];
                String formattedAddress = "${placemark.locality}, ${placemark.country}";
                formatAddress = formattedAddress;
                print(formatAddress);
                usersRef.document(user.uid).updateData({
                    "location" : formatAddress != null ? formatAddress : "Your Location",
                  });
                  setState(() {
                  isDownloading = false;
                });
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProfilePage(profileId: user.uid), settings: RouteSettings(arguments: ScreenArguments(selfieUrl: selfieUrl))));
                }
                
                if(file == null){
                  setState(() {
                    isDownloading = false;
                  });
                  SnackBar snackbar = SnackBar(
                    elevation: 30,
                    content: Container(
                      color: Colors.black,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
                        child: Text("Please upload your Selfie", style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica Neue",
                          fontSize: 16,
                        ),
                        )
                        )
                        ),
                    backgroundColor: Color(0x422c2c2c),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                }
            },
            child: isDownloading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_forward_ios, color: Colors.black,),
            backgroundColor: Color(0xFFFC9F48),
            heroTag: "btn1",
            ),
        ),

        Positioned(
          left: MediaQuery.of(context).size.width * 0.1,
          bottom: MediaQuery.of(context).size.height * 0.08,
                  child: FloatingActionButton(
                  
            onPressed: (){
                Navigator.pop(context, PageTransition(child: null, type: PageTransitionType.fade));
                },
            child: isDownloading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
            backgroundColor: Color(0xFFFC9F48),
            heroTag: "btn2",
            ),
        )
        
        
            ],
          ),
              ),
      ),
    );
  }

   loadingContainer(){
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: DottedBorder(
        strokeWidth: 1,
        dashPattern: [10, 4],
        color: Color(0xff707070),
        borderType: BorderType.RRect,
        radius: Radius.circular(35),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(35)),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: isUploading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,): ListView(
                      children: [
                        ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(35),
                              ),
                              child: Image(
                                height: MediaQuery.of(context).size.height * 0.34,
                                image: FileImage(file),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                        Center(child: AutoSizeText("  selfie uploaded :)",style: TextStyle(fontSize: 25),)),
                      ],
                    ),
        ),
                ),
            ),
      ),
    );
  }

  initialContainer(){
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: DottedBorder(
        strokeWidth: 1,
        dashPattern: [10, 4],
        color: Color(0xff707070),
        borderType: BorderType.RRect,
        radius: Radius.circular(35),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(35)),
                child: GestureDetector(
                  onTap: ()async{
                    File file = await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                      this.file = file;
                    });
                    handleSubmit();
                  },
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.38,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/details3.png"), fit: BoxFit.cover)),
                    
        ),
                                ),
                ),
            ),
      ),
    );
  }
}
