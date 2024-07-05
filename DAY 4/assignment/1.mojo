from sys.intrinsics import sizeof
from memory import memset_zero
from time import now

struct Matrix:
    var data: DTypePointer[DType.float32]
    var rows: Int
    var cols: Int

    fn __init__(inout self, rows: Int, cols: Int):
        self.rows = rows
        self.cols = cols
        self.data = DTypePointer[DType.float32].alloc(rows * cols)
        memset_zero(self.data, rows * cols)

    fn __del__(owned self):
        self.data.free()

    fn __getitem__(self, row: Int, col: Int) -> Float32:
        return self.data.load(row * self.cols + col)

    fn __setitem__(self, row: Int, col: Int, val: Float32):
        self.data.store(row * self.cols + col, val)

fn min(a: Int, b: Int) -> Int:
    if a < b:
        return a
    return b

fn transpose_unoptimized(inout result: Matrix, input: Matrix):
    for i in range(input.rows):
        for j in range(input.cols):
            result[j, i] = input[i, j]

fn transpose_optimized(inout result: Matrix, input: Matrix):
    var block_size = 16
    
    for ii in range(0, input.rows, block_size):
        for jj in range(0, input.cols, block_size):
            for i in range(ii, min(ii + block_size, input.rows)):
                var row_ptr = input.data.offset(i * input.cols + jj)
                for j in range(jj, min(jj + block_size, input.cols)):
                    result[j, i] = row_ptr.load(j - jj)

fn benchmark(func: fn(inout Matrix, Matrix) -> None, inout result: Matrix, input: Matrix) -> Float64:
    var start = now()
    func(result, input)
    var end = now()
    return Float64(end - start) / 1e9  # Convert nanoseconds to seconds

fn main():
    var n = 128  # Size of matrix as specified in the problem
    var input = Matrix(n, n)
    var result = Matrix(n, n)

    # Initialize input matrix
    for i in range(n):
        for j in range(n):
            input[i, j] = Float32(i * n + j)

    # Benchmark unoptimized transpose
    var unoptimized_time = benchmark(transpose_unoptimized, result, input)

    # Reset result matrix
    for i in range(n):
        for j in range(n):
            result[i, j] = 0

    # Benchmark optimized transpose
    var optimized_time = benchmark(transpose_optimized, result, input)

    print("Matrix size:", n, "x", n)
    print("Unoptimized transpose time:", unoptimized_time, "seconds")
    print("Optimized transpose time:", optimized_time, "seconds")
    print("Speedup:", unoptimized_time / optimized_time, "x")