import 'package:flutter/material.dart';
import '../firebase/check_authenticated.dart';

import '../ui/home_page.dart';
import '../ui/login_page.dart';
import '../ui/register_page.dart';
import 'routing_constants.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LandingPageRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const CheckAuthenticated());
      case RegisterPageRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const RegisterPage());
      case LogInPageRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const LogInPage());
      case HomePageRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const CheckAuthenticated());
    }
  }
}
