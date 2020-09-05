import 'package:app_stock/model/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../config/router.dart';
import '../ui/components/203_pageWidget.dart';

/// 页面状态类型
enum Status {
  idle, //空闲中
  busy, //忙中
  loading, //加载中
  chartLoading,//加载图表中
  empty, //无数据
  error, //加载失败
  unAuthorized, //未登录
}

/// 错误类型
enum ErrorType {
  defaultError,
  networkError,
  unLoginError,
}

class ErrorInfo {
  ErrorType errorType;
  String message;

  ErrorInfo(this.errorType, this.message);

  @override
  String toString() {
    return 'BaseModel{errorType: $errorType, message: $message ';
  }
}

class BaseModel extends State<StatefulWidget> with ChangeNotifier {
  bool _disposed = false;

  Status _status;
  Status get status => _status;

  set status(Status newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  String loadingMsg = '';

  ErrorInfo _errorInfo;

  ErrorInfo get errorInfo => _errorInfo;

  BaseModel({Status status}) {
    _status = status ?? Status.idle;
  }

  bool get isBusy => status == Status.busy;

  bool get isLoading => status == Status.loading;

  bool get isChartLoading => status == Status.chartLoading;

  bool get isIdle => status == Status.idle;

  bool get isEmpty => status == Status.empty;

  bool get isError => status == Status.error;

  bool get isDeny => status == Status.error;

  bool get unAuthorized => status == Status.unAuthorized;

  void setIdle() {
    status = Status.idle;
  }

  void setBusy() {
    status = Status.busy;
    _errorInfo = null;
  }

  
  void setChartLoading() {
    status = Status.chartLoading;
    _errorInfo = null;
  }

  void setLoading({String msg}) {
    status = Status.loading;
    loadingMsg = msg ?? '加载中...';
    _errorInfo = null;
  }
  
  void setEmpty() {
    status = Status.empty;
  }

  void setUnAuthorized(String message) {
    status = Status.unAuthorized;
    _errorInfo = ErrorInfo(ErrorType.unLoginError, message);

    onUnAuthorizedException(message);
  }

  void setError(e) {
    ErrorType errorType = ErrorType.defaultError;
    String message = '';
    if (e is UnAuthorizedException) {
      setUnAuthorized(e.msg);
      return;
    } else if(e is DioError){
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        message =  '请求超时';
      }else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        message = '接收超时';
      }else message = e.message.toString();

      errorType = ErrorType.networkError;
    }else{      
      print(e);
         message = '请求异常';
        errorType = ErrorType.defaultError;
    }
    _errorInfo = ErrorInfo(
      errorType,
      message,
    );
    status = Status.error;
  }

  /// 未授权的回调
  void onUnAuthorizedException(message) {}

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;

    print('BaseModel dispose -->$runtimeType');
    super.dispose();
  }

  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (errorInfo != null || message != null) {
      showToast("网络连接错误", textStyle: TextStyle(fontSize: 40));
    }
  }

  Future<BaseResponseEntity> request(
      BuildContext context, Function requestMethod,
      {Map<String, dynamic> params}) async {
    BaseResponseEntity result;
    try {
      if (params == null)
        result = await requestMethod();
      else
        result = await requestMethod(params: params);
      return result;
    } catch (e) {
      if(e is UnAuthorizedException) {
        setError(e);
         redirectLogin(context, e.msg);
         throw e;
      }
      else return throw e;
    }
  }

  redirectLogin(BuildContext context, String message){
      return Navigator.of(context).pushAndRemoveUntil(
        TlCupertinoPageRoute(builder: (context) {
      return LoginWidget(
          message: message,
          onPressed: () {
            // return Navigator.of(context)
            //     .pushNamedAndRemoveUntil(RouteName.login, (route) => false);
          });
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}