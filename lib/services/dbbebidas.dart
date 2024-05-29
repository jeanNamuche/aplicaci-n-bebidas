import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/categoria.dart';
import '../models/proveedores.dart';
import '../models/producto.dart';
import '../models/sale_item.dart';
import '../models/sale.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'store.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)",
        );
        db.execute(
          "CREATE TABLE suppliers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)",
        );
        db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, categoryId INTEGER, supplierId INTEGER, FOREIGN KEY(categoryId) REFERENCES categories(id), FOREIGN KEY(supplierId) REFERENCES suppliers(id))",
        );
        db.execute(
            "CREATE TABLE sales (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT) "
        );
        db.execute(
            "CREATE TABLE sale_items (id INTEGER PRIMARY KEY AUTOINCREMENT,saleId INTEGER,productId INTEGER,quantity INTEGER,totalPrice REAL,FOREIGN KEY (saleId) REFERENCES sales (id),FOREIGN KEY (productId) REFERENCES products (id))");
      },
    );
  }

  // CRUD Operations for Category
  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Category>> categories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Supplier
  Future<void> insertSupplier(Supplier supplier) async {
    final db = await database;
    await db.insert('suppliers', supplier.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Supplier>> suppliers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('suppliers');
    return List.generate(maps.length, (i) {
      return Supplier(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> updateSupplier(Supplier supplier) async {
    final db = await database;
    await db.update('suppliers', supplier.toMap(), where: 'id = ?', whereArgs: [supplier.id]);
  }

  Future<void> deleteSupplier(int id) async {
    final db = await database;
    await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }


  // CRUD Operations for Product
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> products() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        categoryId: maps[i]['categoryId'],
        supplierId: maps[i]['supplierId'],
      );
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  ////



  Future<void> insertSaleItem(int saleId, SaleItem saleItem) async {
    final db = await database;
    await db.insert('sale_items', {
      'sale_id': saleId,
      'product_id': saleItem.productId,
      'quantity': saleItem.quantity,
      'price': saleItem.productPrice,
    });
  }


  Future<List<SaleItem>> getSaleItems(int saleId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sale_items', where: 'saleId = ?', whereArgs: [saleId]);
    return List.generate(maps.length, (i) {
      return SaleItem.fromMap(maps[i]);
    });
  }


  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final results = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return results.map((e) => Product.fromMap(e)).toList();
  }


 ////sales
  Future<void> insertSale(Sale sale) async {
    final db = await database;
    await db.insert('sales', sale.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Sale>> sales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sales');

    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }


}
