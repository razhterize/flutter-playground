// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buff _$BuffFromJson(Map<String, dynamic> json) => Buff(
  name: json['name'] as String? ?? "",
  stats:
      (json['stats'] as List<dynamic>?)
          ?.map((e) => StatValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  maxStack: (json['maxStack'] as num?)?.toInt() ?? 1,
  active: json['active'] as bool? ?? false,
  currentStack: (json['currentStack'] as num?)?.toInt() ?? 1,
  target:
      $enumDecodeNullable(_$BuffTargetEnumMap, json['target']) ??
      BuffTarget.Self,
);

Map<String, dynamic> _$BuffToJson(Buff instance) => <String, dynamic>{
  'name': instance.name,
  'stats': instance.stats,
  'maxStack': instance.maxStack,
  'target': _$BuffTargetEnumMap[instance.target]!,
  'active': instance.active,
  'currentStack': instance.currentStack,
};

const _$BuffTargetEnumMap = {
  BuffTarget.Self: 'Self',
  BuffTarget.Ally: 'Ally',
  BuffTarget.Team: 'Team',
};
