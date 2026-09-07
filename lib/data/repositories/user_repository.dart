import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../mock/mock_data.dart';

class UserRepository extends ChangeNotifier {
  AppUser _user = MockData.user;
  bool _isAuthenticated = false;

  AppUser get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  /// Mock/local auth only — no real backend or credential storage yet.
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.trim().isEmpty || password.trim().length < 4) return false;
    _isAuthenticated = true;
    _user = _user.copyWith(email: email.trim());
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void updatePersonalization({
    String? colorTone,
    String? comfortLevel,
    int? powerTargetUnits,
  }) {
    _user = _user.copyWith(
      colorTone: colorTone,
      comfortLevel: comfortLevel,
      powerTargetUnits: powerTargetUnits,
    );
    notifyListeners();
  }
}
