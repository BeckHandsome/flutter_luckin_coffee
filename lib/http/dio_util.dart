import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/GlobalUtils.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';

import 'error_handle.dart';

class NWApi {
  static final baseApi = "https://api.it120.cc/d6532d0bc96a18d29e95bb4fa664bd10";
}

typedef successCallBack<T> = Function(T data);
typedef failCallBack<T> = Function(T data);

class DioUtil {
  static final DioUtil _instance = DioUtil._init();
  static Dio _dio;
  static BaseOptions _options = getDefOptions();

  factory DioUtil() {
    return _instance;
  }

  DioUtil._init() {
    _dio = new Dio();
    // 该项目用不到
    // _dio.interceptors.add(InterceptorsWrapper(
    //     onRequest:(RequestOptions options) async {
    //     // 在请求被发送之前做一些事情
    //     return options; //continue
    //     // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    //     // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //     //
    //     // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    //     // 这样请求将被中止并触发异常，上层catchError会被调用。
    //     },
    //     onResponse:(Response response) async {
    //     // 在返回响应数据之前做一些预处理
    //     return response; // continue
    //     },
    //     onError: (DioError e) async {
    //       // 当请求失败时做一些预处理
    //     return e;//continue
    //     }
    // ));
  }

  static BaseOptions getDefOptions() {
    BaseOptions options = BaseOptions();
    options.connectTimeout = 50 * 10000;
    options.receiveTimeout = 20 * 10000;
    options.contentType = Headers.formUrlEncodedContentType;

    Map<String, dynamic> headers = Map<String, dynamic>();
    headers['Accept'] = 'application/json';

    String platform;
    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "IOS";
    }
    headers['OS'] = platform;
    options.headers = headers;

    return options;
  }

  setOptions(BaseOptions options) {
    _options = options;
    _dio.options = _options;
  }

  Future request(
    String path, {
    String baseApi,
    String method,
    Map<String, dynamic> pathParams,
    data,
    successCallBack,
    failCallBack,
  }) async {
    Map<String, dynamic> _pathParams = {};
    String token = await sharedGetData('token') ?? null;
    if (token != null) {
      if (pathParams == null) {
        _pathParams['token'] = token;
      } else {
        pathParams['token'] = token;
        _pathParams = pathParams;
      }
    } else {
      _pathParams = pathParams;
    }
    String _baseApi = baseApi ?? NWApi.baseApi;

    ///restful请求处理 对
    Response response = await _dio.request(
      _baseApi + path,
      data: data,
      queryParameters: _pathParams,
      options: Options(
        method: method,
      ),
    );
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        if ((response.data is Map && response.data['code'] == 0)) {
          if (successCallBack != null) {
            return successCallBack(response.data);
          }
        } else {
          return _handleHttpError(response.data['code'], response.data['msg'], failCallBack);
        }
      } on DioError catch (e) {
        final NetError netError = ExceptionHandle.handleException(e);
        return _handleHttpError(netError.code, netError.msg, failCallBack);
      }
    } else {
      return _handleHttpError(response.statusCode, response.statusMessage, failCallBack);
    }
  }

  ///处理Http错误码
  void _handleHttpError(int errorCode, String msg, failCallBack) {
    print(errorCode);
    if (errorCode == 201) {
      NavigatorUtil.navigateTo(GlobalUtils.globalContext, PageRouter.login, replace: true, clearStack: true);
    }
    if (errorCode == 2000) {
      NavigatorUtil.navigateTo(GlobalUtils.globalContext, PageRouter.login, replace: true, clearStack: true);
    }
    EasyLoading.showError('$msg');
    if (failCallBack != null) {
      failCallBack({'code': errorCode, 'msg': msg});
    }

    /// 调用拦截器的 lock()/unlock 方法来锁定/解锁拦截器。
    /// 一旦请求/响应拦截器被锁定，接下来的请求/响应将会在进入请求/响应拦截器之前排队等待，直到解锁后，这些入队的请求才会继续执行(进入拦截器)
    /// 你也可以调用拦截器的clear()方法来清空等待队列
    _dio.lock();
    _dio.clear();
  }
}
