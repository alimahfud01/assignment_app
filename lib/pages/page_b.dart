import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PageB extends StatefulWidget {
  const PageB({super.key});

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
      'version.sdkInt': build.version.sdkInt,
      'version.codename': build.version.codename,
      'hardware': build.hardware,
      'version.release': build.version.release,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'systemVersion': data.systemVersion,
      'model': data.model,
      'identifierForVendor': data.identifierForVendor,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Page B'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      if (_controller.text.isNotEmpty)
                        QrImageView(
                          data: _controller.text,
                          version: QrVersions.auto,
                          size: 220,
                          gapless: false,
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Input Text",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text('Generate QR')),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: _deviceData.keys.map(
                      (String property) {
                        return Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                property,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 10.0, 0.0, 10.0),
                              child: Text(
                                '${_deviceData[property]}',
                                maxLines: _deviceData.length,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
