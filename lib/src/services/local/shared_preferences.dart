import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPreference {
  static SharedPreferences? _sharedPreference;

  init() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  static const _authToken = "auth_token";
  static const _refreshToken = "refresh_token";
  static const _firstTimeInApp = "first_time_in_app";
  static const _language = "language";
  static const _remember = "remember";
  static const _email = "email";
  static const _userId = "userid";
  static const _password = "password";
  static const _expiryTimestamp = "expiryTimestamp";

  static resetCredentials() async {
    _inMemoryToken = null;
    removeAuthToken();
  }

  deleteCredentials() async {
    _inMemoryToken = null;
    await _sharedPreference?.remove(_authToken);
  }

  updateCredentials({String? token}) {
    _inMemoryToken = null;
    removeAuthToken();
    setAuthToken(token.toString());
  }

  //token
  static setAuthToken(String authToken) async =>
      await _sharedPreference?.setString(_authToken, authToken);
  static String? get getSPToken => _sharedPreference?.getString(_authToken);
  static removeAuthToken() async => await _sharedPreference?.remove(_authToken);

//refresh token
  static setRefreshToken(String refreshToken) async =>
      await _sharedPreference?.setString(_refreshToken, refreshToken);

  static String? get getRefreshToken =>
      _sharedPreference?.getString(_refreshToken);

  static removeRefreshToken() async =>
      await _sharedPreference?.remove(_refreshToken);

  //remember
  static setRememberMe(bool remember) async =>
      await _sharedPreference?.setBool(_remember, remember);

  static bool? get getRememberMe =>
      _sharedPreference?.getBool(_remember) ?? false;

  static removeRememberMe() async => await _sharedPreference?.remove(_remember);

  //email
  static setEmail(String email) async =>
      await _sharedPreference?.setString(_email, email);

  static String? get getEmail => _sharedPreference?.getString(_email);

  static removeEmail() async => await _sharedPreference?.remove(_email);

  //password
  static setPassword(String password) async =>
      await _sharedPreference?.setString(_password, password);

  static String? get getPassword => _sharedPreference?.getString(_password);

  static removePassword() async => await _sharedPreference?.remove(_password);

//expire timestamp
  static setExpiryTimestamp(int expiryTimestamp) async =>
      await _sharedPreference?.setInt(_expiryTimestamp, expiryTimestamp);

  static int? get getExpiryTimestamp =>
      _sharedPreference?.getInt(_expiryTimestamp);

  static removeExpireTimestamp() async =>
      await _sharedPreference?.remove(_expiryTimestamp);

//user id
  static setuserId(String userId) async =>
      await _sharedPreference?.setString(_userId, userId);

  static String? get getuserId => _sharedPreference?.getString(_userId);

  static removeuserId() async => await _sharedPreference?.remove(_userId);

  // Use a memory cache to avoid local storage access in each call
  static String? _inMemoryToken;

  static String? getToken() {
    // use in memory token if available
    if (_inMemoryToken?.isNotEmpty ?? false) return _inMemoryToken;

    // otherwise load it from local storage
    _inMemoryToken = getSPToken;

    return _inMemoryToken;
  }

  //first time in app
  static bool get firstTimeInApp =>
      _sharedPreference?.getBool(_firstTimeInApp) ?? false;
  static setFirstTimeInApp() async =>
      await _sharedPreference?.setBool(_firstTimeInApp, true);
  static removeFirstTime() async =>
      await _sharedPreference?.remove(_firstTimeInApp);

  //shared pref init
  static Future sharedPrefInit() async =>
      _sharedPreference = await SharedPreferences.getInstance();

  static setLanguage(String language) async {
    await _sharedPreference?.setString(_language, language);
  }

  static String? get getLanguage => _sharedPreference?.getString(_language);

  bool notLoggedIn() {
    return getSPToken == null;
  }
}
