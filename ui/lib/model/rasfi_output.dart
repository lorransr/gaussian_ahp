class RasfiResults {
  final Map<String, dynamic> ranking;
  final Map<String, dynamic> decisionMatrix;
  final Map<String, dynamic> transformedDecisionMatrix;
  final Map<String, dynamic> normalizedDecisionMatrix;
  final double harmonicMean;
  final double arithmeticMean;

  RasfiResults(
      this.ranking,
      this.decisionMatrix,
      this.transformedDecisionMatrix,
      this.normalizedDecisionMatrix,
      this.harmonicMean,
      this.arithmeticMean);

  RasfiResults.fromJson(Map<String, dynamic> json)
      : ranking = json["ranking"],
        decisionMatrix = json["decision_matrix"],
        transformedDecisionMatrix = json["transformed_decision_matrix"],
        normalizedDecisionMatrix = json["normalized_decision_matrix"],
        harmonicMean = json["harmonic_mean"] as double,
        arithmeticMean = json["arithmetic_mean"] as double;

  Map<String, dynamic> toJson() => {
        "ranking": ranking,
        "decision_matrix": decisionMatrix,
        "transformed_decision_matrix": transformedDecisionMatrix,
        "normalized_decision_matrix": normalizedDecisionMatrix,
        "harmonic_mean": harmonicMean,
        "arithmetic_mean": arithmeticMean
      };

  RasfiResults.withError()
      : ranking = {},
        decisionMatrix = {},
        transformedDecisionMatrix = {},
        normalizedDecisionMatrix = {},
        arithmeticMean = -1,
        harmonicMean = -1;
}
