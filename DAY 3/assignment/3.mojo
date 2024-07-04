@value
struct Pair:
    var name: String
    var age: Int
    var emailId: String

    def validate_date(self):
        if(self.name == "Admin" and self.age>=18):
            print("Admin login")
        else:
            print("wrong credentials")
        



fn main() raises:
    var x1 = Pair("Admin", 20, "sarkarsoham73@gmail.com")
    x1.validate_date()
    

