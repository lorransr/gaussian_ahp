import 'package:taxonomy_method/helpers/table_helper.dart';
import 'package:taxonomy_method/model/model_results.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PDFProvider {
  var _helper = TableHelper();
  createPDF(ModelResults _data) async {
    final pdf = pw.Document();
    var _alternatives = _helper.getAlternatives(_data);
    var _rawMatrixArray =
        _helper.getMatrixArray(_data.results.normalizedDecisionMatrix, _alternatives);
    // var _transformedMatrixArray = _helper.getMatrixArray(
    //     _data.results.transformedDecisionMatrix, _alternatives);
    // var _normalizedMatrixArray = _helper.getMatrixArray(
    //     _data.results.normalizedDecisionMatrix, _alternatives);
    var _developmentAttributeArray = _helper.getSeriesArray(
        _data.results.ranking,
        header: ["Alternative", "Value"]);
    // var distanceMap = {
    //   "Arithmetic Mean": _data.results.arithmeticMean,
    //   "Harmonic Mean": _data.results.harmonicMean
    // };
    // var _averageEstimatesArray =
    //     _helper.getSeriesArray(distanceMap, header: ["Metric", "Value"]);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) { 
          return [
            pw.Header(text: "Gaussian AHP Method Result Sheet"),
            pw.Text('Development Attributes'),
            pw.Table.fromTextArray(data: _developmentAttributeArray),
            pw.Divider(),
            pw.Text("Inputs"),
            pw.Table.fromTextArray(data: _rawMatrixArray),
            pw.Divider(),
            // pw.Text("Transformed Matrix"),
            // pw.Table.fromTextArray(data: _transformedMatrixArray),
            // pw.Divider(),
            // pw.Text("Normalized Matrix"),
            // pw.Table.fromTextArray(data: _normalizedMatrixArray),
            // pw.Divider(),
            // pw.Text("Average Estimates"),
            // pw.Table.fromTextArray(data: _averageEstimatesArray)
          ];
        },
      ),
    );
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'gaussian_ahp_method.pdf';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
