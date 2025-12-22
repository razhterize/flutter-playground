import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'saved_cubit.dart';
import '../logger.dart';
import '../core/wuthering.dart';

typedef EchoBuilder = BlocBuilder<EchoesCubit, EchoState>;

class EchoesCubit extends Cubit<EchoState> {
  EchoesCubit(this.savedCubit) : super(EchoState()) {
    _initPriv();
  }

  final SavedDataCubit savedCubit;
  final _log = Logger("EchoesCubit");
  StreamSubscription? _subs;
  late StreamSubscription _savedSubs;

  List<Echo> get echoes => state.echoes;
  Echo? get editedEcho => state.editedEcho;

  void _initPriv() {
    int echoIdSort(Echo e1, Echo e2) => e1.id - e2.id;
    // Listen for saved state change
    _subs = savedCubit.stream.listen((savedState) {
      emit(state.copyWith(processing: true));
      _log.debug("Saved State change");
      final echoList = savedState.echoes.map((e) => Echo.fromJson(e)).toList()
        ..sort(echoIdSort);
      emit(state.copyWith(processing: false, echoes: echoList));
    });

    // Automagically save echoes
    _savedSubs = stream.listen((echoState) {
      savedCubit.saveEcho(echoState.echoes);
    });

    // Initial state set
    final echoList = savedCubit.state.echoes.map((e) {
      return Echo.fromJson(e);
    }).toList()..sort(echoIdSort);
    emit(state.copyWith(processing: false, echoes: echoList));
  }

  void addEcho(Echo echo) {
    emit(state.copyWith(echoes: [...state.echoes, echo]));
    editEcho(echo);
  }

  void editEcho(Echo? echo) {
    emit(state.copyWith(editedEcho: echo));
  }

  void removeEcho(Echo echo) {
    emit(state.copyWith(processing: true));
    state.echoes.remove(echo);
    emit(state.copyWith(echoes: state.echoes));
  }

  @override
  Future<void> close() {
    _subs?.cancel();
    _savedSubs.cancel();
    return super.close();
  }
}

class EchoState extends Equatable {
  final List<Echo> echoes;
  final Echo? editedEcho;
  final bool processing;
  const EchoState({
    this.processing = false,
    this.echoes = const [],
    this.editedEcho,
  });

  EchoState copyWith({bool? processing, List<Echo>? echoes, Echo? editedEcho}) {
    return EchoState(
      processing: processing ?? this.processing,
      echoes: echoes ?? this.echoes,
      editedEcho: editedEcho,
    );
  }

  @override
  List<Object?> get props => [processing, echoes, editedEcho];
}
