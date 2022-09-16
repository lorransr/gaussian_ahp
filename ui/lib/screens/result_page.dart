import 'dart:convert';

import 'package:gaussian_ahp_method/helpers/example_helper.dart';
import 'package:gaussian_ahp_method/helpers/table_helper.dart';
import 'package:gaussian_ahp_method/model/ahp_input.dart';
import 'package:gaussian_ahp_method/model/shortest_distance.dart';
import 'package:gaussian_ahp_method/provider/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:gaussian_ahp_method/bloc/results_bloc.dart';
import 'package:gaussian_ahp_method/model/model_results.dart';
import 'package:gaussian_ahp_method/screens/home_page.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/results';
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ScrollController _controller;
  var _pdfProvider = PDFProvider();
  var _tableHelper = TableHelper();
  @override
  Widget build(BuildContext context) {
    _controller = ScrollController();
    AhpInput? _input = ModalRoute.of(context)?.settings.arguments as AhpInput?;
    if (_input != null) {
      print("received inputs: $_input");
    } else {
      print("empty arguments; generating inputs...");
      _input = ExampleHelper().ahpExample();
    }
    print("input: ${jsonEncode(_input)}");
    resultsBloc.getRanking(_input);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                child: StreamBuilder<ModelResults>(
                  stream: resultsBloc.subject.stream,
                  builder: (context, AsyncSnapshot<ModelResults> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.error != null &&
                          snapshot.data!.error.length > 0) {
                        return _buildErrorWidget(snapshot.data!.error);
                      }
                      return _buildSuccessWidget(snapshot.data!, _input!);
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error.toString());
                    } else {
                      return _buildLoadingWidget();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading data from API..."),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      ),
    );
  }

  Widget _developmentAttributesTile(ModelResults data) {
    print("data: ${data.results.toJson()}");

    return
        //  Text("data: ${data.results.toJson()}");
        ListTile(
      title: Text(
        "✨ Alternatives Ranking ✨",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: DataTable(
            sortAscending: true,
            sortColumnIndex: 0,
            columns: [
              DataColumn(label: Text("Ranking")),
              DataColumn(label: Text("Alternative")),
              DataColumn(label: Text("Value"))
            ],
            rows: _getRowsFromResults(data.results.ranking),
          ),
        ),
      ),
    );
  }

  Widget _simpleMatrixTile(Map<String, dynamic> simpleMatrix) {
    /* given a series {key,value} return a wide table */
    List<DataColumn> _cols = [];
    List<DataRow> _rows = [];
    List<DataCell> _cells = [];
    simpleMatrix.keys.forEach((column) {
      _cols.add(DataColumn(label: Text(column)));
      _cells.add(DataCell(Text(simpleMatrix[column].toStringAsFixed(3))));
    });
    _rows.add(DataRow(cells: _cells));
    return DataTable(columns: _cols, rows: _rows);
  }

  Widget _seriesTile(Map<String, dynamic> series, String seriesName) {
    /* given a series {key,value} return a long table */
    List<DataRow> _rows = [];
    List<DataColumn> _cols = [
      DataColumn(
        label: Text(seriesName),
      ),
      DataColumn(
        label: Text("Values"),
      )
    ];
    series.forEach((key, value) {
      _rows.add(
        DataRow(cells: [
          DataCell(
            Text(key),
          ),
          DataCell(
            Text(
              value.toStringAsFixed(3),
            ),
          )
        ]),
      );
    });
    return DataTable(columns: _cols, rows: _rows);
  }

  Widget _matrixTile(Map<String, dynamic> matrix,
      {List<String>? alternatives}) {
    print("Matrix: ${matrix.entries}");
    List<DataColumn> _cols = [];
    _cols.add(DataColumn(label: Text("Alternative")));
    matrix.keys.forEach(
      (element) {
        _cols.add(
          DataColumn(label: Text(element)),
        );
      },
    );
    List<DataRow> _rows = [];
    int idx = 0;
    alternatives?.forEach((a) {
      List<DataCell> _cells = [];
      var _alternativeCell = DataCell(Text(a));
      _cells.add(_alternativeCell);
      matrix.keys.forEach((key) {
        print(matrix[key]);
        var _cell = DataCell(Text(matrix[key][a].toStringAsFixed(3)));
        _cells.add(_cell);
      });
      idx += 1;
      _rows.add(DataRow(cells: _cells));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _cols,
        rows: _rows,
      ),
    );
  }

  Widget _relativeAssessmentMatrixTile(Map<String, dynamic> matrix) {
    List<DataColumn> _cols = [];
    print(matrix);
    _cols.add(DataColumn(label: Text("")));
    _cols.addAll(matrix.keys.map((e) => DataColumn(label: Text(e))));
    List<DataRow> _rows = [];
    matrix.forEach((k, v) {
      List<DataCell> _cells = [];
      _cells.add(DataCell(Text(k)));
      v.forEach(
        (key, value) {
          _cells.add(
            DataCell(
              Text(
                value.toStringAsFixed(3),
              ),
            ),
          );
        },
      );
      _rows.add(DataRow(cells: _cells));
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _cols,
        rows: _rows,
      ),
    );
  }

  Widget _distanceTile(
      Map<String, dynamic> vector, List<String> alternatives, String distance) {
    List<DataColumn> _cols = [
      DataColumn(label: Text("Alternatives")),
      DataColumn(label: Text(distance))
    ];
    List<DataRow> _rows = [];
    int maxLen = vector.length;
    print("maxLen: ${maxLen}");
    vector.forEach((_alternative, _value) {
      List<DataCell> _cells = [];
      print(_alternative);
      print(_value);
      _cells.add(DataCell(Text(_alternative)));
      _cells.add(DataCell(Text(_value.toStringAsFixed(3))));
      _rows.add(DataRow(cells: _cells));
    });
    return DataTable(
      columns: _cols,
      rows: _rows,
    );
  }

  DataTable _avgDistanceTile(ShortestDistance shortestDistance) {
    return DataTable(
      columns: [
        DataColumn(label: Text("Avg Distance")),
        DataColumn(label: Text("Std Distance"))
      ],
      rows: [
        DataRow(cells: [
          DataCell(
            Text("${shortestDistance.mean.toStringAsFixed(3)}"),
          ),
          DataCell(
            Text("${shortestDistance.std.toStringAsFixed(3)}"),
          ),
        ])
      ],
    );
  }

  DataTable _acceptedRangeTile(List<double> acceptedRange) {
    return DataTable(
      columns: [
        DataColumn(label: Text("Arithmetic Mean")),
        DataColumn(label: Text("Harmonic Mean"))
      ],
      rows: [
        DataRow(cells: [
          DataCell(
            Text("${acceptedRange[0].toStringAsFixed(3)}"),
          ),
          DataCell(
            Text("${acceptedRange[1].toStringAsFixed(3)}"),
          ),
        ])
      ],
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('All current analysis would be lost'),
                Text("Do you want to proceed?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pushNamed(context, HomePage.routeName);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuccessWidget(ModelResults data, AhpInput input) {
    List<String> _alternatives = _tableHelper.getAlternatives(data);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _developmentAttributesTile(data),
          Divider(),
          Text(
            "Method Outputs",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 32,
          ),
          ListTile(
            title: Text(
              "Normalized Decision Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                child: _matrixTile(data.results.normalizedDecisionMatrix,
                    alternatives: _alternatives),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Gaussian Factor (RENAME)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _simpleMatrixTile(data.results.gaussianFactor)),
            ),
          ),
          ListTile(
            title: Text(
              "Gaussian Factor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _seriesTile(
                      data.results.normalizedGaussianFactor, "Alternatives")),
            ),
          ),
          ListTile(
            title: Text(
              "Weighted Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _matrixTile(data.results.weightedDecisionmatrix,
                      alternatives: _alternatives)),
            ),
          ),
          ListTile(
            title: Text(
              "Weighted Sum",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _seriesTile(data.results.weightedSum, "Alternatives")),
            ),
          ),
          _showCorrelationTiles(input, data, _alternatives),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () => _pdfProvider.createPDF(data),
                    child: Text("Print Results")),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () => _showAlertDialog(),
                    child: Text("Start Again")),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _showCorrelationTiles(
      AhpInput input, ModelResults data, List<String> alternatives) {
    if (input.pearsonCorrelation) {
      return Column(
        children: [
          ListTile(
            title: Text(
              "Correlation Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _matrixTile(data.results.correlationMatrix!,
                      alternatives:
                          data.results.correlationMatrix!.keys.toList())),
            ),
          ),
          ListTile(
            title: Text(
              "Correlation Factor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _seriesTile(
                      data.results.correlationFactor!, "Alternatives")),
            ),
          ),
          ListTile(
            title: Text(
              "Normalized Correlation Factor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _seriesTile(data.results.normalizedCorrelationFactor!,
                      "Alternatives")),
            ),
          ),
        ],
      );
    } else {
      return ListTile();
    }
  }

  List<DataRow> _getRowsFromResults(Map<String, dynamic> results) {
    List<DataRow> _dataRows = [];
    int ranking = 1;
    results.forEach((key, value) {
      var _value = value.toStringAsFixed(3);
      var _row = DataRow(
        cells: [
          DataCell(
            Text(
              ranking.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataCell(
            Text(key),
          ),
          DataCell(
            Text(_value),
          ),
        ],
      );
      _dataRows.add(_row);
      ranking += 1;
    });
    return _dataRows.toList();
  }
}
