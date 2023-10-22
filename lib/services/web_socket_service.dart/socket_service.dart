import 'dart:convert';

import 'package:team_hurricane_hockey/models/server/game_event.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketService {
  SocketService._init();
  static final SocketService instance = SocketService._init();

  static WebSocketChannel? _socket;

  initSocketConnection(String gameId) {
    final uri = Uri.parse("ws://game-socket-a6hv.onrender.com/ws/play-game/$gameId/");
    _socket = IOWebSocketChannel.connect(uri.toString());
  }

  WebSocketChannel get socket {
    if (_socket != null) return _socket!;
    return _socket!;
  }

  connectAndListen(
    Function(dynamic) data,
    Function(dynamic) error,
    Function() onDone,
  ) async {
    socket.stream.listen(
      (event) async => data(event),
      onError: (err) async => await error(err),
      onDone: () async => onDone,
    );
  }

  sendData(GameEvent event) {
    socket.sink.add(jsonEncode(event));
  }

  closeConnection() {
    socket.sink.close(status.goingAway);
  }
}
