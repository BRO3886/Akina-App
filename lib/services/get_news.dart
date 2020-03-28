import 'package:http/http.dart' as http;
import '../model/global.dart';
import '../model/news.dart';

Future<News> getNews() async {
  try {
    final url = 'http://hestia-info.herokuapp.com/node';
    final response = await http.get(Uri.encodeFull(url), headers: {
      'content-type': 'application/json; charset = utf-8',
    });
    if (response.statusCode == 200) {
      News news = newsFromJson(response.body);
      //Remove later
      print(news.title);
      return news;
    } else {
      print(response.statusCode);
    }
  } catch (e) {
    print(e);
  }
}
