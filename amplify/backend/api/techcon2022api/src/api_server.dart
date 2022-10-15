import 'dart:io';

import 'http_request.dart';

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv6, port);
  print('API Server is listening at :$port');

  await server.forEach((HttpRequest request) async {
    final resp = request.response;
    final reqBody = await RequestBody.fromHttpRequest(request);

    try {
      // TODO: some fancy business logic goes here
      await Future.delayed(const Duration(milliseconds: 1));
      resp.write('Hello userId=${reqBody.userId}');
    } catch (error) {
      resp.statusCode = 500;
      resp.write('$error');
    } finally {
      resp.close();
    }
  });
}
