
/*{
  message: Accepts found, 
  Accepts: [
    {
      id: 3, 
      request_made_by: 13, 
      request_acceptor: 27, 
      request_id: 44
    }, 
    {
      id: 4, 
      request_made_by: 13, 
      request_acceptor: 27, 
      request_id: 45
    }
  ]
}*/

class ViewAccepts {
  final List<Accept> accepts;

  ViewAccepts({this.accepts});

  factory ViewAccepts.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['Accepts'] as List;
    List<Accept> accsList = list.map((i) => Accept.fromJson(i)).toList();


    return ViewAccepts(
      accepts: accsList
    );
  }
}

class Accept {
  final String request_acceptor, request_id;

  Accept({this.request_acceptor, this.request_id});

  factory Accept.fromJson(Map<String, dynamic> parsedJson){
   return Accept(
     request_acceptor:parsedJson['request_acceptor'].toString(),
     request_id:parsedJson['request_id'].toString()
   );
  }
}