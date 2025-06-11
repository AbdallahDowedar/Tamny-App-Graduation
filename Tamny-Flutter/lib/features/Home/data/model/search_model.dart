class DoctorResponse {
  final List<Doctor> doctors;

  DoctorResponse({
    required this.doctors,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    return DoctorResponse(
      doctors: List<Doctor>.from(json['data'].map((x) => Doctor.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': doctors.map((x) => x.toJson()).toList(),
    };
  }
}

class Doctor {
  final String id;
  final String specialization; // Note: changed to String
  final int consultationFees;
  final String locations;
  final String userName;
  final int rate;
  final String description;
  final String phone;

  Doctor({
    required this.id,
    required this.specialization,
    required this.consultationFees,
    required this.locations,
    required this.userName,
    required this.rate,
    required this.description,
    required this.phone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      specialization: json['specialization'],
      consultationFees: json['consultationFees'],
      locations: json['locations'],
      userName: json['userName'],
      rate: json['rate'],
      description: json['description'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialization': specialization,
      'consultationFees': consultationFees,
      'locations': locations,
      'userName': userName,
      'rate': rate,
    };
  }
}


class Specialization {
  final String id;
  final String name;

  Specialization({
    required this.id,
    required this.name,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
