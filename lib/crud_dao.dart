abstract class CrudDao<T> {
  Future<bool> create(T data);

  Future<bool> delete(int id);

  Future<T> findByid(int id);

  Future<List<T>> findAll();

  Future<bool> update(T data, int id);
}
