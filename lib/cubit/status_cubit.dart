import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/logger.dart';

typedef StatusBuilder = BlocBuilder<StatusCubit, StatusState>;

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusState());

  final _log = Logger("StatusCubit");

  @override
  void onChange(Change<StatusState> change) {
    _log.debug("Status change");
    super.onChange(change);
  }

  void notify({String? message, ProgressData? progress}) {
    emit(state.copyWith(message: message, progress: progress));
  }
}

class StatusState extends Equatable {
  final String? message;
  final ProgressData? progress;

  const StatusState({this.message, this.progress});

  StatusState copyWith({String? message, ProgressData? progress}) {
    return StatusState(message: message ?? this.message, progress: progress ?? this.progress);
  }

  @override
  List<Object?> get props => [message, progress];
}

class ProgressData {
  final int total;
  final int current;
  final String? message;

  double get percentage => current / total;

  @override
  String toString() {
    return "${message != null ? ": $message" : ""} $percentage%";
  }

  const ProgressData({this.total = 0, this.current = 0, this.message});
}
