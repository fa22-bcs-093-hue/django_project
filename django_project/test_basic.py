"""Basic tests to ensure pytest finds tests."""

def test_basic_math():
    """Test basic math operations."""
    assert 2 + 2 == 4
    assert 3 * 3 == 9
    assert 10 - 5 == 5

def test_string_operations():
    """Test string operations."""
    test_string = "Hello, World!"
    assert "Hello" in test_string
    assert len(test_string) == 13
    assert test_string.upper() == "HELLO, WORLD!"

def test_list_operations():
    """Test list operations."""
    test_list = [1, 2, 3, 4, 5]
    assert len(test_list) == 5
    assert 3 in test_list
    assert max(test_list) == 5
    assert min(test_list) == 1

def test_dictionary_operations():
    """Test dictionary operations."""
    test_dict = {"name": "Django", "version": "3.2"}
    assert "name" in test_dict
    assert test_dict["name"] == "Django"
    assert len(test_dict) == 2
