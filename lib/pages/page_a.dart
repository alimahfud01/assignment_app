import 'dart:async';
import 'package:assignment_app/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';

class PageA extends StatefulWidget {
  const PageA({super.key});

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  //time
  late Timer _timer1;
  late Timer _timer2;
  late dynamic accelerometer;
  late dynamic gyroscope;
  late dynamic magnetometer;

  void _update() {
    setState(() {
      formattedTime = DateFormat('kk:mm').format(DateTime.now());
    });
  }

  //battery
  var battery = Battery();
  int percentage = 0;

  void getBatteryPerentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  //sensor
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<double>? _accelerometerX;
  List<double>? _accelerometerY;
  List<double>? _accelerometerZ;

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    longlatSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    //time
    _timer1 =
        Timer.periodic(Duration(seconds: data['refresh_rate'] ?? 1), (timer) {
      _update();
      getBatteryPerentage();
      data['accelerometer'] = [
        _accelerometerX,
        _accelerometerY,
        _accelerometerZ
      ];
    });
    //long lat
    checkGps();

    //sensor
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
          _accelerometerX?.add(event.x.toDouble());
          _accelerometerY?.add(event.y.toDouble());
          _accelerometerZ?.add(event.z.toDouble());
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          _magnetometerValues = <double>[event.x, event.y, event.z];
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }

  //long lat
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> longlatSubscription;

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    debugPrint(servicestatus.toString());
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
              msg: "Permission denied", gravity: ToastGravity.BOTTOM);
        } else if (permission == LocationPermission.deniedForever) {
          Fluttertoast.showToast(
              msg: "Permission blocked", gravity: ToastGravity.BOTTOM);
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please turn on location", gravity: ToastGravity.BOTTOM);
    }
    setState(() {});
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {});

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    debugPrint("acc length ${accelerometer?.length}");
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page A"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  children: [
                    Text(formattedTime),
                    Text(DateFormat('MMM dd, yyyy').format(DateTime.now())),
                  ],
                ),
                Column(
                  children: [
                    const Text('Battery'),
                    Text("${percentage.toString()}%")
                  ],
                )
              ]),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Accelerometer : "),
                            Text(accelerometer.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Gyroscope        : "),
                            Text(gyroscope.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Magnetometer : "),
                            Text(magnetometer.toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (haspermission)
                          Column(
                            children: [
                              Row(children: [
                                const Text("Latitude : "),
                                Text(lat.toString())
                              ]),
                              Row(children: [
                                const Text("Longitude : "),
                                Text(long.toString())
                              ])
                            ],
                          )
                        else
                          const Text(
                            "Please Enable Location",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
