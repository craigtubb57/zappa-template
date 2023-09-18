from __future__ import print_function
import boto3
import json
import sys
from log import log
from decouple import config


def lambda_handler(event, context):
    env_var = config('ENV_VAR')
    log.debug(f"ENV_VAR: {env_var}")

    # do some operation

    return {
        "status": 200,
        "message": "success",
    }

# ----------------------------------- MAIN ----------------------------------- #

if __name__ == "__main__":
    args = sys.argv[1:]
    print(lambda_handler(json.loads(args[0]), json.loads(args[1])))
