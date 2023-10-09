from __future__ import print_function
import json
import sys
from util.log import log
try:
    from .env import Env
except ImportError:
    from env import Env


def lambda_handler(event, context):
    env_vars = Env().vars(['ENV_VAR_1', 'ENV_VAR_2'])

    # do some operation

    return {
        "status": 200,
        "message": "success",
    }

# ----------------------------------- MAIN ----------------------------------- #

if __name__ == "__main__":
    args = sys.argv[1:]
    print(lambda_handler(json.loads(args[0]), json.loads(args[1])))
