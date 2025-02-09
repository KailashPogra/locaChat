import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locachat/constants/api_url.dart';
import 'package:locachat/repository/get_chat_repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];
  //GET CHAT
  final StreamController<List<Map<String, dynamic>>> streamController =
      StreamController.broadcast();
  // Expose the stream
  Stream<List<Map<String, dynamic>>> get stream => streamController.stream;

  List<Map<String, dynamic>> get messages => _messages;

  void getChat(
    String senderId,
    String receiverId,
  ) async {
    try {
      List<Map<String, dynamic>> messages = await GetChatRepo().getChatApi(
        senderId,
        receiverId,
      );

      _messages.addAll(messages);

      streamController.add(_messages);
      ChangeNotifier();
    } catch (e) {
      rethrow;
    }
  }

  IO.Socket socket = IO.io(
    baseUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNewConnection()
        .build(),
  );

  void connected(String senderIds, String receiverIds) {
    socket.onConnect((data) {
      print('connected');
      // Convert MongoDB ObjectIDs to strings
      String senderId = senderIds;
      String receiverId = receiverIds;
      // Sort the sender and receiver IDs alphabetically
      List<String> sortedIds = [senderId, receiverId]..sort();
      // Join room with sorted sender and receiver IDs
      String roomId = sortedIds.join('_');
      socket.emit('join', {'roomId': roomId});
    });

    socket.on('message', (data) {
      final message = data as Map<String, dynamic>;

      _messages.add(message);

      streamController.add(_messages);
      notifyListeners();
    });
    socket.on('notification', (data) {
      final notification = data as Map<String, dynamic>;
      // Handle the notification
      print('Received notification: ${notification['message']}');
    });
    socket.onConnectError((data) => print(data));
    socket.onDisconnect((data) => print(data));
  }

  void sendMessage(
    String message,
    String senderIds,
    String receiverIds,
  ) {
    // Convert senderId and receiverId to strings
    String senderId = senderIds;
    String receiverId = receiverIds;
    // Sort the sender and receiver IDs alphabetically
    List<String> sortedIds = [senderId, receiverId]..sort();
    // Join room with sorted sender and receiver IDs
    String roomId = sortedIds.join('_');

    socket.emit('message', {
      'receiverId': receiverId,
      'senderId': senderId,
      'roomId': roomId, // Include roomId in the message data
      'message': message
    });
  }

  // for notification
  Map<String, dynamic> sendNotification(String name, String text,
      String senderId, String receiverId, String imageUrl) {
    return {
      'to': fcmToken,
      'notification': {
        'title': name,
        'body': text.toString(),
        "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {
        'type': 'msj',
        'receiverId': receiverId,
        'senderId': senderId,
        'imageUrl': imageUrl,
        'name': name
      }
    };
  }

  // save chat data
  Map<String, dynamic> saveChat(
      String text, String senderId, String receiverId) {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": text,
    };
  }
}
