import 'package:flutter/material.dart';
import 'package:latres/model_search_user.dart';
import 'package:latres/model_specific_user.dart';
import 'package:latres/repo_page.dart';
import 'package:latres/user_data_source.dart';
import 'package:latres/user_follower.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Icon actionIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Search GitHub User");
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchControllerHandler);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          AnimSearchBar(
            width: 400,
            textController: searchController,
            suffixIcon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 28,
            ),
            onSuffixTap: () {
              print("wiwi jembut");
              setState(() {});
            },
          ),
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         if (actionIcon.icon == Icons.search) {
          //           actionIcon = const Icon(Icons.cancel);
          //           customSearchBar = ListTile(
          //             leading: Icon(
          //               Icons.search,
          //               color: Colors.white,
          //               size: 28,
          //             ),
          //             title: TextField(
          //               controller: searchController,
          //               onEditingComplete: (){
          //                 setState(() {
          //                 });
          //               },
          //               decoration: InputDecoration(
          //                 hintText: 'type in username...',
          //                 hintStyle: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 18,
          //                   fontStyle: FontStyle.italic,
          //                 ),
          //                 border: InputBorder.none,
          //               ),
          //               style: TextStyle(
          //                 color: Colors.white,
          //               ),
          //             ),
          //           );
          //         } else {
          //           actionIcon = const Icon(Icons.search);
          //           customSearchBar = const Text('Search GitHub User');
          //         }
          //       });
          //     },
          //     icon: actionIcon)
        ],
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: UserDataSource.instance.getAllUser(searchController.text),
          builder: (
            BuildContext context,
            AsyncSnapshot<dynamic> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text("something error");
            }
            if (snapshot.hasData) {
              SearchUserModel userModel =
                  SearchUserModel.fromJson(snapshot.data);
              if (userModel.items != null) {
                return _buildSuccessSection(userModel);
              }
            }
            if (searchController.text == '') {
              return Center(
                  child: Text(
                "Tap on search icon",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ));
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildSuccessSection(data) {
    return Container(
      child: ListView.builder(
          itemCount: data.items.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: UserDataSource.instance
                  .getSpecificUser(data.items[index].login),
              builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Text("something error");
                }
                if (snapshot.hasData) {
                  ModelSpecificUser specificUser =
                      ModelSpecificUser.fromJson(snapshot.data);
                  if (specificUser.login != null) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.network(specificUser.avatarUrl!),
                            title: Text(specificUser.login!),
                            subtitle: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserRepo(
                                            userId: specificUser.login,
                                          )));
                                },
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Repository: " +
                                          specificUser.publicRepos.toString(),
                                      textAlign: TextAlign.start,
                                    ))),
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserFollowerFollowing(
                                                  section: "followers",
                                                  userId: specificUser.login,
                                                )));
                                  },
                                  child: Text(
                                      "${specificUser.followers.toString()} follower")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserFollowerFollowing(
                                                    section: "following",
                                                    userId:
                                                        specificUser.login)));
                                  },
                                  child: Text(
                                      "${specificUser.following.toString()} following "))
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }
                return _buildLoadingSection();
              },
            );
          }),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _searchControllerHandler() {
    print(searchController.text);
  }
}
