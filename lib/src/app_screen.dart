import 'package:flutter/material.dart';

import 'api_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();

    _apiClient.getValue().then((value) {
      if (mounted) {
        setState(() => _counter = value);
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    _apiClient.increaseValue().then((value) {
      if (mounted && value > _counter) {
        setState(() => _counter = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have thumbed up this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Thumb up',
        child: const Icon(Icons.thumb_up),
      ),
    );
  }
}
