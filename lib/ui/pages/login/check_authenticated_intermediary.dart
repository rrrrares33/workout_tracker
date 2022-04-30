import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/login_and_register_logic.dart';
import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/models/user_auth.dart';
import '../../widgets/loading.dart';

class CheckAuthenticated extends StatelessWidget {
  const CheckAuthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return StreamBuilder<User?>(
        stream: authenticationService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return returnIfUserConnected(snapshot.data);
          } else {
            return const LoadingWidget();
          }
        });
  }
}
