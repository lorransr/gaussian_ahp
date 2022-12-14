import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaussian_ahp_method/model/ahp_input.dart';
import 'package:gaussian_ahp_method/model/criteria.dart';
import 'package:gaussian_ahp_method/model/criteria_type.dart';
import 'package:gaussian_ahp_method/screens/result_page.dart';

class MatrixPage extends StatefulWidget {
  static const routeName = '/matrix';
  MatrixPage({Key? key}) : super(key: key);

  @override
  _MatrixPageState createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  /// Create a Key for EditableState
  final _tableKey = GlobalKey();
  bool isWithPearsonCorrelation = false;

  List<Criteria> _criterias = [];
  List<DataColumn> _cols = [];
  List<DataRow> _rows = [];
  ScrollController _scrollcontroller = ScrollController();

  /// Function to add a new row
  /// Using the global key assigined to Editable widget
  /// Access the current state of Editable
  void _addNewRow() {
    setState(() {
      _rows.add(DataRow(cells: _createEmptyCells(_cols.length)));
    });
  }

  void _removeRow() {
    setState(() {
      _rows.removeLast();
    });
  }

  DataCell _emptyNumberCell() {
    final controller = TextEditingController(text: "0.0");
    return DataCell(
        TextFormField(
          controller: controller,
          showCursor: false,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
          ],
          onFieldSubmitted: (val) {
          },
          validator: (val) {
            if (val!.isEmpty) {
              return "Insert data";
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        showEditIcon: false);
  }

  DataCell _emptyTextCell() {
    var n_row = _rows.length;
    final controller = TextEditingController(text: "alternative_$n_row");
    return DataCell(
        TextFormField(
          controller: controller,
          showCursor: false,
          keyboardType: TextInputType.text,
          onFieldSubmitted: (val) {
          },
          validator: (val) {
            if (val!.isEmpty) {
              return "Name the alternative";
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        showEditIcon: false);
  }

  List<DataCell> _createEmptyCells(int n) {
    int idx = 0;
    List<DataCell> cells = [];
    while (idx < n) {
      if (idx == 0) {
        cells.add(_emptyTextCell());
      } else {
        cells.add(_emptyNumberCell());
      }
      idx++;
    }
    return cells;
  }

  List<List<double>> _getAlternatives() {
    List<List<double>> alternatives = [];
    for (DataRow row in _rows) {
      List<double> alternative = [];
      var idx = 0;
      row.cells.forEach((cell) {
        if (idx > 0) {
          TextFormField form = cell.child as TextFormField;
          alternative.add(double.parse(form.controller!.text));
          idx += 1;
        } else {
          idx += 1;
        }
      });
      alternatives.add(alternative);
    }
    return alternatives;
  }

  List<String> _getAlternativesNames() {
    List<String> alternativesNames = [];
    _rows.forEach((row) {
      DataCell cell = row.cells.first;
      TextFormField form = cell.child as TextFormField;
      alternativesNames.add(form.controller!.text);
    });
    return alternativesNames;
  }

  bool _validAlternatives(List<List<double>> _alternatives) {
    print("Alternatives: ${_alternatives}");
    if (_alternatives.length < 2) {
      print("Invalid alternatives length: ${_alternatives.length}");
      return false;
    } else {
      print("valid alternatives length: ${_alternatives.length}");
      return true;
    }
  }

  void _snackValidationError(String message) {
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[200],
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _submit(List<Criteria> criterias,bool isWithPearsonCorrelation) {
    List<List<double>> alternatives = _getAlternatives();
    List<String> alternativesNames = _getAlternativesNames();
    if (_validAlternatives(alternatives)) {
      AhpInput input = AhpInput(
          criterias: criterias,
          alternativesNames: alternativesNames,
          pearsonCorrelation: isWithPearsonCorrelation,
          vars: alternatives);
      Navigator.pushNamed(context, ResultPage.routeName, arguments: input);
    } else {
      _snackValidationError("You must input at least 2 alternatives");
    }
  }

  List<DataColumn> _createCols(List<Criteria> criterias) {
    List<DataColumn> columns = [];
    columns.add(
      DataColumn(
        label: Text(
          "Alternative",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
    for (Criteria c in criterias) {
      columns.add(
        DataColumn(
          label: Text(
            c.name,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
    return columns;
  }

  List<Criteria> _generateCriterias(int n) {
    List<Criteria> criterias = [];
    int i = 0;
    while (i < n) {
      criterias.add(Criteria(name: "criteria_$i", type: CriteriaType.benefit));
      i++;
    }
    return criterias;
  }

    Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    // _criterias = _generateCriterias(20);
    // _cols = _createCols(_criterias);
    List<Criteria> _criterias =
        ModalRoute.of(context)?.settings.arguments as List<Criteria>;
    _cols = _createCols(_criterias);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        backgroundColor: Colors.blueGrey,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          label: Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text("Fill your decision matrix"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: _addNewRow, icon: Icon(Icons.add_box_sharp)),
                    SizedBox(height: 32),
                    IconButton(
                        onPressed: _removeRow, icon: Icon(Icons.remove_circle)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: _cols, rows: _rows, key: _tableKey)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            title: Text("Calculate using pearson correlation extension method"),
            activeColor: Colors.blue,
            visualDensity: VisualDensity.compact,
            value: isWithPearsonCorrelation,
            onChanged: (value){
              setState(() {
                isWithPearsonCorrelation = value!;
                print("pearson_correlation: $isWithPearsonCorrelation");
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _submit(_criterias,isWithPearsonCorrelation);
                      },
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
