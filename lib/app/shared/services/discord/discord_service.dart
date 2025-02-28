import 'package:dio/dio.dart';

class DiscordService {
  late final Dio _httpClientService;

  DiscordService(this._httpClientService);

  Future<void> send(String message) async {
    const url =
        'https://discord.com/api/webhooks/1040247661225320489/ijXHTG8KaBZeFwkbC2jeqtEuN2QITm7bOwOsB1gGuBU1ik4YUDQk7PoJron6Lge6rKft';

    final headers = {'Content-Type': 'application/json'};

    final body = {
      'content': message,
      'username': 'Gestor Imobiliária',
      'avatar_url': 'https://gestorimobiliaria.com.br/jnh/logo/logo.png'
    };

    _httpClientService.post(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );
  }
}
