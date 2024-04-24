import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/features/chat_users/screen/chat_users_screen.dart';

import 'package:locachat/features/profile/screens/profile_screen.dart';
import 'package:locachat/features/chat/screen/chat_screen.dart';
import 'package:locachat/features/home/screens/home_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final double latitude;
  final double longitude;
  const BottomBar({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

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
      HomeScreen(
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
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
          selectedItemColor: GlobleVariable.selectedNavBarColor,
          unselectedItemColor: GlobleVariable.unselectedNavBarColor,
          backgroundColor: GlobleVariable.backgroundColor,
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
