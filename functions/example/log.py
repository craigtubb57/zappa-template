import logging
import os
import sys

log = logging.getLogger(__name__)
log_levels = { "DEBUG": logging.DEBUG, "INFO": logging.INFO, "WARNING": logging.WARNING, "ERROR": logging.ERROR, "CRITICAL": logging.CRITICAL}
log_level = log_levels[os.environ.get("LOG_LEVEL", "INFO")]
log.setLevel(log_level)
should_log = log_level == log_levels["DEBUG"]

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(log_level)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)
log.propagate = False
