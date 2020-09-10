# Clocktrol

Everybody is tracking their productive time, but no one tracks their unproductive time...

I made this app to gather information about my workday. I start a timer in the morning, stop it for lunch break, turn it back on when I get to work and put it off when I stop working for the day. The app then pulls my tracked working time from [Clockify](https://clockify.me/) and at the end of the day gives me intersting statistics about how productive or unproductive my day really was.

## Getting Started

Setup

- Add `.env` file with your Clockify API key as follows if you have one.

```bash
CLOCKIFY_API_KEY=YourClockifyApiKey
```

- Add `google-services.json` pointing to Firebase backend into `android/app` (or for iOS follow [these steps](https://firebase.google.com/docs/flutter/setup?platform=ios)).

Run project

- Run `flutter pub get` to install dependencies.
- Run `flutter run` to execute app on device.
