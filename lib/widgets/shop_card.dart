import 'package:flutter/material.dart';
import 'package:project_hestia/model/shop.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  ShopCard(this.shop);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      width: MediaQuery.of(context).size.width,
      height: 125,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 0,
              color: Color(0x23000000),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 2, left: 14, right: 14),
          title: Row(
            children: <Widget>[
              Text(shop.nameOfShop),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 15,
                color: Colors.grey[200],
                width: 1,
              ),
              Text(shop.nameOfShop),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Text(shop.descriptionOfShop),
                Text(shop.extraInstruction)
              ],
            )
          ),
        ),
      ),
    );
  }
}
