"""
Tests for the onboard shared library.
Tests the Python-C++ interface via ctypes.
"""

import pytest

from ground_control.onboard import OnboardLib


@pytest.mark.integration
def test_valid_command_simple(onboard):
    result = onboard.process_command("POWER_ON")

    assert result["success"] is True
    assert result["response"] == "ACK: POWER_ON"
    assert result["command"] == "POWER_ON"


@pytest.mark.integration
def test_valid_command_with_spaces(onboard):
    result = onboard.process_command("SET ALTITUDE 1000")

    assert result["success"] is True
    assert result["response"] == "ACK: SET ALTITUDE 1000"


@pytest.mark.integration
def test_valid_command_with_underscore(onboard):
    result = onboard.process_command("GET_STATUS")

    assert result["success"] is True
    assert result["response"] == "ACK: GET_STATUS"


@pytest.mark.integration
def test_valid_command_with_hyphen(onboard):
    result = onboard.process_command("DEPLOY-PAYLOAD")

    assert result["success"] is True
    assert result["response"] == "ACK: DEPLOY-PAYLOAD"


@pytest.mark.integration
def test_invalid_command_empty(onboard):
    result = onboard.process_command("")

    assert result["success"] is False
    assert result["response"] == "NACK: Invalid command format"


@pytest.mark.integration
def test_invalid_command_special_character(onboard):
    result = onboard.process_command("invalid@command!")

    assert result["success"] is False
    assert result["response"] == "NACK: Invalid command format"


@pytest.mark.unit
def test_library_not_found():
    with pytest.raises(FileNotFoundError):
        OnboardLib(lib_path="/nonexistent/path/libonboard.so")
