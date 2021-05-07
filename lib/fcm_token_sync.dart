library fcm_token_sync;

// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';

/// Widget which calls a callback each time the current FCM token is changed.
///
/// Wrap it around the highest widget in the tree which is only shown when the
/// user is logged in e.g. your home page.
class FcmTokenSync extends StatefulWidget {
  /// Constructs a [FcmTokenSync]
  const FcmTokenSync({
    Key? key,
    required this.firebaseMessaging,
    required this.onToken,
    required this.child,
  }) : super(key: key);

  /// An instance of [FirebaseMessaging]
  final FirebaseMessaging firebaseMessaging;

  /// Called when a new FCM token is generated
  final ValueChanged<String> onToken;

  /// The [Widget] to display below this in the tree.
  final Widget child;

  @override
  State<FcmTokenSync> createState() => _FcmTokenSyncState();
}

class _FcmTokenSyncState extends State<FcmTokenSync> {
  FirebaseMessaging get _messaging => widget.firebaseMessaging;

  StreamSubscription<String>? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startListening();
  }

  Future<void> _startListening() async {
    await _subscription?.cancel();

    final settings = await _messaging.requestPermission();
    final authStatus = settings.authorizationStatus;
    if (authStatus == AuthorizationStatus.authorized) {
      final currentToken = await _messaging.getToken();
      if (currentToken != null) {
        widget.onToken(currentToken);
      }

      _subscription = _messaging.onTokenRefresh.listen(widget.onToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
