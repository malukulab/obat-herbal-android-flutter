abstract class HerbDao<T> {
  Future<List<T>> search({title});

  Future<bool> destroy();
}
