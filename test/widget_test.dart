import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/services/user_data_service.dart';

void main() {
  test('UserDataService is singleton', () {
    final a = UserDataService();
    final b = UserDataService();
    expect(identical(a, b), true);
  });
}
