#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 2.1 : Currency Exchange

###############INPUT####################
import numpy as np

# Exchange rate data.
tickers = ["USD", "EUR", "GBP", "CAD", "JPY", "CNY", "RUB", "MXN", "INR", "BRL"]
n = len(tickers)
F = np.zeros((n, n))
# USD
data = ([1.0, 0.87, 0.76, 1.31, 108.90, 6.72, 65.45, 19.11, 71.13, 3.69],
# EUR
[1.0, 0.88, 1.51, 125.15, 7.72, 75.23, 21.96, 81.85, 4.24],
# GBP
[1.0, 1.72, 142.94, 8.82, 85.90, 25.08, 93.50, 4.84],
# CAD
[1.0, 82.93, 5.11, 49.82, 14.54, 54.23, 2.81],
# JPY
[1.0, 0.062, 0.60, 0.18, 0.65, 0.034],
# CNY
[1.0, 9.74, 2.85, 10.61, 0.55],
# RUB
[1.0, 0.29, 1.09, 0.056],
# MXN
[1.0, 3.73, 0.19],
# INR
[1.0, 0.052],
# BRL
[1.0])
for i in range(n):
    F[i,i:] = data[i]
for j in range(n):
    for i in range(j+1,n):
        F[i,j] = 1.035/F[j,i]
        
# Initial and final portfolios.
c_req = np.arange(1,n+1)
c_req = 1e4*c_req/c_req.sum()
c_init = c_req[::-1]

###############PREPROCESSING###########

worths_USD = np.array([np.sqrt(F[j,0]/F[0,j]) for j in range(n)])
# 0 indexed F

################FORMULATION############

import cvxpy as cp

X = cp.Variable((n,n)) #record of proposed exchanges

def portfolio_worth_USD(portfolio):
    return cp.sum(cp.multiply(portfolio,worths_USD))

# c_spent = cp.sum(X,axis=1) # value of the exchange
# c_gain = cp.sum((X/F),axis=0) # value of a currency gained 
c_spent = X.T @ np.ones(n)
c_gain = (X/F) @ np.ones(n)
# cp.sum along axis is buggy for CVXPY's side and returns and inf object upon solving even though the same thing is being done.

c_proposed  = c_init + c_gain - c_spent

# final objective
cost =  portfolio_worth_USD(c_init) - portfolio_worth_USD(c_proposed) 

objective = cp.Minimize(cp.sum(cost))
constraints = [cp.diag(X) == 0, X >= 0, c_spent <= c_init, c_proposed>=c_req]

problem = cp.Problem(objective,constraints)

problem.solve()

############OUTPUT#####################

print(f'Minimum cost for a satisfactory transaction : {cost.value}')
print(f'with a rounded exchange summary matrix as ')
print(np.round(X.value,decimals = 1))

