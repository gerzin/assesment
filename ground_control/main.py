import argparse


def parse_args():
    parser = argparse.ArgumentParser(description="Ground Control Main Application")
    parser.add_argument(
        "--message", type=str, help="Message to send to the onboarding module", required=True
    )

    return parser.parse_args()


def main():
    print("Hello from ground-control!")


if __name__ == "__main__":
    main()
