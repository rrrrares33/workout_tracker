import 'package:flutter/material.dart';

import '../ui/entry_form/post_login_page.dart';
import '../ui/login/check_authenticated.dart';
import '../ui/login/forgotten_password.dart';
import '../ui/login/login_email_pass_page.dart';
import '../ui/login/login_page.dart';
import '../ui/login/register_page.dart';
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
        return MaterialPageRoute<dynamic>(builder: (_) => const PostLoginPage(uid: '', email: ''));
      case LogInWithEmailAndPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const LogInPageEmailAndPassword());
      case ForgottenPasswordRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const ForgottenPassword());
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const CheckAuthenticated());
    }
  }
}
