import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/allProducts.dart';
import 'package:food_ordering_app/screens/searchedProducts.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  var startValue;
  var endValue;
  //RangeValues values = RangeValues(1, 100);
  //RangeLabels labels = RangeLabels('1', "100");
  SfRangeValues _values = const SfRangeValues(1, 1000);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set Price',
              style: TextStyle(fontFamily: 'Sofia'),
            ),
            SfRangeSlider(
              // stepSize: 1,
              values: _values,
              min: 0,
              max: 1000,
              // stepSize: 10,
              interval: 200,
              showLabels: true,
              showTicks: true,
              labelPlacement: LabelPlacement.onTicks,
              onChanged: (value) {
                setState(
                  () {
                    startValue = value.start;
                    endValue = value.end;
                    _values = value;
                    print(startValue);
                  },
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FilterProduct(startValue, endValue),
                  ));
                },
                height: 40,
                color: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'SEARCH',
                    style: TextStyle(
                        fontFamily: 'Sofia',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )),
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
      ),
    );
  }
}
