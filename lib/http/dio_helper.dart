import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wanandroid/http/api.dart';

class DioHelper{
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = CancelToken();
  CookieJar cookieJar = CookieJar();

  static DioHelper instance;
  static DioHelper getInstance() {
    if (null == instance) instance = DioHelper();
    return instance;
  }

  DioHelper() {
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: ApiServer.BASE_URL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        "version": "1.0.0",
        "Access-Control-Allow-Origin": "*",
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.formUrlEncodedContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.plain,
    );
    dio = Dio(options);
    //Cookie管理
    dio.interceptors.add(CookieManager(cookieJar));
    //添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler){
          // Do something before request is sent
          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onResponse:(response,handler) {
          // Do something with response data
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onError: (DioError e, handler) {
          // Do something with response error
          return  handler.next(e);//continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
        }
    ));
  }

  /*
   * get请求
   */
   get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.get(url, queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      handleError(e);
    }
    return response;
  }

  /*
   * post请求
   */
   post(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.post(url, queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      handleError(e);
    }
    return response;
  }

  void handleError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      print("响应超时");
    } else if (e.type == DioErrorType.response) {
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      print("请求取消");
    } else {
      print(e);
    }
  }
}