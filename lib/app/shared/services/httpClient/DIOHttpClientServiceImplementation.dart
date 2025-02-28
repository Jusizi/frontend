// ignore_for_file: unused_local_variable, file_names, prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../either.dart';
import '../../stores/auth/auth_store.dart';
import 'HttpClientResponse.dart';
import 'IHttpClientServiceInterface.dart';

class DIOHttpClientServiceImplementation
    implements IHttpClientServiceInterface {
  @override
  String get baseUrl => const String.fromEnvironment('baseUrlAPI',
      defaultValue: 'http://localhost:8053');

  Dio get httpClient => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          preserveHeaderCase: true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Modular.get<AuthStore>().accessToken}',
          },
        ),
      )..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.next(options);
            },
            onResponse: (response, handler) {
              return handler.next(response);
            },
            onError: (DioException e, handler) {
              if (e.response?.statusCode == 401) {
                Modular.get<AuthStore>().removeAcessToken();
                Modular.to.navigate('/auth/');
              }

              if (e.response?.statusCode == 402) {
                Modular.get<AuthStore>().removeAcessToken();
                Modular.to.navigate('/planos/');
              }

              if (e.response!.data.toString().toLowerCase().contains('token')) {
                Modular.get<AuthStore>().removeAcessToken();
                Modular.to.navigate('/auth/');
              }

              return handler.next(e);
            },
          ),
        );

  @override
  Future<bool> downloadFile({
    required String urlExternalFile,
    required localToSaveInDevice,
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
    } on DioException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> get(String url) async {
    try {
      final response = await httpClient.get(url);

      return Right(HttpClientResponse(response.data));
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      return Left(error.message ?? 'Alguma coisa aconteceu');
    }
  }

  @override
  Future<bool> refreshToken() async {
    //final refreshToken = await _storage.read('refreshToken');
    final response = await httpClient
        .post('/auth/refresh', data: {'refreshToken': refreshToken});

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

  @override
  Future<Either<String, HttpClientResponse>> post(
      {required String endpoint, required dynamic body}) async {
    try {
      final response = await httpClient.post(
        endpoint,
        data: body,
      );

      return Right(HttpClientResponse(response.data));
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      if (error.response?.statusCode == 401) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      if (error.response?.statusCode == 422) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }

      return Left(error.message ?? 'Alguma coisa aconteceu');
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> put(
      {required String endpoint, required dynamic body}) async {
    try {
      final response = await httpClient.put(
        endpoint,
        data: body,
      );

      return Right(HttpClientResponse(response.data));
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      if (error.response?.statusCode == 401) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      return Left(error.message ?? 'Alguma coisa aconteceu');
    }
  }

  @override
  Future<Either<String, HttpClientResponse>> delete(String endpoint) async {
    AuthStore authStore = Modular.get<AuthStore>();

    httpClient.options.headers['Authorization'] =
        'Bearer ${authStore.accessToken}';

    try {
      final response = await httpClient.delete(endpoint);

      return Right(HttpClientResponse(response.data));
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      if (error.response?.statusCode == 401) {
        return Left(
            error.response?.data['message'] ?? 'Alguma coisa aconteceu?');
      }
      return Left(error.message ?? 'Alguma coisa aconteceu');
    }
  }
}
