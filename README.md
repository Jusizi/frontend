# APP Jusizi


```
# Salvar em

.vscode/launch.json
```
```json
{
    "configurations": [
      {
        "name": "Flutter (web)",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
          "--dart-define=isTest=true",
          "--dart-define=baseUrlAPI=http://192.168.18.173:8053",
          "--dart-define=baseUrlAUTH=http://192.168.18.173:8052/",
          "--dart-define=FIREBASE_API_KEY=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_APP_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MESSAGING_SENDER_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_PROJECT_ID=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_AUTH_DOMAIN=XXXXXXXXXXXXXXXXXXXXXXx",
          "--dart-define=FIREBASE_STORAGE_BUCKET=XXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MEASUREMENT_ID=XXXXXXXXXXXXXXXXXXXXXX"
        ]
      },
      {
        "name": "Flutter (android)",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
          "--dart-define=isTest=true",
          "--dart-define=baseUrlAPI=http://192.168.18.173:8053",
          "--dart-define=baseUrlAUTH=http://192.168.18.173:8052/",
          "--dart-define=FIREBASE_API_KEY=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_APP_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MESSAGING_SENDER_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_PROJECT_ID=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_STORAGE_BUCKET=XXXXXXXXXXXXXXXXXm"
        ]
      },
      {
        "name": "Flutter (ios)",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
          "--dart-define=isTest=true",
          "--dart-define=baseUrlAPI=http://192.168.18.173:8053",
          "--dart-define=baseUrlAUTH=http://192.168.18.173:8052/",
          "--dart-define=FIREBASE_API_KEY=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_APP_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MESSAGING_SENDER_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_PROJECT_ID=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_STORAGE_BUCKET=XXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_IOS_BUNDLE_ID=com.example.appjusizi"
        ]
      },
      {
        "name": "Flutter (macos)",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
          "--dart-define=isTest=true",
          "--dart-define=baseUrlAPI=http://192.168.18.173:8053",
          "--dart-define=baseUrlAUTH=http://192.168.18.173:8052/",
          "--dart-define=FIREBASE_API_KEY=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_APP_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MESSAGING_SENDER_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_PROJECT_ID=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_STORAGE_BUCKET=XXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_IOS_BUNDLE_ID=com.example.appjusizi"
        ]
      },
      {
        "name": "Flutter (windows)",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "args": [
          "--dart-define=isTest=true",
          "--dart-define=baseUrlAPI=http://192.168.18.173:8053",
          "--dart-define=baseUrlAUTH=http://192.168.18.173:8052/",
          "--dart-define=FIREBASE_API_KEY=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_APP_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MESSAGING_SENDER_ID=XXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_PROJECT_ID=XXXXXXXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_AUTH_DOMAIN=XXXXXXXXXXXXXXXXXXXXXXx",
          "--dart-define=FIREBASE_STORAGE_BUCKET=XXXXXXXXXXXXXXXXX",
          "--dart-define=FIREBASE_MEASUREMENT_ID=XXXXXXXXXXXXXXXXXXXXXX"
        ]
      }
    ]
  }
```
Para buildar o Android
```bash
flutter build apk --release --dart-define=baseUrlAPI=https://api.jusizi.com.br --dart-define=baseUrlAUTH=https://auth.jusizi.com.br/ --dart-define=FIREBASE_API_KEY=AIzaSyDLTJfxmzLy4dGk0cMmSGOCdl33CQMyrKU --dart-define=FIREBASE_APP_ID=1:913916913322:android:e989dfc364bca58dea12d3 --dart-define=FIREBASE_MESSAGING_SENDER_ID=913916913322 --dart-define=FIREBASE_PROJECT_ID=jusizi-2999c --dart-define=FIREBASE_STORAGE_BUCKET=jusizi-2999c.appspot.com
```