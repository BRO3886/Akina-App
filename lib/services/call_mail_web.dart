import 'package:url_launcher/url_launcher.dart';

void sendEmail(String email)=>launch("mailto:$email");
void callPhone(String phone)=>launch("tel:$phone");