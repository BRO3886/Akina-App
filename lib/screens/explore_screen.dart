import 'package:flutter/material.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/services/get_orgs.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';

class ExploreScreen extends StatelessWidget {
  static const routename = "/explore";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getOrgsByCountry(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            Orgs orgs = snapshot.data;
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                MySliverAppBar(
                  title: 'Explore',
                  isReplaced: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      return ListTile(
                        title: Text('Text'),
                      );
                    },
                    childCount: orgs.organization.length,
                  ),
                ),
                // SliverFillRemaining(
                //   hasScrollBody: false,
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: <Widget>[
                //         for (int i = 0; i < newsList.length; i++)
                //           NewsCard(newsList[i])
                //       ],
                //     ),
                //   ),
                // )
              ],
            );
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                MySliverAppBar(
                  title: 'Explore',
                  isReplaced: true,
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
