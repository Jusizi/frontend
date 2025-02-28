// ignore_for_file: unused_local_variable, deprecated_member_use, file_names

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../either.dart';
import '../../stores/auth/auth_store.dart';
import 'HttpClientResponse.dart';
import 'IHttpClientServiceInterface.dart';

class AUTHDIOHttpClientServiceImplementation
    implements IHttpClientServiceInterface {
  final Dio _dio;

  @override
  final String baseUrl;

  AUTHDIOHttpClientServiceImplementation(
    this._dio,
    this.baseUrl,
  );

  Dio get httpClient => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          preserveHeaderCase: true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Modular.get<AuthStore>().accessToken}',
          },
        ),
      );

  @override
  Future<bool> downloadFile({
    required String urlExternalFile,
    required String localToSaveInDevice,
    Function(int count, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await httpClient.download(
        urlExternalFile,
        '$localToSaveInDevice${DateTime.now().millisecond}.jpg',
        onReceiveProgress: (count, total) => {
          if (onReceiveProgress != null) {onReceiveProgress(count, total)}
        },
      );

      if (response.data != null) {
        return false;
      }

      return false;
    } on DioError catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> get(String endpoint) async {
    try {
      final response = await httpClient.get(endpoint);

      return Right(HttpClientResponse(response.data));
    } on DioError catch (error) {
      String resposta = error.message!;

      if (error.response!.statusCode != 200) {
        _authTokenInvalid(resposta);

        return Left(error.response?.data['message'] ?? '');
      }

      return Left(resposta);
    }
  }

  @override
  Future<bool> refreshToken() async {
    //final refreshToken = await _storage.read('refreshToken');
    final response =
        await _dio.post('/auth/refresh', data: {'refreshToken': refreshToken});

    if (response.statusCode == 201) {
      //authStore.setAcessToken(response.data);
      return true;
    } else {
      // refresh token is wrong
      //authStore.removeAcessToken();
      //  _storage.deleteAll();
      return false;
    }
  }

  _authTokenInvalid(String resposta) {
    if (resposta.contains('token')) {
      Modular.get<AuthStore>().removeAcessToken();
      Modular.to.navigate('/auth/');
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> post(
      {required String endpoint, required dynamic body}) async {
    try {
      final response = await httpClient.post(endpoint, data: body);

      return Right(HttpClientResponse(response.data));
    } on DioError catch (error) {
      String resposta = error.message!;

      if (resposta.contains('token expired')) {
        if (await refreshToken()) {
          return post(endpoint: endpoint, body: body);
        }
      }

      if (error.response!.statusCode != 200) {
        _authTokenInvalid(resposta);

        return Left(error.response?.data['message'] ??
            error.response!.data['message'] ??
            '');
      }

      return Left(resposta);
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> put(
      {required String endpoint, required dynamic body}) async {
    try {
      final response = await httpClient.put(endpoint, data: body);

      return Right(HttpClientResponse(response.data));
    } on DioError catch (error) {
      String resposta = error.message!;

      if (resposta.contains('token expired')) {
        if (await refreshToken()) {
          return post(endpoint: endpoint, body: body);
        }
      }

      if (error.response!.statusCode != 200) {
        _authTokenInvalid(resposta);

        return Left(error.response?.data['message'] ??
            error.response!.data['message'] ??
            '');
      }

      return Left(resposta);
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> delete(String endpoint) async {
    AuthStore authStore = Modular.get<AuthStore>();
    try {
      final response = await httpClient.delete(
        baseUrl + endpoint,
      );

      return Right(HttpClientResponse(response.data));
    } on DioError catch (error) {
      String resposta = error.message ?? 'Alguma coisa aconteceu';
      if (error.response != null) {
        if (error.response!.statusCode == 500) {
          return Left('Erro interno do servidor');
        }

        resposta = error.message!;

        if (error.response!.statusCode == 403) {
          if (resposta.contains('token')) {
            Modular.get<AuthStore>().removeAcessToken();
            Modular.to.navigate('/auth/');
          }
        }
        resposta = error.response?.data['message'] ?? '';
      }
      return Left(resposta);
    }
  }
}
