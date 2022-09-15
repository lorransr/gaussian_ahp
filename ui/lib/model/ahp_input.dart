import 'package:taxonomy_method/model/criteria.dart';

class AhpInput {
  List<Criteria> criterias;
  List<String>? criteriaList;
  List<String>? criteriaTypeList;
  List<List<double>> vars;
  List<String> alternativesNames;
  bool pearsonCorrelation;
  AhpInput(
      {required this.criterias,
      required this.alternativesNames,
      required this.pearsonCorrelation,
      required this.vars}) {
    this.criteriaList = criterias.map((e) => e.name).toList();
    this.criteriaTypeList =
        criterias.map((e) => getCriteriaTypeName(e.type)).toList();
  }

  Map<String, dynamic> toJson() => {
        'criteria': criteriaList,
        'criteria_type_list': criteriaTypeList,
        'alternatives': alternativesNames,
        'vars': vars,
        'pearson_correlation': pearsonCorrelation
      };
}
