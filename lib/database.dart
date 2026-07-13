import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@entity
class ShoppingItem {
  static int ID = 1;

  @primaryKey
  final int id;
  final String name;
  final String quantity;

  ShoppingItem(this.id, this.name, this.quantity) {
    // make sure ID always increase
    if (id >= ID) {
      ID = id + 1;
    }
  }
}


@dao
abstract class ShoppingItemDao {
  @Query('SELECT * FROM ShoppingItem')
  Future<List<ShoppingItem>> findAllItems();

  @delete
  Future<void> deleteItem(ShoppingItem item);

  @insert
  Future<void> insertItem(ShoppingItem item);
}

@Database(version: 1, entities: [ShoppingItem])
abstract class AppDatabase extends FloorDatabase {
  ShoppingItemDao get shoppingItemDao;
}