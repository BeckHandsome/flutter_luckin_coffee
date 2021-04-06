import 'dart:convert';
import 'dart:convert' as convert;

/// fluro 参数编码解码工具类
class FluroConvertUtils {
  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String fluroCnParamsEncode(String originalCn) {
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  /// fluro 传递后取出参数，解析 针对单个参数
  static String fluroCnParamsDecode(String encodeCn) {
    var list = List<int>();

    ///字符串解码
    for (var data in jsonDecode(encodeCn)[0]) {
      list.add(data);
    }
    return Utf8Decoder().convert(list);
  }

  /// fluro 传递后取出参数，解析 针对传入得是map的解析后返回map
  static Map fluroMapParamsDecode(Map params) {
    Map _params = {};
    if (params != null && params.isNotEmpty) {
      for (var key in params.keys) {
        _params[key] = fluroCnParamsDecode(params[key].toString());
      }
    }
    return _params;
  }

  /// object 转为 string json
  static String object2string<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> string2map(String str) {
    return json.decode(fluroCnParamsDecode(str));
  }

  /// string json 转为 List
  static List string2List(String str) {
    return convert.jsonDecode(str);
  }
}
