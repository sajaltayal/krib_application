import 'package:flutter/material.dart';

class ManageNotification extends StatefulWidget {
  String currentUserId;

  ManageNotification({this.currentUserId});

  @override
  _ManageNotificationState createState() => _ManageNotificationState();
}

class _ManageNotificationState extends State<ManageNotification> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Container(
        child: Column(
          children: [
            Text("Notification manage"),
            RaisedButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text("Back"),
            )
          ],
        ),
      ),
    );
  }
}