abstract class HerbRepository<T> {
  List<T> search({title});

  Future<bool> destroy();
}
