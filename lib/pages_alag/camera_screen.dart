import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages_alag/preview_screen.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/post.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final String currentUserId;
  final bool isProfileEdit;

  CameraScreen({this.currentUserId, this.isProfileEdit});
  @override
  _CameraScreenState createState() => _CameraScreenState();
  
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  String fullName;
  double _scaleFactor = 1.0;
  double zoom = 1.0;
  @override
void initState() {
  super.initState();
  usersRef.document(widget.currentUserId).get().then((doc){
      if(doc.exists){
        fullName = doc['fullName'];
      }
    });
  // 1
  availableCameras().then((availableCameras) {
    
    cameras = availableCameras;
    if (cameras.length > 0) {
      setState(() {
        // 2
        selectedCameraIdx = 0;
      });

      _initCameraController(cameras[selectedCameraIdx]).then((void v) {
      });
    }else{
      print("No camera available");
    }
  }).catchError((err) {
    // 3
    print('Error: $err.code\nError Message: $err.message');
  });
}

// 1, 2
Future _initCameraController(CameraDescription cameraDescription) async {
  if (controller != null) {
    await controller.dispose();
  }

  // 3
  controller = CameraController(cameras[selectedCameraIdx], ResolutionPreset.high);

  // If the controller is updated then update the UI.
  // 4
  controller.addListener(() {
    // 5
    if (mounted) {
      setState(() {});
    }

    if (controller.value.hasError) {
      print('Camera error ${controller.value.errorDescription}');
    }
  });

  // 6
  try {
    await controller.initialize();
  } on CameraException catch (e) {
    _showCameraException(e);
  }

  if (mounted) {
    setState(() {});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
             GestureDetector(
               onTap: (){
                 return FlatButton(
                   child: Container(color: Colors.blue, height: 50, width: 50),
                   onPressed: () => FocusScope.of(context).requestFocus(new FocusNode()),
                 );
               },
                    behavior: HitTestBehavior.translucent,
                    onScaleStart: (details) {
                       if(_scaleFactor >= 1){
                         setState(() {
                         zoom = min(_scaleFactor, 10);
                         
                       });
                       }
                       else if(min(_scaleFactor, 1) == _scaleFactor){
                         setState(() {
                           zoom = 1;
                         });
                       }
                    },
                    onScaleUpdate: (details) {
                       if(_scaleFactor >= 1){
                         setState(() {
                         _scaleFactor = min(zoom * details.scale, 10);
                         //controller.setZoomLevel(_scaleFactor);
                       });
                       }
                       else if(min(_scaleFactor, 1) == _scaleFactor){
                         setState(() {
                           _scaleFactor = 1;
                           //controller.setZoomLevel(_scaleFactor);
                         });
                       }
                       print(_scaleFactor);
                       debugPrint('Gesture updated');
                    },
                    child: Transform.scale(
                      scale: min(_scaleFactor, 1) == _scaleFactor ? 1 : _scaleFactor,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: _cameraPreviewWidget(),
                        )
                      )
                    ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.82),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _captureGalleryWidget(context),
                      _captureControlRowWidget(context),
                      _cameraTogglesRowWidget(context),
                    ],
                  ),
            ),
            
          ],
        ),
      ),
    );
  }

  //Display Gallery
  Widget _captureGalleryWidget(context){
    if (cameras == null || cameras.isEmpty) {
    return Spacer();
  }
  CameraDescription selectedCamera = cameras[selectedCameraIdx];
  CameraLensDirection lensDirection = selectedCamera.lensDirection;
  print(lensDirection);
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
        child: IconButton(
            onPressed: () => handleSubmitGallery(context),
            icon: Icon(Icons.collections_outlined,color: Colors.white, size: 40,),
            //label: Text(
              //  "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
    ),
      ),)
  );
  }

  
