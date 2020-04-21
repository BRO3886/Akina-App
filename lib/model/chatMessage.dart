/*{
  code: 200, 
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

  Messages({this.msgs});

  factory Messages.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['messages'] as List;
    List<Message> msgsList = list.map((i) => Message.fromJson(i)).toList();

    return Messages(msgs: msgsList);
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
