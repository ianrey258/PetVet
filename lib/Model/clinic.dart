class ClinicData{
  final String? name;
  final String? address;
  final String? img;
  final String? banner;
  final double? lat;
  final double? lng;
  final double? rating;
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

  static List<ClinicData> getSampleData(){
    return [
      ClinicData(name: 'Pet Vet'),
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
}

