import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLProvider {
  SQLProvider._();
  
  static Database db;

  // 获取数据库中所有的表
  static Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  static Future checkTableIsRight() async {
    List<String> expectTables = ['stock_list'];

    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  //初始化数据库
  static Future init(bool isCreate) async {
    //Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'stock.db');
    print(path);
    try {
      db = await openDatabase(path);
    } catch (e) {
      print("Error $e");
    }
    bool tableIsRight = await checkTableIsRight(); 
    if (!tableIsRight) {
      db.close();
      // Delete the database
      await deleteDatabase(path);

      db = await openDatabase(path, version: 4,
          onCreate: (Database db, int version) async {
          print('db created version is $version');
      }, onOpen: (Database db) async {
            await db.execute('''  
                CREATE TABLE 'stock_list' (
                  id INTEGER PRIMARY KEY, 
                  code TEXT, 
                  name TEXT, 
                  jc TEXT);             
                ''');  
      });
    } else {
      print("Opening existing database");
    }
  }
}


class SqlUtil  { 
 String tableName;
  Database db;
  var query;
  SqlUtil.setTable(String name){
    tableName = name;
    db = SQLProvider.db;
    query = db.query;
  }

  Future<List> get() async {
    return await this.query(tableName);
  }

  String getTableName() {
    return tableName;
  }


  Future<int> delete(String value, String key) async {

    return await this
        .db
        .delete(tableName, where: '$key = ?', whereArgs: [value]);
  }

  Future<int> deleteAll() async {
    return await this.db.delete(tableName);
  }

  Future<List> getByCondition({Map<dynamic, dynamic> conditions}) async {
    if (conditions == null || conditions.isEmpty) {
      return this.get();
    }
    String stringConditions = '';

    int index = 0;
    conditions.forEach((key, value) {
      if (value == null) {
        return;
      }
      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key = "$value"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = $value';
      }

      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions and';
      }
      index++;
    });
    // print("this is string condition for sql > $stringConditions");
    return await this.query(tableName, where: stringConditions);
  }

  Future<int> insert(Map<String, dynamic> json) async {
    int id = await this.db.insert(tableName, json); 
    return id;
  }

  Future<bool> insertAll(String header , List jsons) async {
    try{
        List<String> fieldsArr = [];
        List<String> values = [];
        
        for(int i = 0 ; i < jsons.length; i++) {
            fieldsArr.add("(?,?,?)");
            values.addAll(List<String>.from(jsons[i]));
            if(fieldsArr.length >= 300 || i == jsons.length - 1){
                await _insertArr(header, fieldsArr,  values);
                fieldsArr = [];
                values = [];
            }
        }
        return true;
    }catch(e){
      print(e);
      return null;
    }
  }

    Future<bool> _insertArr(String header , List<String> fieldsArr, List<String> values ) async {
      try{
          String fields =  fieldsArr.join(',');
          String sql = header + fieldsArr.join(',');
          int result = await this.db.rawInsert(sql, values);
          return result  > 0 ? true : false;
      }catch(e){
          return false;
      }
    }


  Future<int> count() async {
     List list =  await this.db.rawQuery('select count(*) as count from $tableName');
     return list[0]['count'] ?? 0;
  }

  Future<List> next(String code) async {

    code = code.toUpperCase();
     //List list =  await this.db.rawQuery("select * from "+tableName+" where id >1");
    List list =  await this.db.rawQuery("select * from $tableName where id >= ((select id from stock_list where code =? )+1) order by id asc limit 12",[code]);
      print(list[0]);
     return list;
  }


  Future<List> pre(String code) async {
    code = code.toUpperCase();
    try{
     List list =  await this.db.rawQuery("select * from $tableName where id <= ((select id from stock_list where code =?)-1) order by id desc limit 10",[code]);

     return list;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<List> searchlimit(int limit) async {
     List list =  await this.db.rawQuery('select *  from $tableName limit ?', [limit]);
     return list;
  }

  
  Future<List> searchOnly(String code) async {
     List list =  await this.db.rawQuery("select * from $tableName where full_code = ?" ,[code]);
     return list;
  }


  ///
  /// 搜索
  /// @param Object condition
  /// @mods [And, Or] default is Or
  /// search({'name': "hanxu', 'id': 1};
  ///
  Future<List> search(
      {Map<String, dynamic> conditions, String mods = 'Or'}) async {
    if (conditions == null || conditions.isEmpty) {
      return this.get();
    }
    String stringConditions = '';
    int index = 0;
    conditions.forEach((key, value) {
      if (value == null) {
        return;
      }

      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key like "%$value%"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = "%$value%"';
      }

      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions $mods';
      }
      index++;
    });

    return await this.query(tableName, where: stringConditions);
  }
}
