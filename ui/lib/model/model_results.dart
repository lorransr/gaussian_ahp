import 'rasfi_output.dart';

class ModelResults {
  final RasfiResults results;
  final String error;
  ModelResults(this.results, this.error);

  ModelResults.fromJson(Map<String, dynamic> json)
      : results = RasfiResults.fromJson(json),
        error = "";

  ModelResults.withError(String errorValue)
      : results = RasfiResults.withError(),
        error = errorValue;
}
