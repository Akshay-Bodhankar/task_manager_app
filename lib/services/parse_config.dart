// lib/services/parse_config.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseConfig {
  // TODO: replace with your Back4App credentials
  static const String applicationId = 'b5LF7L8XbPz1AvQm3ArBp1BEwth6wymcgKM6lqZA';
  static const String clientKey = 'MNvA2nnQZB0d8mnjNLOsGfgC49AlhnyGSP1J35TP';
  static const String serverUrl = 'https://parseapi.back4app.com';

  static Future<void> init() async {
    await Parse().initialize(
      applicationId,
      serverUrl,
      clientKey: clientKey,
      debug: true,
      autoSendSessionId: true,
    );
  }

  static Future<ParseUser?> currentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user;
  }

  static Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) await user.logout();
  }
}
