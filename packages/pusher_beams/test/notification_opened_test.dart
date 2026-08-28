import 'package:flutter_test/flutter_test.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('delivers notification-open data to the registered callback', () async {
    final platform = _FakePusherBeamsPlatform();
    PusherBeamsPlatform.instance = platform;

    Map<Object?, Object?>? receivedData;
    await PusherBeams.instance.onNotificationOpened((data) {
      receivedData = data;
    });

    final callbackId = platform.notificationOpenedCallbackId;
    expect(callbackId, isNotNull);

    PusherBeams.instance.handleCallback(
      callbackId!,
      'onNotificationOpened',
      <Object>[
        <Object?, Object?>{'route': 'notification'},
      ],
    );

    expect(receivedData, <Object?, Object?>{'route': 'notification'});
  });
}

class _FakePusherBeamsPlatform extends PusherBeamsPlatform {
  String? notificationOpenedCallbackId;

  @override
  Future<void> onNotificationOpened(covariant dynamic callbackId) async {
    notificationOpenedCallbackId = callbackId as String;
  }
}
