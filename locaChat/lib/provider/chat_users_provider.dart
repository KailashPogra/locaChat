import 'package:locachat/data/response/api_response.dart';
import 'package:locachat/models/chat_user_model.dart';

import 'package:locachat/repository/chat_users_repo.dart';

import 'package:flutter/material.dart';

class ChatUsersScreenProvider extends ChangeNotifier {
  final chatUsersScreenRepo = ChatUsersRepository();

  ApiResponse<chatUserModel> chatUserList = ApiResponse.loading();

  setChatUser(ApiResponse<chatUserModel> response) {
    chatUserList = response;
    notifyListeners();
  }

  Future<void> getChatUsersApi() async {
    setChatUser(ApiResponse.loading());
    chatUsersScreenRepo.getChatUsersApi().then((value) {
      setChatUser(ApiResponse.completed(value));
      print(value);
    }).onError((error, stackTrace) {
      print(error.toString());
      setChatUser(ApiResponse.error(error.toString()));
    });
  }
}
