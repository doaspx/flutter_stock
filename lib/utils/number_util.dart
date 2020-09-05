/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:09
 * @LastEditTime: 2020-06-03 15:10:34
 * @FilePath: \stock_app\lib\utils\number_util.dart
 */ 
class NumberUtil {
  static String volFormat(double n) {
    if (n > 10000 && n < 999999) {
      double d = n / 1000;
      return "${d.toStringAsFixed(2)}K";
    } else if (n > 1000000) {
      double d = n / 1000000;
      return "${d.toStringAsFixed(2)}M";
    }
    return n.toStringAsFixed(2);
  }

  static String amountFormat(double n) {
    if (n > 10000 && n < 99999999) {
      double d = n / 10000;
      return "${d.toStringAsFixed(2)}万";
    } else if (n > 100000000) {
      double d = n / 100000000;
      return "${d.toStringAsFixed(2)}亿";
    }
    return n.toStringAsFixed(2);
  }

  static String format(double price, {int fractionDigits = 2}) {
    return price.toStringAsFixed(fractionDigits) ;
  }


  static double getNumByValueDouble(double price, {int fractionDigits = 2}) {
    return double.parse(NumberUtil.format(price));
  }
}
