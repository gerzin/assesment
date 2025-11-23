import argparse

from ground_control.onboard.client import OnboardLib


def parse_args():
    parser = argparse.ArgumentParser(description="Ground Control Main Application")
    parser.add_argument(
        "--message", type=str, help="Message to send to the onboarding module", required=True
    )

    return parser.parse_args()


def main():
    args = parse_args()

    onboard_lib = OnboardLib()
    result = onboard_lib.process_command(args.message)

    if result["success"]:
        print(f"Command processed successfully: {result['response']}")
    else:
        print(f"Command processing failed: {result['response']}")


if __name__ == "__main__":
    main()
