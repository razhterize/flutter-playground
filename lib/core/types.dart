typedef JsonType = Map<String, dynamic>;

class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  const Pair({required this.first, required this.second});
  Pair<T1, T2> copyWith({T1? first, T2? second}) {
    return Pair(first: first ?? this.first, second: second ?? this.second);
  }
}
