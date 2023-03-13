class ClinicData{
  final String? name;
  final String? address;
  final String? img;
  final String? banner;
  final String? lat;
  final String? lng;
  final String? rating;
  final List<ClinicService>? services;

  ClinicData({
    this.name,
    this.address,
    this.img,
    this.banner,
    this.lat,
    this.lng,
    this.rating,
    this.services
  });

  // Map toObjectString({
  //   "name":this.name.toString(),
  //   "address":this.address.,
  //   "img":this.img.,
  //   "banner":this.banner.,
  //   "lat":this.lat.,
  //   "lng":this.lng.,
  //   "rating":this.rating.,
  //   "services":this.services.
  // });
  // {"name":"Cats And Dog","image":"assets/images/cats_and_dogs.png","lat":"8.483989","lng":"124.6599067"}
  // ,"lat":"8.4753081","lng":"124.6716228"

  static List<ClinicData> getSampleData(){
    return [
      ClinicData(
        name: 'PetVet Central Vet Clinic',
        address: "Lorraine's Portico, Masterson Ave, Cagayan de Oro, 9000 Misamis Oriental",
        img: 'assets/images/PetVetClinic/logo.png',
        banner: 'assets/images/PetVetClinic/banner.png',
        lat: '8.4753081',
        lng: '124.6716228',
        rating: '4',
        services: [
          ClinicService(name: 'Diagnostic and Therapeutic'),
          ClinicService(name: 'Surgical'),
          ClinicService(name: 'Anesthesia'),
          ClinicService(name: 'Internal medicine'),
          ClinicService(name: 'Radiology Services'),
        ],
      ),
      ClinicData(
        name: 'CAGAYAN DOG & CAT CLINIC',
        address: "Vamenta Bldg, Vamenta Blvd, Cagayan de Oro, 9000 Misamis Oriental",
        img: 'assets/images/CagayanDog&CatClinic/logo1.png',
        banner: 'assets/images/CagayanDog&CatClinic/banner1.png',
        lat: '8.4826239',
        lng: '124.638474',
        rating: '3.5',
        services: [
      ClinicService(name: 'Electrocardiography Services'),
      ClinicService(name: 'Dentistry'),
      ClinicService(name: 'Laboratory'),
      ClinicService(name: 'Permanent identification'),
      ClinicService(name: 'Pharmacy'),
        ],
      ),
      ClinicData(
        name: 'B. Baldonado Veterinary Clinic',
        address: "Tomas Saco St. & 14th St., Macasandig, Cagayan de Oro, 9000 Misamis Oriental",
        img: 'assets/images/BaldonadoVeterinaryClinic/logo2.png',
        banner: 'assets/images/BaldonadoVeterinaryClinic/banner2.png',
        lat: '8.4680643',
        lng: '124.6455383',
        rating: '5',
        services: [
      ClinicService(name: 'Dietary Counseling'),
      ClinicService(name: 'Behavioral Counseling'),
      ClinicService(name: 'Boarding'),
      ClinicService(name: 'Bathing and Grooming'),
      ClinicService(name: 'Emergency Care'),
        ],
      ),
      ClinicData(
        name: 'CASAS-JAMIS Veterinary Clinic',
        address: "Lot 33 Block 7, Xavier Estates, Masterson Avenue, Cagayan de Oro, 9000 Misamis Oriental",
        img: 'assets/images/CasasJamisVeterinaryClinic/logo3.png',
        banner: 'assets/images/CasasJamisVeterinaryClinic/banner3.png',
        lat: '8.44408',
        lng: '124.6194323',
        rating: '4.5',
        services: [
      ClinicService(name: 'Electrocardiography Services'),
      ClinicService(name: 'Dentistry'),
      ClinicService(name: 'Laboratory'),
      ClinicService(name: 'Permanent identification'),
      ClinicService(name: 'Pharmacy'),
        ],
      ),
      ClinicData(
        name: 'Cagayan Animal Clinic',
        address: "Rodolfo N. Pelaez Blvd, Cagayan de Oro, 9000 Misamis Oriental",
        img: 'assets/images/CagayanAnimalClinic/logo4.png',
        banner: 'assets/images/CagayanAnimalClinic/banner4.png',
        lat: '8.4906993',
        lng: '124.6400974',
        rating: '5',
        services: [
      ClinicService(name: 'Dietary Counseling'),
      ClinicService(name: 'Radiology Services'),
      ClinicService(name: 'Internal medicine'),
      ClinicService(name: 'Dentistry'),
      ClinicService(name: 'Laboratory'),
        ],
      ),
    ];
  }
}

class ClinicService{
  final String? name;
  ClinicService({this.name});

  static List<ClinicService> getSampleServices(){
    return [
      ClinicService(name: 'Diagnostic and Therapeutic'),
      ClinicService(name: 'Surgical'),
      ClinicService(name: 'Anesthesia'),
      ClinicService(name: 'Internal medicine'),
      ClinicService(name: 'Radiology Services'),
      ClinicService(name: 'Electrocardiography Services'),
      ClinicService(name: 'Dentistry'),
      ClinicService(name: 'Laboratory'),
      ClinicService(name: 'Permanent identification'),
      ClinicService(name: 'Pharmacy'),
      ClinicService(name: 'Dietary Counseling'),
      ClinicService(name: 'Behavioral Counseling'),
      ClinicService(name: 'Boarding'),
      ClinicService(name: 'Bathing and Grooming'),
      ClinicService(name: 'Emergency Care'),
    ];
  }
  
  static List<ClinicService> getListClinicServices(List services){
    return services.reduce((listData,data)=>ClinicService(name: data));
  }
}
class ClinicModel{
  String? id,clinic_name,clinic_doctor,clinic_email,clinic_address,clinic_img,clinic_img_banner,clinic_lat,clinic_long,clinic_rating;
  List services;

  ClinicModel(
    this.id,
    this.clinic_name,
    this.clinic_doctor,
    this.clinic_email,
    this.clinic_address,
    this.clinic_img,
    this.clinic_img_banner,
    this.clinic_lat,
    this.clinic_long,
    this.clinic_rating,
    this.services
  );

  ClinicModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        clinic_name = json['clinic_name'],
        clinic_doctor = json['clinic_doctor'],
        clinic_email = json['clinic_email'],
        clinic_address = json['clinic_address'],
        clinic_img = json['clinic_img'],
        clinic_img_banner = json['clinic_img_banner'],
        clinic_lat = json['clinic_lat'],
        clinic_long = json['clinic_long'],
        clinic_rating = json['clinic_rating'],
        services = json['services'] as List
    ;

  Map<String, dynamic> toMap() => {
        "id" : id,
        "clinic_name" : clinic_name,
        "clinic_doctor" : clinic_doctor,
        "clinic_email" : clinic_email,
        "clinic_address" : clinic_address,
        "clinic_img" : clinic_img,
        "clinic_img_banner" : clinic_img_banner,
        "clinic_lat" : clinic_lat,
        "clinic_long" : clinic_long,
        "clinic_rating" : clinic_rating,
        "services" : services
      };
}



