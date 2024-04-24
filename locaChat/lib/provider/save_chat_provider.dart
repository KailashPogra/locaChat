import 'package:locachat/repository/save_chat_repo.dart';
import 'package:locachat/utils.dart';
import 'package:flutter/material.dart';

class SaveChatProvider extends ChangeNotifier {
  final saveChatRepo = SaveChatRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> saveChatApi(dynamic data, BuildContext context) async {
    setLoading(true);
    saveChatRepo.saveChatApi(data).then((value) {
      setLoading(false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully'),
        ),
      );
    }).onError((error, stackTrace) {
      setLoading(false);

      showSnackBar(context, error.toString());
    });
  }
}
