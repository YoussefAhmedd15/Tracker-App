class RegistrationData {
  String? email;
  String? password;
  String? fullName;
  String? gender;
  int? age;
  int? height; // in cm
  int? weight; // in kg
  String? nickname;
  String? profileImage;

  RegistrationData({
    this.email,
    this.password,
    this.fullName,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.nickname,
    this.profileImage,
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
      'email': email,
      'password': password,
      'fullName': fullName,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'nickname': nickname ?? fullName?.split(' ').first ?? '',
      'profileImage': profileImage ?? '',
    };
  }
}
