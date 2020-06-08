import 'package:flutter/material.dart';
import 'package:project_hestia/model/shop.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  ShopCard(this.shop);
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      // width: MediaQuery.of(context).size.width,
      // height: 125,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 17),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ExpansionTile(
            // contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            title: Row(
              children: <Widget>[
                SelectableText(shop.nameOfShop),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 15,
                  color: Colors.grey[200],
                  width: 1,
                ),
                SelectableText(
                  shop.phone,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
                      SelectableText(
                        (shop.landmark!=null || shop.landmark!="")?'Landmark: ${shop.landmark}':'-',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      SelectableText(
                        (shop.descriptionOfShop!=null || shop.descriptionOfShop!="")?'Description: ${shop.descriptionOfShop}':'-',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      SelectableText(
                        (shop.extraInstruction!=null || shop.extraInstruction!="")?'More instructions: ${shop.extraInstruction}':'-',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // subtitle: Padding(
            //   padding: EdgeInsets.zero,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       SelectableText(
            //         shop.descriptionOfShop,
            //       ),
            //       SelectableText(shop.extraInstruction)
            //     ],
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
