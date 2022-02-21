import 'package:flutter/material.dart';

import '../../ui/pages/login/check_authenticated_intermediary.dart';
import '../../ui/pages/login/forgotten_password_page.dart';
import '../../ui/pages/login/login_email_pass_page.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/login/register_page.dart';
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
      case LogInWithEmailAndPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const LogInPageEmailAndPassword());
      case ForgottenPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const ForgottenPassword());
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const CheckAuthenticated());
    }
  }
}
