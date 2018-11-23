import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthStore {
  static final AuthStore _authStore = new AuthStore._internal();
  static final FacebookLogin _facebookLogin = new FacebookLogin();

  factory AuthStore() {
    return _authStore;
  }

  FacebookLogin getFacebookLogin() {
    return _facebookLogin;
  }

  AuthStore._internal();
}
