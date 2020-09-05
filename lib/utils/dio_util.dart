/*
 * @Author: zhang
 * @Date: 2020-05-25 20:30:18
 * @LastEditTime: 2020-09-03 21:42:40
 * @FilePath: /stock_app/lib/utils/dio_util.dart
 */ 
import 'dart:io';
import 'package:dio/dio.dart';
import 'package_info_util.dart';


class DioManager {
  
  static Future<Map<String, dynamic>> get(String url, Map<String, dynamic> params) async {
    Map<String, dynamic> t = await _requstHttp(url, 'get', params);
    return t;
  }

   //post
  static Future<Map<String, dynamic>> post(String url,  params) async {
    return await _requstHttp(url, 'post', params);
  }

   //post
  static Future<Map<String, dynamic>> upload(String url,  params) async {
    return await _requstHttp(url, 'upload', params);
  }

  static Future<Map<String, dynamic>> _requstHttp(String url,  [String method, Map<String, dynamic> params]) async {
   // print('Requet: =====>   $url');

    var appVersion = await PackageInfoUtil.getVersion();
    params = params ?? {};
    params['appVerison'] =appVersion;
    //params['platform'] = Platform.operatingSystem;

    Response response;
    try {
      BaseOptions options =   BaseOptions(connectTimeout: 15000,);
      Dio dio = new Dio(options);
      if (method == 'get') {
          response = await dio.get(url, queryParameters: params);
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params );
        } else {
          response = await dio.post(url);
        }
      } else if (method == 'upload') {
          FormData formData =  FormData.fromMap(params);  
          response = await dio.post(url, data: formData );
      }
      return response.data;
    } on DioError catch (error) {
      throw(error);
    } catch (error) {
      throw(error);
    }
  }


}
