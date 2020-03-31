/*
{
  "chats": [
    {
      "receiver": 4,
      "sender": 5,
      "title": "Sample",
      "messages": null
    },
    {
      "receiver": 4,
      "sender": 7,
      "title": "Sample",
      "messages": null
    },
    {
      "receiver": 9,
      "sender": 4,
      "title": "Sample",
      "messages": null
    }
  ],
  "code": 200,
  "message": "Successfully fetched chats for user"
}
*/

import 'dart:convert';

class Chats {
  final List<Chat> chats;

  Chats({this.chats});

  factory Chats.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['chats'] as List;
    List<Chat> chatsList = list.map((i) => Chat.fromJson(i)).toList();


    return Chats(
      chats: chatsList,
    );
  }
}

class Chat {
  final int receiver;
  final int sender;
  final String title;
  String senderName, receiverName;

  Chat({this.sender, this.title, this.receiver, this.receiverName, this.senderName});

  factory Chat.fromJson(Map<String, dynamic> parsedJson){
   return Chat(
      sender:parsedJson['sender'],
      title:parsedJson['title'],
      receiver: parsedJson['receiver'],
      senderName: parsedJson['sender_name'],
      receiverName: parsedJson['receiver_name']
   );
  }
}