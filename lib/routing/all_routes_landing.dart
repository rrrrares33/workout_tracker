import 'package:flutter/material.dart';

import '../firebase/check_authenticated.dart';
import '../ui/logging_screens/forgotten_password.dart';
import '../ui/logging_screens/home_page.dart';
import '../ui/logging_screens/login_email_pass_page.dart';
import '../ui/logging_screens/login_page.dart';
import '../ui/logging_screens/register_page.dart';
import 'routing_constants.dart';

class RoutersLanding {
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
      case LogInWithEmailAndPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const LogInPageEmailAndPassword());
      case ForgottenPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const ForgottenPassword());
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const CheckAuthenticated());
    }
  }
}
