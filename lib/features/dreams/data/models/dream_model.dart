import '../../domain/entities/dream_entity.dart';

class DreamModel extends DreamEntity {
  const DreamModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    super.currentAmount,
    required super.emoji,
    required super.gradientColors,
  });

  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'],
      title: json['title'],
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      emoji: json['emoji'],
      gradientColors: List<String>.from(json['gradientColors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'emoji': emoji,
      'gradientColors': gradientColors,
    };
  }
}
