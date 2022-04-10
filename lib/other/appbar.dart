import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokebag/homepage.dart';
import 'package:pokebag/my_poke.dart';
import 'package:pokebag/theme.dart';

PreferredSizeWidget appbar(
  String title, {
  bool isHome = false,
  bool mypoke = false,
}) {
  return AppBar(
    title: Text(title),
    automaticallyImplyLeading: isHome ? false : true,
    leading: mypoke && !isHome
        ? IconButton(
            onPressed: () {
              Get.off(HomePage());
            },
            icon: Icon(Icons.arrow_back))
        : null,
    actions: [
      mypoke
          ? Container()
          : ElevatedButton(
              onPressed: () {
                Get.to(MyPoke());
              },
              child: Text(
                'Pokebag',
                style: buttonStyle,
              )),
      IconButton(
          icon: Icon(Icons.lightbulb),
          onPressed: () {
            Get.isDarkMode
                ? Get.changeTheme(ThemeData.light())
                : Get.changeTheme(ThemeData.dark());
          })
    ],
  );
}
