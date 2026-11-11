part of 'local_store.dart';

class _Store {
  static final GetStorage _ = GetStorage();

  static T? read<T>(String key) => _.read<T?>(key);

  static Future<void> remove(String key) async => _.remove(key);

  static Future<void> write(String key, dynamic value) async =>
      _.write(key, value);
}

class _StoreObject<T> {

  _StoreObject({
    required this.key,
    this.value,
    T? initialValue,
  }) {
    if (call() == null && initialValue != null) {
      call(initialValue);
    }
  }
  final String key;
  T? value;

  T? call([T? v]) {
    if (v != null) {
      _Store.write(key, v);
      value = v;
    }
    return value ??= _Store.read<T?>(key);
  }

  void remove() {
    _Store.remove(key);
    value = null;
  }

  @override
  String toString() => value.toString();
}
