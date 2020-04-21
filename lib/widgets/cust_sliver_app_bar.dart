import 'package:flutter/material.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/widgets/my_back_button.dart';
import 'package:project_hestia/widgets/profile_icon.dart';

class MySliverAppBar extends StatelessWidget {
  final String title;
  final bool isReplaced;
  final bool hideIcon;
  MySliverAppBar({@required this.title, @required this.isReplaced, this.hideIcon = false});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: MediaQuery.of(context).size.height * 0.08,
      snap: true,
      floating: true,
      titleSpacing: (isReplaced) ? -20 : 10,
      leading: (isReplaced)
          ? Container(
              width: 0,
              height: 0,
              padding: EdgeInsets.zero,
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyBackButton(),
            ),
      title: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          title,
          style: screenHeadingStyle,
        ),
      ),
      actions: <Widget>[
        hideIcon?Container():ProfileIcon(enabled: !hideIcon,),
      ],
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
