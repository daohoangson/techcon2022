import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_color_generator/material_color_generator.dart';

import '../amplifyconfiguration.dart';
import 'app_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      debugPrint('Could not configure Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget built = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: const Color(0xFF04348C)),
      ),
      builder: Authenticator.builder(),
      home: const MyHomePage(title: 'Techcon 2022'),
    );

    built = Authenticator(child: built);

    return built;
  }
}
