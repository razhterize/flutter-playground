import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logger.dart';

class ScreenCubit extends Cubit<ScreenState> {
  ScreenCubit(Widget initialScreen) : super(ScreenState(screen: initialScreen));
  final _log = Logger("ScreenCubit");
  void setScreen(Widget screen) {
    emit(state.copyWith(processing: true));
    _log.info(
      "Change screen from ${state.screen.runtimeType} to ${screen.runtimeType}",
    );
    emit(state.copyWith(screen: screen));
  }
}

class ScreenState extends Equatable {
  final bool processing;
  final Widget screen;

  const ScreenState({required this.screen, this.processing = false});

  ScreenState copyWith({Widget? screen, bool? processing}) {
    return ScreenState(
      screen: screen ?? this.screen,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [processing, screen];
}
