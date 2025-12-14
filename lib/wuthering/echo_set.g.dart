// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'echo_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EchoSet _$EchoSetFromJson(Map<String, dynamic> json) => EchoSet(
  echoes:
      (json['echoes'] as List<dynamic>?)
          ?.map((e) => Echo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$EchoSetToJson(EchoSet instance) => <String, dynamic>{
  'echoes': instance.echoes,
};
