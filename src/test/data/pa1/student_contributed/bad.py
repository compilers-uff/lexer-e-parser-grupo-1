# Error: Invalid assignment inside parentheses
x = (y = 2)

# Error: Invalid keyword usage in function call (assignment in print)
print(x = 1)

# Error: Invalid return type in function definition
def bar(param1, param2) -> 1:  # Return type must be a valid type, not a literal
    z: int = param1
    return 1

# Error: Invalid logical operator (&& is not valid in Python)
3 == 4 or (not False && True)
