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

class Request {
    int id;
    String requestMadeBy;
    String itemName;
    String quantity;
    String location;
    String description;
    DateTime dateTimeCreated;
    String acceptedBy;
    int key;

    Request({
        this.id,
        this.requestMadeBy,
        this.itemName,
        this.quantity,
        this.location,
        this.description,
        this.dateTimeCreated,
        this.acceptedBy,
        this.key,
    });

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        requestMadeBy: json["request_made_by"],
        itemName: json["item_name"],
        quantity: json["quantity"],
        location: json["location"],
        description: json["description"] == null ? null : json["description"],
        dateTimeCreated: DateTime.parse(json["date_time_created"]),
        acceptedBy: json["accepted_by"],
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "request_made_by": requestMadeBy,
        "item_name": itemName,
        "quantity": quantity,
        "location": location,
        "description": description == null ? null : description,
        "date_time_created": dateTimeCreated.toIso8601String(),
        "accepted_by": acceptedBy,
        "key": key,
    };
}
