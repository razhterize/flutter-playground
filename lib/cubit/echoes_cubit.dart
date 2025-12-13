import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/core/wuthering/echo.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/repository/saved_repository.dart';

typedef EchoBuilder = BlocBuilder<EchoesCubit, EchoState>;

class EchoesCubit extends Cubit<EchoState> {
  EchoesCubit(this.savedCubit) : super(EchoState()){
    _subs = savedCubit.stream.listen((savedState){
      emit(state.copyWith(true));
      _log.debug("Saved State change");
      emit(state.copyWith(false, savedState.echoes.map((e)=>Echo.fromJson(e)).toList()));
    });
  }

  void addEcho(Echo echo) => emit(state.copyWith(false, [...state.echoes, echo]));

  final SavedDataCubit savedCubit;
  final _log = Logger("EchoesCubit");
  StreamSubscription? _subs;

  void removeEcho(Echo echo) {
    emit(state.copyWith(true));
    state.echoes.remove(echo);
    emit(state.copyWith(false, state.echoes));
  }

  // void saveEchos() {
  //   savedRepository.echoes = state.echoes.map((r) => r.toJson()).toList();
  // }

  // void getEchoes() {
  //   emit(state.copyWith(true, []));
  //   List<Echo> echoes = [];
  //   final savedEchos = savedRepository.echoes;
  //   for (var jsonEcho in savedEchos) {
  //     echoes.add(Echo.fromJson(jsonEcho));
  //   }
  //   emit(EchoState(false, echoes));
  // }
}

class EchoState extends Equatable {
  final List<Echo> echoes;
  final bool processing;
  const EchoState([this.processing = false, this.echoes = const []]);

  EchoState copyWith([bool? processing, List<Echo>? echoes]) {
    return EchoState(processing ?? this.processing, echoes ?? this.echoes);
  }

  @override
  List<Object?> get props => [processing, echoes];
}
