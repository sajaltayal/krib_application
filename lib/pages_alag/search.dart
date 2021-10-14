import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class Search extends StatefulWidget {
  final String currentUserId;

  Search({this.currentUserId});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search>{
  TextEditingController _textController = new TextEditingController();
  Future<QuerySnapshot> searchResultFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() { 
    _textController.clear();
    super.dispose();
    
  }

  handleSearch(String query){
    Future<QuerySnapshot> usersSearch = usersRef.
    where("username", isGreaterThanOrEqualTo: query).limit(20).
    getDocuments();
  setState(() {
    searchResultFuture = usersSearch;
  });
  }
  searchPage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                child: AutoSizeText.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Search"),
                      TextSpan(text: ".", style: TextStyle(color: Color(0xffb93c5e))),
                    ],
                    style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(8), color: Colors.white,fontFamily: 'Helvetica_Neue', fontWeight: FontWeight.bold),),
                    
                  )
                  
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.04),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  controller: _textController,
                  decoration: InputDecoration(
                    //hintText: "Search your friends",
                    hintStyle: TextStyle(
                      color: Color(0xffdee9f5),
                      fontFamily: "Helvetica Neue"
                    ),
                    fillColor: Color(0xff363637),
                    focusColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/Icon/Search.svg", height: 0, width: 0,),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff707070)),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff707070)),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9))
                    )
                  ),
                  onChanged: handleSearch,
                  maxLines: 1,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.dark,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  buildSearchScreen(){
    print(searchResultFuture);
    return FutureBuilder(
      future: searchResultFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
            child: Center(
              child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CupertinoActivityIndicator(radius: 20,),
              )), ),
            ),
          );
        }
        List<UserResult> searchResult = [];
        snapshot.data.documents.forEach((doc){
          User user = User.fromDocument(doc);
          if(user.uid != widget.currentUserId){
            searchResult.add(UserResult(user));
            if(_textController.text.isEmpty){
              searchResult.clear();
              searchResultFuture = null;
            }
          }
          if(searchResult.isEmpty){
            return SafeArea(
              child: Container(
                height: double.infinity,
                
                child: Column(
                  children: [
                    Text("Discover"),
                    ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(color: Colors.red, height: 20,),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
        print(searchResult.isEmpty);
        return searchResult.isNotEmpty ? Container(
          color: Colors.transparent,
          height: double.maxFinite,
          // color: Color(0xff363637).withOpacity(0.97),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Color(0xff1f1f1f).withOpacity(0.96),
          //         Color(0xff29323c).withOpacity(0.96),
          //       ]
          //     ),
          // ),
          child: ListView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            shrinkWrap: true,
            children: searchResult,
          ),
        ) : Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.transparent,
          //   decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Color(0xff1f1f1f),
          //         Color(0xff29323c),
          //       ]
          //     ),
          // ),
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.height * 0.23 ),
                  child: Center(
                    child: SvgPicture.asset("assets/images/No_Result_Search.svg",
                     alignment: Alignment.center,
                     )),
                )
        );
      },
    );
  }

  buildNoSearch(){
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.017),
                  child: Text("Discover", style: TextStyle(
                    color: Color(0xffdee9f5),
                    fontSize: 40,
                    fontFamily: "Helvetica_Neue"
                  ),
                  
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child:  ProfilePage1(profileOfCurrentUserId: "64jzWAFCyMdy1Dtl5rZoTlbMG0m2", isProfileOwner: (widget.currentUserId == "64jzWAFCyMdy1Dtl5rZoTlbMG0m2") , isEditing: false), ctx: context,duration: Duration(milliseconds: 500)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.05),
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff380036),
                              Color(0xff380036).withOpacity(0.2),
                              Color(0xff0cbada).withOpacity(0.4),
                              Color(0xff0cbada),
                              
                              //Color(0xff),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.035, top: MediaQuery.of(context).size.height * 0.015),
                          child: AutoSizeText.rich(
                            TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Helvetica_Neue",
                                fontSize: 32,
                                decoration: TextDecoration.none,
                              ),
                              
                              children: [
                                TextSpan(
                                  text: "Follow the\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                  )
                                ),
                                TextSpan(
                                  text: "\nKRIB",
                                  style: TextStyle(
                                    fontFamily: "Lovelo-LineLight",
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                  )
                                ),
                              ]
                            ),
                          ),
                        ),
                        
                        ),
                    )
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.01),
                //   child: Text("Curated", style: TextStyle(
                //     color: Color(0xffdee9f5),
                //     fontSize: 40,
                //     fontFamily: "Helvetica_Neue"
                //   ),
                  
                //   ),
                // ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.05),
                //       height: MediaQuery.of(context).size.height * 0.28,
                //       width: MediaQuery.of(context).size.width * 0.35,
                //       decoration: BoxDecoration(
                //         color: Color(0xffdee9f5),
                //         borderRadius: BorderRadius.circular(27),
                //       ),
                      
                //       )
                //   ],
                // ),
                
                
              ],
            ),
          ),
          

        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,
      
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff1f1f1f),
                      Color(0xff29323c),
                    ]
                  )
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      searchPage(),
                      _textController.text.isNotEmpty ?  buildSearchScreen() : buildNoSearch(),
                    ],
                  ),
                ),
                bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.8),)
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  showProfile(context){
    Navigator.push(context, PageTransition(child: ProfilePage1(profileOfCurrentUserId: user.uid, isProfileOwner: false,isEditing: false,), type: PageTransitionType.fade));
  }

  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
// above code also works for the aopoBar too
           FocusManager.instance.primaryFocus?.unfocus();
           
           //FocusScope.of(context).requestFocus(new FocusNode());
            showProfile(context);
          },
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.transparent,
                leading: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(
                       user.photoUrl),
                    backgroundColor: Colors.grey,

                  ),
                ),
                title: AutoSizeText(user.fullName, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Helvetica"),),
                subtitle: AutoSizeText(user.username, style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: "Helvetica"),),
              ),
            ],
          ),

          
        );
    
  }
}