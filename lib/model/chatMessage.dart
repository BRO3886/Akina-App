/*{
  code: 200, 
  "items": [
    {
      "ID": 1,
      "CreatedAt": "2020-04-30T16:26:22.606452Z",
      "UpdatedAt": "2020-04-30T16:26:22.606452Z",
      "DeletedAt": null,
      "request_sender": 124,
      "request_receiver": 125,
      "item": "Sanitizer"
    }
  ],
  message: Successfully retrieved chat messages, 
  messages: [
    {
      ID: 73, 
      CreatedAt: 2020-03-30T14:39:03.885636Z, 
      UpdatedAt: 2020-03-30T14:39:03.885636Z, 
      DeletedAt: null, 
      receiver: 27, 
      sender: 2, 
      text: Hello
    }
  ]
}*/

class Messages {
  final List<Message> msgs;
  final List<Items> items;

  Messages({this.msgs, this.items});

  factory Messages.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['messages'] as List;
    List<Message> msgsList = list.map((i) => Message.fromJson(i)).toList();

    var iList = parsedJson['items'] as List;
    List<Items> itemsList = iList.map((i) => Items.fromJson(i)).toList();

    return Messages(
      msgs: msgsList,
      items: itemsList
      );
  }
}

class Items {
  final int requestReceiver;
  final int requestSender;
  final String item;
  final String description;

  Items({this.item, this.requestReceiver, this.requestSender, this.description});

  factory Items.fromJson(Map<String, dynamic> parsedJson) {
    return Items(
      requestSender: parsedJson['request_sender'],
      requestReceiver: parsedJson['request_receiver'],
      item: parsedJson['item'],
      description: parsedJson['req_desc']
    );
  }
}

class Message {
  final int receiver;
  final int sender;
  final String title;
  DateTime createdAt;

  Message({this.sender, this.title, this.receiver, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    return Message(
      sender: parsedJson['sender'],
      title: parsedJson['text'],
      receiver: parsedJson['receiver'],
      createdAt: DateTime.parse(parsedJson['CreatedAt']),
    );
  }
}
