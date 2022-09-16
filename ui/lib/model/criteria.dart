import "dart:math";

import 'package:taxonomy_method/model/criteria_type.dart';

class Criteria {
  String name;
  String key = "";
  CriteriaType type = CriteriaType.benefit;
  Criteria(
      {required this.name,
      required this.type}) {
    this.key = getRandomString(10);
  }
  Criteria.empty(
      {this.name = "",
      this.type = CriteriaType.benefit});
  Map<String, String> getColumn() {
    return {"title": this.name, "key": this.key};
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": getCriteriaTypeName(type),
      };
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

CriteriaType getCriteriaType(String? criteriaTypeName) {
  if (criteriaTypeName != null &&
      "MAX" == criteriaTypeName) {
    return CriteriaType.benefit;
  } else {
    return CriteriaType.cost;
  }
}

String getCriteriaTypeName(CriteriaType criteriaType) {
  if (criteriaType == CriteriaType.benefit) {
    return "MAX";
  } else {
    return "MIN";
  }
}
