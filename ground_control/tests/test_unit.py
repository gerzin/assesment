"""
Unit tests for the onboard module.
Tests that don't require the C++ library to be loaded.
Uses mocks to test the Python wrapper logic.
"""

from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from ground_control.onboard import OnboardLib


def test_library_not_found():
    """Test that appropriate error is raised when library path is invalid."""
    with pytest.raises(FileNotFoundError):
        OnboardLib(lib_path="/nonexistent/path/libonboard.so")


@patch("ctypes.CDLL")
def test_init_with_explicit_path(mock_cdll):
    """Test OnboardLib initialization with explicit library path."""
    lib_path = "/fake/path/libonboard.so"

    with patch.object(Path, "exists", return_value=True):
        lib = OnboardLib(lib_path=lib_path)

        # Verify CDLL was called with the correct path
        mock_cdll.assert_called_once()
        assert lib is not None


@patch("ctypes.CDLL")
def test_init_with_env_variable(mock_cdll):
    """Test OnboardLib initialization using ONBOARD_LIB_PATH environment variable."""
    lib_path = "/env/path/libonboard.so"

    with (
        patch.dict("os.environ", {"ONBOARD_LIB_PATH": lib_path}),
        patch.object(Path, "exists", return_value=True),
    ):
        lib = OnboardLib()

        # Should use the environment variable path
        mock_cdll.assert_called_once()
        assert lib is not None


@patch("ctypes.CDLL")
def test_process_command_success(mock_cdll):
    """Test successful command processing with mocked C++ library."""
    # Setup mock library
    mock_lib = MagicMock()
    mock_cdll.return_value = mock_lib

    mock_result = OnboardLib.CResult()
    mock_result.data = b"ACK: TEST_COMMAND"
    mock_result.error_code = OnboardLib.CErrorCode.C_OK

    mock_lib.onboard_process_command_c.return_value = mock_result

    with patch.object(Path, "exists", return_value=True):
        lib = OnboardLib(lib_path="/fake/libonboard.so")
        result = lib.process_command("TEST_COMMAND")

    assert result["success"] is True
    assert result["response"] == "ACK: TEST_COMMAND"
    assert result["command"] == "TEST_COMMAND"

    mock_lib.onboard_process_command_c.assert_called_once()
    mock_lib.onboard_free_result.assert_called_once_with(mock_result)


@patch("ctypes.CDLL")
def test_process_command_failure(mock_cdll):
    """Test failed command processing with mocked C++ library."""
    mock_lib = MagicMock()
    mock_cdll.return_value = mock_lib

    mock_result = OnboardLib.CResult()
    mock_result.data = b"NACK: Invalid command"
    mock_result.error_code = OnboardLib.CErrorCode.C_INVALID_COMMAND

    mock_lib.onboard_process_command_c.return_value = mock_result

    with patch.object(Path, "exists", return_value=True):
        lib = OnboardLib(lib_path="/fake/libonboard.so")
        result = lib.process_command("INVALID!")

    assert result["success"] is False
    assert result["response"] == "NACK: Invalid command"

    mock_lib.onboard_free_result.assert_called_once_with(mock_result)


@patch("ctypes.CDLL")
def test_process_command_empty_response(mock_cdll):
    """Test command processing with empty response data."""
    mock_lib = MagicMock()
    mock_cdll.return_value = mock_lib

    mock_result = OnboardLib.CResult()
    mock_result.data = None
    mock_result.error_code = OnboardLib.CErrorCode.C_OK

    mock_lib.onboard_process_command_c.return_value = mock_result

    with patch.object(Path, "exists", return_value=True):
        lib = OnboardLib(lib_path="/fake/libonboard.so")
        result = lib.process_command("TEST")

    assert result["response"] == ""
    assert result["success"] is True
