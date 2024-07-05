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
    var weights1: Array
    var bias1: Array
    var weights2: Array
    var bias2: Array
    var activation_function: Int

    fn __init__(inout self, activation_function: Int):
        self.weights1 = Array(9)  # 3 inputs * 3 hidden nodes
        self.bias1 = Array(3)
        self.weights2 = Array(3)  # 3 hidden nodes * 1 output
        self.bias2 = Array(1)
        self.activation_function = activation_function

        for i in range(9):
            self.weights1[i] = random_float64() * 2 - 1
        for i in range(3):
            self.bias1[i] = random_float64() * 2 - 1
        for i in range(3):
            self.weights2[i] = random_float64() * 2 - 1
        self.bias2[0] = random_float64() * 2 - 1

    fn feed_forward(self, x0: Float64, x1: Float64, x2: Float64, only_predict: Bool = True) -> Array:
        var s_h0: Float64 = x0 * self.weights1[0] + x1 * self.weights1[1] + x2 * self.weights1[2] + self.bias1[0]
        var s_h1: Float64 = x0 * self.weights1[3] + x1 * self.weights1[4] + x2 * self.weights1[5] + self.bias1[1]
        var s_h2: Float64 = x0 * self.weights1[6] + x1 * self.weights1[7] + x2 * self.weights1[8] + self.bias1[2]

        var h0: Float64 = self.activation(s_h0)
        var h1: Float64 = self.activation(s_h1)
        var h2: Float64 = self.activation(s_h2)

        var s_o: Float64 = h0 * self.weights2[0] + h1 * self.weights2[1] + h2 * self.weights2[2] + self.bias2[0]
        var o: Float64 = self.activation(s_o)

        if only_predict:
            return Array(1, o)

        var t = Array(7)
        t[0] = s_h0
        t[1] = h0
        t[2] = s_h1
        t[3] = h1
        t[4] = s_h2
        t[5] = h2
        t[6] = o

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
                var y = self.feed_forward(X[j, 0], X[j, 1], X[j, 2], False)

                var s_h0 = y[0]
                var h0 = y[1]
                var s_h1 = y[2]
                var h1 = y[3]
                var s_h2 = y[4]
                var h2 = y[5]
                var s_o = y[6]
                var o = y[6]

                var dMSE = -2 * (Y[j] - o)

                var dw2_0 = h0 * self.activation_derivative(s_o)
                var dw2_1 = h1 * self.activation_derivative(s_o)
                var dw2_2 = h2 * self.activation_derivative(s_o)
                var db2 = self.activation_derivative(s_o)

                var dh0 = self.weights2[0] * self.activation_derivative(s_o)
                var dh1 = self.weights2[1] * self.activation_derivative(s_o)
                var dh2 = self.weights2[2] * self.activation_derivative(s_o)

                var dw1_0 = X[j, 0] * self.activation_derivative(s_h0)
                var dw1_1 = X[j, 1] * self.activation_derivative(s_h0)
                var dw1_2 = X[j, 2] * self.activation_derivative(s_h0)
                var db1_0 = self.activation_derivative(s_h0)

                var dw1_3 = X[j, 0] * self.activation_derivative(s_h1)
                var dw1_4 = X[j, 1] * self.activation_derivative(s_h1)
                var dw1_5 = X[j, 2] * self.activation_derivative(s_h1)
                var db1_1 = self.activation_derivative(s_h1)

                var dw1_6 = X[j, 0] * self.activation_derivative(s_h2)
                var dw1_7 = X[j, 1] * self.activation_derivative(s_h2)
                var dw1_8 = X[j, 2] * self.activation_derivative(s_h2)
                var db1_2 = self.activation_derivative(s_h2)

                self.weights2[0] -= learning_rate * dMSE * dw2_0
                self.weights2[1] -= learning_rate * dMSE * dw2_1
                self.weights2[2] -= learning_rate * dMSE * dw2_2
                self.bias2[0] -= learning_rate * dMSE * db2

                self.weights1[0] -= learning_rate * dMSE * dh0 * dw1_0
                self.weights1[1] -= learning_rate * dMSE * dh0 * dw1_1
                self.weights1[2] -= learning_rate * dMSE * dh0 * dw1_2
                self.bias1[0] -= learning_rate * dMSE * dh0 * db1_0

                self.weights1[3] -= learning_rate * dMSE * dh1 * dw1_3
                self.weights1[4] -= learning_rate * dMSE * dh1 * dw1_4
                self.weights1[5] -= learning_rate * dMSE * dh1 * dw1_5
                self.bias1[1] -= learning_rate * dMSE * dh1 * db1_1

                self.weights1[6] -= learning_rate * dMSE * dh2 * dw1_6
                self.weights1[7] -= learning_rate * dMSE * dh2 * dw1_7
                self.weights1[8] -= learning_rate * dMSE * dh2 * dw1_8
                self.bias1[2] -= learning_rate * dMSE * dh2 * db1_2

            if i % 100 == 0:
                var mse: Float64 = 0.0
                for j in range(X.rows()):
                    var y = self.feed_forward(X[j, 0], X[j, 1], X[j, 2], True)
                    mse += self.mse_loss(y[0], Y[j])

                print("Epoch ", i, " loss = ", mse / X.rows())

fn get_activation_name(index: Int) -> String:
    if index == 0:
        return "Sigmoid"
    elif index == 1:
        return "Tanh"
    else:
        return "ReLU"

fn main():
    seed(now())

    var X_OR: Array2D = Array2D(8, 3)
    var Y_OR: Array = Array(8)

    # Training data for a 3-input OR gate
    X_OR[0, 0] = 0
    X_OR[0, 1] = 0
    X_OR[0, 2] = 0
    Y_OR[0] = 1

    X_OR[1, 0] = 0
    X_OR[1, 1] = 0
    X_OR[1, 2] = 1
    Y_OR[1] = 1

    X_OR[2, 0] = 0
    X_OR[2, 1] = 1
    X_OR[2, 2] = 0
    Y_OR[2] = 1

    X_OR[3, 0] = 0
    X_OR[3, 1] = 1
    X_OR[3, 2] = 1
    Y_OR[3] = 1

    X_OR[4, 0] = 1
    X_OR[4, 1] = 0
    X_OR[4, 2] = 0
    Y_OR[4] = 1

    X_OR[5, 0] = 1
    X_OR[5, 1] = 0
    X_OR[5, 2] = 1
    Y_OR[5] = 1

    X_OR[6, 0] = 1
    X_OR[6, 1] = 1
    X_OR[6, 2] = 0
    Y_OR[6] = 1

    X_OR[7, 0] = 1
    X_OR[7, 1] = 1
    X_OR[7, 2] = 1
    Y_OR[7] = 0

    for af in range(3):
        print("\nTraining OR gate with", get_activation_name(af), "activation function:")
        var network = NeuralNetwork(af)
        network.fit(X_OR, Y_OR, 0.1, 10000)

        print("\nPredictions for NAND gate:")
        for i in range(8):
            var result = network.feed_forward(X_OR[i, 0], X_OR[i, 1], X_OR[i, 2])
            print(X_OR[i, 0].__int__(), X_OR[i, 1].__int__(), X_OR[i, 2].__int__(), (result[0] > 0.5).__int__())

