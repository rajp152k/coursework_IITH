#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 1.1 : Diet Problem

import numpy as np
import cvxpy as cp

n = 3 # num var
m = 3 # num properties

food_items = ['corn','milk','bread']

A = np.array([[0.18,0.23,0.05],[107,500,0],[72,121,65]])
# array of cost, vit_a, cals for the food items

# Formulation
n_i = cp.Variable((n,1))

cost = (A@n_i)[0]
vit_A = (A@n_i)[1]
cal = (A@n_i)[2]

obj = cp.Minimize(cost)

constraints = [ vit_A <= 50000,vit_A >= 5000,
                cal <= 2250, cal >= 2000,
                n_i<= 10, n_i >=0]
                
prob = cp.Problem(obj,constraints)

prob.solve()
                 
sol = np.rint(n_i.value.flatten())
# rouding servings to nearest integers

print('Optimum solution')
for food,num in zip(food_items,sol):
    print(f'{food} : {num}')

print(f'@ cost : $ {(A@sol)[0]}')
