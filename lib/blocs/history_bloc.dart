import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../model/struct_model.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this.dataDirectory) : super(HistoryState(structs: const [])) {
    on<Init>(_init);
    on<Next>(_next);
    on<AddHistory>(_addStruct);
    on<RemoveHistory>(_removeStruct);

    add(Init());
  }

  Future<void> _init(event, emit) async {
    final isar = await Isar.open([StructModelSchema], directory: dataDirectory.path);
    isarCollection = isar.structModels;
    var structs = await isarCollection.filter().idGreaterThan(state.lastIndex).findAll();
    emit(state.copy(structs: structs, lastIndex: structs.length));
  }

  Future<void> _next(Next event, Emitter<HistoryState> emit) async {
    var nextStructs = await isarCollection.filter().idBetween(state.lastIndex, state.lastIndex + event.count).findAll();
    var newStructs = state.structs.toList() + nextStructs;
    emit(state.copy(structs: newStructs));
  }

  Future<void> _addStruct(AddHistory event, Emitter<HistoryState> emit) async {
    await isarCollection.isar.writeTxn(() async => await isarCollection.put(event.struct));
    var newStructs = state.structs.toList()..add(event.struct);
    emit(state.copy(structs: newStructs));
  }

  Future<void> _removeStruct(RemoveHistory event, Emitter<HistoryState> emit) async {
    await isarCollection.delete(event.struct.id);
    emit(state.copy(structs: state.structs.toList()..removeWhere((element) => element.id == event.struct.id)));
  }

  late final IsarCollection<StructModel> isarCollection;
  final Directory dataDirectory;
}

final class HistoryState extends Equatable {
  final List<StructModel> structs;

  late final int lastIndex;

  HistoryState({required this.structs}) {
    lastIndex = structs.length;
  }

  HistoryState copy({List<StructModel>? structs, int? lastIndex}) {
    return HistoryState(structs: structs ?? this.structs);
  }

  @override
  List<Object?> get props => [structs, lastIndex];
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

final class Next extends HistoryEvent {
  final int count;
  Next(this.count);
}
