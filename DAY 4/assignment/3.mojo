from math import exp, tanh
from random import seed, random_float64
from time import now


struct Array:
    var data: Pointer[Float64]
    var size: Int
   
    fn __init__(inout self, size: Int):
        self.size = size
        self.data = Pointer[Float64].alloc(self.size)

    fn __init__(inout self, size: Int, default_value: Float64):
        self.size = size
        self.data = Pointer[Float64].alloc(self.size)
        for i in range(self.size):
            self.data.store(i, default_value)

    fn __copyinit__(inout self, copy: Array):
        self.size = copy.size
        self.data = Pointer[Float64].alloc(self.size)
        for i in range(self.size):
            self.data.store(i, copy[i])

    fn __getitem__(self, i: Int) -> Float64:
      return self.data.load(i)

    fn __setitem__(self, i: Int, value: Float64):
      self.data.store(i, value)

    fn __del__(owned self):
      self.data.free()

    fn len(self) -> Int:
      return self.size

struct Array2D:
    var data: Pointer[Float64]
    var sizeX: Int
    var sizeY: Int
   
    fn __init__(inout self, sizeX: Int, sizeY: Int):
        self.sizeX = sizeX
        self.sizeY = sizeY
        self.data = Pointer[Float64].alloc(self.sizeX * sizeY)

    fn __init__(inout self, sizeX: Int, sizeY: Int, default_value: Float64):
        self.sizeX = sizeX
        self.sizeY = sizeY
        self.data = Pointer[Float64].alloc(self.sizeX * self.sizeY)
        for i in range(self.sizeX * self.sizeY):
            self.data.store(i, default_value)

    fn __copyinit__(inout self, copy: Array2D):
        self.sizeX = copy.sizeX
        self.sizeY = copy.sizeY
        self.data = Pointer[Float64].alloc(self.sizeX * self.sizeY)
        for i in range(self.sizeX * self.sizeY):
            self.data.store(i, copy[i])

    fn __getitem__(self, i: Int, j: Int) -> Float64:
        return self[self.sizeY * i + j]

    fn __getitem__(self, i: Int) -> Float64:
      return self.data.load(i)

    fn __setitem__(self, i: Int, value: Float64):
      self.data.store(i, value)

    fn __setitem__(self, i: Int, j: Int, value: Float64):
        self[self.sizeY * i + j] = value

    fn __del__(owned self):
      self.data.free()

    fn len(self) -> Int:
      return self.sizeY * self.sizeX

    fn rows(self) -> Int:
        return self.sizeX

    fn columns(self) -> Int:
        return self.sizeY      

