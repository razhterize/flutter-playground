import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/core/wuthering/resonator.dart';

typedef ResonatorBuilder = BlocBuilder<ResonatorCubit, ResonatorState>;

class ResonatorCubit extends Cubit<ResonatorState> {
  ResonatorCubit() : super(ResonatorState());

  void addResonator(Resonator resonator) =>
      emit(state.copyWith(state.processing, [...state.resonators, resonator]));

  void removeResonator(Resonator resonator) {
    emit(state.copyWith(true));
    state.resonators.remove(resonator);
    emit(state.copyWith(false, state.resonators));
  }

  void saveResonators() {
    localAssets.resonators = state.resonators.map((r) => r.toJson()).toList();
  }

  void getResonators() {
    emit(state.copyWith(true));
    List<Resonator> resonators = [];
    final savedResonators = localAssets.resonators;
    for (var jsonResonator in savedResonators) {
      resonators.add(Resonator.fromJson(jsonResonator));
    }
    emit(state.copyWith(false, resonators));
  }
}

class ResonatorState extends Equatable {
  final List<Resonator> resonators;
  final bool processing;
  const ResonatorState([this.processing = false, this.resonators = const []]);

  ResonatorState copyWith([bool? processing, List<Resonator>? resonators]) {
    return ResonatorState(processing ?? this.processing, resonators ?? this.resonators);
  }

  @override
  List<Object?> get props => [processing, resonators];
}
