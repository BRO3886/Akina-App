import 'package:flutter/material.dart';
import 'package:project_hestia/model/shop.dart';
import 'package:project_hestia/services/suggest_shop.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/shop_card.dart';

class ShopSuggestionsScreen extends StatefulWidget {

  @override
  _ShopSuggestionsScreenState createState() => _ShopSuggestionsScreenState();
}

class _ShopSuggestionsScreenState extends State<ShopSuggestionsScreen> {

  ScrollController fabController = ScrollController();
  bool _dataIsLoaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAllShops(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            AllShops allShops = snapshot.data;
            if (allShops.shop.length <= 0) {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(title: 'Suggestions',isReplaced: false,hideIcon: true),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text("No shop found"),
                    ),
                  )
                ],
              );
            } else {
              return CustomScrollView(
                controller: fabController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  MySliverAppBar(title: 'Suggestions',isReplaced: false,hideIcon: true),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return ShopCard(allShops.shop[index]);
                    }, childCount: allShops.shop.length),
                  ),
                ],
              );
            }
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                MySliverAppBar(title: 'Suggestions',isReplaced: false,hideIcon: true),
                SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
