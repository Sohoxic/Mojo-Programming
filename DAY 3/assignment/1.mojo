from python import Python as p
import math

# Function to find the square root of an integer
def find_root(x: Int):
    return math.sqrt(x)

# Function to find the log10 of a SIMD vector of int16 values
def find_log(x:Float16):
    mt=p.import_module("math")
    print("log",mt.log(x))

# Function to find the sine of a SIMD vector of int16 values
def find_sin(x=0.00):
    mt=p.import_module("math")
    print ("sin value",mt.sin(0.00))

def find_cos(x=0.00):
    mt=p.import_module("math")
    print ("cos value",mt.cos(0.00))

# Function to find the GCD of two integers
def find_gcd(x: Int, y: Int) -> Int:
    return math.gcd(x, y)

# Function to find the factorial of an integer
def find_factorial(x: Int) -> Int:
    return math.factorial(x)

# Function to find the LCM of two integers
def find_lcm(x: Int, y: Int) -> Int:
    return math.lcm(x, y)

# Function to find the gamma of a SIMD vector of float16 values
def find_gamma(x: SIMD[DType.float16, 4]) -> SIMD[DType.float16, 4]:
    return math.gamma(x)

def find_asin(x=0.00):
    mt=p.import_module("math")
    print ("asin value",mt.asin(0.00))

# Function to find the arccosine of a SIMD vector of float16 values
def find_acos(x: SIMD[DType.float16, 4]) -> SIMD[DType.float16, 4]:
    return math.acos(x)

def main():
    # Initializing a SIMD vector with float16 values for testing
    vector_float16 = SIMD[DType.float16, 4](1.0, 2.0, 3.0, 4.0)
    vector_int16 = SIMD[DType.int16, 4](1, 2, 3, 4)
    result_acos = find_acos(vector_float16)
    print("acos:", result_acos)
    find_sin()
    find_log(10)
    result_gamma = find_gamma(vector_float16)
    print("gamma:", result_gamma)
    find_asin()
    find_cos()
    # Testing integer functions
    print("gcd:", find_gcd(24, 36))
    print("factorial:", find_factorial(5))
    print("lcm:", find_lcm(12, 15))
    print("sqrt:", find_root(16))

