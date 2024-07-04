from python import Python as p

def main():
    var py_input=p.import_module("builtins")
    s=p.evaluate("45+56")
    print(s)
    