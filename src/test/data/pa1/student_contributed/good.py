# Class definition
class ExampleClass(object):
    flag: bool = False

    # Method definition
    def process(self: "ExampleClass", numbers: [int]) -> str:
        global counter
        a: int = 0
        b: int = 1

        # Nested function
        def nested_function(b: int) -> object:
            nonlocal a
            if a < b:
                a = 10

        # Loop through the list
        for a in numbers:
            self.flag = a == 3

        nested_function(5)  # Nested function call

        counter = counter + 1

        # While loop with conditional logic
        while a >= 0:
            if self.flag:
                numbers[0] = numbers[1]
                self.flag = not self.flag
                a = a - 1
            elif string_length("Test"[0]) == 1:
                return self is not None

        return "Done"
    
# Function definition
def string_length(input_str: str) -> int:
    return len(input_str)

# Global variable
counter: int = 0

# Main execution
print(ExampleClass().process([4, 3]))