from ahp_gaussiano.models import AhpInputs,AhpOutputs
from ahp_gaussiano.method import apply_method
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event,context):
    body = json.loads(event["body"])
    logger.info(f"received body: {body}")
    inputs = AhpInputs(**body)
    results = apply_method(inputs)
    return {
        "statusCode": 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST'
        },
        "body": json.dumps(results.__dict__)
        }