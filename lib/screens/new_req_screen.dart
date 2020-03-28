import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../model/global.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/shared_prefs_custom.dart';

class NewRequestScreen extends StatefulWidget {
  static const routename = "/new-request";

  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final GlobalKey<FormState> _newRequestFormKey = GlobalKey<FormState>();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  final GlobalKey<ScaffoldState> _snackBarKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool customLocation = false;

  Map<String, String> request = {
    "item_name": "",
    "quantity": "",
    "location": "",
  };

  _showSnackBar(int code, String msg) {
    SnackBar snackbar;
    if (code == 201) {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.teal,
      );
    } else if (code == 400) {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: colorRed,
      );
    } else if (code == 69) {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: colorRed,
      );
    } else {
      snackbar = SnackBar(
        content: Text(msg),
        backgroundColor: colorRed,
      );
    }
    _snackBarKey.currentState.showSnackBar(snackbar);
  }

  _submitRequest() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      isLoading = true;
    });
    Position position;
    List<Address> address;
    final sp = SharedPrefsCustom();
    String token = await sp.getToken();
    print(token);
    if (!_newRequestFormKey.currentState.validate()) {
      return;
    }
    _newRequestFormKey.currentState.save();

    if (customLocation == false) {
      ServiceStatus serviceStatus = await PermissionHandler()
          .checkServiceStatus(PermissionGroup.location);
      if (serviceStatus == ServiceStatus.disabled) {
        _showSnackBar(
            69, 'You need to enable device location before sending a request');
      }
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus != GeolocationStatus.granted) {
        _showSnackBar(69, 'Location permission required');
      }
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(position.latitude, position.longitude));
      request['location'] = address.first.locality;
      // request['location'] = 'vellore';
    }
    print(request['location']);
    final body = jsonEncode(request);
    print(body);
    try {
      final uri = Uri.https(REQUEST_BASE_URL, URL_NEW_REQUEST);
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
        body: request,
      );
      final resBody = jsonDecode(response.body);
      _showSnackBar(response.statusCode, resBody['message']);
      if (response.statusCode == 201) {
        print(resBody['message']);
      } else if (response.statusCode == 400) {
        print(resBody['message']);
        print("location not provided");
      } else {
        print(response.statusCode);
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
      key: _snackBarKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: colorBlack),
        // title: Text(
        //   'New Request',
        //   style: screenHeadingStyle,
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'New Request',
                style: screenHeadingStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _newRequestFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _itemNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      // onChanged: (value) => _itemNameController.text = value,
                      onSaved: (value) => request['item_name'] = value,
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _quantityController,
                      // textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      // onChanged: (value) => _quantityController.text = value,
                      onSaved: (value) => request['quantity'] = value,
                      validator: (value) {
                        if (value == "") {
                          return "This field is required";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'My Location',
                          style: TextStyle(
                            color: (!customLocation) ? mainColor : Colors.grey,
                          ),
                        ),
                        Switch.adaptive(
                            value: !customLocation,
                            onChanged: (bool _) {
                              setState(() {
                                customLocation = !customLocation;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: customLocation,
                      controller: _locationController,
                      textCapitalization: TextCapitalization.words,
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        labelText: 'Custom Location',
                        // labelText: (customLocation)?'Custom Location':'Turn off  \'My Location\' to enable this field',
                        labelStyle: TextStyle(
                          color:
                              (customLocation) ? Colors.grey : Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                          borderSide: BorderSide(
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      // onChanged: (value) => _locationController.text = value,
                      onSaved: (value) => request["location"] = value,
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
                          onPressed: _submitRequest,
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
