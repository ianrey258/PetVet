class reviewModel{
  String? id,user_name,email,comment,rate;

  reviewModel(
    this.id,
    this.user_name,
    this.email,
    this.comment,
    this.rate
  );

  reviewModel.fromMap(Map<String, dynamic> json):
    id = json['id'],
    user_name = json['user_name'],
    email = json['email'],
    comment = json['comment'],
    rate = json['rate']
    ;

  Map<String, dynamic> toMap() => {
    "id":id,
    "user_name":user_name,
    "email":email,
    "comment":comment,
    "rate":rate
  };
}
