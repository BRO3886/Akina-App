import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';


class NewRequestWidget extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      title: Text(
        'New Request',
        style: TextStyle(color: Colors.grey[600]),
      ),
      content: Container(
        height: 150,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          textColor: mainColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Submit'),
          textColor: mainColor,
          onPressed: () {},
          // onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
