import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/screens/explore_screen.dart';
import 'package:project_hestia/screens/my_chats.dart';
import 'package:project_hestia/screens/show_shop_suggestios.dart';
import './requests_feed.dart';
import './news_feed.dart';

class MyHomeScreen extends StatefulWidget {
  static const routename = "/homescreen";
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _pageIndex;
  PageController _pageController;

  final pageList = [
    RequestsFeedScreen(),
    ExploreScreen(),
    NewsFeedScreen(),
  ];

  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
     // Handle data message
     final dynamic data = message['data'];
     //Fluttertoast.showToast(msg: "Data in background is "+data.toString());
     
    /*final Item item = _itemForMessage(message);
    print("The url of notification is "+item.url);
    if(item.url.contains('requests')){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => MyChatsPage()));
    }
    else if(item.url.contains('main')){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => MyHomeScreen()));
    }
    else if(item.url.contains('https://akina.dscvit.com/suggestashop')){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => ShopSuggestionsScreen()));
    }
    else{
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => MyHomeScreen()));
    }*/
   }

   if (message.containsKey('notification')) {
     // Handle notification message
     final dynamic notification = message['notification'];
   }

   // Or do other work.
  }
  
  void _navigateToItemDetail(Map<String, dynamic> message) {
    Item item;
    setState(() {
      item = _itemForMessage(message);
    });
    print("The url of notification is "+item.url);
    print("The url of my own is "+message['data']['url']);
    if((message['data']['url']).contains('requests') || (message['data']['url']).contains('chat')){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => MyChatsPage()));
    }
    // else if(item.url.contains('main')){
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (BuildContext context) => MyHomeScreen()));
    // }
    else if((message['data']['url']).contains('akina.dscvit.com/suggestashop')){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => ShopSuggestionsScreen()));
    }
    // else{
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (BuildContext context) => MyHomeScreen()));
    // }

    /*Navigator.push(context, item.route);

    //Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }*/
  }

    Widget _buildDialog(BuildContext context, Item item) {
      String textToBeShown= '';
      if(item.url.contains('requests')){
        setState(() {
          textToBeShown = 'Chats page';
        });
      }
      else if(item.url.contains('main')){
        setState(() {
          textToBeShown = 'News Page';
        });
      }
      else if(item.url.contains('akina.dscvit.com/suggestashop')){
        setState(() {
          textToBeShown = 'Shop Suggestions Page';
        });
      }
      else{
        setState(() {
          textToBeShown = 'The app';
        });
      }

    return AlertDialog(
      content: Text("${textToBeShown} has something new"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  final Map<String, Item> _items = <String, Item>{};
  Item _itemForMessage(Map<String, dynamic> message) {
    final dynamic data = message['data'] ?? message;
    final String itemId = data['id'];
    final String url = data['url'];
    final String screen = data['screen'];
    final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId, screen: screen, url: url))
      ..status = data['status'];
    return item;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pageList,
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            _pageIndex = newPage;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn),
        currentIndex: _pageIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: mainColor,
        iconSize: 25,
        unselectedFontSize: 0,
        backgroundColor: colorWhite,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_view_day,
              // color: Colors.black,
            ),
            title: Text('Feed'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              // color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              // color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: Text('News'),
          ),
        ],
      ),
    );
  }
}


  //Model class to represent the message return by FCM
class Item {
  Item({this.itemId, this.screen, this.url});
  final String itemId, url, screen;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{

  };
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (context){}
      //  builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}

/*Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}*/

