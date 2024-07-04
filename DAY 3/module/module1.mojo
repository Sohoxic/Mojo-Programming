@value
struct MyPair:
    var firstname: String
    var age: Int

    def dump(self):
        print(self.firstname, " ", self.age)
