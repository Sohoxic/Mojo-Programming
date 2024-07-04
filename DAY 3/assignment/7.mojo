# WAP to generate random numbers from 1-128 using necessary python library.
# from python import Python
# import math

# def main():
#     np = Python.import_module("builtins")
#     print(np.random.randint(1, 128))

from random.random import random_si64

def main():
  for i in range(10):
    print(random_si64(1, 128))
