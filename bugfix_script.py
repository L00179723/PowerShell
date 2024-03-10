# bugfix_script.py

def divide_numbers(a, b):
    """
    Function to divide two numbers.
    
    Args:
        a (float): The numerator.
        b (float): The denominator.
    
    Returns:
        float: The result of the division.
    """
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# Test the function
result = divide_numbers(10, 2)
print("Result of division:", result)
