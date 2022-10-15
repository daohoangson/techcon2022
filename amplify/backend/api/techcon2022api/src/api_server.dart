import 'dart:io';

import 'aws_client_credentials.dart';
import 'aws_dynamodb.dart';
import 'http_request.dart';

void main() async {
  final db = new DynamodbUtil(credentials: await CredentialsUtil.resolve());

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv6, port);
  print('API Server is listening at :$port');

  await server.forEach((HttpRequest request) async {
    final resp = request.response;
    final reqBody = await RequestBody.fromHttpRequest(request);

    try {
      if (request.method == 'POST') {
        // increase counter on POST request
        await db.thumbsUp(reqBody.userId ?? '');
      }

      // always return the latest value
      final value = await db.getThumbUps();
      resp.write('$value');
    } catch (error) {
      resp.statusCode = 500;
      resp.write('$error');
    } finally {
      resp.close();
    }
  });
}
