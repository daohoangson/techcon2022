import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<int> getValue() async {
    final endpoint = await _getEndpoint();
    final resp = await http.get(Uri.parse(endpoint));
    final value = int.tryParse(resp.body) ?? 0;
    return value;
  }

  Future<int> increaseValue() async {
    final user = await Amplify.Auth.getCurrentUser();
    final body = jsonEncode(<String, String>{'user_id': user.userId});
    final endpoint = await _getEndpoint();
    final resp = await http.post(Uri.parse(endpoint), body: body);
    final value = int.tryParse(resp.body) ?? 0;
    return value;
  }

  Future<String> _getEndpoint() async {
    final amplifyConfig = await Amplify.asyncConfig;
    final Map<String, AmplifyPluginConfig> apiPlugins =
        amplifyConfig.api?.plugins ?? {};
    for (final entry in apiPlugins.entries) {
      final apiConfig = entry.value.toJson()['techcon2022api'];
      if (apiConfig is! Map) {
        continue;
      }

      final endpoint = apiConfig['endpoint'];
      if (endpoint is! String) {
        continue;
      }

      return endpoint;
    }

    throw Exception(
      'Unable to determine endpoint from '
      'amplifyConfig=${amplifyConfig.toJson()}',
    );
  }
}
