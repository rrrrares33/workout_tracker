import 'package:flutter/material.dart';

class RoutersLanding {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const Text('gds'));
    }
  }
}
