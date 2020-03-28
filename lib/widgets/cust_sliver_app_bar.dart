import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/widgets/profile_icon.dart';

class MySliverAppBar extends StatelessWidget {
  final String title;
  MySliverAppBar({@required this.title});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: MediaQuery.of(context).size.height * 0.10,
      snap: true,
      floating: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10),
        child: Text(
          title,
          style: screenHeadingStyle,
        ),
      ),
      actions: <Widget>[
        ProfileIcon(),
      ],
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
