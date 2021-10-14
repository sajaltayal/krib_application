import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages_alag/preview_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';

class PreviewImageScreen1 extends StatefulWidget {
  final String imagePath;

  PreviewImageScreen1({this.imagePath});

  @override
  _PreviewImageScreen1State createState() => _PreviewImageScreen1State();
}

class _PreviewImageScreen1State extends State<PreviewImageScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff363637),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            GestureDetector(
              //onTap: () => Navigator.push(context, PageTransition(child: PreviewImageScreen(imageFile: widget.imagePath), type: PageTransitionType.fade, duration: Duration(milliseconds: 200))),
              child: Icon(Icons.receipt_long_outlined)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            Icon(Icons.mediation_outlined),
            
          ],
        ),
        backgroundColor: Colors.blue.withOpacity(0.1),
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
                      BoxShadow(
            color: const Color(0xff000000),
            offset: Offset(0, 15),
            blurRadius: 20,
                            ),
                    ],
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Stack(
          children: <Widget>[
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.455,
                width: MediaQuery.of(context).size.width * 0.93,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(39),
                  child: InteractiveViewer(
                    child: Image.file(File(widget.imagePath), 
                    fit: BoxFit.fitWidth)
                    )
                    ),
              )
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
                
            onPressed: (){
              //Navigator.pop(context, PageTransition(child: null, type: PageTransitionType.fade));
              },
            child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            backgroundColor: Color(0xFFFC9F48),
            ),
    );
  }

}