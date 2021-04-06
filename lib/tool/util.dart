import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 本地存储数据 添加或者更新
sharedAddAndUpdate(String key, Object dataType, Object data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (dataType) {
    case bool:
      await prefs.setBool(key, data);
      break;
    case String:
      await prefs.setString(key, data);
      break;
    case double:
      await prefs.setDouble(key, data);
      break;
    case int:
      await prefs.setInt(key, data);
      break;
    case List:
      await prefs.setStringList(key, data);
      break;
    default:
      await prefs.setString(key, data.toString());
  }
}

// 获取本地存储的数据
sharedGetData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get(key);
}

// 移除本地存储的数据
sharedDeleteData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

/// 检查是否是邮箱格式
bool isEmail(String input) {
  /// 邮箱正则
  final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  if (input == null || input.isEmpty) return false;
  return new RegExp(regexEmail).hasMatch(input);
}

// 二进制流转图片
//  Uint8List img;
//   // 获取图片二进制流的方法
//   Future _verificationPic() async {
//     Dio _dio = new Dio();
//     String path = NWApi.baseApi + "/verification/pic/get";
//     try {
//       String url = path;
//       Response response = await _dio.get(url,
//           options: Options(responseType: ResponseType.bytes));
//       final Uint8List bytes =
//           await consolidateHttpClientResponseBytes(response.data);
//       print("服务器返回：${bytes.length}");
//       print(bytes);
//       img = bytes;
//       setState(() {});
//     } catch (e) {
//       print("网络错误：" + e.toString());
//     }
//   }
// 二进制流转图片
dynamic httpClientResponseBytes(data) {
  // response.contentLength is not trustworthy when GZIP is involved
  // or other cases where an intermediate transformer has been applied
  // to the stream.
  final List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  chunks.add(data);
  contentLength += data.length;
  final Uint8List bytes = Uint8List(contentLength);
  int offset = 0;
  for (List<int> chunk in chunks) {
    bytes.setRange(offset, offset + chunk.length, chunk);
    offset += chunk.length;
  }
  return bytes;
}

// 定位权限 Permission.location  //可以选择别的权限
// permission = Permission.location; //定位权限
// isRepplyPermission 是否需要一直申请权限
// 判断获取权限
Future<bool> getPermission(Permission permission, {bool isRepplyPermission = true}) async {
  if (await permission.status == PermissionStatus.granted) {
    // 权限申请通过
    return true;
  } else {
    //权限没允许
    //如果弹框还能出现，那就不用管了，申请权限就行了

    if (isRepplyPermission) {
      bool l = await repplyPermission(permission);
      return l;
    }
    return false;
  }
}

// 再次申请权限
Future<bool> repplyPermission(Permission permission) async {
  final status = await permission.request();
  if (status.isGranted) {
    // 权限或者已经被授予，或者用户刚刚授予
    return true;
  } else {
    // 如果弹框不在出现了，那就跳转到设置页。
    if (await permission.status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      // 被拒绝再次申请
      repplyPermission(permission);
    }
    return false;
  }
}
