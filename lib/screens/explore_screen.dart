import 'package:flutter/material.dart';
import 'package:project_hestia/model/orgs.dart';
import 'package:project_hestia/model/util.dart';
import 'package:project_hestia/services/get_orgs.dart';
import 'package:project_hestia/services/url_launcher.dart';
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
            if (orgs.organization.length == 0) {
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.32,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17),
                          child: Text(
                            orgs.message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                        vertical: 10),
                    child: Column(
                      children: <Widget>[
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.05,
                        // ),
                        Text(
                          'NGOs providing food to the needy and protective equipment to healthcare workers are listed above.\nDonate to help fight the battle against covid-19',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          'To register an organization with us, visit',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () => launchURL(
                              context, "https://orgregister.netlify.com/"),
                          child: Text(
                            "Akina Org-Registration Portal",
                            style: TextStyle(color: mainColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
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
