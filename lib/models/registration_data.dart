class RegistrationData {
  String? fullName;
  String? nickname;
  String? email;
  String? password;
  String? gender;
  int? age;
  int? height; // in cm
  int? weight; // in kg

  RegistrationData({
    this.fullName,
    this.nickname,
    this.email,
    this.password,
    this.gender,
    this.age,
    this.height,
    this.weight,
  });

  // Check if all required fields are filled
  bool isComplete() {
    return email != null &&
        email!.isNotEmpty &&
        password != null &&
        password!.isNotEmpty &&
        fullName != null &&
        fullName!.isNotEmpty &&
        gender != null &&
        gender!.isNotEmpty &&
        age != null &&
        height != null &&
        weight != null;
  }

  // Convert to a map for database
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName ?? '',
      'nickname': nickname ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'gender': gender ?? '',
      'age': age ?? 0,
      'height': height ?? 0,
      'weight': weight ?? 0,
    };
  }

  // Create from map
  factory RegistrationData.fromMap(Map<String, dynamic> map) {
    return RegistrationData(
      fullName: map['fullName'],
      nickname: map['nickname'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
    );
  }

  // Copy with method
  RegistrationData copyWith({
    String? fullName,
    String? nickname,
    String? email,
    String? password,
    String? gender,
    int? age,
    int? height,
    int? weight,
  }) {
    return RegistrationData(
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
