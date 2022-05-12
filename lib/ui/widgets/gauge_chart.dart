import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeChart extends StatelessWidget {
  const GaugeChart({required this.key, required this.valueToPoint, required this.lightTheme}) : super(key: key);
  final double valueToPoint;
  final bool lightTheme;
  @override
  // ignore: overridden_fields
  final Key key;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(enableLoadingAnimation: true, animationDuration: 1500, axes: <RadialAxis>[
      RadialAxis(
        labelOffset: 9,
        labelsPosition: ElementsPosition.outside,
        showAxisLine: false,
        showTicks: false,
        minimum: 10,
        maximum: 45,
        axisLabelStyle: GaugeTextStyle(
            color: lightTheme ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
        pointers: <GaugePointer>[
          NeedlePointer(
            needleLength: 0.75,
            needleColor: Colors.black,
            knobStyle: const KnobStyle(
              color: Colors.black,
            ),
            value: valueToPoint,
          ),
        ],
        ranges: <GaugeRange>[
          GaugeRange(
              startValue: 0,
              endValue: 18.5,
              color: Colors.red,
              label: 'Underweight',
              labelStyle: const GaugeTextStyle(
                fontFamily: 'Times',
                fontSize: 14,
              ),
              startWidth: 0.3,
              endWidth: 0.3,
              sizeUnit: GaugeSizeUnit.factor),
          GaugeRange(
            startValue: 18.5,
            endValue: 25,
            color: Colors.green,
            label: 'Normal',
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 17.5),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.3,
            endWidth: 0.3,
          ),
          GaugeRange(
            startValue: 25,
            endValue: 30,
            color: Colors.yellowAccent,
            label: 'Overweight',
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 10),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.3,
            endWidth: 0.3,
          ),
          GaugeRange(
            startValue: 30,
            endValue: 35,
            color: Colors.orange,
            label: 'Obese',
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 14),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.3,
            endWidth: 0.3,
          ),
          GaugeRange(
            startValue: 35,
            endValue: 40,
            color: Colors.redAccent,
            label: 'Severely\nObese',
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 13),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.3,
            endWidth: 0.3,
          ),
          GaugeRange(
            startValue: 40,
            endValue: 45,
            color: Colors.purpleAccent,
            label: 'Morbidly\nObese',
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 14),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.3,
            endWidth: 0.3,
          ),
        ],
      )
    ]);
  }
}
