#include "onboard.hpp"

#include <algorithm>
#include <cstring>
#include <format>

namespace ob {

constexpr bool isValidCommand(std::string_view command) noexcept {
  if (command.empty()) {
    return false;
  }

  return std::ranges::all_of(command, [](char c) constexpr noexcept {
    return std::isalnum(static_cast<unsigned char>(c)) || c == ' ' || c == '_' || c == '-';
  });
}

Result process_command(std::string_view command) {
  if (!isValidCommand(command)) {
    return std::unexpected(ErrorCode::INVALID_COMMAND);
  }

  return std::format("ACK: {}", command);
}

}  // namespace ob

// C interface implementation
extern "C" {

CResult onboard_process_command_c(const char* command) {
  if (!command) {
    return CResult{nullptr, C_INVALID_COMMAND};
  }

  auto result = ob::process_command(command);

  if (result.has_value()) {
    const auto& response = result.value();
    char* data = static_cast<char*>(malloc(response.size() + 1));
    if (data) {
      std::memcpy(data, response.data(), response.size());
      data[response.size()] = '\0';
    }
    return CResult{data, C_OK};
  } else {
    const char* error_msg = "NACK: Invalid command format";
    char* data = static_cast<char*>(malloc(std::strlen(error_msg) + 1));
    if (data) {
      std::strcpy(data, error_msg);
    }
    return CResult{data, C_INVALID_COMMAND};
  }
}

void onboard_free_result(CResult result) {
  if (result.data) {
    free(result.data);
  }
}
}
