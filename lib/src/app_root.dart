import 'package:flutter/material.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'app_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget built = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: const Color(0xFF04348C)),
      ),
      home: const MyHomePage(title: 'Techcon 2022'),
    );

    return built;
  }
}
