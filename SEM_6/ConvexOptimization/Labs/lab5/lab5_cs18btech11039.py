#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 5

#################################
import numpy as np
import cvxpy as cp
import pandas as pd

nf = 3 # num factories
nd = 5 # num destinations

Fs = np.array([40,50,45]) # Factory maximum supply
Dd = np.array([45,20,30,30,10]) #destation minimum demands

C =  np.array([ [8,6,10,9,8],
                [9,12,13,7,5],
                [14,9,16,5,2] ]) # costs

Qs = cp.Variable((nf,nd)) #Quantities supplied

supply = Qs @ np.ones(nd) # summing up supply of a factory
demand = (np.ones(nf) @ Qs) # summing up goods recieved by a destination

cost = cp.sum(cp.multiply(C,Qs)) # hadamard product

constraints = [ supply==Fs,
                demand>=Dd,
                Qs>=0]# not necessary, but anyway...

prob = cp.Problem(cp.Minimize(cost),constraints)
prob.solve()

### Solution

strat = pd.DataFrame(np.round(Qs.value,2),index = [f'Factory {i+1}' for i in range(nf)],columns =  [f'Dest {j+1}' for j in range(nd)])

print(f'optimal supply strategy was found to be')
print()
print(strat)
print()
print(f'at an incurred cost of {np.round(cost.value,2)}') 
