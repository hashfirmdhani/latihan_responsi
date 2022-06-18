import 'package:flutter/material.dart';
import 'package:latres/model_follower_following.dart';
import 'package:latres/user_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

class UserFollowerFollowing extends StatelessWidget {
  final section;
  final userId;
  const UserFollowerFollowing(
      {Key? key, required this.section, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""
            "$userId $section"),
      ),
      body: Container(
        child: FutureBuilder(
          future: UserDataSource.instance.getFollowingFollower(userId, section),
          builder: (
            BuildContext context,
            AsyncSnapshot<dynamic> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              FollowerFollowingUserModel followModel =
                  FollowerFollowingUserModel.fromJson(snapshot.data);
              return ListView.builder(
                  itemCount: followModel.items?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        if (!await launch(
                            "${followModel.items![index].htmlUrl!}"))
                          throw 'Could not launch ${followModel.items![index].htmlUrl!}';
                      },
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                  followModel.items![index].avatarUrl!),
                              title: Text(followModel.items![index].login!),
                              subtitle: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Type: ${followModel.items![index].type}"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     Row(
                                    //       children: [
                                    //         Icon(
                                    //           Icons.apartment_outlined,
                                    //           size: 16,
                                    //         ),
                                    //         Text("Text 1"),
                                    //       ],
                                    //     ),
                                    //     SizedBox(
                                    //       width: 30,
                                    //     ),
                                    //     Row(
                                    //       children: [
                                    //         Icon(
                                    //           Icons.location_on_outlined,
                                    //           size: 16,
                                    //         ),
                                    //         Text("Text 2"),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
