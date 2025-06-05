// 文件路径: lib/request/Https.dart
import 'package:Rupee_Rush/utils/Method.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:Rupee_Rush/store/index.dart';
import 'package:Rupee_Rush/utils/Config.dart';
import 'package:get/get.dart';

import 'ApiException.dart';

class Http extends GetxService {
  late Dio.Dio _dio;
  final Dio.CancelToken _cancelToken = Dio.CancelToken();
  //取消所有请求
  void cancelAllRequests() {
    _cancelToken.cancel();
  }

  // 单例模式初始化
  static Http get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    final options = Dio.BaseOptions(
      baseUrl: AppMethod.getBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {},
    );
    _dio = Dio.Dio(options);
    // 添加拦截器
    _dio.interceptors.add(
      Dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          bool needToken = true; // 可根据 url 判断是否需要 token
          if (needToken) {
            // 获取 token
            String? token = Storage.to.getToken();
            // 如果有 token，添加到请求头中
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = token;
            }
          }
          options.headers['User-Agent'] = '';
          options.headers['Accept-Language'] = '';
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("Response: ${response.statusCode} ${response.data}");
          handler.next(response);
        },
        onError: (Dio.DioException e, handler) async {
          ApiException.handle(e); // 统一异常处理
          return handler.next(e);
        },
      ),
    );
  }

  // 泛型 GET 请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      cancelToken: _cancelToken,
    );
    return _processResponse<T>(response, parser: parser);
  }

  // 泛型 POST 请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: _cancelToken,
    );
    return _processResponse<T>(response, parser: parser);
  }

  // 泛型 PUT 请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? parser,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      cancelToken: _cancelToken,
    );
    return _processResponse<T>(response, parser: parser);
  }

  // 泛型 DELETE 请求
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    final response = await _dio.delete(
      path,
      queryParameters: queryParameters,
      cancelToken: _cancelToken,
    );
    return _processResponse<T>(response, parser: parser);
  }

  // 统一处理响应数据并转换为泛型 T
  T _processResponse<T>(Dio.Response response, {T Function(dynamic)? parser}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      if (parser != null) {
        return parser(data);
      }
      if (T == dynamic || T == Object || T == Map || T == List) {
        return data;
      }
      throw UnsupportedError('Unsupported type: $T');
    } else {
      throw Exception(
        'HTTP request failed with status code: ${response.statusCode}',
      );
    }
  }

  // 注册服务时调用
  static Future<Http> init() async {
    Get.put(Http());
    return Http.to;
  }
}
