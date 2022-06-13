// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Vertical bar chart with bar label renderer example.
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';

// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:ai_score/constants/string_constants.dart';
import 'package:ai_score/models/student_side_charData_Response.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class VerticalBarLabelChartStudent extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  VerticalBarLabelChartStudent(this.seriesList, {this.animate = false});

  /// Creates a [BarChart] with sample data and no transition.
  factory VerticalBarLabelChartStudent.withSampleData(List<Scores> score, bool ai, bool totalTeacher, bool total) {
    return VerticalBarLabelChartStudent(
      _createSampleData(score, ai ,totalTeacher, total),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  // factory VerticalBarLabelChart.withRandomData() {
  //   return new VerticalBarLabelChart(_createRandomData());
  // }
  //
  // /// Create random data.
  // static List<charts.Series<OrdinalSales, String>> _createRandomData() {
  //   final random = new Random();
  //
  //   final data = [
  //     new OrdinalSales('2014', random.nextInt(100)),
  //     new OrdinalSales('2015', random.nextInt(100)),
  //     new OrdinalSales('2016', random.nextInt(100)),
  //     new OrdinalSales('2017', random.nextInt(100)),
  //   ];
  //
  //   return [
  //     new charts.Series<OrdinalSales, String>(
  //         id: 'Sales',
  //         domainFn: (OrdinalSales sales, _) => sales.year,
  //         measureFn: (OrdinalSales sales, _) => sales.sales,
  //         data: data,
  //         // Set a label accessor to control the text of the bar label.
  //         labelAccessorFn: (OrdinalSales sales, _) =>
  //         '${sales.sales.toString()}')
  //   ];
  // }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit,
  // it will draw outside of the bar.
  // Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      /*  barRendererDecorator: charts.BarLabelDecorator(
               insideLabelStyleSpec: const charts.TextStyleSpec(),
                outsideLabelStyleSpec: const charts.TextStyleSpec()),*/
      // barRendererDecorator:  charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(),

      /// Assign a custom style for the measure axis.
      ///
      /// The NoneRenderSpec can still draw an axis line with
      /// showAxisLine=true.
      // primaryMeasureAxis:
      //     const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),

      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(20),
            charts.TickSpec<num>(40),
            charts.TickSpec<num>(60),
            charts.TickSpec<num>(80),
            charts.TickSpec<num>(100),

          ],
        ),
      ),


      // This is an OrdinalAxisSpec to match up with BarChart's default
      // ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      // other charts).
      //  domainAxis:  const charts.OrdinalAxisSpec(
      //    Make sure that we draw the domain axis line.
      //     showAxisLine: true,
      //      // But don't draw anything else.
      //     renderSpec:  charts.NoneRenderSpec()),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalData, String>> _createSampleData(
      List<Scores> score, bool ai, bool totalTeacher, bool total) {
    // for(int i = 0 ; i < score.length ; i++){
    //   final data = [
    //
    //   ];
    // }
    final aiDataStartYear = [
      OrdinalData(StringConstants.monthsList[score[0].month!-1], score[0].totalAIScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[1].month!-1], score[1].totalAIScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[2].month!-1], score[2].totalAIScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[3].month!-1], score[3].totalAIScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[4].month!-1], score[4].totalAIScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[5].month!-1], score[5].totalAIScore?.toInt() ?? 0)
      // score.isNotEmpty ? OrdinalData('Jan', score[0].totalAIScore?.toInt() ?? 0) : OrdinalData('Jan', 0),
      // score.length > 1 ? OrdinalData('Feb', score[1].totalAIScore?.toInt() ?? 0) : OrdinalData('Feb', 0),
      // score.length > 2 ? OrdinalData('Mar', score[2].totalAIScore?.toInt() ?? 0) : OrdinalData('Mar', 0),
      // score.length > 3
      //     ? OrdinalData('Apr', score[3].totalAIScore?.toInt() ?? 0)
      //     : OrdinalData('Apr', 0),
      // score.length > 4
      //     ? OrdinalData('May', score[4].totalAIScore?.toInt() ?? 0)
      //     : OrdinalData('May', 0),
      // score.length > 5
      //     ? OrdinalData('Jun', score[5].totalAIScore?.toInt() ?? 0)
      //     : OrdinalData('Jun', 0),
    ];

    final aiDataEndYear = [
      score.length > 6
          ? OrdinalData('Jul', score[6].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Jul', 0),
      score.length > 7
          ? OrdinalData('Aug', score[7].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Aug', 0),
      score.length > 8
          ? OrdinalData('Sep', score[8].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Sep', 0),
      score.length > 9
          ? OrdinalData('Oct', score[9].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Oct', 0),
      score.length > 10
          ? OrdinalData('Nov', score[10].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Nov', 0),
      score.length > 11
          ? OrdinalData('Dec', score[11].totalAIScore?.toInt() ?? 0)
          : OrdinalData('Dec', 0),
    ];

    final teacherScoreDataStartYear = [
      // score.isNotEmpty ? OrdinalData('Jan', score[0].totalTeacherScore?.toInt() ?? 0) : OrdinalData('Jan', 0),
      // score.length > 1 ? OrdinalData('Feb', score[1].totalTeacherScore?.toInt() ?? 0) : OrdinalData('Feb', 0),
      // score.length > 2 ? OrdinalData('Mar', score[2].totalTeacherScore?.toInt() ?? 0) : OrdinalData('Mar', 0),
      // score.length > 3
      //     ? OrdinalData('Apr', score[3].totalTeacherScore?.toInt() ?? 0)
      //     : OrdinalData('Apr', 0),
      // score.length > 4
      //     ? OrdinalData('May', score[4].totalTeacherScore?.toInt() ?? 0)
      //     : OrdinalData('May', 0),
      // score.length > 5
      //     ? OrdinalData('Jun', score[5].totalTeacherScore?.toInt() ?? 0)
      //     : OrdinalData('Jun', 0),
      OrdinalData(StringConstants.monthsList[score[0].month!-1], score[0].totalTeacherScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[1].month!-1], score[1].totalTeacherScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[2].month!-1], score[2].totalTeacherScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[3].month!-1], score[3].totalTeacherScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[4].month!-1], score[4].totalTeacherScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[5].month!-1], score[5].totalTeacherScore?.toInt() ?? 0)
    ];

    final teacherScoreDataEndYear = [
      score.length > 6
          ? OrdinalData('Jul', score[6].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Jul', 0),
      score.length > 7
          ? OrdinalData('Aug', score[7].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Aug', 0),
      score.length > 8
          ? OrdinalData('Sep', score[8].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Sep', 0),
      score.length > 9
          ? OrdinalData('Oct', score[9].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Oct', 0),
      score.length > 10
          ? OrdinalData('Nov', score[10].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Nov', 0),
      score.length > 11
          ? OrdinalData('Dec', score[11].totalTeacherScore?.toInt() ?? 0)
          : OrdinalData('Dec', 0),
    ];



    final totalScoreDataStartYear = [
      // score.isNotEmpty ? OrdinalData('Jan', score[0].totalScore?.toInt() ?? 0) : OrdinalData('Jan', 0),
      // score.length > 1 ? OrdinalData('Feb', score[1].totalScore?.toInt() ?? 0) : OrdinalData('Feb', 0),
      // score.length > 2 ? OrdinalData('Mar', score[2].totalScore?.toInt() ?? 0) : OrdinalData('Mar', 0),
      // score.length > 3
      //     ? OrdinalData('Apr', score[3].totalScore?.toInt() ?? 0)
      //     : OrdinalData('Apr', 0),
      // score.length > 4
      //     ? OrdinalData('May', score[4].totalScore?.toInt() ?? 0)
      //     : OrdinalData('May', 0),
      // score.length > 5
      //     ? OrdinalData('Jun', score[5].totalScore?.toInt() ?? 0)
      //     : OrdinalData('Jun', 0),
      OrdinalData(StringConstants.monthsList[score[0].month!-1], score[0].totalScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[1].month!-1], score[1].totalScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[2].month!-1], score[2].totalScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[3].month!-1], score[3].totalScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[4].month!-1], score[4].totalScore?.toInt() ?? 0),
      OrdinalData(StringConstants.monthsList[score[5].month!-1], score[5].totalScore?.toInt() ?? 0)
    ];

    final totalScoreDataEndYear = [
      score.length > 6
          ? OrdinalData('Jul', score[6].totalScore?.toInt() ?? 0)
          : OrdinalData('Jul', 0),
      score.length > 7
          ? OrdinalData('Aug', score[7].totalScore?.toInt() ?? 0)
          : OrdinalData('Aug', 0),
      score.length > 8
          ? OrdinalData('Sep', score[8].totalScore?.toInt() ?? 0)
          : OrdinalData('Sep', 0),
      score.length > 9
          ? OrdinalData('Oct', score[9].totalScore?.toInt() ?? 0)
          : OrdinalData('Oct', 0),
      score.length > 10
          ? OrdinalData('Nov', score[10].totalScore?.toInt() ?? 0)
          : OrdinalData('Nov', 0),
      score.length > 11
          ? OrdinalData('Dec', score[11].totalScore?.toInt() ?? 0)
          : OrdinalData('Dec', 0),
    ];

    return [
      charts.Series<OrdinalData, String>(
        colorFn: (_, __) => charts.Color.fromHex(code: '#855CF8'),
        id: 'Sales',
        domainFn: (OrdinalData sales, _) => sales.month,
        measureFn: (OrdinalData sales, _) => sales.score,
        data: ai == true ? aiDataStartYear : (totalTeacher == true ? teacherScoreDataStartYear : totalScoreDataStartYear),
        //score.length > 6 ? ai == true ? aiDataEndYear : (totalTeacher == true ? teacherScoreDataEndYear : totalScoreDataEndYear) :  ai == true ? aiDataStartYear : (totalTeacher == true ? teacherScoreDataStartYear : totalScoreDataStartYear),
        // Set a label accessor to control the text of the bar label.
        /*  *//*labelAccessorFn: (OrdinalData sales, _) =>
         '\$${s*//*ales.score.toString()}'*/
      )
    ];
  }

}

/// Sample ordinal data type.
class OrdinalData {
  final String month;
  final int score;


  OrdinalData(this.month, this.score);
}
