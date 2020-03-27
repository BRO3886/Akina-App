import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';

class NewRequestScreen extends StatefulWidget {
  static const routename = "/new-request";

  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text('New Request'),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: colorBlack),
      ),
      body: Center(
        child: Text('new req'),
      ),
    );
  }
}
