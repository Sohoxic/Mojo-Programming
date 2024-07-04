from python import Python as p

def main():
    pd = p.import_module("pandas")
    data = pd.read_csv("day.csv")
    print(data)
