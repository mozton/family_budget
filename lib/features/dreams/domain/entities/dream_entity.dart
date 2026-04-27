import 'package:equatable/equatable.dart';

class DreamEntity extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String emoji;
  final List<String> gradientColors;

  const DreamEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.emoji,
    required this.gradientColors,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        currentAmount,
        emoji,
        gradientColors,
      ];
}
