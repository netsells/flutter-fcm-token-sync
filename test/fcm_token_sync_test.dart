// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 🌎 Project imports:
import 'package:fcm_token_sync/fcm_token_sync.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  late MockFirebaseMessaging messaging;

  setUp(() {
    messaging = MockFirebaseMessaging();
  });

  testWidgets(
    '''FcmTokenSync invokes callback when current token loaded, and when new tokens are posted to the stream''',
    (tester) async {
      when(() => messaging.requestPermission()).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.authorized,
          showPreviews: AppleShowPreviewSetting.always,
          sound: AppleNotificationSetting.enabled,
          carPlay: AppleNotificationSetting.disabled,
          lockScreen: AppleNotificationSetting.enabled,
          notificationCenter: AppleNotificationSetting.enabled,
          badge: AppleNotificationSetting.enabled,
          announcement: AppleNotificationSetting.enabled,
          alert: AppleNotificationSetting.enabled,
        ),
      );

      when(() => messaging.getToken()).thenAnswer((_) async => 'token1');

      when(() => messaging.onTokenRefresh).thenAnswer(
        (_) => Stream.fromIterable(['token2', 'token3']),
      );

      final collectedTokens = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: FcmTokenSync(
            firebaseMessaging: messaging,
            onToken: collectedTokens.add,
            child: const Scaffold(),
          ),
        ),
      );

      await expectLater(
        collectedTokens,
        containsAllInOrder(['token1', 'token2', 'token3']),
      );
    },
  );

  testWidgets('FcmTokenSync displays child', (tester) async {
    when(() => messaging.requestPermission()).thenAnswer(
      (_) async => const NotificationSettings(
        authorizationStatus: AuthorizationStatus.denied,
        showPreviews: AppleShowPreviewSetting.always,
        sound: AppleNotificationSetting.enabled,
        carPlay: AppleNotificationSetting.disabled,
        lockScreen: AppleNotificationSetting.enabled,
        notificationCenter: AppleNotificationSetting.enabled,
        badge: AppleNotificationSetting.enabled,
        announcement: AppleNotificationSetting.enabled,
        alert: AppleNotificationSetting.enabled,
      ),
    );

    when(() => messaging.getToken()).thenAnswer((_) async => null);

    when(() => messaging.onTokenRefresh)
        .thenAnswer((_) => const Stream.empty());

    final collectedTokens = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: FcmTokenSync(
          firebaseMessaging: messaging,
          onToken: collectedTokens.add,
          child: const Scaffold(key: Key('child-key')),
        ),
      ),
    );

    expect(find.byKey(const Key('child-key')), findsOneWidget);
  });

  testWidgets(
    'FcmTokenSync does not read tokens if permission denied',
    (tester) async {
      when(() => messaging.requestPermission()).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.denied,
          showPreviews: AppleShowPreviewSetting.always,
          sound: AppleNotificationSetting.enabled,
          carPlay: AppleNotificationSetting.disabled,
          lockScreen: AppleNotificationSetting.enabled,
          notificationCenter: AppleNotificationSetting.enabled,
          badge: AppleNotificationSetting.enabled,
          announcement: AppleNotificationSetting.enabled,
          alert: AppleNotificationSetting.enabled,
        ),
      );

      final collectedTokens = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: FcmTokenSync(
            firebaseMessaging: messaging,
            onToken: collectedTokens.add,
            child: const Scaffold(key: Key('child-key')),
          ),
        ),
      );

      expect(collectedTokens, isEmpty);

      verifyNever(() => messaging.getToken());
      verifyNever(() => messaging.onTokenRefresh);
    },
  );
}
