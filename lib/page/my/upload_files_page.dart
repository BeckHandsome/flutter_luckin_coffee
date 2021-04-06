import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/widget/widget_video_player_small.dart';
import 'package:flutter_luckin_coffee/widget/widget_photo_view.dart';

class UploadFilesPage extends StatefulWidget {
  UploadFilesPage({Key key}) : super(key: key);
  @override
  _UploadFilesPageState createState() => _UploadFilesPageState();
}

class _UploadFilesPageState extends State<UploadFilesPage> {
  Map _mapData = {};
  List _listData = [];
  @override
  void initState() {
    super.initState();
    _getUploadFileList();
  }

  Future<FormData> _formData(path, name) async {
    return FormData.fromMap({
      "upfile": await MultipartFile.fromFile(
        path,
        filename: name,
      ),
    });
  }

  // 获取上传文件列表
  _getUploadFileList() {
    Api.uploadFileList(successCallBack: (res) {
      _mapData = res['data'];
      _listData = res['data']['oSSObjectSummaryList'] ?? [];
      setState(() {});
    });
  }

  // 获取所有图片用于预览
  List _getPhoto(List item, url) {
    List _item = [];
    item.forEach((element) {
      String _type = element['key'] != null ? element['key'].substring(element['key'].lastIndexOf('.') + 1, element['key'].length) : '';
      if (['bmp', 'jpg', 'png', 'tif', 'gif', 'svg', 'psd', 'webp'].contains(_type)) {
        _item.add(url + '/' + element['key']);
      }
    });
    return _item;
  }

// 根据类型返回不同Widget
  Widget _getFlieType(String key, String url, BuildContext context) {
    String _type = key != null ? key.substring(key.lastIndexOf('.') + 1, key.length) : '';
    if (['bmp', 'jpg', 'png', 'tif', 'gif', 'svg', 'psd', 'webp'].contains(_type)) {
      return InkWell(
        onTap: () {
          NavigatorUtil.navigateTo(
            context,
            PageRouter.widgetPhotoView,
            params: {'dataList': _getPhoto(_listData, url), 'current': url + '/' + key},
          );
        },
        child: Image.network(
          url + '/' + key,
          fit: BoxFit.cover,
        ),
      );
    } else if (['mp4', '3gp', 'avi', 'flv', 'rmvb', 'wmv'].contains(_type)) {
      return WidgetVideoPlayerSmall(
        url: url + '/' + key,
      );
    } else {
      return Image.asset('lib/assets/images/logo.png');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上传图片和视频'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _listData.length == 0
              ? Text('')
              : Padding(
                  padding: EdgeInsets.all(5),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 10,
                    direction: Axis.horizontal,
                    children: _listData.map(
                      (e) {
                        return SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: _getFlieType(e['key'].toString(), _mapData['baseUrl'].toString(), context),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.6),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
          Padding(
            padding: EdgeInsets.all(20),
            child: DottedBorder(
              dashPattern: [5, 5],
              customPath: (size) {
                Path customPath = Path()
                  ..moveTo(80, 80)
                  ..lineTo(0, 80)
                  ..lineTo(0, 0)
                  ..lineTo(80, 0)
                  ..lineTo(80, 80);
                return customPath;
              },
              color: Colors.grey[400],
              child: InkWell(
                onTap: () async {
                  await FilePicker.getFile(type: FileType.any).then(
                    (file) async {
                      String path = file.path;
                      String name = path.substring(path.lastIndexOf("/") + 1, path.length);
                      FormData _formDatas = await _formData(
                        path,
                        name,
                      );
                      EasyLoading.show(status: '上传中...');
                      Api.uploadFile(
                        formData: _formDatas,
                        successCallBack: (res) {
                          EasyLoading.showToast('$res');
                          EasyLoading.dismiss();
                          _getUploadFileList();
                        },
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: Text('点击上传'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
