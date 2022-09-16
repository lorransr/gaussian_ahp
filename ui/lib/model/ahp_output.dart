class AhpResults {
  final Map<String, dynamic> ranking;
  final Map<String, dynamic> weightedDecisionmatrix;
  final Map<String, dynamic> weightedSum;
  final Map<String, dynamic> normalizedDecisionMatrix;
  final Map<String, dynamic> gaussianFactor;
  final Map<String, dynamic> normalizedGaussianFactor;
  Map<String, dynamic>? correlationMatrix;
  Map<String, dynamic>? correlationFactor;
  Map<String, dynamic>? normalizedCorrelationFactor;

  AhpResults(
    this.ranking,
    this.weightedDecisionmatrix,
    this.normalizedDecisionMatrix,
    this.weightedSum,
    this.gaussianFactor,
    this.normalizedGaussianFactor,
  );

  AhpResults.fromJson(Map<String, dynamic> json)
      : ranking = json["ranking"],
        weightedDecisionmatrix = json["weighted_matrix"],
        normalizedDecisionMatrix = json["normalized_matrix"],
        weightedSum = json["weighted_sum"],
        gaussianFactor = json["gaussian_factor"],
        normalizedGaussianFactor = json["normalized_gaussian_factor"],
        correlationMatrix = json["correlation_matrix"],
        correlationFactor = json["correlation_factor"],
        normalizedCorrelationFactor = json["normalized_correlation_factor"];

  Map<String, dynamic> toJson() => {
        "ranking": ranking,
        "weighted_matrix": weightedDecisionmatrix,
        "normalized_matrix": normalizedDecisionMatrix,
        "weighted_sum": weightedSum,
        "gaussian_factor": gaussianFactor,
        "normalized_gaussian_factor": normalizedGaussianFactor,
        "correlation_matrix": correlationMatrix,
        "correlation_factor": correlationFactor,
        "normalized_correlation_factor": normalizedCorrelationFactor,
      };

  AhpResults.withError()
      : ranking = {},
        weightedDecisionmatrix = {},
        normalizedDecisionMatrix = {},
        weightedSum = {},
        gaussianFactor = {},
        normalizedGaussianFactor = {},
        correlationMatrix = null,
        correlationFactor = null,
        normalizedCorrelationFactor = null;
}
