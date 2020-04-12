// To parse this JSON data, do
//
//     final orgs = orgsFromJson(jsonString);

import 'dart:convert';

Orgs orgsFromJson(String str) => Orgs.fromJson(json.decode(str));

String orgsToJson(Orgs data) => json.encode(data.toJson());

class Orgs {
    String message;
    List<Organization> organization;

    Orgs({
        this.message,
        this.organization,
    });

    factory Orgs.fromJson(Map<String, dynamic> json) => Orgs(
        message: json["message"],
        organization: List<Organization>.from(json["Organization"].map((x) => Organization.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "Organization": List<dynamic>.from(organization.map((x) => x.toJson())),
    };
}

class Organization {
    int id;
    String name;
    String city;
    String state;
    String country;
    String description;
    String email;
    String webLinks;
    String phoneNo;
    bool isVerified;

    Organization({
        this.id,
        this.name,
        this.city,
        this.state,
        this.country,
        this.description,
        this.email,
        this.webLinks,
        this.phoneNo,
        this.isVerified,
    });

    factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        description: json["description"],
        email: json["email"],
        webLinks: json["web_links"],
        phoneNo: json["phone_no"],
        isVerified: json["is_verified"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "state": state,
        "country": country,
        "description": description,
        "email": email,
        "web_links": webLinks,
        "phone_no": phoneNo,
        "is_verified": isVerified,
    };
}
