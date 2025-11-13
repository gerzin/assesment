/**
 * @brief Dummy library for the assignment. It contains a simple funtion that processes a command
 * string.
 *
 * If the command is valid, it returns an acknowledgment string "ACK: <command>".
 * If the command is invalid, it returns an error code.
 *
 * A command is considered valid if it is non-empty and contains only alphanumeric characters
 * (or ' ', '_', '-').
 *
 * The C++ version uses std::expected for error handling.
 * The C interface uses a struct to return both data and error code.
 *
 * It provides both a C++ interface and a C interface for processing commands.
 */
#pragma once

#include <expected>
#include <string_view>

/**
 * @namespace ob
 * @brief Namespace for the onboard module.
 */
namespace ob {

/**
 * @enum ErrorCode
 * @brief Error codes for the onboard module.
 */
enum class ErrorCode {
  /**
   * @brief Indicates that the command provided is invalid.
   */
  INVALID_COMMAND,
};

using Result = std::expected<std::string, ErrorCode>;
Result process_command(std::string_view command);

}  // namespace ob

extern "C" {
/**
 * @enum CErrorCode
 * @brief C-compatible error codes for the onboard module.
 */
enum CErrorCode {
  /**
   * @brief Indicates that the command provided is valid.
   */
  C_OK = 0,
  /**
   * @brief Indicates that the command provided is invalid.
   */
  C_INVALID_COMMAND = 1,
};

/**
 * @struct CResult
 * @brief C-compatible struct to hold the result of command processing.
 */
struct CResult {
  /**
   * @brief Pointer to the response data string.
   */
  char* data;
  /**
   * @brief Error code indicating the result of command processing.
   */
  enum CErrorCode error_code;
};

/**
 * @brief C interface function to process a command.
 *
 * @param command The command string to be processed.
 * @return CResult struct containing the response data and error code.
 */
CResult onboard_process_command_c(const char* command);

/**
 * @brief Frees the memory allocated for the CResult data.
 *
 * @param result The CResult struct whose data needs to be freed.
 */
void onboard_free_result(CResult result);
}
