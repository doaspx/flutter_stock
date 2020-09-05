/*
 * @Author: zhang
 * @Date: 2020-05-25 21:03:30
 * @LastEditTime: 2020-06-15 08:57:30
 * @FilePath: \stock_app\lib\model\base_response.dart
 */ 


class BaseResponseEntity<T> {
  String status; //"suc" or "fai"
  int msg_code; //110未登录
  String msg; //"msg":"Suc!"
  String tok;

  int pg;
  int pgSize;
  int total;

  Map  record;

  List records;
  dynamic data;

  List<T> getRecords<T>(Function fromJson) {
    List<T> resultList = List<T>();
    for (int i = 0; i < records.length; i++) {
      resultList.add(fromJson(records[i]));
    }
    return resultList;
  }

  get isFai {
    if(this.status == 'fai') return true;
    return false;
  }

  get unAuthorized {
    return this.msg_code == 110 ? true: false;
  }

  static BaseResponseEntity fromJson(Map<String, dynamic> map, {Function parseFun}) {
    if (map == null) return null;
    BaseResponseEntity response = BaseResponseEntity();
    response.status = map['status'];
    response.msg_code = map['msg_code'] as int;
    response.msg = map['msg'];
    response.tok = map['tok'];

    if (map['pg'] != null) response.pg = int.parse(map['pg'].toString());
    if (map['pgSize'] != null)
      response.pgSize = int.parse(map['pgSize'].toString());
    if (map['total'] != null)
      response.total = int.parse(map['total'].toString());


    response.record = map['record'];

    if(parseFun != null) response.records = parseFun(map);
    else response.records = map['records']??[];
    response.data = map['data'];
    return response;
  }
}

abstract class BaseResponseParse<T> {
  T fromJson(map);

  toJson(T t);
}



class UnAuthorizedException implements Exception {
  final String msg;
  const UnAuthorizedException(this.msg);
}