"""
Pytest configuration and shared fixtures for ground_control tests.
"""

import pytest

from ground_control.onboard import OnboardLib


@pytest.fixture(scope="session")
def onboard_session():
    """
    Session-scoped fixture providing a single OnboardLib instance
    shared across all tests in the session.
    """
    return OnboardLib()


@pytest.fixture(scope="module")
def onboard():
    """
    Module-scoped fixture providing an OnboardLib instance
    shared across all tests in a module.
    """
    return OnboardLib()


@pytest.fixture
def onboard_instance():
    """
    Function-scoped fixture providing a fresh OnboardLib instance
    for each test that needs isolation.
    """
    return OnboardLib()
