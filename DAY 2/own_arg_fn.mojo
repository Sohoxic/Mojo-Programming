fn take_text(owned text: String):
    text+= "!"
    print(text)

fn my_function():
    var message: String = "Hello"
    take_text(message^)
    # message+="hiii"
    # print(message)

fn main():
    my_function()