struct NeuralNetwork:
    var weights: Array
    var bias: Array
    var activation_function: Int  

    fn __init__(inout self, activation_function: Int):
        self.weights = Array(6)
        self.bias = Array(3)
        self.activation_function = activation_function

        for i in range(6):
            if i < 3:
                self.bias[i] = random_float64() * 2 - 1
            self.weights[i] = random_float64() * 2 - 1

    fn feed_forward(self, x0: Float64, x1: Float64, only_predict: Bool = True) -> Array:
        var s_h0: Float64 = x0 * self.weights[0] + x1 * self.weights[1] + self.bias[0]
        var s_h1: Float64 = x0 * self.weights[2] + x1 * self.weights[3] + self.bias[1]
        var s_oo: Float64 = x0 * self.weights[4] + x1 * self.weights[5] + self.bias[2]

        var h0: Float64 = self.activation(s_h0)
        var h1: Float64 = self.activation(s_h1)
        var oo: Float64 = self.activation(s_oo)

        if only_predict:
            return Array(1, oo)
        
        var t = Array(6)
        t[0] = s_h0
        t[1] = h0
        t[2] = s_h1
        t[3] = h1
        t[4] = s_oo
        t[5] = oo

        return t

    fn mse_loss(self, y: Float64, y_true: Float64) -> Float64:
        return (y - y_true) ** 2

    fn activation(self, x: Float64) -> Float64:
        if self.activation_function == 0:
            return self.sigmoid(x)
        elif self.activation_function == 1:
            return tanh(x)
        else:
            return self.relu(x)

    fn activation_derivative(self, x: Float64) -> Float64:
        if self.activation_function == 0:
            return self.sigmoid_derivative(x)
        elif self.activation_function == 1:
            return self.tanh_derivative(x)
        else:
            return self.relu_derivative(x)

    fn sigmoid(self, x: Float64) -> Float64:
        return 1.0 / (1 + exp(-x))

    fn sigmoid_derivative(self, x: Float64) -> Float64:
        var s = self.sigmoid(x)
        return s * (1 - s)

    fn tanh_derivative(self, x: Float64) -> Float64:
        var t = tanh(x)
        return 1 - t * t

    fn relu(self, x: Float64) -> Float64:
        return max(0, x)

    fn relu_derivative(self, x: Float64) -> Float64:
        return 1 if x > 0 else 0

    fn fit(self, X: Array2D, Y: Array, learning_rate: Float64, epochs: Int):
        for i in range(epochs):
            for j in range(X.rows()):
                var y = self.feed_forward(X[j, 0], X[j, 1], False)

                var s_h0 = y[0]
                var h0 = y[1]
                var s_h1 = y[2]
                var h1 = y[3]
                var s_o0 = y[4]
                var o0 = y[5]

                var dMSE = -2 * (Y[j] - y[5])

                var dw4 = h0 * self.activation_derivative(s_o0)
                var dw5 = h1 * self.activation_derivative(s_o0)
                var db2 = self.activation_derivative(s_o0)

                var dh0 = self.weights[4] * self.activation_derivative(s_o0)
                var dh1 = self.weights[5] * self.activation_derivative(s_o0)

                var dw0 = self.weights[0] * self.activation_derivative(s_h0)
                var dw1 = self.weights[1] * self.activation_derivative(s_h0)
                var db0 = self.activation_derivative(s_h0)

                var dw2 = self.weights[2] * self.activation_derivative(s_h1)
                var dw3 = self.weights[3] * self.activation_derivative(s_h1)
                var db1 = self.activation_derivative(s_h1)

                self.weights[0] -= learning_rate * dMSE * dh0 * dw0
                self.weights[1] -= learning_rate * dMSE * dh0 * dw1
                self.bias[0] -= learning_rate * dMSE * dh0 * db0

                self.weights[2] -= learning_rate * dMSE * dh1 * dw2
                self.weights[3] -= learning_rate * dMSE * dh1 * dw3
                self.bias[1] -= learning_rate * dMSE * dh1 * db1

                self.weights[4] -= learning_rate * dMSE * dw4
                self.weights[5] -= learning_rate * dMSE * dw5
                self.bias[2] -= learning_rate * dMSE * db2

            if i % 100 == 0:
                var mse : Float64 = 0.0
                for j in range(X.rows()):
                    var y = self.feed_forward(X[j, 0], X[j, 1], True)
                    mse += self.mse_loss(y[0], Y[j])
                
                print("Epoch ", i, " loss = ", mse/X.rows())

fn get_activation_name(index: Int) -> String:
    if index == 0:
        return "Sigmoid"
    elif index == 1:
        return "Tanh"
    else:
        return "ReLU"

fn main():
    seed(now())
    var X : Array2D = Array2D(4, 2)
    var Y : Array = Array(4)

    # XOR
    X[0, 0] = 0
    X[0, 1] = 0
    Y[0] = 0

    X[1, 0] = 0
    X[1, 1] = 1
    Y[1] = 1

    X[2, 0] = 1
    X[2, 1] = 0
    Y[2] = 1

    X[3, 0] = 1
    X[3, 1] = 1
    Y[3] = 0
    
    for af in range(3):
        print("\nTraining with", get_activation_name(af), "activation function:")
        var network = NeuralNetwork(af)
        network.fit(X, Y, 0.1, 10000)
        
        print("\nPredictions:")
        for i in range(4):
            var result = network.feed_forward(X[i, 0], X[i, 1])
            print(X[i, 0].__int__(), X[i, 1].__int__(), (result[0] > 0.5).__int__())