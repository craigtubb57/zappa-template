from __future__ import absolute_import
from unittest.mock import MagicMock, patch, call
from ...test_case import TestCase
from functions.example.main import lambda_handler


@patch("functions.example.main.Env")
class TestMain(TestCase):

    def test_success(self, MockEnv):
    # Given:
        event = {}
        MockEnv.return_value.vars.return_value = {"ENV_VAR_1":"var_1","ENV_VAR_2":"var_2"}
        expect_result = {"status": 200,"message": "success"}
    # When:
        result = lambda_handler(event, {})
    # Then:
        self.assert_equals(result, expect_result)
        MockEnv.assert_called_once_with()
        MockEnv.return_value.vars.assert_called_once_with(["ENV_VAR_1","ENV_VAR_2"])

    def test_throws_exception(self, MockEnv):
    # Given:
        MockEnv.return_value.vars.side_effect = Exception("some error")
        expect_message = "some error"
    # When:
        with self.assertRaises(Exception) as context:
            lambda_handler({}, {})
    # Then:
        self.assert_error_message(context, expect_message)
        MockEnv.assert_called_once_with()
        MockEnv.return_value.vars.assert_called_once_with(["ENV_VAR_1","ENV_VAR_2"])
