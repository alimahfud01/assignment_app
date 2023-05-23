import 'package:assignment_app/bottom_bar.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';

class PageC extends StatefulWidget {
  const PageC({super.key});

  @override
  State<PageC> createState() => _PageCState();
}

class _PageCState extends State<PageC> {
  final List<List<double>?> _data = data['accelerometer'];

  @override
  Widget build(BuildContext context) {
    debugPrint(_data.elementAt(1)?.length.toString());
    List<Feature> features = [
      Feature(
        title: "Accelerometer X",
        color: Colors.blue,
        data: _data.elementAt(0) ?? [0, 0],
      ),
      Feature(
        title: "Accelerometer Y",
        color: Colors.pink,
        data: _data.elementAt(1) ?? [0, 0],
      ),
      Feature(
        title: "Accelerometer Z",
        color: Colors.green,
        data: _data.elementAt(2) ?? [0, 0],
      ),
    ];
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Page C'),
          ),
          body: Center(
            child: LineGraph(
              features: features,
              size: const Size(320, 400),
              labelX: const ['1', '2', '3', '4', '5'],
              labelY: const ['20%', '40%', '60%', '80%', '100%'],
              showDescription: true,
              graphColor: Colors.white30,
              graphOpacity: 0.2,
              verticalFeatureDirection: true,
              descriptionHeight: 130,
            ),
          )),
    );
  }
}
