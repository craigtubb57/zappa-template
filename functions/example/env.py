from __future__ import absolute_import
from decouple import config
from dotenv import find_dotenv, load_dotenv
from util.log import log


class Env:

    def __init__(self, *args, **kwargs):
        super().__init__()

    def vars(self, names, *args, **kwargs):
        env_vars = { var: config(var) for var in names }
        for var, val in env_vars.items():
            log.debug(f"{var}: {val}")
        return env_vars
