import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_hestia/model/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';
import 'package:project_hestia/widgets/my_back_button.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({this.id, this.pop, this.requestReceiver, this.requestSender});
  final int id, requestSender, requestReceiver;
  bool pop;
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  _ReportScreenState({this.id, this.pop});

  final String id;bool pop;

  TextEditingController dataController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;
  String data;

  var reportData = {"user_id": 1, "reason": "Excessive charging of sanitizers"};

  SharedPrefsCustom s = new SharedPrefsCustom();

  Future _createReport() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    reportData['user_id'] = widget.id;
    setState(() {
      isLoading = true;
    });

    print("Data being sent is "+reportData.toString());
    /*setReportedList();
    Navigator.pop(context);
    Navigator.pop(context);
    widget.pop ? Navigator.pop(context) : null;
*/

print("Report id is "+widget.id.toString());
    try {
      final token = await SharedPrefsCustom().getToken();
      final response = await http.post(URL_REPORT_A_PERSON,
          body: jsonEncode(reportData),
          headers: {
            HttpHeaders.authorizationHeader: token,
            "Content-Type": "application/json"
          });
      print("Response is " + response.toString());
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 201) {
        //setReportedList();
        /*Fluttertoast.showToast(msg: "Successfully reported");
        Navigator.pop(context);
        Navigator.pop(context, 'delete');
        Fluttertoast.showToast(msg: "Successfully reported");*/

        updateChat();

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

  var bodyUpdateChatRoom = {
    'title': 'itemName',
    "request_sender": 1,
    "is_reported":true
  };

updateChat() async{
  print("I am in update chat");
  try {
    bodyUpdateChatRoom["request_sender"] = widget.requestSender;
	  bodyUpdateChatRoom["request_receiver"] = widget.requestReceiver;
    bodyUpdateChatRoom['is_reported'] = true;
    final token = await SharedPrefsCustom().getToken();
    final response = await http.post(
      URL_UPDATE_CHAT,
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
      body: json.encode(
        bodyUpdateChatRoom
    ));

    print("Body of update chat is " + bodyUpdateChatRoom.toString() );
    print("response of update chat is "+response.body.toString());
    final result = json.decode(response.body);
    print("Result of create chat room is "+result.toString());
    if (result["code"] == 200) {
        Fluttertoast.showToast(msg: "Successfully reported");
        Navigator.pop(context);
        Navigator.pop(context, 'delete');
        //TODO check this
        Fluttertoast.showToast(msg: "Successfully reported");
    }
    else {
      Fluttertoast.showToast(msg: result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}

  /*setReportedList(){
    if(reportedList == null){
      setState(() {
        reportedList = [];
        reportedList.add(widget.id.toString());
        //s.setReportedList(reportedList);
      });
    }
    else if ((reportedList.length == 0)){
      setState(() {
        reportedList = [];
        reportedList.add(widget.id.toString());
        //s.setReportedList(reportedList);
      });
    }
    else if(reportedList.contains(widget.id.toString())){
      print("ID already present in reported list");
    } 
    else{
      setState(() {
        reportedList.add(widget.id.toString());
        //s.setReportedList(reportedList);
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    //getValues();
  }

  /*Future<List<String>> checkReportedList;
  List<String> reportedList;
  
  getValues() {
      checkReportedList = s.getReportedList();
      checkReportedList.then((resultStringLogin) {
        setState(() {
          reportedList = resultStringLogin;
        });
        print("Value of reported list is "+ reportedList.toString() );
      });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: colorBlack),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Report a person',
                    style: screenHeadingStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLength: 250,
                      maxLines: 5,
                      controller: dataController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Reason',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      onSaved: (value) => reportData['reason'] = value.trim(),
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
                          color: colorRed,
                          textColor: colorWhite,
                          onPressed: _createReport,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Report'),
                              SizedBox(
                                width: 5,
                              ),
                              SvgPicture.asset('assets/images/check.svg'),
                            ],
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: colorWhite,
                    textColor: colorBlack,
                    child: Row(
                      children: <Widget>[
                        Text('Cancel'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ],
                    ),
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
