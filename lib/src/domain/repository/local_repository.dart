import 'package:hive/hive.dart';

abstract class LocalStorage<E> {
  bool containKey(String key);
  E? read(String key);
  Future<void> write(String key, E value);
  Future<void> remove(String key);
  Future<void> clear();
  bool get isEmpty;
  Iterable<MapEntry<String, E>> get entries;
  List<E> get list;
  Stream<E> stream();
}

class LocalRepository<E> implements LocalStorage<E> {
  LocalRepository(this.box);
  final Box<E> box;
  @override
  Future<void> clear() async {
    await box.clear();
  }

  @override
  bool containKey(String key) {
    return box.containsKey(key);
  }

  @override
  Iterable<MapEntry<String, E>> get entries => box.toMap().entries as Iterable<MapEntry<String, E>>;

  @override
  bool get isEmpty => box.isEmpty;

  @override
  E? read(String key) {
    _guard();
    return box.get(key);
  }

  @override
  Future<void> remove(String key) async {
    _guard();
    await box.delete(key);
  }

  @override
  Future<void> write(String key, value) async {
    _guard();
    if (box.containsKey(key)) {
      box.delete(key);
    }
    await box.put(key, value);
  }

  @override
  Stream<E> stream() => box.watch().map((event) => event.value);

  void _guard() {
    assert(box.isOpen, 'Box with name ${box.name} is not opened');
  }

  @override
  List<E> get list => box.toMap().values.cast<E>().toList();
}
