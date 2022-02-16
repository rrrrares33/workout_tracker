import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import '../../../models/user_auth.dart';
import '../entry_form/check_first_time.dart';
import 'login_page.dart';

class CheckAuthenticated extends StatelessWidget {
  const CheckAuthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return StreamBuilder<User?>(
        stream: authenticationService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null
                ? const LogInPage()
                : CheckFirstTime(loggedUserUid: user.getUid, loggedEmail: user.getEmail);
          } else {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
