import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_dream.dart';
import '../../domain/usecases/get_dreams.dart';
import '../../domain/usecases/update_dream_progress.dart';
import 'dreams_event.dart';
import 'dreams_state.dart';

class DreamsBloc extends Bloc<DreamsEvent, DreamsState> {
  final GetDreams getDreams;
  final AddDream addDream;
  final UpdateDreamProgress updateDreamProgress;

  DreamsBloc({
    required this.getDreams,
    required this.addDream,
    required this.updateDreamProgress,
  }) : super(DreamsInitial()) {
    on<LoadDreams>(_onLoadDreams);
    on<AddDreamEvent>(_onAddDream);
    on<UpdateDreamProgressEvent>(_onUpdateDreamProgress);
  }

  Future<void> _onLoadDreams(
      LoadDreams event, Emitter<DreamsState> emit) async {
    emit(DreamsLoading());
    try {
      final dreams = await getDreams.call();
      emit(DreamsLoaded(dreams));
    } catch (e) {
      emit(DreamsError(e.toString()));
    }
  }

  Future<void> _onAddDream(
      AddDreamEvent event, Emitter<DreamsState> emit) async {
    try {
      await addDream.call(event.dream);
      add(LoadDreams());
    } catch (e) {
      emit(DreamsError(e.toString()));
    }
  }

  Future<void> _onUpdateDreamProgress(
      UpdateDreamProgressEvent event, Emitter<DreamsState> emit) async {
    try {
      await updateDreamProgress.call(event.dreamId, event.addedAmount);
      add(LoadDreams());
    } catch (e) {
      emit(DreamsError(e.toString()));
    }
  }
}
