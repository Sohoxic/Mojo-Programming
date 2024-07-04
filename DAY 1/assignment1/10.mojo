from python import Python as p

def main():
    ip = p.import_module("builtins")
    user_input = ip.input("Enter mark for subject")
    print(user_input)
