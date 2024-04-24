import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/data/response/status.dart';
import 'package:locachat/features/chat/screen/chat_screen.dart';
import 'package:locachat/provider/chat_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatUsersScreen extends StatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  ChatUsersScreenProvider chatUsersScreenProvider = ChatUsersScreenProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatUsersScreenProvider.getChatUsersApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Chats",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: hexToColor("4F4DAC"), fontFamily: "Poppins", fontSize: 32),
        ),
      ),
      body: ChangeNotifierProvider<ChatUsersScreenProvider>(
        create: (context) => chatUsersScreenProvider,
        child: Consumer<ChatUsersScreenProvider>(
          builder: (context, value, _) {
            switch (value.chatUserList.status) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                return Center(child: Text(value.toString()));

              case Status.COMPLETED:
                return ListView.builder(
                  itemCount: value.chatUserList.data!.user!.chatUsers!.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        Divider(
                          height: kHeight(1, context),
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: Image.network(
                            "$baseUrl/${value.chatUserList.data!.user!.chatUsers![index].profileImage}",
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              // If there's an error loading the network image (e.g., 404), display the asset image instead
                              return Image.asset(
                                "assets/images/profile.png",
                                height: kHeight(6, context),
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                          title: Text(
                            value
                                .chatUserList.data!.user!.chatUsers![index].name
                                .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            value.chatUserList.data!.user!.chatUsers![index]
                                .lastMessage
                                .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            value.chatUserList.data!.user!.chatUsers![index]
                                .lastMessageTime
                                .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        senderId: value.chatUserList.data!.user!
                                            .chatUsers![index].userId
                                            .toString(),
                                        receiverId: value.chatUserList.data!
                                            .user!.chatUsers![index].senderId
                                            .toString(),
                                        imageUrl: value.chatUserList.data!.user!
                                            .chatUsers![index].profileImage
                                            .toString(),
                                        name: value.chatUserList.data!.user!
                                            .chatUsers![index].name
                                            .toString())));
                          },
                        ),
                        // Add Divider if it's not the last item
                        if (index ==
                            value.chatUserList.data!.user!.chatUsers!.length -
                                1)
                          Divider(
                            height: kHeight(1, context),
                            thickness: 1,
                            color: Colors.grey,
                          ),
                      ],
                    );
                  }),
                );

              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
