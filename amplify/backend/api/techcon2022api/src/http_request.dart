import 'dart:convert';
import 'dart:io';

class RequestBody {
  final String? userId;

  RequestBody._({
    this.userId,
  });

  static Future<RequestBody> fromHttpRequest(HttpRequest request) async {
    if (request.method != 'POST') {
      return RequestBody._();
    }

    final reqBody = await utf8.decodeStream(request);
    Map reqMap;
    try {
      final reqJson = jsonDecode(reqBody);
      if (reqJson is! Map) {
        return RequestBody._();
      }
      reqMap = reqJson;
    } catch (error) {
      print('jsonDecode($reqBody): $error');
      return RequestBody._();
    }

    String? userId;
    final reqUserId = reqMap['user_id'];
    if (reqUserId is String) {
      userId = reqUserId;
    }

    return RequestBody._(
      userId: userId,
    );
  }
}
