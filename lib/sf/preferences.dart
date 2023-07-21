import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user.dart';

class Preferences {
  SharedPreferences? _preferences;

  Preferences._private() {
    init();
  }
  static final instance = Preferences._private();
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> isLoggedIn() async {
    return instance._preferences?.getBool('isLoggedIn') ?? false;
  }

  Future<void> setIsLoggedIn() async {
    await instance._preferences?.setBool('isLoggedIn', true);
  }

  Future<void> setUser(String userId) async {
    await instance._preferences?.setString('userId', userId);
  }

  Future<String?> getUser() async {
    return instance._preferences?.getString('userId');
  }
}
