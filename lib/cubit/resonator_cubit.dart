import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/core/wuthering/resonator.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/repository/saved_repository.dart';

typedef ResonatorBuilder = BlocBuilder<ResonatorCubit, ResonatorState>;

class ResonatorCubit extends Cubit<ResonatorState> {
  ResonatorCubit(this.savedCubit) : super(ResonatorState()) {
    _subs = savedCubit.stream.listen((savedState) {
      emit(state.copyWith(true));
      _log.debug("Saved Cubit change state?");
      emit(state.copyWith(false, savedState.resonators.map((e) => Resonator.fromJson(e)).toList()));
    });
    savedCubit.loadData();
  }

  final SavedDataCubit savedCubit;
  final _log = Logger("ResonatorCubit");
  StreamSubscription? _subs;

  void addResonator(Resonator resonator) =>
      emit(state.copyWith(state.processing, [...state.resonators, resonator]));

  void removeResonator(Resonator resonator) {
    emit(state.copyWith(true));
    state.resonators.remove(resonator);
    emit(state.copyWith(false, state.resonators));
  }

  @override
  Future<void> close() {
    _subs?.cancel();
    // TODO: implement close
    return super.close();
  }
}

class ResonatorState extends Equatable {
  final List<Resonator> resonators;
  final Resonator? editedResonator;
  final bool processing;
  const ResonatorState([this.processing = false, this.resonators = const [], this.editedResonator]);

  ResonatorState copyWith([bool? processing, List<Resonator>? resonators]) {
    return ResonatorState(processing ?? this.processing, resonators ?? this.resonators);
  }

  @override
  List<Object?> get props => [processing, resonators];
}
