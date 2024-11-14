
//model class for users
class MyUser {
  String? userId;
  String? userName;
  String? userEmail;


  MyUser({
    this.userId,
    this.userName,
    this.userEmail,

  });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
    userId: json["user_id"],
    userName: json['user_name'],
    userEmail: json["user_email"],

  );
}
