from ahp_gaussiano import method
from ahp_gaussiano.models import AhpInputs
import pandas as pd
import numpy as np


def get_gaussian_ahp_inputs() -> AhpInputs:
    decision_matrix = {
        "custo": [1500, 1800, 5000],
        "camera": [12, 12, 20],
        "armazenamento": [64, 128, 128],
        "duracao": [24, 18, 10],
    }
    alternatives = ["xiaomi", "samsung", "iphone"]
    decision_matrix = pd.DataFrame(decision_matrix, index=alternatives)
    criteria_type = {
        "custo": "MIN",
        "camera": "MAX",
        "armazenamento": "MAX",
        "duracao": "MAX",
    }
    return AhpInputs(
        decision_matrix=decision_matrix,
        criteria_type=criteria_type,
        pearson_correlation=False,
    )


def get_gaussian_ahp_pearson_correlation_inputs() -> AhpInputs:
    decision_matrix = {
        "custo": [6700, 4100, 2650],
        "camera": [12, 64, 108],
        "armazenamento": [128, 256, 128],
        "tela": [6.1, 6.2, 6.7],
        "duracao": [19, 24, 30],
    }
    alternatives = ["iphone", "samsung", "motorola"]
    decision_matrix = pd.DataFrame(decision_matrix, index=alternatives)
    criteria_type = {
        "custo": "MIN",
        "camera": "MAX",
        "armazenamento": "MAX",
        "tela": "MAX",
        "duracao": "MAX",
    }
    return AhpInputs(
        decision_matrix=decision_matrix,
        criteria_type=criteria_type,
        pearson_correlation=True,
    )


def test_normalize_matrix():
    inputs = get_gaussian_ahp_inputs()
    result = method.normalize_matrix(inputs)
    expected = {
        "custo": {
            "xiaomi": 0.46874999999999994,
            "samsung": 0.390625,
            "iphone": 0.140625,
        },
        "camera": {
            "xiaomi": 0.2727272727272727,
            "samsung": 0.2727272727272727,
            "iphone": 0.45454545454545453,
        },
        "armazenamento": {"xiaomi": 0.2, "samsung": 0.4, "iphone": 0.4},
        "duracao": {
            "xiaomi": 0.46153846153846156,
            "samsung": 0.34615384615384615,
            "iphone": 0.19230769230769232,
        },
    }
    assert result.to_dict() == expected


def test_apply_method():
    inputs = get_gaussian_ahp_inputs()
    result = method.apply_method(inputs)
    expected = {"xiaomi": 1.0, "samsung": 2.0, "iphone": 3.0}
    assert result.ranking == expected


def test_apply_method_with_pearson_correlation():
    inputs = get_gaussian_ahp_pearson_correlation_inputs()
    result = method.apply_method(inputs)
    expected = {"motorola": 1.0, "samsung": 2.0, "iphone": 3.0}
    assert result.ranking == expected
