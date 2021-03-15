abstract class HerbRepository<T> {
  Future<List<T>> search({title});

  Future<bool> destroy();
}
