import 'package:app_stock/model/base_response.dart';
import 'package:app_stock/utils/dio_util.dart';
import 'package:flutter/material.dart';

import '../config/env.dart';
import '../utils/sp_util.dart'; 

class BaseService {
  static Future<BaseResponseEntity> tlRequest({
    @required String path,
    String host = Env.Stk,
    Map params,
    needTok: false,
    Function parseResult,
  }) async {
    //null
    String page = '';
    String start = '';
    String limit = '';
    String erpPageCondition = '';
 
    String otherCondition = '';
    if (params != null && params.isNotEmpty) {
      page = params['page'] != null ? params['page'].toString() : null;
      start = params['start'] != null ? params['start'].toString() : null;
      limit = params['limit'] != null ? params['limit'].toString() : null;

      params.remove('page');
      params.remove('start');
      params.remove('limit');

      if (page != null && start != null && limit != null)
        erpPageCondition =
            "&page=${page.toString()}&start=${start.toString()}&limit=${limit.toString()}";

 
      if (params != null && params.isNotEmpty) {
        params.forEach((key, value) {
          otherCondition += '&${key.toString()}=${value.toString()}';
        });
      }
    }

    print('page:$page, start:$start, limit:$limit');

    String tok = '';
    if (needTok) {
      String localTok =  SpUtil.instance.getString('tok');

      if (localTok == null) throw UnAuthorizedException('请登录系统'); 
      tok = 'tok=$localTok';
    }
    String url =
        "$host$path?$tok$erpPageCondition$otherCondition";

  print('Request:$url');
    var data = await DioManager.get(url, {});
    BaseResponseEntity result = BaseResponseEntity.fromJson(data, parseFun: parseResult);
    if (needTok && data['msg_code'] == 110)  throw UnAuthorizedException(result.msg);
  
    // if (parseResult != null) {
    //   BaseResponseEntity newResult;

    //   newResult = parseResult(result, data);
    //   return newResult;
    // }
    return result;
  }

  static Future<BaseResponseEntity> request(
      {@required String path,
      String host = Env.Stk,
      bool map2Str = true,
      String type = 'get',
      Map params,
      Function parseResult}) async {
    String otherCondition = '';

    String tok = SpUtil.instance.getString('tok');
    
    if (tok == null) return throw ({'msg': '请登录系统'});
    if (params != null && params.isNotEmpty && map2Str) {
      otherCondition = '&';
      params.forEach((key, value) {
        otherCondition += '&${key.toString()}=${value.toString()}';
      });
    }
    String url = "$host$path?tok=$tok$otherCondition";
    var data;
    if (type == 'get')
      data = await DioManager.get(url, null);
    else if (type == 'post')
      data = await DioManager.post(url, params);
    else if (type == 'upload') data = await DioManager.upload(url, params);

    BaseResponseEntity result = BaseResponseEntity.fromJson(data);

    if (parseResult != null) {
      BaseResponseEntity newResult = parseResult(result, data);
      return newResult;
    }
    return result;
  }
}
