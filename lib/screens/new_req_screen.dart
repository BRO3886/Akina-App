import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:project_hestia/widgets/my_back_button.dart';
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
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _snackBarKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool customLocation = false;

  Map<String, String> request = {
    "item_name": "",
    "quantity": "",
    "location": "",
    "description": "",
  };

  _showSnackBar(int code, String msg) {
    SnackBar snackbar;
    if (code == 201) {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: Text(msg),
        backgroundColor: Colors.teal,
      );
    } else if (code == 400) {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        backgroundColor: colorRed,
      );
    } else if (code == 69) {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        backgroundColor: colorRed,
      );
    } else {
      snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
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
    //print(token);
    if (!_newRequestFormKey.currentState.validate()) {
      return;
    }
    _newRequestFormKey.currentState.save();

    if (customLocation == false) {
      ServiceStatus serviceStatus = await PermissionHandler()
          .checkServiceStatus(PermissionGroup.locationAlways);
      if (serviceStatus == ServiceStatus.disabled) {
        _showSnackBar(
            69, 'You need to enable device location before sending a request');
      }
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways);
      if (geolocationStatus != GeolocationStatus.granted) {
        _showSnackBar(69, 'Location permission required');
      }
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(position.latitude, position.longitude));
      //TODO: change location
      //request['location'] = 'Noida';
      request['location'] = address.first.locality;
      // request['location'] = 'Noida';
    }
    print(request['location']);
    final body = jsonEncode(request);
    print(body);
    try {
      final uri = Uri.https(REQUEST_BASE_URL, URL_NEW_ITEM_REQUEST);
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
        Future.delayed(Duration(milliseconds: 1000),
            () => Navigator.of(context).maybePop());
      } else if (response.statusCode == 400) {
        print(resBody['message']);
        print("400");
      } else {
        //print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  String usrLocation = '';

  getLocation() {
    final sp = SharedPrefsCustom();
    sp.getUserLocation().then((value) {
      setState(() {
        usrLocation = value;
      });
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snackBarKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
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
              Row(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'New Request',
                    style: screenHeadingStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _newRequestFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLength: 100,
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
                      onSaved: (value) => request['item_name'] = value.trim(),
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
                      maxLength: 100,
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
                      onSaved: (value) => request['quantity'] = value.trim(),
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
                      controller: _descriptionController,
                      // textCapitalization: TextCapitalization.words,
                      maxLines: 3,
                      maxLength: 250,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 10,
                        ),
                      ),
                      // onChanged: (value) => _itemNameController.text = value,
                      onSaved: (value) => request['description'] = value.trim(),
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
                    Visibility(
                      visible: !customLocation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '(Your current location is ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${usrLocation??''}'+')',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLength: 100,
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
                      onSaved: (value) => request["location"] = value.trim(),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Submit'),
                              SizedBox(
                                width: 5,
                              ),
                              SvgPicture.asset("assets/images/check.svg"),
                            ],
                          ),
                        ),
                  SizedBox(
                    width: 15,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: colorWhite,
                    textColor: colorBlack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Cancel'),
                        Icon(
                          Icons.close,
                          size: 19,
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
