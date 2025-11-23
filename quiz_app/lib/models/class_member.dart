class ClassMember {
  final String classId;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime joinedAt;
  final String role; // 'teacher' or 'student'

  ClassMember({
    required this.classId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.joinedAt,
    required this.role,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
      'role': role,
    };
  }

  // Create from Firestore JSON
  factory ClassMember.fromJson(Map<String, dynamic> json) {
    return ClassMember(
      classId: json['classId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      joinedAt: DateTime.fromMillisecondsSinceEpoch(json['joinedAt'] as int),
      role: json['role'] as String,
    );
  }

  bool get isTeacher => role == 'teacher';
  bool get isStudent => role == 'student';
}
