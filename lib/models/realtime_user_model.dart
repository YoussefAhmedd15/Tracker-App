class RealtimeUserModel {
  final String id;
  final String email;
  final String? password;
  final int age;
  final String fullName;
  final String gender;
  final int height;
  final String nickname;
  final String profileImage;
  final int weight;
  final int lastUpdated;

  RealtimeUserModel({
    required this.id,
    required this.email,
    this.password,
    required this.age,
    required this.fullName,
    required this.gender,
    required this.height,
    required this.nickname,
    required this.profileImage,
    required this.weight,
    required this.lastUpdated,
  });

  // Convert from Realtime Database data
  factory RealtimeUserModel.fromRealtime(
      String userId, Map<dynamic, dynamic> data) {
    return RealtimeUserModel(
      id: userId,
      email: data['email'] ?? '',
      password: data['password'],
      age: data['age'] ?? 0,
      fullName: data['fullName'] ?? '',
      gender: data['gender'] ?? '',
      height: data['height'] ?? 0,
      nickname: data['nickname'] ?? '',
      profileImage: data['profileImage'] ?? '',
      weight: data['weight'] ?? 0,
      lastUpdated: data['lastUpdated'] ?? 0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email,
      'age': age,
      'fullName': fullName,
      'gender': gender,
      'height': height,
      'nickname': nickname,
      'profileImage': profileImage,
      'weight': weight,
    };

    // Only include password if it's provided
    if (password != null) {
      map['password'] = password;
    }

    return map;
  }
}
