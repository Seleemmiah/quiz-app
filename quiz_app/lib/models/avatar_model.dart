class AvatarModel {
  final String id;
  final String emoji;
  final int price;
  final String name;

  const AvatarModel({
    required this.id,
    required this.emoji,
    required this.price,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emoji': emoji,
      'price': price,
      'name': name,
    };
  }

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      id: map['id'] ?? '',
      emoji: map['emoji'] ?? '',
      price: map['price'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

final List<AvatarModel> allAvatars = [
  const AvatarModel(
      id: 'student_m', emoji: '👨‍🎓', price: 0, name: 'Student (M)'),
  const AvatarModel(
      id: 'student_f', emoji: '👩‍🎓', price: 0, name: 'Student (F)'),
  const AvatarModel(
      id: 'teacher_m', emoji: '👨‍🏫', price: 100, name: 'Teacher (M)'),
  const AvatarModel(
      id: 'teacher_f', emoji: '👩‍🏫', price: 100, name: 'Teacher (F)'),
  const AvatarModel(
      id: 'scientist_m', emoji: '👨‍🔬', price: 200, name: 'Scientist (M)'),
  const AvatarModel(
      id: 'scientist_f', emoji: '👩‍🔬', price: 200, name: 'Scientist (F)'),
  const AvatarModel(
      id: 'astronaut_m', emoji: '👨‍🚀', price: 500, name: 'Astronaut (M)'),
  const AvatarModel(
      id: 'astronaut_f', emoji: '👩‍🚀', price: 500, name: 'Astronaut (F)'),
  const AvatarModel(
      id: 'hero_m', emoji: '🦸‍♂️', price: 1000, name: 'Super Hero (M)'),
  const AvatarModel(
      id: 'hero_f', emoji: '🦸‍♀️', price: 1000, name: 'Super Hero (F)'),
  const AvatarModel(
      id: 'wizard_m', emoji: '🧙‍♂️', price: 1500, name: 'Wizard (M)'),
  const AvatarModel(
      id: 'wizard_f', emoji: '👩‍‍♀️', price: 1500, name: 'Wizard (F)'),
  const AvatarModel(id: 'ninja', emoji: '🥷', price: 2000, name: 'Ninja'),
  const AvatarModel(id: 'nerd', emoji: '🤓', price: 100, name: 'Nerd'),
  const AvatarModel(id: 'cool', emoji: '😎', price: 250, name: 'Cool Guy'),
  const AvatarModel(id: 'cowboy', emoji: '🤠', price: 300, name: 'Cowboy'),
  const AvatarModel(id: 'robot', emoji: '🤖', price: 2500, name: 'Robot'),
  const AvatarModel(id: 'alien', emoji: '👽', price: 3000, name: 'Alien'),
  const AvatarModel(id: 'ghost', emoji: '👻', price: 4000, name: 'Ghost'),
  const AvatarModel(id: 'king', emoji: '👑', price: 5000, name: 'Royal'),
];
