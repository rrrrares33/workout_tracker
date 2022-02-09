import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/database_service.dart';
import 'check_first_time.dart';

class PostLoginPage extends StatelessWidget {
  const PostLoginPage({Key? key, required this.uid, required this.email}) : super(key: key);

  final String uid;
  final String email;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider<dynamic>>[
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
      ],
      child: CheckFirstTime(loggedUserUid: uid, loggedEmail: email),
    );
  }
}
