from ahp_gaussiano.models import AhpInputs, AhpOutputs
import pandas as pd


def normalize_matrix(inputs: AhpInputs):
    matrix = pd.DataFrame(inputs.vars,columns=inputs.criteria,index=inputs.alternatives)

    for criteria, criteria_type in dict(zip(inputs.criteria,inputs.criteria_type_list)).items():
        if criteria_type == "MAX":

            matrix.loc[:, criteria] = matrix[criteria] / matrix[criteria].sum()

        elif criteria_type == "MIN":

            divided_matrix = 1 / matrix[criteria]
            denominator = divided_matrix.sum()
            matrix.loc[:, criteria] = divided_matrix / denominator

    return matrix


def gaussian_ahp(
    normalized_matrix: pd.DataFrame,
    gaussian_factor: pd.Series,
    normalized_gaussian_factor: pd.Series,
):
    weighted_matrix = normalized_matrix * normalized_gaussian_factor
    weighted_sum = weighted_matrix.sum(axis=1)
    ranking = weighted_sum.rank(ascending=False)

    return AhpOutputs(
        normalized_matrix=normalized_matrix.to_dict(),
        gaussian_factor=gaussian_factor.to_dict(),
        normalized_gaussian_factor=normalized_gaussian_factor.to_dict(),
        weighted_matrix=weighted_matrix.to_dict(),
        weighted_sum=weighted_sum.to_dict(),
        ranking=ranking.to_dict(),
    )


def gaussian_ahp_with_pearson_correlation(
    normalized_matrix: pd.DataFrame,
    gaussian_factor: pd.Series,
    normalized_gaussian_factor: pd.Series,
):
    correlation_matrix = normalized_matrix.corr().abs().replace(1, 0)
    correlation_avg = correlation_matrix.mean()
    correlation_factor = (1 - correlation_avg) * normalized_gaussian_factor
    normalized_correlation_factor = correlation_factor / correlation_factor.sum()
    weighted_matrix = normalized_matrix * normalized_correlation_factor
    weighted_sum = weighted_matrix.sum(axis=1)
    ranking = weighted_sum.rank(ascending=False)

    return AhpOutputs(
        normalized_matrix=normalized_matrix.to_dict(),
        gaussian_factor=gaussian_factor.to_dict(),
        normalized_gaussian_factor=normalized_gaussian_factor.to_dict(),
        weighted_matrix=weighted_matrix.to_dict(),
        weighted_sum=weighted_sum.to_dict(),
        ranking=ranking.to_dict(),
        correlation_matrix=correlation_matrix.to_dict(),
        correlation_factor=correlation_factor.to_dict(),
        normalized_correlation_factor=normalized_correlation_factor.to_dict(),
    )


def apply_method(inputs: AhpInputs):
    normalized_matrix = normalize_matrix(inputs)
    gaussian_factor = normalized_matrix.std() / normalized_matrix.mean()
    normalized_gaussian_factor: pd.Series = gaussian_factor / gaussian_factor.sum()
    if inputs.pearson_correlation:
        return gaussian_ahp_with_pearson_correlation(
            normalized_matrix, gaussian_factor, normalized_gaussian_factor
        )
    else:
        return gaussian_ahp(
            normalized_matrix, gaussian_factor, normalized_gaussian_factor
        )
