/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:09
 * @LastEditTime: 2020-06-04 12:37:15
 * @FilePath: \stock_app\lib\utils\event_bus_util.dart
 */ 
typedef void EventCallback(arg);
class EventBus { //饿汉
  EventBus._();
  static EventBus instance ;


  static Future init() async {
    if (instance == null) {
      instance = new EventBus._();
    }
  }

  var _eMap = new Map<Object, List<EventCallback>>();

  void on(eventName, EventCallback f, {isAdd: false}) {
    if (eventName == null || f == null) return;
    _eMap[eventName] ??= new List<EventCallback>();
    if(_eMap[eventName].length == 0){
      _eMap[eventName].add(f);
    }else{      
       if(isAdd == true) _eMap[eventName].add(f);
    }
  }

  void off(eventName, [EventCallback f]) {
    var list = _eMap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }
  
  void send(eventName, [arg]) {
    var list = _eMap[eventName];
    if (list == null) return;
    print('EVent Map:${list.length}');
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}