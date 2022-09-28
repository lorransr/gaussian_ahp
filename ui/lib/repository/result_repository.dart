import 'package:gaussian_ahp_method/model/ahp_input.dart';
import 'package:gaussian_ahp_method/model/model_results.dart';
import 'package:gaussian_ahp_method/provider/api_provider.dart';

class ResultsRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<ModelResults> getRanking(AhpInput input) {
    return _apiProvider.getRanking(input);
  }
}
