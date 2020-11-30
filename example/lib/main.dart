import 'package:flutter/material.dart';
import 'package:passikey_flutter_sdk/passikey_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PassikeyFlutterSdk.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _obscureSecretKey = true;
  String _loginStateToken = '';
  LoginResult _passikeyLoginResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Passikey SDK Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('패시키 앱 설치 여부'),
                subtitle: FutureBuilder<bool>(
                  builder: (context, snapshot) {
                    return Text(snapshot?.data ?? false ? '설치됨' : '설치안됨');
                  },
                  future: PassikeyFlutterSdk.instance.isInstalledPassikey,
                ),
                trailing: FlatButton(
                  onPressed: () {
                    PassikeyFlutterSdk.instance.startStore();
                  },
                  child: Text('스토어 열기'),
                ),
              ),
              ListTile(
                title: Text("Passikey Client ID"),
                subtitle: FutureBuilder(
                  builder: (context, snapshot) {
                    return Text(snapshot?.data ?? 'Unknown');
                  },
                  future: PassikeyFlutterSdk.instance.clientId,
                ),
              ),
              ListTile(
                title: Text("Passikey Secret Key"),
                subtitle: FutureBuilder<String>(
                  builder: (context, snapshot) {
                    final secretKey = snapshot?.data ?? 'Unknown';

                    return Text(
                        _obscureSecretKey ? '*' * secretKey.length : secretKey);
                  },
                  future: PassikeyFlutterSdk.instance.clientSecret,
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureSecretKey = !_obscureSecretKey;
                    });
                  },
                  icon: Icon(_obscureSecretKey
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Login State Token',
                      labelText: 'Login State Token',
                      floatingLabelBehavior: FloatingLabelBehavior.auto),
                  onChanged: (v) => _loginStateToken = v,
                ),
              ),
              ListTile(
                title: Text('로그인 결과'),
                subtitle: Text(
                  _passikeyLoginResult == null
                      ? '로그인 전입니다'
                      : 'state token : ${_passikeyLoginResult.stateToken}\npartner token : ${_passikeyLoginResult.partnerToken}',
                ),
                isThreeLine: true,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: RaisedButton(
                    onPressed: () async {
                      final result = await PassikeyFlutterSdk.instance
                          .login(stateToken: _loginStateToken);

                      setState(() {
                        _passikeyLoginResult = result;
                      });
                    },
                    child: Text('로그인 하기'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
