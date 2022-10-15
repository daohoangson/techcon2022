import 'dart:io';

import 'package:document_client/document_client.dart';

class DynamodbUtil {
  static const keyPK = 'PK';
  static const keyValue = 'Value';
  static const userIdZero = '00000000-0000-0000-0000-000000000000';

  late final DocumentClient dc;
  late final String tableName;

  DynamodbUtil({
    AwsClientCredentials? credentials,
  }) {
    final region = Platform.environment['REGION'] ?? 'ap-southeast-1';
    dc = DocumentClient(
      credentials: credentials,
      region: region,
    );

    tableName = Platform.environment['STORAGE_THUMB_UPS_NAME'] ?? '';
  }

  Future<int> getThumbUps() async {
    final getResponse = await dc.get(
      tableName: tableName,
      key: {keyPK: userIdZero},
    );

    final value = getResponse.item[keyValue];
    if (value is num) {
      return value.toInt();
    } else {
      return 0;
    }
  }

  Future<void> thumbsUp(String userId) async {
    final transactItems = [
      TransactWrite(update: _buildUpdateOperation(userIdZero)),
      if (userId.isNotEmpty)
        TransactWrite(update: _buildUpdateOperation(userId)),
    ];
    await dc.transactWrite(transactItems: transactItems);
  }

  UpdateOperation _buildUpdateOperation(String pk) {
    return UpdateOperation(
      value: {keyPK: pk},
      tableName: tableName,
      expression: ':delta = :delta',
      updateExpression: 'ADD #value :delta',
      expressionAttributeNames: {'#value': keyValue},
      expressionAttributeValues: {':delta': 1},
    );
  }
}
