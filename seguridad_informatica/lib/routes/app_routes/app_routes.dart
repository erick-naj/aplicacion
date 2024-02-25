import 'package:flutter/material.dart';
import 'package:seguridad_informatica/pages/explore_page.dart';
import 'package:seguridad_informatica/pages/login.dart';
import 'package:seguridad_informatica/pages/registrer_page.dart';

final appRoutes = <String, WidgetBuilder>{
  Login.pageName: (_) => Login(),
  RegistrerPage.pageName: (_) => RegistrerPage(),
  ExplorePage.pageName: (_) => ExplorePage(),
};
