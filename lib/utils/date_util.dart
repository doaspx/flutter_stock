/*
 * @Author: zhanghongtao
 * @Date: 2020-06-02 16:26:45
 * @LastEditTime: 2020-06-19 17:28:21
 * @FilePath: \stock_app\lib\utils\date_util.dart
 */ 


  import 'date_format_util.dart';

class DateUtil {
  DateUtil._();

  static String getTime(int time) {
    DateTime now = DateTime.now();
    DateTime first = DateTime(now.year, now.month, now.day, 9, 30);

    DateTime second = DateTime(now.year, now.month, now.day, 11, 31);
    DateTime t1 = first.add(Duration(minutes: time));
    if (t1.millisecondsSinceEpoch > second.millisecondsSinceEpoch) {
      t1 = t1.add(Duration(minutes: 90));
    }

    return dateFormat(t1, [HH, ':', nn]);
  }

  static DateTime getDateTimeByIndex(int date){
    DateTime first = DateTime(2005, 1, 1);
    DateTime target = first.add(Duration(days: date));
    return target;
  }
  
  static String getDateByIndex(int date) {
    DateTime target = getDateTimeByIndex(date);
    return dateFormat(target, [yyyy, '/', mm, '/', d]);
  }


  static bool isInSameWeekByIndex(int firstNum, int secondNum){  
    if(firstNum == null || secondNum == null) return false;
    DateTime first = getDateTimeByIndex(firstNum); 
    DateTime second = getDateTimeByIndex(secondNum); 
    return isInSameWeek(first, second);
  }  

  static bool isInSameWeek(DateTime first, DateTime second){
    if(first == null || second == null) return false;
    DateTime min, max;

    if(first.microsecondsSinceEpoch < second.millisecondsSinceEpoch){//第一个日期小
      min = first;
      max = second;
    }else{
      min = second;
      max = first;
    }
    
    int days = min.difference(max).inDays;
    if(days < 7 && first.weekday < second.weekday) return true; 
    return false;
  }

  static bool isInSameByIndexType(int firstNum, int secondNum, int type){
    if(type == 2) return isInSameWeekByIndex(firstNum, secondNum);
    else if(type == 3) return isInSameMonthByIndex(firstNum, secondNum);
    else if(type == 4) return isInSameQuarterByIndex(firstNum, secondNum);
    else if(type == 5) return isInSameYearByIndex(firstNum, secondNum);
    else throw('没有配置K线类型');
  }

  static bool isInSameMonthByIndex(int firstNum, int secondNum){  
    if(firstNum == null || secondNum == null) return false;
    DateTime first = getDateTimeByIndex(firstNum); 
    DateTime second = getDateTimeByIndex(secondNum); 
    
    int days = first.difference(second).inDays;
    if(days.abs() > 32) return false;
    return first.month == second.month ? true : false ;
  }  

  static bool isInSameQuarterByIndex(int firstNum, int secondNum){
    if(firstNum == null || secondNum == null) return false;
    DateTime first = getDateTimeByIndex(firstNum); 
    DateTime second = getDateTimeByIndex(secondNum); 
    
    int days = first.difference(second).inDays;
    if(days.abs() > 100) return false;
    return getQuarter(first) == getQuarter(second) ? true : false;
  }

  
  static bool isInSameYearByIndex(int firstNum, int secondNum){
    if(firstNum == null || secondNum == null) return false;
    DateTime first = getDateTimeByIndex(firstNum); 
    DateTime second = getDateTimeByIndex(secondNum);     
    return first.year == second.year ? true : false;
  }


  static int getIndexByDate(DateTime d) {
    DateTime first = DateTime(2005, 1, 1);
    int days = d.difference(first).inDays;
    return days;
  }

    
  static int getWeekByIndex(int date) {    
    DateTime target = getDateTimeByIndex(date);
    return  target.weekday;
  }

  static int getMonthByIndex(int date) {
    DateTime target = getDateTimeByIndex(date);
    return  target.month;
  }

  
  static int getQuarterByIndex(int index){
    DateTime target = getDateTimeByIndex(index);
    return getQuarter(target);
  }

  static int getQuarter(DateTime date){
    int quarter = (date.month / 3).ceil();
    return quarter;
  }
      
  static int getYearByIndex(int date) {
    DateTime target = getDateTimeByIndex(date);
    return  target.year;
  }
}
