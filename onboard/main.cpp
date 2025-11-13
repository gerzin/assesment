#include <argparse/argparse.hpp>
#include <print>

#include "onboard.hpp"
#include "spdlog/spdlog.h"

int main(int argc, char* argv[]) {
  argparse::ArgumentParser program("onboard_module");
  program.add_description("Dummy program that returns an ACK with the command received.");
  program.add_argument("command").help("Command to be processed by the onboard module");

  try {
    program.parse_args(argc, argv);
  } catch (const std::exception& err) {
    spdlog::error("Argument parsing error: {}", err.what());
    std::cerr << program;
    return 1;
  }

  auto command{program.get<std::string>("command")};
  spdlog::info("Starting the onboarding module with command: {}", command);

  ob::Result result{ob::process_command(command)};

  if (result.has_value()) {
    spdlog::info("Onboard module response: {}", result.value());
    std::print("{}", result.value());
  } else {
    spdlog::error("Onboard module error: Invalid command");
    return static_cast<int>(ob::ErrorCode::INVALID_COMMAND);
  }
}
