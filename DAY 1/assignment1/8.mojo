from python import Python as p

def main():
    ip = p.import_module("builtins")
    a = atol(ip.input("Enter number 1 "))
    b = atol(ip.input("Enter number 2 "))

    if a == b:
        print("a is equal to b")
    elif a < b:
        print("a is less than b")
    else:
        print("a is greater than b")


