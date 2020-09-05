/*
 * @Author: your name
 * @Date: 2020-05-25 21:02:44
 * @LastEditTime: 2020-06-06 17:49:07
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /stock_app/lib/service/system/system.dart
 */ 
import 'package:app_stock/model/base_response.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import '../base_service.dart';

class SystemService {
  static Future<BaseResponseEntity> login({Map<String, String> params}) async {
    BaseResponseEntity data = await BaseService.tlRequest(path:'r_login', params: params,needTok: false);
    return data;
  }

  static Future<BaseResponseEntity> outLogin() async {
    BaseResponseEntity data = await BaseService.tlRequest(path: 'st/sys.core/logout');
    return data;
  }

  static Future<BaseResponseEntity> checkUpdate() async { 
    BaseResponseEntity data = await BaseService.tlRequest(  path: 'st/api.app.system/checkNew',);
    return data;
  }

  static Future<BaseResponseEntity> init() async {
    
  }

  //测试下载本地
  static Future download() async {
    final dirPath = await getExternalStorageDirectory();
    String path = '${dirPath.path}/aaa.png';

    print(path);
  //  CancelToken cancelToken = CancelToken();
  try{
   await Dio().download('http://192.168.6.16:9090/css/img/****5_2.png', path, onReceiveProgress: (p, total) {
      String currPrecent = ((p / total) * 100).toStringAsFixed(2);
      print(currPrecent);
    }).then((Response response) {
      print('over');
      return path;
    }).catchError((onError) {
      print(onError);
        //showToast(onError.error.msg.toString());
    });

  }catch(e){
    print(1);
  }
  }
}
