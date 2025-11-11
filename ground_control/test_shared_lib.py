#!/usr/bin/env python3
"""
Test the onboard shared library using ctypes.
This demonstrates calling C++ code from Python via the C interface.
"""

import ctypes
from pathlib import Path
from typing import Optional


class OnboardLib:
    """Wrapper for the onboard shared library."""
    
    # Define the C structures and enums
    class CErrorCode(ctypes.c_int):
        C_OK = 0
        C_INVALID_COMMAND = 1
    
    class CResult(ctypes.Structure):
        _fields_ = [
            ("data", ctypes.c_char_p),
            ("error_code", ctypes.c_int),
        ]
    
    def __init__(self, lib_path: Optional[str] = None):
        """Initialize the library wrapper."""
        if lib_path is None:
            # Default to bazel-bin location
            lib_path = Path(__file__).parent.parent / "bazel-bin" / "onboard" / "libonboard.so"
        
        self.lib_path = Path(lib_path)
        if not self.lib_path.exists():
            raise FileNotFoundError(f"Shared library not found: {self.lib_path}")
        
        # Load the shared library
        self.lib = ctypes.CDLL(str(self.lib_path))
        
        # Configure the function signatures
        self.lib.onboard_process_command_c.argtypes = [ctypes.c_char_p]
        self.lib.onboard_process_command_c.restype = self.CResult
        
        self.lib.onboard_free_result.argtypes = [self.CResult]
        self.lib.onboard_free_result.restype = None
    
    def process_command(self, command: str) -> dict:
        """
        Process a command through the onboard module.
        
        Args:
            command: The command string to process
            
        Returns:
            Dictionary with 'success' (bool), 'response' (str)
        """
        # Call the C function
        result = self.lib.onboard_process_command_c(command.encode('utf-8'))
        
        # Extract the response
        response = result.data.decode('utf-8') if result.data else ""
        success = (result.error_code == self.CErrorCode.C_OK)
        
        # Free the allocated memory using the library's free function
        self.lib.onboard_free_result(result)
        
        return {
            'success': success,
            'response': response,
            'command': command
        }


def main():
    """Test the shared library."""
    print("=" * 60)
    print("Onboard Shared Library Test (Python + ctypes)")
    print("=" * 60)
    print()
    
    try:
        # Initialize the library
        onboard = OnboardLib()
        print(f"✓ Loaded library: {onboard.lib_path}")
        print()
        
        # Test commands
        test_commands = [
            "POWER_ON",
            "SET_ALTITUDE 1000",
            "GET_STATUS",
            "DEPLOY_PAYLOAD",
            "invalid@command!",  # Should fail - special character
            "",  # Should fail - empty
            "TEST-WITH_underscore",  # Should succeed
        ]
        
        print("Testing commands:")
        print("-" * 60)
        
        for cmd in test_commands:
            result = onboard.process_command(cmd)
            status = "✓" if result['success'] else "✗"
            print(f"\n{status} Command: '{cmd}'")
            print(f"  Response: {result['response']}")
        
        print("\n" + "-" * 60)
        print("\n✅ All tests completed!")
        
    except FileNotFoundError as e:
        print(f"✗ Error: {e}")
        print("\nTo build the shared library:")
        print("  bazel build //onboard:libonboard.so")
        return 1
    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
