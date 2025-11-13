"""
Tests for the onboard shared library.
Tests the Python-C++ interface via ctypes.
"""

import unittest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from onboard_lib import OnboardLib


class TestOnboardLib(unittest.TestCase):
    """Test suite for OnboardLib wrapper."""

    @classmethod
    def setUpClass(cls):
        """Set up test fixtures that are shared across all tests."""
        cls.onboard = OnboardLib()

    def test_valid_command_simple(self):
        """Test processing a simple valid command."""
        result = self.onboard.process_command("POWER_ON")
        
        self.assertTrue(result["success"])
        self.assertEqual(result["response"], "ACK: POWER_ON")
        self.assertEqual(result["command"], "POWER_ON")

    def test_valid_command_with_spaces(self):
        """Test processing a valid command with spaces."""
        result = self.onboard.process_command("SET ALTITUDE 1000")
        
        self.assertTrue(result["success"])
        self.assertEqual(result["response"], "ACK: SET ALTITUDE 1000")

    def test_valid_command_with_underscore(self):
        """Test processing a valid command with underscores."""
        result = self.onboard.process_command("GET_STATUS")
        
        self.assertTrue(result["success"])
        self.assertEqual(result["response"], "ACK: GET_STATUS")

    def test_valid_command_with_hyphen(self):
        """Test processing a valid command with hyphens."""
        result = self.onboard.process_command("DEPLOY-PAYLOAD")
        
        self.assertTrue(result["success"])
        self.assertEqual(result["response"], "ACK: DEPLOY-PAYLOAD")

    def test_invalid_command_empty(self):
        """Test processing an empty command."""
        result = self.onboard.process_command("")
        
        self.assertFalse(result["success"])
        self.assertEqual(result["response"], "NACK: Invalid command format")

    def test_invalid_command_special_character(self):
        """Test processing a command with special characters."""
        result = self.onboard.process_command("invalid@command!")
        
        self.assertFalse(result["success"])
        self.assertEqual(result["response"], "NACK: Invalid command format")

    def test_library_not_found(self):
        """Test that FileNotFoundError is raised when library doesn't exist."""
        with self.assertRaises(FileNotFoundError):
            OnboardLib(lib_path="/nonexistent/path/libonboard.so")


if __name__ == "__main__":
    unittest.main()

