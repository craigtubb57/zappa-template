from __future__ import print_function
import unittest
from os.path import exists


class TestCase(unittest.TestCase):

    def assert_equals(self, val, expect):
        self.assertEqual(val, expect, f"Expect: {expect}\n   Got: {val}")

    def assert_exists(self, path):
        return exists(path)

    def assert_error_message(self, context, expect):
        message = str(context.exception)
        self.assertTrue(expect in message, f"\nExpect error to have: {expect}\n  But full error was: {message}")
