import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String menuName;
  final IconData menuIcon;

  const MenuItem({
    @required this.menuName,
    @required this.menuIcon,
  });
}

List<MenuItem> menuItems = [
  MenuItem(
    menuName: 'Home',
    menuIcon: Icons.home,
  ),
  MenuItem(
    menuName: 'Cart',
    menuIcon: Icons.local_grocery_store,
  ),
  MenuItem(
    menuName: 'My Account',
    menuIcon: Icons.account_box,
  ),
  MenuItem(
    menuName: 'Notifications',
    menuIcon: Icons.notifications,
  ),
  MenuItem(
    menuName: 'Payments',
    menuIcon: Icons.payment,
  ),
  MenuItem(
    menuName: 'Settings',
    menuIcon: Icons.settings,
  ),
];

Map<int, Color> color = {
  50: Color.fromRGBO(255, 92, 87, .1),
  100: Color.fromRGBO(255, 92, 87, .2),
  200: Color.fromRGBO(255, 92, 87, .3),
  300: Color.fromRGBO(255, 92, 87, .4),
  400: Color.fromRGBO(255, 92, 87, .5),
  500: Color.fromRGBO(255, 92, 87, .6),
  600: Color.fromRGBO(255, 92, 87, .7),
  700: Color.fromRGBO(255, 92, 87, .8),
  800: Color.fromRGBO(255, 92, 87, .9),
  900: Color.fromRGBO(255, 92, 87, 1),
};
