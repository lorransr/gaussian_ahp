from dataclasses import dataclass
import pandas as pd


@dataclass
class AhpInputs:
    decision_matrix: pd.DataFrame
    criteria_type: dict
    pearson_correlation: bool


@dataclass
class AhpOutputs:
    normalized_matrix: dict
    gaussian_factor: dict
    normalized_gaussian_factor: dict
    weighted_matrix: dict
    weighted_sum: dict
    ranking: dict
    correlation_matrix: dict = None
    correlation_factor: dict = None
    normalized_correlation_factor: dict = None
