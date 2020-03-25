import 'package:flutter/foundation.dart';

class News {
  final String title;
  final String source;
  final String shortDescription;
  final String dateTime;
  News({
    @required this.title,
    @required this.source,
    @required this.shortDescription,
    @required this.dateTime,
  });
}
