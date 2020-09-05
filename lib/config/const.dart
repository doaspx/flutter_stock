/*
 * @Author: zhang
 * @Date: 2020-05-25 21:38:22
 * @LastEditTime: 2020-06-12 13:52:33
 * @FilePath: \stock_app\lib\config\const.dart
 */ 

class Const{
  static const String KLineDataHeader = 'k_stock_'; // 'k_stock_'+m+c  
  static const String FsLineDataHeader = 'fs_stock_'; 
  static const String LastViewStockInfo = 'last_view_stock'; //最后查询股票信息 0:m, 1:code,2:name
}

class PathConst{
  PathConst._();
  static const String StockList = 'stock_list'; //股票列表

  static const String KHistory = 'get_kline'; //历史K线数据

  static const String FSAllLine = 'get_fs_all_line';//获取分时，委托成交 数据
  
  static const String StockInfo = 'get_kline'; //获取股票信息
}