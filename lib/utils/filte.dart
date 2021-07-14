import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues values = RangeValues(1, 100);
  RangeLabels labels = RangeLabels('1', "100");
  SfRangeValues _values = const SfRangeValues(1, 100);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SfTheme(
            data: SfThemeData(
              rangeSliderThemeData: SfRangeSliderThemeData(
                activeLabelStyle:
                    TextStyle(fontFamily: 'Sofia', color: Colors.black),
                inactiveLabelStyle:
                    TextStyle(fontFamily: 'Sofia', color: Colors.black),
              ),
            ),
            child: SfRangeSlider(
                // stepSize: 1,
                values: _values,
                min: 0,
                max: 100,
                // stepSize: 10,
                interval: 20,
                showLabels: true,
                showTicks: true,
                onChanged: (dynamic values) {
                  setState(() {
                    _values = values;
                  });
                }),
          )
          // RangeSlider(
          //   divisions: 5,

          //   activeColor: Colors.green,
          //   inactiveColor: Colors.yellow,
          //   labels: labels,
          //   values: values,
          //   min: 1,
          //   max: 100,
          //   onChanged: (value) {
          //     setState(() {
          //       values = value;
          //       labels = RangeLabels("${value.start.toInt().toString()}\$",
          //           "${value.start.toInt().toString()}\$");
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
