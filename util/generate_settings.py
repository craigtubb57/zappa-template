import json
import os
import sys
import re
from collections import ChainMap


def generate(*args, **kwargs):

    function_name = kwargs['function_name']

    settings = json.load(open("zappa_template.json"))
    rep = { f"<{env_var}>": os.environ[env_var] for env_var in os.environ }
    settings = json.loads(replace_all(json.dumps(settings), rep))

    with open('zappa_settings.json', 'w', encoding='utf-8') as f:
        json.dump(settings, f, ensure_ascii=False, indent=4)

    return f"Generated zappa_settings.json for {function_name}"

# ----------------------------------- UTIL ----------------------------------- #

def replace_all(text: str, rep: dict, ignore_case: bool = False):
    kwargs = { "flags": re.IGNORECASE } if ignore_case else {}
    rep = dict((re.escape(k), v) for k, v in rep.items())
    pattern = re.compile("|".join(rep.keys()), **kwargs)
    return pattern.sub(lambda m: rep[re.escape(m.group(0))], text)

# ----------------------------------- MAIN ----------------------------------- #

if __name__ == "__main__":
    args = sys.argv[1:]
    print(generate(**{ "function_name": args[0] }))
