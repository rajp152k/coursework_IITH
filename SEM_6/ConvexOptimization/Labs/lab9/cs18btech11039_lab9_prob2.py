#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 9 - problem 2

###### ###### ###### ###### ######

import cvxpy as cp
import numpy as np

######## DATA #########
n = 5

G = np.array([
    [1.,.1,.2,.1,.0],
    [.1,1.,.1,.1,.0],
    [.2,.1,2.,.2,.2],
    [.1,.1,.2,1.,.1],
    [.0,.0,.2,.1,1.]])

sigma = 0.5 # inherent noise from receivers

pTransMax = 3.
pRecvMax = 5.

# approach
approach = '''
    The objective right now is 
    Maximise(minimum(SINR)) which is equivalent to 
    Minimise(maximum(1/SINR)) (reframing for obtaining sublevel-set formulation)

    Note that this is a quasiconvex function (max of multiple 1/xis) and now converting this to a convex set (constraint) using the parameterized alpha sub-level set and applying the bisection method.
    i.e. we minimize  alpha where alpha is set to the max of the reciprocal of all SINRs
    this is enforced via an extra constraint
    '''
print('Approach: ',approach)
# preparing vars and params
p = cp.Variable(n)
optimal_p = np.zeros(n)

alpha = cp.Parameter(1)

S = G*np.identity(n) # signal coefficients
I = G - S # Interference coefficients

recvNoise = cp.matmul(I,p) + sigma # total noise, for each receiver
recvSignal = cp.matmul(S,p) # signal power received, for each receiver

####### 
# SINR = recvSignal / recvNoise ==> defined as alpha
# obj is to minimize the maximum SINR
# defining alpha as
######

# constraints
constr = [
        recvNoise <= alpha * recvSignal,# same as alpha being the max inv SINR
        p <= pTransMax, # max transmisison power constraint
        p >= 0, # physics...
        cp.matmul(G,p) <= pRecvMax, # power saturation constraint
        p[0] + p[1] <= 4, #group 1 transmission total constraint
        p[2] + p[3] + p[4] <= 6 # groupt 2 transmission total constraint
        ]

# bisection initial bounds
u = np.array([1e5])
l = np.array([0.])

alpha.value = l # setting initial value of alpha (first guess of feasible SINR)

# checking if bounds are valid using prob.status
obj = cp.Minimize(alpha) # sentinel objective, just to enforce cascading feasibility constraints, alpha is a constant



thr = 0.05
satisfied = False

# reiterating until threshold satisfied
while not satisfied:
    alpha.value = (u+l)/2

    if u-l<=thr:
        # this update won't differ more than thr
        satisfied = True
        continue

    prob = cp.Problem(obj,constr)
    prob.solve()

    if prob.status == 'optimal':
        u = alpha.value
        optimal_p = p.value
    else:
        l = alpha.value
   
print(f'(approximately) Optimal transmitter powers are {np.round(optimal_p,2)}')
