// Map<String, String> data_create_chat = {
//      'receiver': "",
//       'sender': "" ,
//       'title': ""
// };

// createChat(String r, String s, String t) async{
//   data_create_chat["receiver"] = r;
//   data_create_chat["sender"] = s;
//   data_create_chat["title"] = t;
//   try {
//     final token = await SharedPrefsCustom().getToken();
//     final response = await http.post(
//       URL_CREATE_CHAT,
//       headers: {
//         HttpHeaders.authorizationHeader: token,
//       },
//       body: json.encode({
//         'receiver': 27,
//         'sender': 21 ,
//         'title': "Hello"
//       })
//     );
//     print("response is "+response.body.toString());
//     final result = json.decode(response.body);
//     if (response.statusCode == 200) {
  
//     } else {
//         Fluttertoast.showToast(msg: result['message']);
//     }
//   } catch (e) {
//     print(e.toString());
//   }
// }