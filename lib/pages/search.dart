import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'activity_feed.dart';
import 'home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: searchController,
          onFieldSubmitted: handleSearch,
          decoration: InputDecoration(
            hintText: "Search for a user...",
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
        ));
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return linearProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchresult = new UserResult(user);
          searchResults.add(searchresult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: orientation == Orientation.portrait ? 300.0 : 100.0,
                    child: new Image.asset(
                      'assets/images/search.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurple,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0 ),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
                      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => showsearchProfile(context, profileId: user.id),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                  title: Text(
                    user.displayName,
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user.username,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white54,
              ),
            ],
        ),
      ),
          ),
    );
  }
}
