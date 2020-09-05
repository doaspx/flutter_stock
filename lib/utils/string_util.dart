/*
 * @Author: zhang
 * @Date: 2020-05-25 20:30:33
 * @LastEditTime: 2020-06-19 17:24:34
 * @FilePath: \stock_app\lib\utils\string_util.dart
 */ 
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart'; 
 

class StringUtil {
  static String toMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String toSH1(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = sha1.convert(content);
    return hex.encode(digest.bytes);
  }

  static String formatNum(num, {point: 2}) {
    if (num != null) {
      String str = double.parse(num.toString()).toString();
      // 分开截取
      List<String> sub = str.split('.');
      // 处理值
      List val = List.from(sub[0].split(''));
      // 处理点
      List<String> points = List.from(sub[1].split(''));
      //处理分割符
      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
        // 除以三没有余数、不等于零并且不等于1 就加个逗号
        if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
      }
      // 处理小数点
      for (int i = 0; i <= point - points.length; i++) {
        points.add('0');
      }
      //如果大于长度就截取
      if (points.length > point) {
        // 截取数组
        points = points.sublist(0, point);
      }
      // 判断是否有长度
      if (points.length > 0) {
        return '${val.join('')}.${points.join('')}';
      } else {
        return val.join('');
      }
    } 
    return "0.0"; 
  }
}

