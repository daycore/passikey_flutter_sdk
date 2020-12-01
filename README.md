# passikey_flutter_sdk

Flutter용 Passikey SDK 입니다.
현재 지원되는 운영체제는 `Android` ,`iOS` 입니다.

기능 구현시 사용된 SDK 상세 내용은 아래 링크에서 확인하실 수 있습니다.

[passikey_sdk](https://developer.passikey.com/docs/login/common) 



## 구현설명

### Android

`PASSIKEY_LOGIN_SDK_v0.0.7_release.aar` 을 사용하여 구현되었습니다.

해당 라이브러리를 그대로 사용할 경우 Flutter에서는 appcompat 라이브러리를 사용하지 않고 passikey 라이브러리에서는 Appcompat Theme을 사용하고 있어서 에러가 발생하고 있습니다.

그래서 `PASSIKEY_LOGIN_SDK_v0.0.7_release.aar` 을 디컴파일해서 `AndroidManifest.xml`파일에서 `PassikeyLoginActivity`테마를 수정해서 재 컴파일해서 사용하고 있습니다.

수정본

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" 
          package="com.rowem.passikey.sdk" 
          android:versionCode="7" 
          android:versionName="0.0.7">
   <uses-sdk android:minSdkVersion="18" 
             android:targetSdkVersion="28" />
   <application>
      <activity android:theme="@style/Theme.AppCompat" 
                android:name="com.rowem.passikey.sdk.ui.PassikeyLoginActivity" 
                android:launchMode="singleTask">
         <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <data android:host="result" android:scheme="@string/pk_scheme" />
         </intent-filter>
      </activity>
   </application>
</manifest>
```

원본

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" 
          package="com.rowem.passikey.sdk" 
          android:versionCode="7" 
          android:versionName="0.0.7">
   <uses-sdk android:minSdkVersion="18" 
             android:targetSdkVersion="28" />
   <application>
      <activity android:name="com.rowem.passikey.sdk.ui.PassikeyLoginActivity" 
                android:launchMode="singleTask">
         <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <data android:host="result" android:scheme="@string/pk_scheme" />
         </intent-filter>
      </activity>
   </application>
</manifest>
```



## 시작하기

패시키로 로그인을 활성화 하였고 프로젝트 설정을 완료했다고 가정하고 앱에서 설정하는 부분만 설명되어있습니다.
만약 패시키로 로그인을 아직 설정하지 않으셨다면 [패시키로 로그인 사전 준비 안내](https://developer.passikey.com/docs/beforeCheck)의 내용을 읽으시고 환경을 구축한 후 진행해주세요.



### Dependencies

Passikey Flutter SDK를 사용하기 위해서 가장 먼저 `pubspec.yaml`파일에 아래의 코드를 추가해줘야 합니다.

```yaml
dependencies:
  passikey_flutter_sdk: ^0.0.2
```



### Android

#### SDK 설정

1. 패시키 개발자 센터에서 다운로드 받은 `passikey_sdk_config.json`파일을 Flutter 프로젝트의 `android/app/src/main/assets`디렉토리에 넣어주세요.
   
   

2. 패시키에서 사용되는 scheme을 strings.xml 에 추가해야합니다.
   `android/app/src/main/values/strings.xml`

   ```xml
   <resources>
     // scheme 설정 ( 개발자 센터에서 제휴사 Client id 적용 )
     <string name="pk_scheme" translatable="false">pk{CLIEND ID}</string>
   </resources>
   ```

   

3. 패시키 라이브러리는 gson, appcompat을 사용합니다.
   `android/app/build.gradle`파일에 dependency를 추가합니다.

   ```groovy
   dependencies {
       implementation "com.google.code.gson:gson:2.8.6"
       implementation "androidx.appcompat:appcompat:1.2.0"
   }
   ```



4. `android/build.gradle`파일에 repository를 추가합니다.

   ```groovy
   allprojects {
       repositories {
           google()
           jcenter()
           maven {
               url "${project(':passikey_flutter_sdk').projectDir}/libs"
           }
       }
   }
   ```

   

### iOS

#### SDK 설정

1. 패시키 개발자 센터에서 다운로드 받은`passikey_sdk_config.plist`파일을 Flutter 프로젝트의 `ios/Runner`디렉토리에 넣어주세요.
   
   

2. Info.plist 설정 
   `LSApplicationQueriesSchemes`에 passikeyauth를 추가합니다.
   `CFBundleURLTypes`에 자신의 client id에 해당하는 값을 추가합니다.

   ```xml
   <key>LSApplicationQueriesSchemes</key>
   <array>
     <string>passikeyauth</string>
   </array>
   ```

   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLName</key>
       <string></string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>pk{CLIENT ID}</string>
       </array>
     </dict>
   </array>
   ```



3. AppDelegate.swift 수정

   Passikey sdk를 사용하기 위해서는 UINavationController가 RootViewController에 존재해야 합니다.
   다음과 같이 코드를 변경해야 합니다.

   ```swift
   import UIKit
   import Flutter
   
   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GeneratedPluginRegistrant.register(with: self)
       
       let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
       let navigationController = UINavigationController(rootViewController: flutterViewController);
       navigationController.setNavigationBarHidden(true, animated: false);
           
       self.window = UIWindow(frame: UIScreen.main.bounds);
       self.window.rootViewController = navigationController;
       self.window.makeKeyAndVisible();
   
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```

   

## 구현 가이드

### SDK 초기화

passikey sdk를 사용하기 위해서는 초기화 작업을 걸쳐야 합니다.

```dart
PassikeyFlutterSdk.init();
```



Example:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PassikeyFlutterSdk.init();

  runApp(MyApp());
}
```



### Passikey 로그인

패시키로 로그인 하기 위해서는 다음 함수를 호출하면 됩니다.

```dart
PassikeyFlutterSdk.instance.login(stateToken: "myLoginStateToken");
```



Example:

```dart
final result = await PassikeyFlutterSdk.instance.login(stateToken: "myLoginStateToken");

print(result.partnerToken); // 파트너 토큰
print(result.stateToken); // 로그인 할때 사용한 StateToken
```



### ClientID, ClientSecret 반환

```dart
await PassikeyFlutterSdk.instance.clientId; // 나의 앱 클라이언트 아이디
await PassikeyFlutterSdk.instance.clientSecret; // 나의 앱 클라이언트 시크릿
```



### 패시키 앱 설치여부 확인

```dart
await PassikeyFlutterSdk.instance.isInstalledPassikey; // 핸드폰에 패시키 앱 설치 여부
```



### 패시키 앱 다운로드 페이지 이동

```dart
await PassikeyFlutterSdk.instance.startStore(); // 각 플랫폼별 스토어 열기
```

