import 'package:appjusizi/app/models/CNJ.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Deverão ser CNJ válidos', () async {
    CNJ processo1 = CNJ('81187783720218050001');

    expect(processo1.value, '8118778-37.2021.8.05.0001');

    CNJ processo2 = CNJ('00202059420255040662');

    expect(processo2.value, '0020205-94.2025.5.04.0662');
  });

  test('Deverão ser CNJ inválidos', () async {
    expect(() => CNJ('81187783720218050002'), throwsException);
    expect(() => CNJ('00202059420255040663'), throwsException);
  });
}
