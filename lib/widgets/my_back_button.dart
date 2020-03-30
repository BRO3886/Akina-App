import 'package:flutter/material.dart';
import '../model/util.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Hero(
        tag: 'back-button',
        child: Tooltip(
          message: 'Back',
          child: CircleAvatar(
            child: Icon(
              Icons.arrow_back_ios,
              color: colorWhite,
              semanticLabel: 'Back',
              size: 15,
            ),
            // radius: 16.8,
            maxRadius: 16.8,
            // minRadius: 10,
            backgroundColor: mainColor,
          ),
        ),
      ),
    );
  }
}
