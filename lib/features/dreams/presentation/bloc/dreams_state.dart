import 'package:equatable/equatable.dart';
import '../../domain/entities/dream_entity.dart';

abstract class DreamsState extends Equatable {
  const DreamsState();
  
  @override
  List<Object> get props => [];
}

class DreamsInitial extends DreamsState {}

class DreamsLoading extends DreamsState {}

class DreamsLoaded extends DreamsState {
  final List<DreamEntity> dreams;

  const DreamsLoaded(this.dreams);

  @override
  List<Object> get props => [dreams];
}

class DreamsError extends DreamsState {
  final String message;

  const DreamsError(this.message);

  @override
  List<Object> get props => [message];
}
