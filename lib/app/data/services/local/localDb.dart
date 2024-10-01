import 'dart:developer';
import 'dart:ffi';
import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    // _database = await _initializeDB('Local.db');
    _database = await _initializeDB('App_ganaderia_local2.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    print('aqui va la inicializacion de base de datos');
    print(path);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    // await db.execute("DROP TABLE IF EXISTS users");
    await db.execute('''
        CREATE TABLE users( id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name VARCHAR(255),
                            email VARCHAR(100),
                            password VARCHAR(50),
                            photo VARCHAR(50),
                            perfil INT(1)
                          )
      ''');
    await db.insert('users', {
      "name": "Admin",
      "email": "admin@gmail.com",
      "password": "123456789",
      "photo": "admin.png",
      "perfil": "1",
    });

    // scripts de categories
    await db.execute('''
        CREATE TABLE categories( id INTEGER PRIMARY KEY AUTOINCREMENT,
                                name VARCHAR(255)
                                )
      ''');
    await db.insert('categories', {
      "name": "General",
    });

    // scripts de categories
    await db.execute('''
        CREATE TABLE razas( id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name VARCHAR(255), 
                            id_raza_padre INTEGER,
                            name_raza_padre VARCHAR(255),
                            id_raza_madre INTEGER,
                            name_raza_madre VARCHAR(255)
                          )
      ''');
    await db.insert('razas', {
      "name": "General",
    });
  }

  Future readUser({email, password}) async {
    final db = await database;
    final List data = await db!.rawQuery(
        "SELECT * FROM users WHERE email = '${email}' AND password = '${password}'");
    if (!data.isEmpty) {
      var user = data[0];
      return {
        "id": user['id'].toString(),
        "name": user['name'],
        "email": user['email'],
        "photo": user['photo'],
        "perfil": user['perfil']
      };
    }
    return {};
  }

  Future readUserByEmail({email}) async {
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM users WHERE email = '$email' ");
    if (!data.isEmpty) {
      var user = data[0];
      return {
        "name": user['name'],
        "email": user['email'],
        "photo": user['photo'],
        "perfil": user['perfil']
      };
    }
    return {};
  }

  Future getUserById({id}) async {
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM users WHERE id = '${id}'");
    if (!data.isEmpty) {
      var user = data[0];
      return {
        "name": user['name'],
        "email": user['email'],
        "photo": user['photo'],
        "perfil": user['perfil'].toString(),
      };
    }
    return {};
  }

  Future readAllUser() async {
    final db = await database;
    var users = <Map>[];
    final List data = await db!.rawQuery("SELECT * FROM users");
    if (!data.isEmpty) {
      for (var i = 0; i < data.length; i++) {
        var user = data[i];
        var json = <String, Object>{
          "id": user['id'],
          "name": user['name'],
          "email": user['email'],
          "photo": user['photo'],
          "perfil": user['perfil'].toString(),
        };
        users.add(json);
      }
      return users;
    }
    return {};
  }

  Future<int> insertUser({name, email, password, perfil}) async {
    // primero validar que el usuario no exista
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM users WHERE email = '${email}'");
    if (!data.isEmpty) {
      return 0;
    }

    var photo = perfil == '1' ? "admin.png" : "operator.png";
    int result = await db.insert('users', {
      "name": name,
      "email": email,
      "password": password,
      "photo": photo,
      "perfil": perfil,
    });
    // en sqlif lite las inserciones retornan el id de la inserción
    return result;
  }

  Future updateUser<int>({id, name, email, password, perfil}) async {
    // primero validar que el usuario no exista
    final db = await database;
    final List data = await db!
        .rawQuery("SELECT * FROM users WHERE email = '$email' and id != $id ");
    if (!data.isEmpty) {
      return 0;
    }

    var photo = perfil == 1 ? "admin.png" : "operator.png";
    await db!.rawQuery("""
      UPDATE users SET 
        name = '${name}',
        email = '${email}',
        password = '${password}',
        photo = '${photo}',
        perfil = '${perfil}'
      WHERE id = '${id}'""");
    return 1;
  }

  Future deleteUser({id}) async {
    final db = await database;
    await db!.rawQuery('DELETE FROM users WHERE id = $id');
  }

  Future _createNo(Database db, int version) async {
    await db.execute('''
        CREATE TABLE novillo( id INTEGER PRIMARY KEY AUTOINCREMENT,
                            pesoT VARCHAR(20),
                            estaturaT VARCHAR(20),
                            razaT VARCHAR(50),
                            generoT VARCHAR(50)
                          )
      ''');
    await db.insert('novillo', {
      "pesoT": "Admin",
      "email": "admin@gmail.com",
      "password": "123456789"
    });
  }

  Future addnovi() async {
    final db = await database;
    await db.insert('novillo', {
      "pesoT": String,
      "estaturaT": Float,
      "razaT": String,
      "generoT": String
    });
    return 'agregado';
  }

  // scripts categorias
  Future readAllCategories() async {
    final db = await database;
    var categories = <Map>[];
    final List data = await db!.rawQuery("SELECT * FROM categories");
    print('categories');
    print(data);
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var category = data[i];
        var json = <String, Object>{
          "id": category['id'],
          "name": category['name'],
        };
        categories.add(json);
      }
      return categories;
    }
    return {};
  }

  Future<int> insertCategory({name}) async {
    // primero validar que el usuario no exista
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM categories WHERE name = '${name}'");
    if (!data.isEmpty) {
      return 0;
    }

    int result = await db.insert('categories', {
      "name": name,
    });
    return result;
  }

  Future getCategoryById({id}) async {
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM categories WHERE id = '$id'");
    if (data.isNotEmpty) {
      var category = data[0];
      return {
        "name": category['name'],
      };
    }
    return {};
  }

  Future updateCategory<int>({id, name}) async {
    // primero validar que la categoria no exista
    final db = await database;
    final List data = await db!.rawQuery(
        "SELECT * FROM categories WHERE name = '$name' and id != $id ");
    if (data.isNotEmpty) {
      return 0;
    }

    await db!.rawQuery("""
      UPDATE categories SET 
        name = '$name'
      WHERE id = '$id'""");
    return 1;
  }

  Future deleteCategory({id}) async {
    final db = await database;
    await db!.rawQuery('DELETE FROM categories WHERE id = $id');
  }

  /******************************** razas *********************************/
  Future readAllRazas() async {
    final db = await database;
    var razas = <Map>[];
    final List data = await db!.rawQuery("SELECT * FROM razas");
    print('razas');
    print(data);
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var raza = data[i];
        var json = <String, Object>{
          "id": raza['id'],
          "name": raza['name'],
          "name_raza_padre": raza['name_raza_padre'] ?? '',
          "name_raza_madre": raza['name_raza_madre'] ?? '',
        };
        razas.add(json);
      }
      return razas;
    }
    return {};
  }

  Future<int> insertRaza(
      {name, idRazaPadre, nameRazaPadre, idRazaMadre, nameRazaMadre}) async {
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM razas WHERE name = '${name}'");
    if (!data.isEmpty) {
      return 0;
    }

    int result = await db.insert('razas', {
      "name": name,
      "id_raza_padre": idRazaPadre,
      "name_raza_padre": nameRazaPadre,
      "id_raza_madre": idRazaMadre,
      "name_raza_madre": nameRazaMadre,
    });
    return result;
  }

  Future getRazaById({id}) async {
    final db = await database;
    final List data =
        await db!.rawQuery("SELECT * FROM razas WHERE id = '$id'");
    if (data.isNotEmpty) {
      var raza = data[0];
      return {
        "name": raza['name'],
        "id_raza_padre": raza['id_raza_padre'],
        "name_raza_padre": raza['name_raza_padre'],
        "id_raza_madre": raza['id_raza_madre'],
        "name_raza_madre": raza['name_raza_madre'],
      };
    }
    return {};
  }

  Future updateRaza<int>(
      {id,
      name,
      id_raza_padre,
      name_raza_padre,
      id_raza_madre,
      name_raza_madre}) async {
    // primero validar que la categoria no exista
    final db = await database;
    final List data = await db!.rawQuery(
        "SELECT * FROM categories WHERE name = '$name' and id != $id ");
    if (data.isNotEmpty) {
      return 0;
    }

    await db!.rawQuery("""
      UPDATE razas SET
        name = '$name',
        id_raza_padre = '$id_raza_padre',
        name_raza_padre = '$name_raza_padre',
        id_raza_madre = '$id_raza_madre',
        name_raza_madre = '$name_raza_madre'
      WHERE id = '$id'""");
    return 1;
  }

  Future deleteRaza({id}) async {
    final db = await database;
    await db!.rawQuery('DELETE FROM razas WHERE id = $id');
  }
}
