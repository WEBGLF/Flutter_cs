import 'package:get/get.dart';

/// 基于 GetX 的全局事件总线服务，支持类型安全的事件监听和发送
class EventBusService extends GetxService {
  final Map<Type, List<Function>> _listeners = {};

  static EventBusService get to => Get.find();

  /// 注册一个事件监听器
  void on<T>(void Function(T event) callback) {
    _listeners.putIfAbsent(T, () => []);
    _listeners[T]?.add(callback);
  }

  /// 移除一个事件监听器
  void off<T>(void Function(T event)? callback) {
    if (callback == null) {
      _listeners.remove(T);
    } else {
      _listeners[T]?.removeWhere((element) => element.hashCode == callback.hashCode);
    }
  }

  /// 发送事件给所有监听者
  void fire<T>(T event) {
    if (_listeners.containsKey(event.runtimeType)) {
      for (var handler in _listeners[event.runtimeType]!) {
        handler(event);
      }
    }
  }

  @override
  void onClose() {
    _listeners.clear();
    super.onClose();
  }
}
