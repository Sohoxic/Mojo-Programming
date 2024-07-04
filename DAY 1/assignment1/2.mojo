fn factorial(n: Int) -> Int:
    var result: Int = 1
    # print("value of n is ", n)
    # print()
    # print("value of result is ", result)
    # print()
    for i in range(1, n+1):
        result *= i
    return result

fn main():
    var num: Int = 5
    print("Factorial: ", factorial(num))


