import 'package:equatable/equatable.dart';
import '../../domain/entities/dream_entity.dart';

abstract class DreamsEvent extends Equatable {
  const DreamsEvent();

  @override
  List<Object> get props => [];
}

class LoadDreams extends DreamsEvent {}

class AddDreamEvent extends DreamsEvent {
  final DreamEntity dream;

  const AddDreamEvent(this.dream);

  @override
  List<Object> get props => [dream];
}

class UpdateDreamProgressEvent extends DreamsEvent {
  final String dreamId;
  final double addedAmount;

  const UpdateDreamProgressEvent({
    required this.dreamId,
    required this.addedAmount,
  });

  @override
  List<Object> get props => [dreamId, addedAmount];
}
