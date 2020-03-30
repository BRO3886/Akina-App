// To parse this JSON data, do
//
//     final allRequests = allRequestsFromJson(jsonString);

import 'dart:convert';

AllRequests allRequestsFromJson(String str) => AllRequests.fromJson(json.decode(str));

String allRequestsToJson(AllRequests data) => json.encode(data.toJson());

class AllRequests {
    String message;
    List<Request> request;

    AllRequests({
        this.message,
        this.request,
    });

    factory AllRequests.fromJson(Map<String, dynamic> json) => AllRequests(
        message: json["message"],
        request: List<Request>.from(json["Request"].map((x) => Request.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "Request": List<dynamic>.from(request.map((x) => x.toJson())),
    };
}
/*
 {
            "id": 45,
            "request_made_by": "13",
            "item_name": "Nsnsnb",
            "quantity": "1",
            "location": "Guna",
            "date_time_created": "2020-03-28T19:51:36.068251Z",
            "accepted_by": "",
            "key": 4
        },
*/

class Request {
    int id;
    String requestMadeBy;
    String itemName;
    String quantity;
    String location;
    DateTime dateTimeCreated;

    Request({
        this.id,
        this.requestMadeBy,
        this.itemName,
        this.quantity,
        this.location,
        this.dateTimeCreated,
    });

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        requestMadeBy: json["request_made_by"],
        itemName: json["item_name"],
        quantity: json["quantity"],
        location: json["location"],
        dateTimeCreated: DateTime.parse(json["date_time_created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "request_made_by": requestMadeBy,
        "item_name": itemName,
        "quantity": quantity,
        "location": location,
        "date_time_created": dateTimeCreated.toIso8601String(),
    };
}


// class Request {
//   final String title;
//   final int qty;
//   final String dateTime;
//   Request({
//     @required this.title,
//     @required this.qty,
//     @required this.dateTime,
//   });
// }
