import 'package:flutter/foundation.dart';

class Request {
  final String title;
  final int qty;
  final String dateTime;
  Request({
    @required this.title,
    @required this.qty,
    @required this.dateTime,
  });
}
