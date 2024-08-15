import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Local.db');
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
    await db.execute("DROP TABLE IF EXISTS users");
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
    var photo = perfil == '1' ? "admin.png" : "operator.png";
    final db = await database;
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

  Future updateUser({id, name, email, password, perfil}) async {
    var photo = perfil == 1 ? "admin.png" : "operator.png";
    final db = await database;
    await db!.rawQuery("""
      UPDATE users SET 
        name = '${name}',
        email = '${email}',
        password = '${password}',
        photo = '${photo}',
        perfil = '${perfil}'
      WHERE id = '${id}'""");
    return {};
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

  // Future addDataLocally({Name}) async {
  //   final db = await database;
  //   await db.insert('users', {"name": Name});
  //   print('${Name} Agregado exitosamente');
  //   return "added";
  // }
}
