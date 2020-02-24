import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart";
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId, _userPicture, _userName;
  Timer _authTimer;
  bool _sso = false;

  bool get isAuth {
    // print(_userId);
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else if (_sso && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get userPicture {
    return _userPicture;
  }

  String get userName {
    return _userName;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyBhFXKRdvxET09wORdfjFsTE3aG-nFians';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
//Google authentication
  // Future<FirebaseUser> handleSignIn() async {
  //   final GoogleSignIn _googleSignIn = GoogleSignIn();
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   final FirebaseUser user =
  //       (await _auth.signInWithCredential(credential)).user;
  //   print("signed in " + user.displayName);
  //   return user;
  // }

  Future<void> handleSignIn() async {
    // FirebaseAuth _auth = FirebaseAuth.instance;
    final FacebookLogin _facebookLogin = FacebookLogin();
    final result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;

    final graphResponse = await http.get(
        'https://graph.facebook.com/v4.0/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
    final responseData = json.decode(graphResponse.body);
    // _token = result.accessToken.token;
    _userId = responseData['id'];
    _userName = responseData['first_name'];
    _userPicture = responseData['picture']['data']['url'];
    if (result.accessToken.token != null) {
      _sso = true;
    }
    //  print(responseData);
    // print(responseData['picture']['data']['url']);
    notifyListeners();
    accessToken();
  }

  void accessToken() {
    final accountCredentials = new ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "flutter-e767a",
      "private_key_id": "8b9f45c5ae4ad2ce08d01004da1181571d86b106",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDR5jzUVHuJblmh\ndXeZe4SALLEN7VL1QFuczAmpZE7LATD1ajt/fEyBxvvtq1akNvtL0BsGToz6x8gT\nm192p1FBXJxRleCcXiR2DDii6bDVMJJh/T57XhKOX//eUzwUZHelOVHo+LoD+vXh\nEijTCRMrnvgL/Ba2vMtjlKdcAV6ZAIPZKMMf7p6U302KX1X0ku+HKZwrQrYxBhSu\nEejPfzzWnDng48bW2jSQ9RH3+YsYevo/EQUKw/9LzeEWmwBZI9iUiha0Zz4JKwaK\nYjYufxm+GE8P3Er51LSJqsxodg0VZwq9VSln962lQ7JrZza1QctfJqoZZ7iEiPp9\na36cJBJHAgMBAAECggEAHJG0wYZsOCT7xc+qGIsThP9QQV/bikPDvxWV0mdeQsr7\nNx7J/AysPH/Ge4TLgAIhyyGyA/Y+FxuJKS4H3NZiPL4WYr5pJNoQJrx8GvnUK/hL\n/FK5UJZZz+TTe+x4AXiOlmpfspDkKgrcW6bv7+V3eq5M/xNFTi29QI++WyCul67B\nvPdV8s8voMO+CmaB8Y4fjtHZVN9PTsg8GnxvJSVopXXZiX6xYQZjHc+jjWYm1x8X\n0Y77oCUacNwpzdBMW3P9vD1JUMleHmOB5hZtbtD2MSuVMcMM4iVtsXcRVagW3IYr\n7W71OUWxDKa7LSrb9M8uwpnB/EdG38Mh4PZhPlZpgQKBgQD9owPrUbkM+YAE2p0D\nkK+hGeVgDT6uid8SHkyJ1y8zNRRGJAqA8Z2GTIcFdsyHvJhN7uYlwZcfcmRGzcRm\nB1Cb6LXjMWuECicWPCXHDgr4li9swlRn2Tsdnt1ntyExtiCbMP8GQ8/D55q3kgmV\nALaG5xJheDsv8Wlj0g67wKLhgQKBgQDT2uXnWfb+DC1qWK4aYxUZxnwhotSqpD40\n9daDzsFC3YgAAFyAvcce575t3DGVcErXucL5+1i4IYGYWlAknOuj3cKBtuFV8uVg\nJJgQjng0XH9fBNV+p/C6p8I6+h6AHtIsMYCqKdrnhDONoNoBPoUl1ZSCKRb55XwO\nuWX3tvxHxwKBgD2kuPcgTZFRskN7vl13dLf6yzyk+28AIy8MHh4CJn6Tj/HcIJFm\nJ5rUTpyNWvhCZeHLBjR28Hu8GZL7v5fsfzLlRA+Lm03kCcvlomjWiOQR3ETalhkH\nOs7gJX9nirHCSfpt1g13va8nQvsKizmjirkOv/Dgf8IPMkYIb3xCPVQBAoGAJSv0\nSNqNLtgeI9m5eqHF8wbTgudaHzLAQ3SbFfdyC3RpR27IzEIALRkGXapT/N9+Ekni\nvw/t6ije30eBZlsuMUtYtH/NG9KJkov5LnaA+tb79kUX3KhE4ctLliOKtHoz8FMj\nOzgq05JrpT8C4VMB87h83TWudVxhnwfCr2so6sMCgYBJX3nTVmXTJ22G7ywktcIB\nnpGswC9oIvbor7kC5UKGldMSd7IQpR1mqWlG1+XPGZNkN+lAxCIZPM+1ErIaOLBt\nHowOsQX+qokWLKxgL3Ia7qSDSKmyFAX8NB0Zl0gkjUWRiO/eyoOWXBECD2XJuyIo\nDGKXkr8Q3oOC4NAZnP0SCg==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-ar4i4@flutter-e767a.iam.gserviceaccount.com",
      "client_id": "111408251105373785602",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ar4i4%40flutter-e767a.iam.gserviceaccount.com"
    });
    var scopes = [
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email'
    ];
    var client = new http.Client();
    obtainAccessCredentialsViaServiceAccount(accountCredentials, scopes, client)
        .then((AccessCredentials credentials) {
      // Access credentials are available in [credentials].
      // ...
      // print(credentials.accessToken.data);
      _token = credentials.accessToken.data;
      print(_token);
      notifyListeners();
      client.close();
    });
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
