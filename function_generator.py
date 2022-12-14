import random as r
from inspect import signature

def generate_min(arg1, arg2):
    return "min(" + arg1 + ", " + arg2 + ")"

def generate_sin():
    rand = r.random()
    return "sin(x)" if rand > 0.5 else "sin(y)"

def generate_cos():
    rand = r.random()
    return "cos(x)" if rand > 0.5 else "cos(y)"

def generate_exponential():
    power = r.randint(2, 5)
    rand = r.random()
    return "pow(" + "x, " + str(power) + ")" if rand > 0.5 else "pow(" + "y, " + str(power) + ")"

def generate_function(probabilities):
    return "return new PVector(" + generate_exponential() + ", " + generate_exponential() + ")"

terms = ["x", "y", "x + y", "x - y", "x * y", "sqrt(pow(x, 2) + pow(y, 2))"]
functions = [generate_min, generate_sin, generate_cos, generate_exponential]

for func in functions:
    print(len(signature(func).parameters))



function = generate_function(0)

print(function)

f = open('vector_field_walk.pde', 'r')
print(f)
lines = []
i = 0
target = -1
for line in f:
    lines.append(line)
    if (line == "  public PVector getDirection(float x, float y){\n"):
        target = i + 1
    i += 1

if (target != -1):
    lines[target] = function

f.close()