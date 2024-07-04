var globVar = 100

def func():
    a=1
    print("a inside function",a)

def main():
    print("accesing global variable x", globVar)   #GLOBAL ACCESS
    a=10
    func()   #value not affected by main
    a+=a
    func()
    print("a outside function",a)