#include "onboard/onboard.hpp"

#include <gtest/gtest.h>

// Test fixture for onboard module tests
class OnboardTest : public ::testing::Test {
 protected:
  void SetUp() override {
    // Setup code if needed
  }

  void TearDown() override {
    // Cleanup code if needed
  }
};

// C++ interface tests

TEST_F(OnboardTest, ValidCommand_Simple) {
  auto result = ob::process_command("POWER_ON");

  ASSERT_TRUE(result.has_value());
  EXPECT_EQ(result.value(), "ACK: POWER_ON");
}

TEST_F(OnboardTest, ValidCommand_WithSpaces) {
  auto result = ob::process_command("SET ALTITUDE 1000");

  ASSERT_TRUE(result.has_value());
  EXPECT_EQ(result.value(), "ACK: SET ALTITUDE 1000");
}

TEST_F(OnboardTest, InvalidCommand_Empty) {
  auto result = ob::process_command("");

  ASSERT_FALSE(result.has_value());
  EXPECT_EQ(result.error(), ob::ErrorCode::INVALID_COMMAND);
}

TEST_F(OnboardTest, InvalidCommand_SpecialCharacter) {
  auto result = ob::process_command("invalid@command");

  ASSERT_FALSE(result.has_value());
  EXPECT_EQ(result.error(), ob::ErrorCode::INVALID_COMMAND);
}

// C interface tests

TEST_F(OnboardTest, CInterface_ValidCommand) {
  CResult result = onboard_process_command_c("POWER_ON");

  ASSERT_NE(result.data, nullptr);
  EXPECT_EQ(result.error_code, C_OK);
  EXPECT_STREQ(result.data, "ACK: POWER_ON");

  onboard_free_result(result);
}

TEST_F(OnboardTest, CInterface_InvalidCommand) {
  CResult result = onboard_process_command_c("invalid@command");

  ASSERT_NE(result.data, nullptr);
  EXPECT_EQ(result.error_code, C_INVALID_COMMAND);
  EXPECT_STREQ(result.data, "NACK: Invalid command format");

  onboard_free_result(result);
}

TEST_F(OnboardTest, CInterface_NullCommand) {
  CResult result = onboard_process_command_c(nullptr);

  EXPECT_EQ(result.data, nullptr);
  EXPECT_EQ(result.error_code, C_INVALID_COMMAND);
}
