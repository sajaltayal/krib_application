import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/library_post.dart' as globals;
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sliding_up_panel/sliding_up_panel.dart';


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String postUrl;
  final String username;

  // final String location;
  final String description;
  final dynamic likes;
  final dynamic dislikes;
  final dynamic saves;
  final int commentCount;
  int trendPercentage;

  Post({this.username, this.likes, this.ownerId, this.postId, this.postUrl, this.dislikes, this.saves, this.description, this.commentCount, this.trendPercentage});

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc["postId"],
      ownerId: doc["ownerId"],
      postUrl: doc["postUrl"],
      username: doc["username"],
      likes: doc["likes"],
      dislikes: doc['dislike'],
      saves: doc["saves"],
      description: doc['description'],
      commentCount: doc['commentCount'],
      trendPercentage: doc['trendPercentage'],
    );
  }

  int getLikeCount(likes){
    if(likes == null){
      return 0;
    }
    // if true
    int count = 0;
    likes.values.forEach((val){
      if(val == true){
        count = count +1;
      }
    });
    return count;
  }

  int getDislikeCount(dislikes){
    if(dislikes == null){
      return 0;
    }
    // if true
    int count = 0;
    dislikes.values.forEach((val){
      if(val == true){
        count = count +1;
      }
    });
    return count;
  }

  int getSaveCount(saves){
    if(saves == null){
      return 0;
    }
    // if true
    int count = 0;
    saves.values.forEach((val){
      if(val == true){
        count = count +1;
      }
    });
    return count;
  }

  int getTrendPercentage(){
    return trendPercentage = ((likes+commentCount+saves-dislikes)/(likes+commentCount+saves-dislikes)) * 100;
  }
  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    postUrl: this.postUrl,
    ownerId: this.ownerId,
    username: this.username,
    description: this.description,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
    dislikes: this.dislikes,
    dislikeCount: getDislikeCount(this.dislikes),
    saves: this.saves,
    savePostCount: getSaveCount(this.saves),
    commentCount: this.commentCount,
    trendPercentage: this.trendPercentage,
  );
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
 bool get wantKeepAlive => true;
  final String postId;
  final String ownerId;
  final String postUrl;
  final String username;
  final String description;
  int commentCount;
  int trendPercentage;
  // final String location;
  // final String description;
  Map likes;
  Map dislikes;
  Map saves;
  int likeCount;
  int savePostCount;
  int dislikeCount;
  bool isLiked;
  bool isDisliked;
  bool isSaved;
  _PostState({this.username, this.likes,this.saves, this.dislikes, this.ownerId, this.description, this.postId, this.postUrl, this.likeCount,this.savePostCount, this.dislikeCount, this.commentCount, this.trendPercentage});
  String currentUserId;

  @override
  void initState() { 
    super.initState();
    getIfLiked();
    getIfDisLiked();
    
  }

  getIfLiked()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState((){
      currentUserId = user.uid;
    });
    DocumentSnapshot doc = await postRef.document(ownerId).collection("usersPost").document(postId).get();
    if(doc.exists){
      if(doc["saves.$currentUserId"] == true){
        isSaved = true;
      }
      else if(doc['saves.$currentUserId'] == false || doc['saves'] == null){
        isSaved  = false;
      }
      else if(doc["likes.$currentUserId"] == true){
        setState(() {
          isLiked = true;
        });
      }
      else if(doc['likes.$currentUserId'] == false || doc['likes'] == null){
        setState(() {
          isLiked = false;
        });
      }
    }
  }

