/*      "id": 1,
      "recommended_for": "1",
      "name_of_shop": "Shanti Medical",
      "phone_number": "68794039245",
      "landmark": "Chettinad Hospital",
      "extra_instruction": "Go towards the right bifurcation at the end of the avenue, shop should be at the right",
      "description_of_shop": "Sanitizers, medicines, and masks available",
      "read_by_user": false
*/

// To parse this JSON data, do
//
//     final allRequests = allRequestsFromJson(jsonString);

import 'dart:convert';

AllShops allShopsFromJson(String str) => AllShops.fromJson(json.decode(str));

String allShopsToJson(AllShops data) => json.encode(data.toJson());

class AllShops {
    String message;
    List<Shop> shop;

    AllShops({
        this.message,
        this.shop,
    });

    factory AllShops.fromJson(Map<String, dynamic> json) => AllShops(
        message: json["message"],
        shop: List<Shop>.from(json["payload"].map((x) => Shop.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "Request": List<dynamic>.from(shop.map((x) => x.toJson())),
    };
}

class Shop {
    int id;
    String recommendedFor, nameOfShop, phone, landmark, extraInstruction, descriptionOfShop;

    Shop({
        this.id,
        this.descriptionOfShop,
        this.extraInstruction,
        this.landmark,
        this.nameOfShop,
        this.phone,
        this.recommendedFor
    });

    factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        recommendedFor: json["recommended_for"].toString(),
        nameOfShop: json["name_of_shop"],
        phone: json["phone_number"],
        landmark: json["landmark"],
        extraInstruction : json["extra_instruction"],
        descriptionOfShop: json['description_of_shop']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "recommended_for": recommendedFor,
        "name_of_shop": nameOfShop,
        "phone_number": phone,
        "landmark": landmark,
        "extra_instruction": extraInstruction,
        "description_of_shop": descriptionOfShop
    };
}

