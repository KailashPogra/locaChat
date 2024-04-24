class NearbyUser {
  bool? success;
  String? senderId;
  List<NearbyUsers>? nearbyUsers;

  NearbyUser({this.success, this.senderId, this.nearbyUsers});

  NearbyUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    senderId = json['senderId'];
    if (json['nearbyUsers'] != null) {
      nearbyUsers = <NearbyUsers>[];
      json['nearbyUsers'].forEach((v) {
        nearbyUsers!.add(new NearbyUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['senderId'] = this.senderId;
    if (this.nearbyUsers != null) {
      data['nearbyUsers'] = this.nearbyUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearbyUsers {
  String? sId;
  String? name;
  String? profileImage;

  NearbyUsers({this.sId, this.name, this.profileImage});

  NearbyUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
