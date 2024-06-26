import 'package:flutter/material.dart';
import 'package:connect/screens/Business/business.dart';

import '../screens/Personal_chat/chat_page.dart';
import '../screens/communities/group_chat_pagr.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _Navigations_ScreenState();
}

int _currentIndex = 0;

class _Navigations_ScreenState extends State<BottomNavBar> {
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Communities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Business',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          ChatPage(),
          GroupChatPage(),
          Business(),

        ],
      ),
    );
  }
}