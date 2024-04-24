class chatUserModel {
  bool? success;
  User? user;

  chatUserModel({this.success, this.user});

  chatUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? profileImage;
  List<ChatUsers>? chatUsers;

  User({this.name, this.profileImage, this.chatUsers});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profileImage'];
    if (json['chatUsers'] != null) {
      chatUsers = <ChatUsers>[];
      json['chatUsers'].forEach((v) {
        chatUsers!.add(new ChatUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    if (this.chatUsers != null) {
      data['chatUsers'] = this.chatUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatUsers {
  String? userId;
  String? name;
  String? profileImage;
  String? lastMessage;
  String? lastMessageTime;
  String? senderId;

  ChatUsers(
      {this.userId,
      this.name,
      this.profileImage,
      this.lastMessage,
      this.lastMessageTime,
      this.senderId});

  ChatUsers.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    profileImage = json['profileImage'];
    lastMessage = json['lastMessage'];
    lastMessageTime = json['lastMessageTime'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageTime'] = this.lastMessageTime;
    data['senderId'] = this.senderId;
    return data;
  }
}
