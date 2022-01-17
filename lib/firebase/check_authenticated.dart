import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../ui/home_page.dart';
import '../ui/login_page.dart';
import 'authentication_service.dart';

class CheckAuthenticated extends StatelessWidget {
  const CheckAuthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context);
    return StreamBuilder<User?>(
        stream: authenticationService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null ? const LogInPage() : const HomePage();
          } else {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
