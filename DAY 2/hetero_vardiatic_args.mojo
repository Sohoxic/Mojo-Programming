fn count_many_things[*ArgTypes: Intable](*args: *ArgTypes) -> Int:
    var total = 0

    @parameter
    fn add[Type: Intable](value: Type):
        total += int(value)

    args.each[add]()
    return total

def main():
    print(count_many_things(5, 11.7, 12))