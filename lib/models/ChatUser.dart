

class ChatUser {

  ChatUser({
    required this.image,
    required this.interest,
    required this.username,
    required this.status,
    required this.id,
    required this.email,
    required this.group,
  });
  late String image;
  late String interest;
  late String username;
  late String status;
  late String id;
  late String email;
  late List group;


  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    username = json['username'] ?? '';
    status = json['status'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    interest=json['interest']?? '';
    group=json['group']?? [];

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['interest'] = interest;
    data['username'] = username;
    data['status'] = status;
    data['id'] = id;
    data['email'] = email;
    data['group'] = group;

    return data;
  }

  static Future<ChatUser> fromMap(Map<String, dynamic> data) {
    return Future.value(ChatUser.fromJson(data));
  }
}