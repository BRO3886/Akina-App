import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/model/global.dart';
import 'package:ant_icons/ant_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hestia/screens/home_screen.dart';
import 'package:project_hestia/screens/login.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({this.id});
  final id;
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  _ReportScreenState({this.id});

  final String id;

  TextEditingController dataController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;
  String data;

  var reportData = {
    "user_id": 1,
    "reason": "Excessive charging of sanitizers"
  };


  Future _createReport() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    reportData['user_id']=widget.id;
    setState(() {
      isLoading = true;
    });
    String content = "";
    try {
      final token = await SharedPrefsCustom().getToken();
      final response = await http.post(URL_REPORT_A_PERSON, body: jsonEncode(reportData), headers: {HttpHeaders.authorizationHeader: token,"Content-Type": "application/json"});
      print("Response is "+response.toString());
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode==201) {
        Fluttertoast.showToast(msg: "Successfully reported");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: responseBody['message']);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: colorBlack),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Report a person',
                style: screenHeadingStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: dataController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onSaved: (value) => reportData['reason'] = value,
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (isLoading)
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: mainColor,
                          textColor: colorWhite,
                          onPressed: _createReport,
                          child: Text('Submit'),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: colorWhite,
                    textColor: mainColor,
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
