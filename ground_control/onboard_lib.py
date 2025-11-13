"""
Wrapper for the onboard shared library.
Provides Python interface to C++ onboard module via ctypes.
"""

import ctypes
from pathlib import Path


class OnboardLib:
    """Wrapper for the onboard shared library."""

    class CErrorCode(ctypes.c_int):
        C_OK = 0
        C_INVALID_COMMAND = 1

    class CResult(ctypes.Structure):
        _fields_ = [
            ("data", ctypes.c_char_p),
            ("error_code", ctypes.c_int),
        ]

    def __init__(self, lib_path: str | Path | None = None):
        """Initialize the library wrapper."""
        if lib_path is None:
            # Try to find library in Bazel runfiles or standard location
            current_dir = Path(__file__).parent

            possible_paths = [
                current_dir.parent / "onboard" / "libonboard.so",
                current_dir / "libonboard.so",
                current_dir.parent / "bazel-bin" / "onboard" / "libonboard.so",
            ]

            lib_path = None
            for path in possible_paths:
                if path.exists():
                    lib_path = path
                    break

            if lib_path is None:
                raise FileNotFoundError(
                    f"Shared library not found. Tried: {[str(p) for p in possible_paths]}"
                )

        self.lib_path = Path(lib_path)
        if not self.lib_path.exists():
            raise FileNotFoundError(f"Shared library not found: {self.lib_path}")

        self.lib = ctypes.CDLL(str(self.lib_path))

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
            Dictionary with 'success' (bool), 'response' (str), 'command' (str)
        """
        result = self.lib.onboard_process_command_c(command.encode("utf-8"))

        response = result.data.decode("utf-8") if result.data else ""
        success = result.error_code == self.CErrorCode.C_OK

        self.lib.onboard_free_result(result)

        return {"success": success, "response": response, "command": command}
