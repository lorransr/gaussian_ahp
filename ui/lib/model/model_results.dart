import 'package:taxonomy_method/model/ahp_output.dart';

class ModelResults {
  final AhpResults results;
  final String error;
  ModelResults(this.results, this.error);

  ModelResults.fromJson(Map<String, dynamic> json)
      : results = AhpResults.fromJson(json),
        error = "";

  ModelResults.withError(String errorValue)
      : results = AhpResults.withError(),
        error = errorValue;
}
