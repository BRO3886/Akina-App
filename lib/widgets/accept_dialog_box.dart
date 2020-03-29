// import 'package:flutter/material.dart';
// import 'package:project_hestia/model/util.dart';
// import 'package:project_hestia/services/accept_request.dart';

// class AcceptRequestWidget extends StatelessWidget {
//   final String id;
//   AcceptRequestWidget(this.id);
//   @override
//   Widget build(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (context) => new AlertDialog(
//       backgroundColor: Theme.of(context).canvasColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       title: Text(
//         'New Request',
//         style: TextStyle(color: Colors.grey[600]),
//       ),
//       content: Container(
//         height: 150,
//         child: Text('Do you have this item?')
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text('Yes'),
//           textColor: mainColor,
//           onPressed: () { 
//             acceptRequest(id);
//           }
//         ),
//         FlatButton(
//           child: Text('No'),
//           textColor: mainColor,
//           onPressed: () => Navigator.of(context).pop(),
//         )
//       ],
//     ));
//   }
// }
