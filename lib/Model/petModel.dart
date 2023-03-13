class AnimalData{
  final String? name;
  AnimalData({this.name});

  static List<AnimalData> getSampleList(){
    return [
      AnimalData(name: 'Dog'),
      AnimalData(name: 'Cat'),
      AnimalData(name: 'Snake'),
      AnimalData(name: 'Bird'),
      AnimalData(name: 'Fish'),
      AnimalData(name: 'Turtle'),
      AnimalData(name: 'Lizard'),
      AnimalData(name: 'Worms'),
      AnimalData(name: 'Monkey'),
      AnimalData(name: 'Chicken'),
      AnimalData(name: 'Mouse'),
    ];
  }
  
  static List<String> getSampleList1(){
    return [
      'Dog',
      'Cat',
      'Snake',
      'Bird',
      'Fish',
      'Turtle',
      'Lizard',
      'Worms',
      'Monkey',
      'Chicken',
      'Mouse'
    ];
  }
  
  static List<String> getAnimalTypes(){
    return [
      'Dog',
      'Cat',
      'Snake',
      'Bird',
      'Fish',
      'Turtle,',
      'Lizard',
      'Worms',
      'Monkey',
      'Chicken',
      'Mouse'
    ];
  }
}

class PetModel{
  String? id,user_id,pet_name,pet_type,pet_gender,pet_img;

  PetModel(
    this.id,
    this.user_id,
    this.pet_name,
    this.pet_type,
    this.pet_gender,
    this.pet_img,
  );

  PetModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        pet_name = json['pet_name'],
        pet_type = json['pet_type'],
        pet_gender = json['pet_gender'],
        pet_img = json['pet_img']
    ;

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": user_id,
        "pet_name": pet_name,
        "pet_type": pet_type,
        "pet_gender": pet_gender,
        "pet_img": pet_img,
      };


}

