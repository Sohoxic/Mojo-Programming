import time

numbers = list(range(1,1000001))

start = time.time()
total = sum(numbers)
end = time.time()

print("time taken in python is: ", end - start)