from time import now
from python import Python

fn main():
    var py = Python()
    
    # Create a large list of numbers
    var numbers = py.eval("list(range(1, 1000001))")
    
    # Calculate sum in Mojo
    var start_time = now()
    var total: Int64 = 0
    for i in range(1, 1000001):
        total += i
    var end_time = now()
    
    # Calculate execution time
    var execution_time_mojo = Float64(end_time - start_time) / 1e9
    
    print("Sum in Mojo:", total)
    print("Execution Time in Mojo:", execution_time_mojo, "seconds")