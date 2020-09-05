/*
 * @Author: your name
 * @Date: 2020-05-25 11:11:58
 * @LastEditTime: 2020-06-04 10:18:36
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \stock_app\lib\utils\socket_io_utils.dart
 */

import 'package:app_stock/config/env.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'event_bus_util.dart';

class SocketIoUtils {
  static Socket _socket;
  SocketIoUtils._();

  static SocketIoUtils _instance;
  static SocketIoUtils getInstance() {
    if (_instance == null) {
      _instance = SocketIoUtils._();
    }
    if (_socket == null) {
      _instance._init();
    }

    return _instance;
  }

  _init() {
    _socket = io(Env.StkTcp, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      print('connect');
    });

    _socket.on('connecting', (_) {
      print('connecting');
    });

    _socket.on('disconnect', (_) {
      print('disconnect');
    });

    _socket.on('error', (_) {
      print('error');
    });

    _socket.connect();
    bind('fs_line');
  }

  bind(channel) {
    _socket.on(channel, (_) {
      EventBus.instance.send(channel, _);
    });
  }

  emit(channel, params) {
    _socket.emit(channel, params);
  }
}
