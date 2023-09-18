from __future__ import print_function
from log import log
import subprocess
import json


def list_of(obj):
    if not isinstance(obj, list):
        obj = [ obj ] if obj else []
    return obj

def non_empty_list(lst):
    return [ item for item in lst if item ]

def first_dict(list):
    return list[0] if list else {}

def flatten(t):
    return [item for sublist in t for item in sublist]

def dedupe(name_items):
    return [ v for k, v in { item['name']: item for item in name_items }.items() ]

def check(name, iterable):
    logger.debug(f"{name}: {len(iterable)}")
    return iterable

def pbcopy(data):
    try:
        subprocess.run("pbcopy", text=True, input=json.dumps(data, indent = 4))
    except:
        log.warning("pbcopy not available")
