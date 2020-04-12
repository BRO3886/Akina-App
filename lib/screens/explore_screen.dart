import 'package:flutter/material.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/services/get_orgs.dart';
import 'package:project_hestia/widgets/cust_sliver_app_bar.dart';
import 'package:project_hestia/widgets/org_card.dart';

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
            if(orgs.organization.length == 0){
              return Center(child: Text(orgs.message),);
            }
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
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                    ),
                    child: Text(
                      'NGOs providing food to the needy and protective equipment to healthcare workers are listed below. Donate to help fight the battle against covid-19',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      return OrganizationCard(orgs.organization[index]);
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
