class RealtimeUserModel {
  final String id;
  final String email;
  final String? password;
  final int age;
  final String fullName;
  final String gender;
  final int height;
  final String nickname;
  final String profileImage; // Keeping for database compatibility
  final int weight;
  final int lastUpdated;
  final bool isAdmin;

  RealtimeUserModel({
    required this.id,
    required this.email,
    this.password,
    required this.age,
    required this.fullName,
    required this.gender,
    required this.height,
    required this.nickname,
    this.profileImage = '', // Default to empty string
    required this.weight,
    required this.lastUpdated,
    this.isAdmin = false,
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
      profileImage: '', // Always set to empty string
      weight: data['weight'] ?? 0,
      lastUpdated: data['lastUpdated'] ?? 0,
      isAdmin: data['isAdmin'] ?? false,
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
      'profileImage': '', // Always send empty string
      'weight': weight,
      'isAdmin': isAdmin,
    };

    // Only include password if it's provided
    if (password != null) {
      map['password'] = password;
    }

    return map;
  }
}
