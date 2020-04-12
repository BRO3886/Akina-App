import 'package:http/http.dart' as http;
import '../model/news.dart';

Future<News> getNews() async {
  try {
    final url = 'http://hestia-info.herokuapp.com/node';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      News news = newsFromJson(response.body);
      //Remove later
      print(news.source??'no title');
      return news;
    } else {
      //print(response.statusCode);
    }
  } catch (e) {
    print(e);
  }
}
