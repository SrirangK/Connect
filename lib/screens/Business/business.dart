import 'package:flutter/material.dart';
import 'package:connect/screens/Business/business_home_page.dart';
import 'package:connect/screens/Business/my_posts.dart';

import '../../APIS/apis.dart';
import '../profile/pofile_screen.dart';

class Business extends StatefulWidget {
  const Business({Key? key}) : super(key: key);

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Business',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(user: API.me)),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white, // Color of the indicator
            labelColor: Colors.white, // Color of the selected tab text/icon
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'My Posts'),
              Tab(text: 'All'),
            ],
          ),

        ),
        body: TabBarView(
          children: [
            MyPosts(),
            BusinessHomePage() // Replace with your other page widget
          ],
        ),
      ),
    );
  }
}
