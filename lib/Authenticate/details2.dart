import 'dart:io';
import 'dart:ui';
import 'package:adobe_xd/adobe_xd.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/Welcome/welcome_page2.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'details3.dart';


class Details2 extends StatefulWidget {
  @override
  _Details2State createState() => _Details2State();
}

class _Details2State extends State<Details2> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  var uuid = Uuid();
  final usersRef = Firestore.instance.collection("users");
  String downloadUrl1;
  bool isDownloading = false;
  bool isUploading = false;
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

    usersRef.document(user.uid).updateData({
      
      "fullName" : arg.fullName,
      "dob" : arg.dob,
      "gender" : arg.gender,
      
    });
  }
  }


  handleSubmit()async{
    setState(() {
      isUploading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageUploadTask uploadTask = storageRef.child("AADHAR CARD").child("${user.uid}.jpg").putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    setState(() {
      downloadUrl1 = downloadUrl;
      isUploading = false;
    });
    print(downloadUrl1);
  }

  String aadharNumber;

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff363637),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
            children: [
                Container(
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
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                        AutoSizeText(
                          'KRIB',
                          maxLines: 1,
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
                          maxLines: 1,
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
          top: MediaQuery.of(context).size.height * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: AutoSizeText.rich(
    TextSpan(
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveFlutter.of(context).fontSize(2.9),
            color: const Color(0xff5c5a5a),
            letterSpacing: 0.24,
        ),
        children: [
            TextSpan(
              text: 'Moving on, please upload \n',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'Aadhaar Card',
              style: TextStyle(
                  color: const Color(0xffe33846),
                  fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' photo and \nwrite its number.\n ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
              ),
            ),
        ],
    ),
    
    textAlign: TextAlign.left,
  ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height * 0.25,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Form(
            key: _formKey,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (val){
                  if(val.isEmpty){
                    return ("Please enter your Aadhar Number");
                  }
                },
                  onChanged: (val){
                    
                      this.aadharNumber = val;
                  
                          },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFC9F48))
                  ),
                    hintText: "Aadhar Number",
                    hintStyle: TextStyle(
                        color: Color(0xffbcb8b8),
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: file == null && !isUploading ? initialContainer():loadingContainer() 
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          right: MediaQuery.of(context).size.width * 0.1,
                  child: FloatingActionButton(
                  
            onPressed: isUploading ? (){}: ()async{
                setState(() {
                  isDownloading = true;
                });
                if(file != null && !isUploading){
                  if(_formKey.currentState.validate() ){
                    setState(() {
                      isDownloading = false;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => Details3(), transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child,),transitionDuration: Duration(milliseconds: 300), settings: RouteSettings(arguments: ScreenArguments(aadharUrl: downloadUrl1, aadharNumber: aadharNumber))));
                  
                }
                }
                setState(() {
                  isDownloading = false;
                });
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
                        child: Text("Please upload an image of your Aadhar Card", style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica Neue",
                          fontSize: 16,
                        ),))),
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
          bottom: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width * 0.1,
                  child: FloatingActionButton(
                  
            onPressed: (){
                Navigator.pop(context, PageTransition(child: null, type: PageTransitionType.fade));
                },
            child: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
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
                        Center(child: AutoSizeText("aadhar uploaded :)",maxLines: 1,style: TextStyle(fontSize: 25),)),
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
                    FocusManager.instance.primaryFocus?.unfocus();
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
                        image: DecorationImage(image: AssetImage("assets/images/details2.png"), fit: BoxFit.cover)),
                    
        ),
                                ),
                ),
            ),
      ),
    );
  }
}
