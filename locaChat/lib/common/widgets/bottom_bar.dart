import 'package:locachat/constants/custom_feature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/screens/chat_users/screen/chat_users_screen.dart';

import 'package:locachat/screens/profile/screens/profile_screen.dart';

import 'package:locachat/screens/home/screens/home_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget>? pages;
  @override
  void initState() {
    super.initState();
    pages = [
      const HomeScreen(),
      const ChatUsersScreen(),
      const ProfileScreen(),
    ];
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages![_page],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: GlobleVariable.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          border: Border(
            top: BorderSide(
              color: hexToColor("41327E"),
              width: bottomBarBorderWidth,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.blue,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey
              : Colors.black54,
          iconSize: 28,
          onTap: updatePage,
          items: [
            // HOME
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 0
                          ? hexToColor("41327E")
                          : GlobleVariable.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.map,
                  color: hexToColor("41327E"),
                ),
              ),
              label: '',
            ),
            // ACCOUNT
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 1
                          ? hexToColor("41327E")
                          : GlobleVariable.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: Icon(Icons.message, color: hexToColor("41327E")),
              ),
              label: '',
            ),
            // CART
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 2
                          ? hexToColor("41327E")
                          : GlobleVariable.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child:
                    Icon(Icons.person_2_outlined, color: hexToColor("41327E")),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
