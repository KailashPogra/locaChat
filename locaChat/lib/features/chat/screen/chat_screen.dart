import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/provider/save_chat_provider.dart';
import 'package:locachat/repository/get_chat_repo.dart';
import 'package:locachat/repository/get_fcm.dart';
import 'package:locachat/repository/send_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String senderId;
  final String imageUrl;
  final String name;
  const ChatScreen(
      {Key? key,
      required this.senderId,
      required this.receiverId,
      required this.imageUrl,
      required this.name})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  SendNotificationRepo sendNotificationRepo = SendNotificationRepo();
  final GetFcmRepo fcmRepo = GetFcmRepo();
  final List<Map<String, dynamic>> _messages = [];
  late ScrollController _scrollController;
  String? fcmToken;
  IO.Socket socket = IO.io(
    baseUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNewConnection()
        .build(),
  );

  @override
  void initState() {
    super.initState();
    fcmRepo
        .getFcmApi(widget.receiverId)
        .then((value) => fcmToken = value['token']['fcmToken']);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Check if the socket is not already connected
    if (!socket.connected) {
      socket.connect();
    }

    connected();
    getChat();
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // At the bottom of list
    }
  }

  void getChat() async {
    try {
      List<Map<String, dynamic>> messages = await GetChatRepo().getChatApi(
        widget.senderId,
        widget.receiverId,
      );
      setState(() {
        _messages.addAll(messages);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom(); // Scroll to the bottom after the build is complete
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  void connected() {
    socket.onConnect((data) {
      print('connected');
      // Convert MongoDB ObjectIDs to strings
      String senderId = widget.senderId.toString();
      String receiverId = widget.receiverId.toString();
      // Sort the sender and receiver IDs alphabetically
      List<String> sortedIds = [senderId, receiverId]..sort();
      // Join room with sorted sender and receiver IDs
      String roomId = sortedIds.join('_');
      socket.emit('join', {'roomId': roomId});
    });

    socket.on('message', (data) {
      final message = data as Map<String, dynamic>;
      setState(() {
        _messages.add(message);
        scrollToBottom();
      });
    });
    socket.on('notification', (data) {
      final notification = data as Map<String, dynamic>;
      // Handle the notification
      print('Received notification: ${notification['message']}');
    });
    socket.onConnectError((data) => print(data));
    socket.onDisconnect((data) => print(data));
  }

  void _sendMessage(String message) {
    // Convert senderId and receiverId to strings
    String senderId = widget.senderId.toString();
    String receiverId = widget.receiverId.toString();
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

    print('Sent message: $message');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.senderId + " " + widget.receiverId);
    final saveChatProvider =
        Provider.of<SaveChatProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(
                height: kHeight(8, context),
                width: kWidth(12, context),
                child: Image.network(
                  "$baseUrl/${widget.imageUrl}",
                  // fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    // If there's an error loading the network image (e.g., 404), display the asset image instead
                    return Image.asset(
                      "assets/images/profile.png",
                      height: kHeight(1, context),
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name),
                  const Text(
                    "online",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert), // This is the dots icon
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> message =
                    _messages.reversed.toList()[index];
                final isSent = message['senderId'].toString() ==
                    widget.senderId.toString();
                return ListTile(
                  title: Align(
                    alignment:
                        isSent ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: isSent
                            ? const BorderRadius.only(
                                topRight: Radius.circular(0),
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))
                            : const BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0)),
                        color: isSent
                            ? hexToColor("978BC4")
                            : hexToColor(
                                "7465B1"), // Customize colors for sent and received messages
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        message['message'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "senderId": widget.senderId,
                      "receiverId": widget.receiverId,
                      "message": _controller.text,
                    };
                    var notificationData = {
                      'to': fcmToken,
                      'notification': {
                        'title': widget.name,
                        'body': _controller.text.toString(),
                        "sound": "jetsons_doorbell.mp3"
                      },
                      'android': {
                        'notification': {
                          'notification_count': 23,
                        },
                      },
                      'data': {
                        'type': 'msj',
                        'receiverId': widget.receiverId,
                        'senderId': widget.senderId,
                        'imageUrl': widget.imageUrl,
                        'name': widget.name
                      }
                    };
                    if (_controller.text.isEmpty) {
                      return;
                    } else {
                      _sendMessage(_controller.text);
                      saveChatProvider.saveChatApi(data, context);
                      sendNotificationRepo
                          .sendNotificationApi(notificationData);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();

    super.dispose();
  }
}
