from __future__ import absolute_import
from ...test_case import TestCase
from functions.example.utils import dict_coalesce


class TestDictCoalesce(TestCase):

    def test_no_keys_and_empty_dict_returns_default(self):
    # Given:
        empty_dict = {}
        no_keys = []
    # When:
        result = dict_coalesce(empty_dict, "default", no_keys)
    # Then:
        self.assert_equals(result, "default")

    def test_no_keys_and_1_dict_value_returns_default(self):
    # Given:
        item_1 = { 'item1': 'value1' }
        no_keys = []
    # When:
        result = dict_coalesce(item_1, "default", no_keys)
    # Then:
        self.assert_equals(result, "default")

    def test_1_key_and_empty_dict_returns_default(self):
    # Given:
        empty_dict = {}
        item_1_key = [ 'item1' ]
    # When:
        result = dict_coalesce(empty_dict, "default", item_1_key)
    # Then:
        self.assert_equals(result, "default")

    def test_wrong_key_and_1_dict_value_returns_default(self):
    # Given:
        item_1 = { 'item1': 'value1' }
        item_2_key = [ 'item2' ]
    # When:
        result = dict_coalesce(item_1, "default", item_2_key)
    # Then:
        self.assert_equals(result, "default")

    def test_correct_key_and_1_dict_value_returns_matching_value(self):
    # Given:
        item_1 = { 'item1': 'value1' }
        item_1_key = [ 'item1' ]
    # When:
        result = dict_coalesce(item_1, "default", item_1_key)
    # Then:
        self.assert_equals(result, "value1")

    def test_wrong_and_correct_keys_and_1_dict_value_returns_matching_value(self):
    # Given:
        item_2 = { 'item2': 'value2' }
        item_1_2_keys = [ 'item1', 'item2' ]
    # When:
        result = dict_coalesce(item_2, "default", item_1_2_keys)
    # Then:
        self.assert_equals(result, "value2")

    def test_correct_key_and_2_dict_values_returns_matching_value(self):
    # Given:
        items_1_2 = { 'item1': 'value1', 'item2': 'value2' }
        item_1_key = [ 'item1' ]
    # When:
        result = dict_coalesce(items_1_2, "default", item_1_key)
    # Then:
        self.assert_equals(result, "value1")

    def test_2_correct_keys_and_2_dict_values_returns_first_matching_value(self):
    # Given:
        items_1_2 = { 'item1': 'value1', 'item2': 'value2' }
        item_1_2_keys = [ 'item1', 'item2' ]
    # When:
        result = dict_coalesce(items_1_2, "default", item_1_2_keys)
    # Then:
        self.assert_equals(result, "value1")

    def test_wrong_and_correct_keys_and_2_dict_values_returns_first_matching_value(self):
    # Given:
        items_1_2 = { 'item1': 'value1', 'item2': 'value2' }
        item_3_2_keys = [ 'item3', 'item2' ]
    # When:
        result = dict_coalesce(items_1_2, "default", item_3_2_keys)
    # Then:
        self.assert_equals(result, "value2")

    def test_correct_key_and_1_dict_value_returns_transformed_value(self):
    # Given:
        item_1 = { 'item1': 'value1' }
        item_1_key = [ 'item1' ]
        transform = lambda k, v : f"transformed_{v}"
    # When:
        result = dict_coalesce(item_1, "default", item_1_key, transform)
    # Then:
        self.assert_equals(result, 'transformed_value1')
