import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio();

  Future<Response> getRequest(String url) async {
    try {
      final response = await _dio.get(url);
      print('Status CODE IS : ${response.statusCode}');
      return response;
    } on DioException catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: url),
        error: error.error,
        response: error.response,
      );
    }
  }
}
