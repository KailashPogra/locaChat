import 'dart:io';

import 'package:locachat/repository/update_profile_repo.dart';
import 'package:locachat/utils.dart';
import 'package:flutter/material.dart';

class UpdateProfileProvider extends ChangeNotifier {
  UpdateProfileRepository updateProfileRepository = UpdateProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> updateProfileApi(
      String name, String email, File? imageFile, BuildContext context) async {
    setLoading(true);
    updateProfileRepository
        .updateProfileApi(
      name: name,
      email: email,

      imageFile: imageFile, // Provide a default file if imageFile is null
    )
        .then((value) {
      setLoading(false);
      showSnackBar("profile update sucessfull");
    }).onError((error, stackTrace) {
      setLoading(false);
      showSnackBar("Error: $error");
    });
  }
}
