from python import Python as p
from collections import List

def main():

    ip = p.import_module("builtins")
    marks = ip.list()
    for _ in range(5):
        mark = ip.input("Enter mark for subject")  # Convert input to integer
        marks.append(mark)
        
    sum = 0
    for i in marks:
        sum+=atol(i)
        ip.type(sum)
    print(sum)
    average = sum/5

    if average >= 90:
        print("Grade: A")
    elif average >= 80:
        print("Grade: B")
    elif average >= 70:
        print("Grade: C")
    elif average >= 60:
        print("Grade: D")
    else:
        print("Grade: F")


