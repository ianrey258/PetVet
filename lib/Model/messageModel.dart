class MessageModel{
  String? id,user,message,type,datetime;

  MessageModel(
    this.id,
    this.user,
    this.message,
    this.type,
    this.datetime
  );

  MessageModel.fromMap(Map<String, dynamic> json):
    id = json['id'],
    user = json['user'],
    message = json['message'],
    type = json['type'],
    datetime = json['datetime']
    ;

  Map<String, dynamic> toMap() => {
    "id":id,
    "user": user,
    "message": message,
    "type": type,
    "datetime": datetime
  };
}

class MessageIdModel{
  String? id;
  List? users_id;

  MessageIdModel(
    this.id,
    this.users_id
  );

  MessageIdModel.fromMap(Map<String, dynamic> json):
    id = json['id'],
    users_id = json['users_id']
    ;

  Map<String, dynamic> toMap() => {
    "id":id,
    "users_id": users_id as List
  };
}
