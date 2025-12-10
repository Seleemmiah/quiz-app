class BookmarkedQuestion {
  final String id;
  final String userId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String category;
  final String difficulty;
  final DateTime bookmarkedAt;
  final String? userNote;

  BookmarkedQuestion({
    required this.id,
    required this.userId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    required this.category,
    required this.difficulty,
    required this.bookmarkedAt,
    this.userNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'bookmarkedAt': bookmarkedAt.millisecondsSinceEpoch,
      'userNote': userNote,
    };
  }

  factory BookmarkedQuestion.fromJson(Map<String, dynamic> json) {
    return BookmarkedQuestion(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: json['explanation'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      bookmarkedAt: DateTime.fromMillisecondsSinceEpoch(
        json['bookmarkedAt'] as int,
      ),
      userNote: json['userNote'] as String?,
    );
  }

  BookmarkedQuestion copyWith({
    String? id,
    String? userId,
    String? questionText,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? category,
    String? difficulty,
    DateTime? bookmarkedAt,
    String? userNote,
  }) {
    return BookmarkedQuestion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
      userNote: userNote ?? this.userNote,
    );
  }
}
