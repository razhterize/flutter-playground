import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';

typedef ResonatorBuilder = BlocBuilder<ResonatorCubit, ResonatorState>;

class ResonatorCubit extends Cubit<ResonatorState> {
  ResonatorCubit(this.savedCubit) : super(ResonatorState()) {
    _initPriv();
  }

  final SavedDataCubit savedCubit;
  final _log = Logger("ResonatorCubit");
  StreamSubscription? _subs;
  late StreamSubscription _saveSubs;

  void _initPriv() {
    int sortResonator(Resonator r1, Resonator r2) {
      return r1.elementType.index - r2.elementType.index;
    }

    // Listen for saved state
    _subs = savedCubit.stream.listen((savedState) {
      emit(state.copyWith(processing: true));
      final resonatorList = savedState.resonators
          .map((e) => Resonator.fromJson(e))
          .toList();
      resonatorList.sort(sortResonator);
      emit(state.copyWith(processing: false, resonators: resonatorList));
    });

    // Automagically save resonators
    _saveSubs = stream.listen((resonatorState) {
      savedCubit.saveResonator(resonatorState.resonators);
    });

    // Initial state set
    final resonatorList = savedCubit.state.resonators
        .map((e) => Resonator.fromJson(e))
        .toList();
    resonatorList.sort(sortResonator);
    emit(state.copyWith(processing: false, resonators: resonatorList));
  }

  void editResonator(Resonator resonator) {
    emit(state.copyWith(editedResonator: resonator));
  }

  void updateResonator(Resonator resonator) {
    emit(state.copyWith(processing: true));
    final newList = state.resonators;
    final index = newList.indexWhere((r) => r.name == resonator.name);
    newList[index] = resonator;
    emit(state.copyWith(processing: false, resonators: newList));
  }

  void addResonator(Resonator resonator) {
    var newList = state.resonators;
    newList.add(resonator);
    emit(state.copyWith(resonators: newList));
  }

  void removeResonator(Resonator resonator) {
    emit(state.copyWith(processing: true));
    state.resonators.remove(resonator);
    emit(state.copyWith(processing: false, resonators: state.resonators));
  }

  @override
  Future<void> close() {
    _subs?.cancel();
    _saveSubs.cancel();
    return super.close();
  }
}

class ResonatorState extends Equatable {
  final List<Resonator> resonators;
  final Resonator? editedResonator;
  final bool processing;
  const ResonatorState([
    this.processing = false,
    this.resonators = const [],
    this.editedResonator,
  ]);

  ResonatorState copyWith({
    bool? processing,
    List<Resonator>? resonators,
    Resonator? editedResonator,
  }) {
    return ResonatorState(
      processing ?? this.processing,
      resonators ?? this.resonators,
      editedResonator ?? this.editedResonator,
    );
  }

  @override
  List<Object?> get props => [processing, resonators, editedResonator];
}