// for gallery sdubmission
  handleSubmitGallery(context)async{
    final path = (await ImagePicker().getImage(source: ImageSource.gallery)).path;
              print(path);
              if(path != null){
                await ImageCropper.cropImage(
                  sourcePath: path,
                  aspectRatio: !widget.isProfileEdit ? CropAspectRatio(
                  ratioX: 0.565, ratioY: 1
                ) : CropAspectRatio(
                  ratioX: 1, ratioY: 0.7
                ),
                compressQuality: 85,
                // maxHeight: (MediaQuery.of(context).size.height * 0.855).toInt(),
                // maxWidth:  (MediaQuery.of(context).size.width * 0.855).toInt(),
                androidUiSettings: AndroidUiSettings(
                  
                  toolbarWidgetColor: Colors.black,
                  cropGridRowCount: 6,
                  cropGridColumnCount: 2,
                  toolbarColor: Colors.black.withOpacity(0.1),
                  toolbarTitle: " ",
                  statusBarColor: Color(0xff363637),
                  backgroundColor: Color(0xff363637),
                  hideBottomControls: true,
                  
                )

                ).then((value){
                  if(value != null){
                    Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewImageScreen(imageFile: value, isProfileEdit: widget.isProfileEdit, currentUserId: widget.currentUserId, fullName: fullName,),
              ),
            );
                  }
                  else if(value == null){
                    
                  }
                  
                }
                        );
                    }

  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    //TODO: Display camera preview
    if (controller == null || !controller.value.isInitialized) {
    return Container(height: double.infinity, color: Colors.black,);
  }

  return CameraPreview(controller);
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              elevation: 50,
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(
                  
                  side: BorderSide(width: 4, color: Colors.white)
                ),
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget(context) {
    //TODO: Add logic to display icon for the selected camera and switch camera
    if (cameras == null || cameras.isEmpty) {
    return Spacer();
  }

  CameraDescription selectedCamera = cameras[selectedCameraIdx];
  CameraLensDirection lensDirection = selectedCamera.lensDirection;
  print(lensDirection);
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
        child: IconButton(
            onPressed: _onSwitchCamera,
            icon: Icon(Icons.flip_camera_ios_outlined, color: _getCameraLensIconColor(lensDirection), size: 40,),
            //label: Text(
              //  "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
    ),
      ),)
  );
  }

  void _onSwitchCamera() {
  if(selectedCameraIdx < (cameras.length - 1)){
    setState(() {
      selectedCameraIdx = selectedCameraIdx + 1;
    });
  }
  if(selectedCameraIdx >= (cameras.length - 1)){
    setState(() {
      selectedCameraIdx = 0;
    });
  }
  //selectedCameraIdx = selectedCameraIdx < (cameras.length - 1) ? selectedCameraIdx + 1 : 0 ;
  CameraDescription selectedCamera = cameras[selectedCameraIdx];
  _initCameraController(selectedCamera);
}

  Color _getCameraLensIconColor(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Colors.white;
    case CameraLensDirection.front:
      return Colors.blue;
    case CameraLensDirection.external:
      return Colors.green;
    default:
      return Colors.red;
  }
}

   void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      print(path);
      await controller.takePicture(path);
      
      if(path !=  null){
        await ImageCropper.cropImage(
          
          sourcePath: path,
          aspectRatio: !widget.isProfileEdit ? CropAspectRatio(
            ratioX: 0.565, ratioY: 1
          ) : CropAspectRatio(
            ratioX: 1, ratioY: 0.7
          ),
          compressQuality: 85,
          // maxHeight: (MediaQuery.of(context).size.height * 0.855).toInt(),
          // maxWidth:  (MediaQuery.of(context).size.width * 0.855).toInt(),
          androidUiSettings: AndroidUiSettings(
            
            toolbarWidgetColor: Colors.black,
            cropGridRowCount: 6,
            cropGridColumnCount: 2,
            toolbarColor: Colors.black.withOpacity(0.1),
            toolbarTitle: "RPS CROPPER",
            statusBarColor: Color(0xff363637),
            backgroundColor: Color(0xff363637),
            hideBottomControls: true,
            
          )

          ).then((value){
            if(value != null){
              Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(imageFile: value, isProfileEdit: widget.isProfileEdit, currentUserId: widget.currentUserId, fullName: fullName,),
        ),
      );
            }
            else if(value == null){
              
            }
            
          });
      }
      // If the picture was taken, display it on a new screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PreviewImageScreen(imagePath: path),
      //   ),
      // );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print("${e.message}");
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}