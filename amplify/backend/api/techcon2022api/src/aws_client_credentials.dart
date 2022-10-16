import 'dart:convert';
import 'dart:io';

import 'package:document_client/document_client.dart';

class CredentialsUtil {
  static const keyFullUri = 'AWS_CONTAINER_CREDENTIALS_FULL_URI';
  static const keyRelativeUri = 'AWS_CONTAINER_CREDENTIALS_RELATIVE_URI';

  static Future<AwsClientCredentials?> resolve() async {
    var fullUri = Platform.environment[keyFullUri] ?? '';
    if (fullUri.isEmpty) {
      final relativeUri = Platform.environment[keyRelativeUri] ?? '';
      if (relativeUri.isNotEmpty) {
        // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
        fullUri = 'http://169.254.170.2$relativeUri';
      }
    }
    if (fullUri.isEmpty) {
      return null;
    }

    String? respBody;
    try {
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(fullUri));
      final resp = await req.close();
      respBody = await resp.transform(utf8.decoder).join();
    } catch (error) {
      print('CredentialsUtil.resolve: $error');
      return null;
    }

    final respJson = jsonDecode(respBody);
    if (respJson is! Map) {
      print(
        'CredentialsUtil.resolve: '
        'Unexpected response body runtimeType=${respJson.runtimeType}',
      );
      return null;
    }

    final accessKeyId = respJson['AccessKeyId'] ?? '';
    final secretAccessKey = respJson['SecretAccessKey'] ?? '';
    final token = respJson['Token'] ?? '';
    final expirationJson = respJson['Expiration'] ?? '';
    final expiration = DateTime.tryParse('$expirationJson');
    if (accessKeyId is! String ||
        secretAccessKey is! String ||
        token is! String ||
        expiration == null) {
      print(
        'CredentialsUtil.resolve: '
        'Unexpected response body $respBody',
      );
      return null;
    }

    print(
      'CredentialsUtil.resolve: '
      'expirationJson=$expirationJson '
      'expiration=${expiration.millisecondsSinceEpoch}',
    );

    return AwsClientCredentials(
      accessKey: accessKeyId,
      expiration: expiration,
      secretKey: secretAccessKey,
      sessionToken: token,
    );
  }
}
