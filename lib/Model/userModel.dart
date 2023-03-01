class UserModel{
  String? id,username,fullname,address,email,password,birthdate,profile_img,auth_key;

  UserModel(
    this.id,
    this.username,
    this.fullname,
    this.address,
    this.email,
    this.password,
    this.birthdate,
    this.profile_img,
    this.auth_key,
  );

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        fullname = json['fullname'],
        address = json['address'],
        email = json['email'],
        password = json['password'],
        birthdate = json['birthdate'],
        profile_img = json['profile_img'],
        auth_key = json['auth_key']
    ;

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "fullname": fullname,
        "address": address,
        "email": email,
        "password": password,
        "birthdate": birthdate,
        "profile_img": profile_img,
        "auth_key": auth_key,
      };

}

class UserAppointmentModel{
  String? id,clinic_id;

  UserAppointmentModel(
    this.id,
    this.clinic_id
  );

  UserAppointmentModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        clinic_id = json['clinic_id']
    ;

  Map<String, dynamic> toMap() => {
        "id": id,
        "clinic_id": clinic_id,
      };
}