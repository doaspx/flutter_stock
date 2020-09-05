/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:09
 * @LastEditTime: 2020-06-11 13:32:56
 * @FilePath: \stock_app\lib\ui\pages\lib\chart_state.dart
 */ 

enum MainState { FS, K, NONE }
enum SecondaryState { VOL, KDJ, MACD ,NONE }
enum CyqState { CYQ, NONE }
enum AxisType{ NORMAL, LOG }

class StateManager {
      
    StateManager._();
    static changeSecondaryState(curr, {setting}){

      int currNum = SecondaryState.values.indexOf(curr);
      if(currNum == SecondaryState.values.length - 2){
         return  SecondaryState.values[0];
      }else{
         return  SecondaryState.values[currNum + 1];
      }      
    }

    String enumToString(o) => o.toString().split('.').last;

    ///string转枚举类型
    T enumFromString<T>(Iterable<T> values, String value) {
      return values.firstWhere((type) => type.toString().split('.').last == value, orElse: () => null);
    }    
}
