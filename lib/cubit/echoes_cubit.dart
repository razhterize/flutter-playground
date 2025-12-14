import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/repository/saved_repository.dart';

typedef EchoBuilder = BlocBuilder<EchoesCubit, EchoState>;

class EchoesCubit extends Cubit<EchoState> {
  EchoesCubit(this.savedCubit) : super(EchoState()) {
    int echoIdSort(Echo e1, Echo e2) => e1.id - e2.id;
    _subs = savedCubit.stream.listen((savedState) {
      emit(state.copyWith(true));
      _log.debug("Saved State change");
      final echoList = savedState.echoes.map((e) => Echo.fromJson(e)).toList()
        ..sort(echoIdSort);
      emit(state.copyWith(false, echoList));
    });
    final echoList = savedCubit.state.echoes.map((e) {
      return Echo.fromJson(e);
    }).toList()..sort(echoIdSort);
    emit(state.copyWith(false, echoList));
  }

  void addEcho(Echo echo) =>
      emit(state.copyWith(false, [...state.echoes, echo]));

  final SavedDataCubit savedCubit;
  final _log = Logger("EchoesCubit");
  StreamSubscription? _subs;

  void removeEcho(Echo echo) {
    emit(state.copyWith(true));
    state.echoes.remove(echo);
    emit(state.copyWith(false, state.echoes));
  }
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
