#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 9 - problem 1

###### ###### ###### ###### ######

import cvxpy as cp
import numpy as np

######## FORMULATION #############
formulation = '''
Note that h,w,d are always positive; replacing them with exp(h),exp(w),exp(d) respectively will not alter the solution to the problem.
The new h,w,d are unconstrained.

Objective:
    max(whd) becomes
    max(exp(w+h+d)) ==> max(w+h+d)
    ==> min(-(w+h+d)) which is convex

Constraints:
    1.)
    wd <= 60 becomes
    exp(w+d)<=60 ==> w+d <= ln(60) which is convex

    2.)
    2(hw+hd) <= 200 becomes
    2(exp(h+w) + exp(h+d)) <= 200 which is convex
    
    3.)
    d/w >=0.8 becomes
    exp(d-w) >= 0.8 ==> d-w >= ln(0.8) which is convex

    4.) 
    h/w <= 1.2 becomes 
    exp(h-w) <= 1.2 ==> h-w <= ln(1.2) which is convex

    5.) 
    h,w,d being greater than 0 are already handled by the formulation.\n
'''
print(formulation)

###### CODE ########
h = cp.Variable()
w = cp.Variable()
d = cp.Variable()

obj = cp.Maximize(w+h+d)

exp = lambda x: cp.exp(x)
ln = lambda x: cp.log(x)

constraints = [ w+d<=ln(60), exp(h+w) +exp(h+d) <= 100, d-w >= ln(0.8), h-w <= ln(1.2)]

prob = cp.Problem(obj,constraints)
prob.solve()
v = lambda x: x.value
nrexp = lambda x: np.round(np.exp(x),2)
print(f'Optimal volume found to be {nrexp(v(w)+v(h)+v(d))} at \n w = {nrexp(v(w))},\n h = {nrexp(v(h))},\n d = {nrexp(v(d))}')
