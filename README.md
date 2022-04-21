# FCM Token Sync

A widget which keeps your FCM token in sync with your backend

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev/)
[![Pub Version](https://img.shields.io/pub/v/fcm_token_sync)](https://pub.dev/packages/fcm_token_sync)
![GitHub](https://img.shields.io/github/license/netsells/flutter-fcm-token-sync)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/netsells/flutter-fcm-token-sync/Test)
[![Coverage Status](https://coveralls.io/repos/github/netsells/flutter-fcm-token-sync/badge.svg?branch=master)](https://coveralls.io/github/flutter-fcm-token-sync?branch=master)

## ✨ Features

- Keeps your user's FCM tokens in sync with your backend
- Automatically handles permission requests
- 100% test coverage
- Null-safety

## 🚀 Installation

Install from [pub.dev](https://pub.dev/packages/fcm_token_sync):

```yaml
fcm_token_sync: ^1.0.4
```

## ✅ Prerequisites

You should already have Firebase Cloud Messaging set up in your project. Go [here](https://firebase.flutter.dev/docs/messaging/overview) for setup instructions.

Additionally, you will need to have built a way to send FCM tokens to your backend service.

## 🔨 Usage

This package contains a `FcmTokenSync` widget, which you can wrap around any widget in your project.

Some recommendations for usage:

- Add this widget to your tree wherever you want to ask your user for notification permissions.
- This will probably be after the user has registered and/or signed in.

### Example

```dart
class HomePage extends StatelessWidget {
    const HomePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return FcmTokenSync(
            firebaseMessaging: FirebaseMessaging.instance,
            onToken: _updateFcmToken,
            child: Scaffold(), // Widget to display here
        );
    }

    Future<void> _updateFcmToken(String token) async {
        // Send the updated token to your backend here.
    }
}
```

## 👨🏻‍💻 Authors

- [@ptrbrynt](https://www.github.com/ptrbrynt) at [Netsells](https://netsells.co.uk/)
