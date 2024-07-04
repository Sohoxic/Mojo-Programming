struct MyPair:
    var first: Int
    var second: Int
    fn __init__(inout self, first: Int, second: Int):
        self.first = first
        self.second = second

    fn get_sum(self) -> Int:
        return self.first + self.second

def main():
    var mine = MyPair(1,2)
    print(mine.get_sum())
