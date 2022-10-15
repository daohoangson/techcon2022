import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  Future<int> getValue() async {
    const opts = RestOptions(path: '/');
    final resp = await Amplify.API.get(restOptions: opts).response;
    final value = int.tryParse(resp.body) ?? 0;
    return value;
  }

  Future<int> increaseValue() async {
    final user = await Amplify.Auth.getCurrentUser();
    final body = jsonEncode(<String, String>{'user_id': user.userId});
    final opts = RestOptions(
      path: '/',
      body: Uint8List.fromList(body.codeUnits),
    );
    final resp = await Amplify.API.post(restOptions: opts).response;
    final value = int.tryParse(resp.body) ?? 0;
    return value;
  }
}