getIfDisLiked()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await postRef.document(ownerId).collection("usersPost").document(postId).get();
    if(doc.exists){
      if(doc["dislike.${user.uid}"] == true){
        setState(() {
          isDisliked = true;
        });
      }
      else if(doc['dislike.${user.uid}'] == false || doc['dislike'] == null){
        setState(() {
          isDisliked = false;
        });
      }
    }
  }

  bool _visible = true;
  final postRef = Firestore.instance.collection("posts");

  TextEditingController commentController = new TextEditingController();
  final DateTime timestamp = DateTime.now();
  //var visiblity = new Visible();
  final scrollController = ScrollController();
  final panelController = PanelController();
  //ScrollController comController = ScrollController();
  buildComments(){
    return StreamBuilder(
      stream: commentRef.document(postId).collection("postComments").orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CupertinoActivityIndicator(radius: 20,),
          )), );
        }
        List<DocumentSnapshot> doc = snapshot.data.documents;
        return Center(
          child: SlidingUpPanel(
            controller: panelController,
            header: GestureDetector(
              onTap: () => panelController.open(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.007,
                width: MediaQuery.of(context).size.width * 0.3,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, left: MediaQuery.of(context).size.width * 0.32) ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[400],
                ),
                ),
            ),
            color: Colors.transparent,
            minHeight: MediaQuery.of(context).size.height * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.7358,
            panelBuilder: (scrollScontroller){
              return Container(              
                child: doc.isEmpty ? Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06, top: MediaQuery.of(context).size.height * 0.1),
                        child: SvgPicture.asset("assets/images/No_comments.svg",
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ),
                    ],
                  ),
                
                  // child: ListView(
                  //   //controller: scrollController,
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   children: [
                  //     ListTile(
                  //       title: Text("No Comments",
                  //       style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 50,
                  //             fontFamily: "Poppins",
                  //           ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ) : Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: ListView(
                   // controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: doc.map((doc) => Column(
                      children: [
                        ListTile(
                          title: Text(doc['username'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 15
                            ),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.004),
                            child: Text(doc['comment'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(doc['commentingUserPhotoUrl']),

                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06),
                            child: Text(
                                    //Jiffy().fromNow(),
                                  timeago.format(doc['timestamp'].toDate()),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  ),
                          ),
                          
                        ),
                        doc.data[commentCount] == doc.data[commentCount] ? Text('') : Divider(
                          indent: MediaQuery.of(context).size.width * 0.03,
                          endIndent: MediaQuery.of(context).size.width * 0.03,
                          color: Colors.white60,
                          
                        ),
                      ],
                    ),).toList(),
                            
                  ),
                ),
              );
            },
          ),
        );
            // SizedBox(
            //   height: 20,
            // ),
          
      },
    );
  }

  deleteComment(){
      
  }

  showComments()async{
    setState(() {
      _commentVisible = !_commentVisible;
      _visible = !_visible;
    });
  }
    

  // showComments(context){
  //   return Padding(
  //     padding: EdgeInsets.all(0),
  //     child: showCommentsPage(context),
  //   );
  // }
  bool _commentVisible = false;
  showCommentsPage(context){
    final textKey = GlobalKey<FormState>();
        return ClipRRect(
        borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(39),
              top: Radius.circular(39),
            ),
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
            child: Container(
          
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(39),
              top: Radius.circular(39),
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: buildComments(),
              ),
              Divider(
                indent: MediaQuery.of(context).size.width * 0.03,
                endIndent: MediaQuery.of(context).size.width * 0.03,
                color: Colors.white60,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                child: ListTile(
                  title: Form(
                    key: textKey,
                    child: TextFormField(
                      
                      //scrollPadding: EdgeInsets.all(8),
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white),
                      controller: commentController,
                      validator: (val){
                        if(val.isEmpty){
                          return "Please add a comment";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelText: "Add a comment",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        )
                      ),
                      
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: (){
                      if(textKey.currentState.validate()){
                        addComment();
                        }
                        },
                    icon: Icon(Icons.send_rounded, color: Colors.white,size: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      );
      
  }
  // showCommentsPage(context){
  //   return Visibility(
  //     visible: _commentVisible,
  //         child: Container(
  //           child: Column(
  //             children: [
  //               Center(
  //                   child: IconButton(
  //                     icon: Icon(Icons.cancel),
  //                     iconSize: 50,
  //                     color: Colors.black.withOpacity(0.6),
  //                     onPressed: (){
  //                       setState(() {
  //                         _commentVisible = !_commentVisible;
  //                         _visible = !_visible;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ClipRRect(
  //       borderRadius: BorderRadius.vertical(
  //                     bottom: Radius.circular(39),
  //                     top: Radius.circular(39),
  //                   ),
  //                 child: BackdropFilter(
  //               filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
  //                   child: Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.black.withOpacity(0.5),
  //                   borderRadius: BorderRadius.vertical(
  //                     bottom: Radius.circular(39),
  //                     top: Radius.circular(39),
  //                   )
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Flexible(
  //                       fit: FlexFit.loose,
  //                       flex: 1,
  //                       child: buildComments(),
  //                     ),
  //                     Divider(
  //                       indent: MediaQuery.of(context).size.width * 0.03,
  //                       endIndent: MediaQuery.of(context).size.width * 0.03,
  //                       color: Colors.white60,
  //                       thickness: 2,
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
  //                       child: ListTile(
  //                         title: TextFormField(
  //                           //scrollPadding: EdgeInsets.all(8),
  //                           controller: commentController,
  //                           decoration: InputDecoration(
  //                             hintText: "Add a comment",
  //                             hintStyle: TextStyle(
  //                               color: Colors.white,
  //                             )
  //                           ),
                            
  //                         ),
  //                         trailing: IconButton(
  //                           onPressed: addComment,
  //                           icon: Icon(Icons.smart_button, color: Colors.white,),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //       ),
  //     ),
  //             ],
  //           ),
  //         ),
  //   );
  // }

  addComment()async{

    DocumentSnapshot doc = await usersRef.document(currentUserId).get();
    commentRef.document(postId).collection("postComments").add({
      "username" : doc["username"],
      "comment" : commentController.text,
      "commentingUserPhotoUrl" : doc["photoUrl"],
      "userId": currentUserId,
      "timestamp" : timestamp,
    });
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner){
      activityFeedRef.document(ownerId).collection("usersFeed").add({
      "type" : "comment",
      "commentData" : commentController.text,
      "postId" : postId,
      "postUrl" : postUrl,
      "requestorId" : currentUserId,
      "usernameOfRequestor" : doc['username'],
      "fullNameOfRequestor" : doc['fullName'],
      "photoUrlOfRequestor" : doc['photoUrl'],
      "timestamp" : timestamp,
    });
    }

    commentCount += 1;
    commentController.clear();
  }


  handleLikePost()async{
    print(MediaQuery.of(context).size.width * 0.0556);
    bool _isLiked = (likes[currentUserId] == true);
    if(_isLiked){
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "likes.$currentUserId" : false,
      });
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    }
    else if(!_isLiked){
      if(isDisliked){
        postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "dislike.$currentUserId" : false,
      });
      setState(() {
        dislikeCount -= 1;
        isDisliked = false;
        dislikes[currentUserId] = false;
      });
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "likes.$currentUserId" : true,
      });
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
      }

      else if (!isDisliked){
        postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "likes.$currentUserId" : true,
      });
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
      }
      
    }
  }

  addLikeToActivityFeed()async{
    //add a notification only when like is made by other user and not by post owner

    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner){
      DocumentSnapshot doc = await usersRef.document(currentUserId).get();
      activityFeedRef.document(ownerId).collection("usersFeed").document(postId).setData({
      "type" : "like",
      "postId" : postId,
      "postUrl" : postUrl,
      "requestorId" : currentUserId,
      "usernameOfRequestor" : doc['username'],
      "fullNameOfRequestor" : doc['fullName'],
      "photoUrlOfRequestor" : doc['photoUrl'],
      "timestamp" : timestamp,
    });
    }
  }

  removeLikeFromActivityFeed()async{
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner){
      activityFeedRef.document(ownerId).collection("usersFeed").document(postId).get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });
    }
  }

  handleDislikePost()async{
    bool _isDisLiked = (dislikes[currentUserId] == true);
    if(_isDisLiked){
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "dislike.$currentUserId" : false,
      });
      setState(() {
        dislikeCount -= 1;
        isDisliked = false;
        dislikes[currentUserId] = false;
      });
    }
    else if(!_isDisLiked){
      if(isLiked == true){
        postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "likes.$currentUserId" : false,
      });
      removeLikeFromActivityFeed();
      setState(() {
        isLiked = false;
        likeCount -= 1;
        likes[currentUserId] = false;
      });
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "dislike.$currentUserId" : true,
      });
      setState(() {
        dislikeCount += 1;
        isDisliked = true;
        dislikes[currentUserId] = true;
      });
      }
    
    else if(isLiked == false){
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "dislike.$currentUserId" : true,
      });
      setState(() {
        dislikeCount += 1;
        isDisliked = true;
        dislikes[currentUserId] = true;
      });
    }
    }
  }

  handleSavePost(){
    bool _isSaved = (saves[currentUserId] == true);
    if(_isSaved){
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "saves.$currentUserId" : false,
      });
      setState(() {
        savePostCount -= 1;
        isSaved = false;
        saves[currentUserId] = false;
      });
    }
    else if(!_isSaved){
      postRef.document(ownerId).collection("usersPost").document(postId).updateData({
        "saves.$currentUserId" : true,
      });
      setState(() {
        savePostCount += 1;
        isSaved = true;
        saves[currentUserId] = true;
      });
  
    }
    
  }

  titleAndComments(context){
    return AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: Duration(milliseconds: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(39),
            ),
                      child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              
                              _visible = !_visible;
                              
                            });
                          },
                          onLongPress: (){
                            bottomHelpSheet(context, ownerId, description, postId);
                          },
                          child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(39),
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      description != null ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                          child: Text(
                            
                            "$description",
                            //'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Fusce cursus sollicitudin eros, \na molestie diam porta quis. Aliquam sit \namet laoreet orci. Vivamus pretium, tellus a \ntincidunt rutrum, nulla orci laoreet purus, id \nlobortis diam sapien id libero. Nam \ncondimentum sit amet urna sed pretium.\n\n98.76% trend ',
                            //post.description
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                            
                          ),
                      ): Text(''),
                      
                      Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: description != null ? 25 : 0),
                          child: Text(
                            "$likeCount likes",
                            //'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Fusce cursus sollicitudin eros, \na molestie diam porta quis. Aliquam sit \namet laoreet orci. Vivamus pretium, tellus a \ntincidunt rutrum, nulla orci laoreet purus, id \nlobortis diam sapien id libero. Nam \ncondimentum sit amet urna sed pretium.\n\n98.76% trend ',
                            //post.likesCount
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
                      ),

                      Row(
                          mainAxisSize: MainAxisSize.max,
                          
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.01),
                              child: GestureDetector(
                                onTap: handleLikePost,
                                child: SvgPicture.asset(!isLiked ? "assets/Icon/Uplike.svg" : "assets/Icon/Uplike_Filled.svg", color: Colors.white, height: MediaQuery.of(context).size.height * 0.046, width: MediaQuery.of(context).size.width * 0.046,)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.006, left: MediaQuery.of(context).size.width * 0.01),
                              child: GestureDetector(
                              child: SvgPicture.asset(!isDisliked ? "assets/Icon/Downlike.svg" : "assets/Icon/Downlike_Filled.svg", color: Colors.white, height: MediaQuery.of(context).size.height * 0.046, width: MediaQuery.of(context).size.width * 0.046,),
                              onTap: handleDislikePost,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.001, left: MediaQuery.of(context).size.width * 0.02),
                              child: GestureDetector(
                              child: SvgPicture.asset("assets/Icon/Comment.svg", color: Colors.white, height: MediaQuery.of(context).size.height * 0.06, width: MediaQuery.of(context).size.width * 0.1,),
                              onTap: showComments,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                              child: GestureDetector(
                              child: SvgPicture.asset("assets/Icon/Share and chat.svg", color: Colors.white, height: MediaQuery.of(context).size.height * 0.063, width: MediaQuery.of(context).size.width * 0.1,),
                              onTap: showComments,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.004, left: MediaQuery.of(context).size.width * 0.02),
                              child: GestureDetector(
                              child: SvgPicture.asset("assets/Icon/Save.svg", color: isSaved ? Colors.red : Colors.white, height: MediaQuery.of(context).size.height * 0.055, width: MediaQuery.of(context).size.width * 0.09,),
                              onTap: handleSavePost,
                              ),
                            ),
                          ],
                      )
                    ],
                  )
              ),
                        ),
            ),
          ),
        );
     
  }

  postScreen(){
    return Center(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.048),
              child: GestureDetector(
                onTap: (){
                  _commentVisible ? setState((){
                    _commentVisible = !_commentVisible;
                    _visible  = !_visible;
                  }) : setState((){
                    _visible = !_visible;
                    print(_visible);
                    globals.postVisible = !globals.postVisible;
                    
                  }) ;

                },
                onDoubleTap: handleLikePost,
                onLongPress: (){
                  bottomHelpSheet(context, ownerId, description, postId);
                },
                child: CachedNetworkImage(
                  imageUrl: postUrl,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.845,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(39),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000),
                            offset: Offset(0, 15),
                            blurRadius: 20,
                                ),
                        ],
                        
                      ),
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(39),
                          child: InteractiveViewer(
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      
                    );
                  },
                  placeholder: (context, url){
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.845,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        color: Colors.grey[500].withOpacity(0.1),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[500].withOpacity(0.1),
                        highlightColor: Colors.grey[500].withOpacity(0.3),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.845,
                          width: MediaQuery.of(context).size.width * 0.91,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(39),
                         
                        
                      ),
                        ),
                      )
                    );
                  },
                  errorWidget: (context, url,error) => Icon(Icons.error),
                ),
              ),
            ),
            
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.047,
              left: 0,
              right: 0,
              child:_commentVisible ?  showCommentsPage(context) : titleAndComments(context)
            ),

            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.11,
            //   left: 0,
            //   right: 0,
            //   child: GestureDetector(
            //     onTap: (){
            //       setState(() {
            //         _visible = !_visible;
            //         print(_visible);
            //         // visiblity.visiblity = _visible;
            //         // print(visiblity.visiblity);
            //       });
                  
            //     },
            //     onLongPress: (){
            //       bottomHelpSheet(context, ownerId);
            //     },
            //     child: Container(
            //       height: 120,
            //       width: 500,
            //       color: Colors.transparent,
            //     ),
            //   )
            // )
          ],
        ),
      );
  }
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setState(() {
      isLiked = (likes[currentUserId] == true);
      isDisliked = (dislikes[currentUserId] == true);
      isSaved = (saves[currentUserId] == true);
    });
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
            children: [
              postScreen(),
            ],
          ),
    );
  }
}