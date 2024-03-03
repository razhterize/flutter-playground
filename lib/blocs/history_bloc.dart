import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../model/struct_model.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this.dataDirectory) : super(const HistoryState(structs: [], lastIndex: 0)) {
    on<Init>(_init);

    add(Init());
  }

  Future<void> _init(event, emit) async {
    final isar = await Isar.open([StructModelSchema], directory: dataDirectory.path);
    isarCollection = isar.structModels;
  }

  late final IsarCollection<StructModel> isarCollection;
  final Directory dataDirectory;
}

final class HistoryState extends Equatable {
  final List<StructModel> structs;

  final int lastIndex;

  const HistoryState({required this.structs, required this.lastIndex});

  HistoryState copy({List<StructModel>? structs, int? lastIndex}) {
    return HistoryState(structs: structs ?? this.structs, lastIndex: lastIndex ?? this.lastIndex);
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class Init extends HistoryEvent {}

final class AddHistory extends HistoryEvent {
  final StructModel struct;
  AddHistory(this.struct);
}

final class RemoveHistory extends HistoryEvent {
  final StructModel struct;
  RemoveHistory(this.struct);
}

final class FetchHistory extends HistoryEvent {
  final int count;
  final int offset;
  FetchHistory(this.count, {this.offset = 0});
}
