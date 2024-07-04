fn slice(text: String, start: Int, end: Int) -> String:
    return text[start:end]

fn main():
    var text: String = "Hello, Mojo!"
    var substring1: String = slice(text, 0, 5)
    print(substring1)  

