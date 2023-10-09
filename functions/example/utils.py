from __future__ import print_function
import subprocess
import json
from os.path import exists
from datetime import datetime as dt
from pathlib import Path
from util.log import log


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

def dict_coalesce(dict, default, keys: list, transform = lambda k, v : v):
    return next((transform(key, dict[key]) for key in keys if key in dict), default)

def open_any_file(path, default = None):
    if exists(path):
        with open(path, "rb") as file:
            return file.read()
    return default

def ttl_expired(path, ttl):
    file_created_ts = Path(path).stat().st_mtime
    created = dt.fromtimestamp(file_created_ts)
    return (dt.now() - created).total_seconds() > ttl

def write_to(path, bytes):
    with open(path, "w+") as file:
        file.write(bytes)
