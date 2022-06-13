/// Horizontal bar chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/models/student_side_charData_Response.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class HorizontalBarChartStudent extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  HorizontalBarChartStudent(this.seriesList, {this.animate = false});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChartStudent.withSampleData(List<Exams> exams) {
    return HorizontalBarChartStudent(
      _createSampleData(exams),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  // factory HorizontalBarChart.withRandomData() {
  //   return HorizontalBarChart(_createRandomData());
  // }

  // /// Create random data.
  // static List<charts.Series<OrdinalSales, String>> _createRandomData() {
  //   final random = new Random();
  //
  //   final data = [
  //      OrdinalSales('2014', random.nextInt(100)),
  //      OrdinalSales('2015', random.nextInt(100)),
  //      OrdinalSales('2016', random.nextInt(100)),
  //      OrdinalSales('2017', random.nextInt(100)),
  //   ];
  //
  //   return [
  //      charts.Series<OrdinalSales, String>(
  //       id: 'Sales',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: data,
  //     )
  //   ];
  // }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      // /// Assign a custom style for the measure axis.
      // ///
      // /// The NoneRenderSpec can still draw an axis line with
      // /// showAxisLine=true.
      // primaryMeasureAxis:
      //  const charts.NumericAxisSpec(renderSpec:  charts.NoneRenderSpec()),

      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis:  const charts.OrdinalAxisSpec(
        // Make sure that we draw the domain axis line.
          showAxisLine: true,
          // But don't draw anything else.
          renderSpec:  charts.NoneRenderSpec()),

      // primaryMeasureAxis: const charts.NumericAxisSpec(
      //   tickProviderSpec: charts.StaticNumericTickProviderSpec(
      //     <charts.TickSpec<num>>[
      //       charts.TickSpec<num>(0),
      //       charts.TickSpec<num>(20),
      //       charts.TickSpec<num>(40),
      //       charts.TickSpec<num>(60),
      //       charts.TickSpec<num>(80),
      //       charts.TickSpec<num>(100),
      //       charts.TickSpec<num>(120),
      //       charts.TickSpec<num>(140),
      //     ],
      //   ),
      // ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalData, String>> _createSampleData(List<Exams> exams) {
    final data = [
      exams.isNotEmpty ? OrdinalData("smile".tr(), exams[0].count ?? 0) : OrdinalData("smile".tr(),0),
      exams.length > 1 ?  OrdinalData('bow'.tr(), exams[1].count ?? 0) : OrdinalData("bow".tr(), 0),
      exams.length > 2 ?  OrdinalData('greet'.tr(), exams[2].count ?? 0) : OrdinalData("greet".tr(),0),
      exams.length > 3 ?  OrdinalData('life_vest'.tr(), exams[3].count ?? 0) : OrdinalData("life_vest".tr(),  0),
      exams.length > 4 ?  OrdinalData('oxygen_mask'.tr(), exams[4].count ?? 0) : OrdinalData("oxygen_mask".tr(),  0),
      exams.length > 5 ?  OrdinalData('seat_belt'.tr(), exams[5].count ?? 0) : OrdinalData("seat_belt".tr(),  0),
      exams.length > 6 ?   OrdinalData('em_exit'.tr(), exams[6].count ?? 0) : OrdinalData("em_exit".tr(),  0),
      exams.length > 7 ?  OrdinalData('safety_note'.tr(), exams[7].count ?? 0) : OrdinalData("safety_note".tr(),  0)
    ];

    return [
      charts.Series<OrdinalData, String>(
        colorFn: (_, __) => charts.Color.fromHex(code: '#6F6C99'),
        id: 'Sales',
        domainFn: (OrdinalData sales, _) => sales.feature,
        measureFn: (OrdinalData sales, _) => sales.score,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalData {
  final String feature;
  final int score;

  OrdinalData(this.feature, this.score);
}