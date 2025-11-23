class ClassModel {
  final String classId;
  final String className;
  final String classCode;
  final String teacherId;
  final String teacherName;
  final DateTime createdAt;
  final String? subject;
  final String? description;
  final int memberCount;

  ClassModel({
    required this.classId,
    required this.className,
    required this.classCode,
    required this.teacherId,
    required this.teacherName,
    required this.createdAt,
    this.subject,
    this.description,
    this.memberCount = 1,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'className': className,
      'classCode': classCode,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'subject': subject,
      'description': description,
      'memberCount': memberCount,
    };
  }

  // Create from Firestore JSON
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['classId'] as String,
      className: json['className'] as String,
      classCode: json['classCode'] as String,
      teacherId: json['teacherId'] as String,
      teacherName: json['teacherName'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      subject: json['subject'] as String?,
      description: json['description'] as String?,
      memberCount: json['memberCount'] as int? ?? 1,
    );
  }

  // Copy with method for updates
  ClassModel copyWith({
    String? classId,
    String? className,
    String? classCode,
    String? teacherId,
    String? teacherName,
    DateTime? createdAt,
    String? subject,
    String? description,
    int? memberCount,
  }) {
    return ClassModel(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      classCode: classCode ?? this.classCode,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      createdAt: createdAt ?? this.createdAt,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}
