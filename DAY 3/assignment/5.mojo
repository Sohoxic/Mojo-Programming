# WAP to form 10 numbers from SIMD datatype and calculate its square. Also print the original and square values of the numbers.

fn main():
    var vector = SIMD[DType.int32, 16](1,2,3,4,5,6,7,8,9,10)
    for i in range(10):
        print(vector[i], end=" ")
    print()
    vector = vector * vector
    for i in range(10):
        print(vector[i], end=" ")