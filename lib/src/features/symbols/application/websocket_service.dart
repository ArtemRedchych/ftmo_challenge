import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebsocketService {
  WebsocketService(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url));

  final WebSocketChannel _channel;

  Stream<String> get stream => _channel.stream.cast<String>();

  void send(String message) {
    _channel.sink.add(message);
  }

  void close() {
    _channel.sink.close(status.normalClosure);
  }
}

