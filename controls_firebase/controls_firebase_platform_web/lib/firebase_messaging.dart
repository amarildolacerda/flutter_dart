import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;
import 'package:controls_firebase_platform_interface/firebase_messaging_interface.dart';
//import 'dart:convert';
//import 'dart:html';

//import 'package:http/browser_client.dart';
//import 'package:service_worker/window.dart' as sw;
//import 'dart:js' as js;

class FBMessaging extends FBMessagingInterface {
  FBMessaging();
  firebase.Messaging? _mc;
  String? _token;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  @override
  void close() {
    _controller.close();
  }

  @override
  Future<void> init(String keyPair) async {
    _mc = firebase.messaging();
    _mc!.usePublicVapidKey(keyPair); // 'FCM_SERVER_KEY');
    _mc!.onMessage.listen((event) {
      goMessage(event);
    });
    /*_mc.onTokenRefresh.listen((token) {
      if (onTokenRefresh != null) {
        onTokenRefresh(token);
      }
    });*/
  }

  showNotification(title, body, data) {
    // js.context.callMethod('showNotification', [title, body, data]);
  }

  Future<void> goMessage(message) async {
    if (message != null)
      try {
        var notification = message.notification;
        var title = notification.title;
        var body = notification.body;
        var data = message.data;
        _controller.sink.add({
          "notification": {"title": title, "body": body},
          "show": true
          //"data": TODO: data - web retorna objeto nao compativel
        });
        showNotification(title, body, data);
      } catch (err) {
        print('$err');
      }
  }

  @override
  Future requestPermission() {
    return _mc!.requestPermission();
  }

  @override
  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      await requestPermission();
      _token = await _mc!.getToken();
    }
    return _token!;
  }
}
