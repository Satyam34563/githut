
import 'package:flutter/material.dart';
import 'package:githut/screens/HomePage.dart';
import 'package:githut/screens/SplashScreen.dart';
Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScrren.routeName: (context) => const SplashScrren(),
  Homepage.routeName: (context) => const Homepage(),

};
