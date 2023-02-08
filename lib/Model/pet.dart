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
  
  static List getSampleList1(){
    return [
      'Dog'
      'Cat'
      'Snake'
      'Bird'
      'Fish'
      'Turtle'
      'Lizard'
      'Worms'
      'Monkey'
      'Chicken'
      'Mouse'
    ];
  }
}

