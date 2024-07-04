from python import Python as p
def calculatecgpa():
    pyin=p.import_module("builtins")
    var totalmarks:Int=0
    for i in range(5):
        userin=atol(pyin.input("enter marks"))
        totalmarks+=userin
    return (totalmarks/50)

def main():
    print(calculatecgpa())