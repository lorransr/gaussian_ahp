import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:gaussian_ahp_method/helpers/table_helper.dart';
import 'package:gaussian_ahp_method/model/model_results.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PDFProvider {
  var _helper = TableHelper();
  creatPdfFromImage(Uint8List img) async {
    print("start printing");
    final _image = pw.MemoryImage(img);
    final doc = pw.Document();

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(_image),
      ); // Center
    }));
    final bytes = await doc.save();
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

  createPDF(ModelResults _data) async {
    final pdf = pw.Document();
    var _alternatives = _helper.getAlternatives(_data);
    var _rawMatrixArray = _helper.getMatrixArray(
        _data.results.normalizedDecisionMatrix, _alternatives);
    var _variationCoeficient = _helper.getSeriesArray(
        _data.results.gaussianFactor,
        header: ["Criteria", "Value"]);
    var _gaussianFactor = _helper.getSeriesArray(
        _data.results.normalizedGaussianFactor,
        header: ["Criteria", "Value"]);
    var _weightedMatrix = _helper.getMatrixArray(
        _data.results.weightedDecisionmatrix, _alternatives);
    var _correlationMatrix = _helper.getMatrixArray(
        _data.results.correlationMatrix!,
        _data.results.correlationMatrix!.keys.toList());
    var _correlationFactor =
        _helper.getSeriesArray(_data.results.correlationFactor);
    var _normalizedCorrelationFactor =
        _helper.getSeriesArray(_data.results.normalizedCorrelationFactor);
    var _results = _helper.getSeriesArray(_data.results.weightedSum,
        header: ["Alternative", "Value"], ascending: false);
    var _ranking = _helper.getSeriesArray(_data.results.ranking,
        header: ["Alternative", "Ranking"], ascending: true);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          if (_data.results.correlationMatrix == null) {
            var listOfOutputs = [
              pw.Header(text: "Gaussian AHP Method Result Sheet"),
              pw.Text('Ranking'),
              pw.Table.fromTextArray(data: _ranking!),
              pw.Text('Weighted Sum'),
              pw.Table.fromTextArray(data: _results!),
              pw.Divider(),
              pw.Text("Normalized Matrix"),
              pw.Table.fromTextArray(data: _rawMatrixArray),
              pw.Divider(),
              pw.Text("Variation Coefficient"),
              pw.Table.fromTextArray(data: _variationCoeficient!),
              pw.Divider(),
              pw.Text("Gaussian Factor"),
              pw.Table.fromTextArray(data: _gaussianFactor!),
              pw.Divider(),
              pw.Text("Weighted Matrix"),
              pw.Table.fromTextArray(data: _weightedMatrix),
              pw.Divider(),
            ];
            return listOfOutputs;
          } else {
            var listOfOutputs = [
              pw.Header(text: "Gaussian AHP Method Result Sheet"),
              pw.Text('Ranking'),
              pw.Table.fromTextArray(data: _ranking!),
              pw.Text('Weighted Sum'),
              pw.Table.fromTextArray(data: _results!),
              pw.Divider(),
              pw.Text("Normalized Matrix"),
              pw.Table.fromTextArray(data: _rawMatrixArray),
              pw.Divider(),
              pw.Text("Variation Coefficient"),
              pw.Table.fromTextArray(data: _variationCoeficient!),
              pw.Divider(),
              pw.Text("Gaussian Factor"),
              pw.Table.fromTextArray(data: _gaussianFactor!),
              pw.Divider(),
              pw.Text("Correlation Matrix"),
              pw.Table.fromTextArray(data: _correlationMatrix),
              pw.Divider(),
              pw.Text("Correlation Factor"),
              pw.Table.fromTextArray(data: _correlationFactor!),
              pw.Divider(),
              pw.Text("Normalized Correlation Factor"),
              pw.Table.fromTextArray(data: _normalizedCorrelationFactor!),
              pw.Divider(),
              pw.Text("Weighted Matrix"),
              pw.Table.fromTextArray(data: _weightedMatrix),
              pw.Divider(),
            ];
            return listOfOutputs;
          }
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
