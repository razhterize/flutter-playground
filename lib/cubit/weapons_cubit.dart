import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/logger.dart';

typedef WeaponBuilder = BlocBuilder<WeaponCubit, WeaponState>;

class WeaponCubit extends Cubit<WeaponState> {
  WeaponCubit(this.savedCubit) : super(WeaponState(true)) {
    _initPriv();
  }

  final SavedDataCubit savedCubit;
  final _log = Logger("WeaponCubit");
  StreamSubscription? _subs;
  late StreamSubscription _saveSubs;

  void _initPriv() {
    _log.debug("Init WeaponCubit");
    int sortWeapon(Weapon w1, Weapon w2) => w1.type.index - w2.type.index;

    // Listen for saved state change
    _subs = savedCubit.stream.listen((s) {
      _log.debug("Received saved cubit state");
      emit(state.copyWith(true));
      final weaponList = s.weapons.map((w) => Weapon.fromJson(w)).toList();
      weaponList.sort(sortWeapon);
      emit(state.copyWith(false, weaponList));
    });

    // Automagically save weapons
    _saveSubs = stream.listen((weaponState) {
      _log.debug("Data changed. Saving to local file");
      savedCubit.saveWeapons(weaponState.weapons);
    });

    //Initial state set
    final weaponList = savedCubit.state.weapons
        .map((w) => Weapon.fromJson(w))
        .toList();
    weaponList.sort(sortWeapon);
    emit(state.copyWith(false, weaponList));
  }

  @override
  Future<void> close() {
    _log.debug("WeaponCubit close");
    _subs?.cancel();
    _saveSubs.cancel();
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
