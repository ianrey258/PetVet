class RatingReviewModel{
  String? id,user_id,email,comment,rate,datatime;

  RatingReviewModel(
    this.id,
    this.user_id,
    this.comment,
    this.datatime,
    this.rate
  );

  RatingReviewModel.fromMap(Map<String, dynamic> json):
    id = json['id'],
    user_id = json['user_id'],
    datatime = json['datatime'],
    comment = json['comment'],
    rate = json['rate']
    ;

  Map<String, dynamic> toMap() => {
    "id":id,
    "user_id":user_id,
    "datatime":datatime,
    "comment":comment,
    "rate":rate
  };
}
