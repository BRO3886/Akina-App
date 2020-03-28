import 'package:flutter/foundation.dart';

// class News {
//   final String title;
//   final String source;
//   final String shortDescription;
//   final String dateTime;
//   News({
//     @required this.title,
//     @required this.source,
//     @required this.shortDescription,
//     @required this.dateTime,
//   });
// }

// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    List<Item> items;
    String title;
    String description;
    String link;

    News({
        this.items,
        this.title,
        this.description,
        this.link,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        title: json["title"],
        description: json["description"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "title": title,
        "description": description,
        "link": link,
    };
}

class Item {
    String title;
    String link;
    String pubDate;
    String content;
    String contentSnippet;
    String guid;
    DateTime isoDate;

    Item({
        this.title,
        this.link,
        this.pubDate,
        this.content,
        this.contentSnippet,
        this.guid,
        this.isoDate,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        title: json["title"],
        link: json["link"],
        pubDate: json["pubDate"],
        content: json["content"],
        contentSnippet: json["contentSnippet"],
        guid: json["guid"],
        isoDate: DateTime.parse(json["isoDate"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "pubDate": pubDate,
        "content": content,
        "contentSnippet": contentSnippet,
        "guid": guid,
        "isoDate": isoDate.toIso8601String(),
    };
}
