mixin EnumFlag on Enum {
  int get value => 1 << index;
  int operator |(EnumFlag other) => value | other.value;
  int operator &(EnumFlag other) => value & other.value;
}

extension FlagExtension on int {
  bool has(EnumFlag flag) => this & flag.value == flag.value;
}
