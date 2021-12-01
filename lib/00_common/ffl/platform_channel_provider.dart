import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter/services.dart';

final platformChannelProvider = ChangeNotifierProvider<PlatformChannelProvider>(
  (ref) => PlatformChannelProvider(),
);

final onNetworkStateChangeStreamProvider = StreamProvider<int>((ref) {
  final provider = ref.read(platformChannelProvider);
  return provider.onNetworkStateChange();
});

class PlatformChannelProvider extends ChangeNotifier {
  PlatformChannelProvider() {
    Future.wait([
      Future(() async => await checkReachability()),
    ]);
  }

  // MethodChannel: １体１メソッド
  static const MethodChannel _channel =
      MethodChannel('platform_channel/method_channel');

  // EventChannel: １体多イベント
  static const EventChannel _eventChannel =
      EventChannel('platform_channel/event_channel');

  bool isReachable = false;

  Future<bool> checkIsReachable() async {
    final bool isReachable = await _channel.invokeMethod('isReachable');
    return isReachable;
  }

  void setIsReachable(bool isReachable) {
    this.isReachable = isReachable;
    notifyListeners();
  }

  Future<void> checkReachability() async {
    try {
      final result = await checkIsReachable();
      setIsReachable(result);
    } catch (e) {
      print(e);
      setIsReachable(false);
    }
  }

  Stream<int> onNetworkStateChange() {
    final state = _eventChannel.receiveBroadcastStream().map((dynamic event) {
      return event as int;
    });
    return state;
  }
}
