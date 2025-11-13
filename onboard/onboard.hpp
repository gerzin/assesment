#pragma once

#include <expected>
#include <string_view>

namespace ob {
enum class ErrorCode {
  INVALID_COMMAND,
};

using Result = std::expected<std::string, ErrorCode>;
Result process_command(std::string_view command);

}  // namespace ob

extern "C" {
enum CErrorCode {
  C_OK = 0,
  C_INVALID_COMMAND = 1,
};

struct CResult {
  char* data;
  enum CErrorCode error_code;
};

CResult onboard_process_command_c(const char* command);

void onboard_free_result(CResult result);
}
