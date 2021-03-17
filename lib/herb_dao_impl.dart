import 'package:sqflite/sqflite.dart';

import 'crud_dao.dart';
import 'herb_dao.dart';
import 'mysqlite_connection.dart';

class HerbDaoImpl implements HerbDao, CrudDao<Map<String, dynamic>> {
  final MySqliteConnection con = MySqliteConnection();


  @override
  Future<bool> destroy() async {
    final Database db = await con.getConnection;

    try {
      await db.rawDelete(
        """
        DELETE FROM herbs;
        """
      );

      return true;
    }catch (err) {
      return false;
    }
  }

  @override
  Future<bool> create(Map<String, dynamic> data) async {
    final Database db = await con.getConnection;

    try {
      await db.insert(
        'herbs',
        data
      );

      return true;
    }catch (err) {

      return false;
    }
  }

  @override
  Future<bool> delete(int? id) async {
    final Database db = await con.getConnection;

    try {
      await db.rawDelete(
        """
        DELETE FROM herbs WHERE id = ?
        """,
        [id]
      );
      return true;
    }catch (err) {
      return false;
    }

  }

  @override
  Future<List<Map<String, dynamic>>> findAll() async {
    final Database db = await con.getConnection;

    try {
      final List<Map<String, dynamic>> rows = await db.query('herbs');

      return rows;
    }catch (err) {
      return List.of([]);
    }
  }

  @override
  Future<Map<String, dynamic>> findByid(int? id) async {
    final Database db = await con.getConnection;

    try {
      List<Map<String, dynamic>> row = await db.rawQuery(
        """
        SELECT * FROM herbs WHERE id = ? LIMIT 1
        """,
        [id]
      );

      return row.first;
    }catch (err) {
      return Map.of({
        'message': 'not found by id $id'
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> search({title}) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Map<String, dynamic> data, int? id) async {
    final Database db = await con.getConnection;

    try {
      await db.rawUpdate(
        """
        UPDATE herbs SET photo = ?, title = ?, description = ? WHERE id = ?
        """,
        [...data.values, id]
      );
      return true;
    }catch (err) {
      return false;
    }
  }
}
