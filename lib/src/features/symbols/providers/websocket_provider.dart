import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/constants/constants.dart';
import 'package:ftmo/src/features/symbols/application/websocket_service.dart';

final websocketServiceProvider = Provider<WebsocketService>((ref) {
  return WebsocketService(webSoketUrl);
});