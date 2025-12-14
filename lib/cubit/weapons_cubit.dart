import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';

typedef WeaponBuilder = BlocBuilder<WeaponCubit, WeaponState>;

class WeaponCubit extends Cubit<WeaponState> {
  WeaponCubit(this.savedCubit) : super(WeaponState(true)) {
    int sortWeapon(Weapon w1, Weapon w2) => w1.type.index - w2.type.index;
    _subs = savedCubit.stream.listen((savedState) {
      emit(state.copyWith(true));
      _log.debug("Received state change");
      final weaponList =
          savedState.weapons.map((w) => Weapon.fromJson(w)).toList()
            ..sort(sortWeapon);
      emit(state.copyWith(false, weaponList));
    });
    final weaponList =
        savedCubit.state.weapons.map((w) => Weapon.fromJson(w)).toList()
          ..sort(sortWeapon);
    emit(state.copyWith(false, weaponList));
  }

  final SavedDataCubit savedCubit;
  final _log = Logger("WeaponCubit");
  StreamSubscription? _subs;

  @override
  Future<void> close() {
    _subs?.cancel();
    return super.close();
  }
}

class WeaponState extends Equatable {
  final List<Weapon> weapons;
  final Weapon? editedWeapon;
  final bool processing;
  const WeaponState([
    this.processing = false,
    this.weapons = const [],
    this.editedWeapon,
  ]);

  WeaponState copyWith([bool? processing, List<Weapon>? weapons]) {
    return WeaponState(processing ?? this.processing, weapons ?? this.weapons);
  }

  @override
  List<Object?> get props => [processing, weapons, editedWeapon];
}
