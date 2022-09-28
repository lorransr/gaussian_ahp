import 'package:gaussian_ahp_method/model/ahp_input.dart';
import 'package:gaussian_ahp_method/model/criteria.dart';
import 'package:gaussian_ahp_method/model/criteria_type.dart';

class ExampleHelper {
  AhpInput ahpExample() {
    List<Criteria> _criterias = [
      Criteria(name: "custo", type: CriteriaType.cost),
      Criteria(name: "camera", type: CriteriaType.benefit),
      Criteria(name: "armazenamento", type: CriteriaType.benefit),
      Criteria(name: "duracao", type: CriteriaType.benefit),
    ];
    List<List<double>> _vars = [
      [1500, 12, 64, 24],
      [1800, 12, 128, 18],
      [5000, 20, 128, 10],
    ];
    List<String> _alternativesNames = ["xiaomi", "samsung", "iphone"];
    return AhpInput(
        criterias: _criterias,
        vars: _vars,
        alternativesNames: _alternativesNames,
        pearsonCorrelation: true);
  }
}
