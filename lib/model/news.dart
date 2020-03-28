// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    List<Item> items;
    String description;
    String link;
    String source;

    News({
        this.items,
        this.description,
        this.link,
        this.source,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        description: json["description"],
        link: json["link"],
        source: json["source"],
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "description": description,
        "link": link,
        "source": source,
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
