from ahp_gaussiano import method
from ahp_gaussiano.models import AhpInputs
import pandas as pd
import numpy as np


def get_gaussian_ahp_inputs() -> AhpInputs:
    vars = [
        [1500,12,64,24],
        [1800,12,128,18],
        [5000,20,128,10],
        ]
    criteria = ["custo","camera","armazenamento","duracao"]
    alternatives = ["xiaomi", "samsung", "iphone"]
    criteria_type = ["MIN","MAX","MAX","MAX"]
    return AhpInputs(
        vars=vars,
        criteria=criteria,
        criteria_type_list=criteria_type,
        pearson_correlation=False,
        alternatives=alternatives
    )


def get_gaussian_ahp_pearson_correlation_inputs() -> AhpInputs:
    vars = [
        [6700,12,128,6.1,19],
        [4100,65,256,6.2,24],
        [2650,108,128,6.7,30]
    ]
    criteria = ["custo","camera","armazenamento","tela","duracao"]
    alternatives = ["iphone", "samsung", "motorola"]
    criteria_type = [
        "MIN",
        "MAX",
        "MAX",
        "MAX",
        "MAX",
    ]
    return AhpInputs(
        vars=vars,
        criteria=criteria,
        criteria_type_list=criteria_type,
        pearson_correlation=True,
        alternatives=alternatives
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
