import 'package:flutter/material.dart';
import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_feature.dart';
import 'package:locachat/provider/chat_screen_provider.dart';
import 'package:locachat/provider/save_chat_provider.dart';

import 'package:locachat/repository/get_fcm.dart';
import 'package:locachat/repository/send_notification.dart';
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
  ChatScreenProvider chatScreenProvider = ChatScreenProvider();
  final TextEditingController _controller = TextEditingController();
  SendNotificationRepo sendNotificationRepo = SendNotificationRepo();
  final GetFcmRepo fcmRepo = GetFcmRepo();

  late ScrollController _scrollController;
  String? fcmToken;

  @override
  void initState() {
    chatScreenProvider.getChat(widget.senderId, widget.receiverId);
    super.initState();
    fcmRepo
        .getFcmApi(widget.receiverId)
        .then((value) => fcmToken = value['token']['fcmToken']);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    chatScreenProvider.connected(widget.senderId, widget.receiverId);
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

  @override
  Widget build(BuildContext context) {
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
            child: ChangeNotifierProvider<ChatScreenProvider>(
              create: (context) => chatScreenProvider,
              child: Consumer<ChatScreenProvider>(
                builder: (BuildContext context, ChatScreenProvider value,
                    Widget? child) {
                  return StreamBuilder<List<Map<String, dynamic>>>(
                      stream: chatScreenProvider.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text(""));
                        }
                        return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> message =
                                snapshot.data!.reversed.toList()[index];
                            final isSent = message['senderId'].toString() ==
                                widget.senderId.toString();
                            return ListTile(
                              title: Align(
                                alignment: isSent
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
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
                        );
                      });
                },
              ),
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
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      return;
                    } else {
                      chatScreenProvider.sendMessage(
                          _controller.text, widget.senderId, widget.receiverId);
                      saveChatProvider.saveChatApi(
                          chatScreenProvider.saveChat(_controller.text,
                              widget.senderId, widget.receiverId),
                          context);
                      sendNotificationRepo.sendNotificationApi(
                          chatScreenProvider.sendNotification(
                              widget.name,
                              _controller.text,
                              widget.senderId,
                              widget.receiverId,
                              widget.imageUrl));
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
    chatScreenProvider.streamController.close();
    chatScreenProvider.socket.disconnect();
    super.dispose();
  }
}
