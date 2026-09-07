import 'package:flutter_test/flutter_test.dart';
import 'package:artinium/data/repositories/user_repository.dart';

void main() {
  group('UserRepository', () {
    test('login fails with a short password', () async {
      final repo = UserRepository();
      final ok = await repo.login(email: 'a@b.com', password: '12');
      expect(ok, false);
      expect(repo.isAuthenticated, false);
    });

    test('login succeeds with a valid email and password', () async {
      final repo = UserRepository();
      final ok = await repo.login(email: 'praveen@artinium.com', password: 'secret');
      expect(ok, true);
      expect(repo.isAuthenticated, true);
      expect(repo.user.email, 'praveen@artinium.com');
    });

    test('updatePersonalization stores comfort level and power target', () {
      final repo = UserRepository();
      repo.updatePersonalization(comfortLevel: 'COOL', powerTargetUnits: 250, colorTone: 'Green');
      expect(repo.user.comfortLevel, 'COOL');
      expect(repo.user.powerTargetUnits, 250);
      expect(repo.user.colorTone, 'Green');
    });

    test('logout clears authentication', () async {
      final repo = UserRepository();
      await repo.login(email: 'a@b.com', password: 'abcd');
      repo.logout();
      expect(repo.isAuthenticated, false);
    });
  });
}
