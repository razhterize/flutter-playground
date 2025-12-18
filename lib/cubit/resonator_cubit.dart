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

  Resonator? get edited => state.editedResonator;
  List<Resonator> get resonators => state.resonators;

  void _initPriv() {
    _log.debug("Init Resonator Cubit");
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

    try {
      // Initial state set
      final resonatorList = savedCubit.state.resonators
          .map((e) => Resonator.fromJson(e))
          .toList();
      resonatorList.sort(sortResonator);
      emit(state.copyWith(processing: false, resonators: resonatorList));
    } catch (e) {
      _log.error(
        "Something is wrong when loading initial resonators: ${e.toString()}",
        st: .current,
      );
    }
  }

  void editResonator(Resonator resonator) {
    emit(state.copyWith(editedResonator: resonator));
  }

  void updateResonator(Resonator resonator) {
    emit(state.copyWith(processing: true));
    _log.debug("Update Resonator ${resonator.name}");
    final newList = state.resonators;
    final index = newList.indexWhere((r) => r.name == resonator.name);
    newList[index] = resonator;
    _log.debug("Resonators count: ${newList.length}");
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
    _log.debug(
      "Remove ${resonator.name}. Current length: ${state.resonators.length}",
    );
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

  @override
  String toString() {
    return """
    Processing: $processing
    Resonators Length: ${resonators.length}
    Edited: $editedResonator
    """;
  }

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
