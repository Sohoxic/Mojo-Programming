fn main():
    var a: Int = 0
    var b: Int = 1
    print(a)
    print(b)
    # var cnt: Int = 2
    for _ in range(2,20):
        var next: Int = a + b
        print(next)
        a = b
        b = next
        # cnt = cnt+1
    # print(cnt)


