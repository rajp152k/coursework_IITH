#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 6

#################################

import numpy as np
import cvxpy as cp
from itertools import combinations

####### BASE DATA FORMULATION ##########

dpc = np.array([6000,5000,3000])
# daily unidimensional production capacities

vol = np.array([40,45,210])
maxvol = 6000
# volume requirements for 1000 of ..

ppp = np.array([4,6,10])
# profit per product

maxdpp = np.array([10000,15000,8000])
# max weekly (5 days) demand per product

minspp = np.array([5000,4000,4000])
# min weekly (5 days) supply per product

####### A ######

constrA = []

x = cp.Variable(3) # time devotion proportions
constrA+= [x>=0, cp.sum(x) <= 1]

wprodA = 5 * cp.multiply(x,dpc) # weekly production
constrA += [wprodA>=minspp,wprodA<=maxdpp]

wvolA = cp.sum(cp.multiply(wprodA,vol))/1000 # weekly volume requirements
constrA += [wvolA<=maxvol]

wprofA = cp.sum(cp.multiply(wprodA,ppp)) # weekly net profits

objA = cp.Maximize(wprofA)

probA = cp.Problem(objA,constrA)
probA.solve()

####### B ######

constrB = []

y = cp.Variable(3) # weekly production numbers
constrB += [y<=maxdpp,y>=minspp]

dpB = cp.multiply(1/dpc,y)/5 # daily proportions for production
# this corresponds to x of part A
constrB += [dpB>=0,cp.sum(dpB)<=1]

wvolB = cp.sum(cp.multiply(y,vol))/1000 # weekly volume requirements
constrB+=[wvolB<=maxvol]

wprofB = cp.sum(cp.multiply(y,ppp)) # weekly net profits

objB = cp.Maximize(wprofB)

probB = cp.Problem(objB,constrB)
probB.solve()

####### C ######

constrC = []

z = cp.Variable(3) # weekly hour devotion, from an 8*5 hour workweek

dpC = z/(5*8) # daily proportion 
# this corresponds to x of part A : this is the answer to part D
constrC += [dpC>=0,cp.sum(dpC)<=1]

wprodC = 5*cp.multiply(dpC,dpc) # weekly production numbers
constrC += [wprodC>=minspp,wprodC<=maxdpp]

wvolC = cp.sum(cp.multiply(wprodC,vol))/1000 # weekly volume requirements
constrC += [wvolC<=maxvol]

wprofC = cp.sum(cp.multiply(wprodC,ppp)) # weekly profit 

objC = cp.Maximize(wprofC)

probC = cp.Problem(objC,constrC)
probC.solve()

#### Verification ####

def areClose(num_list,thr=1e-3):
    '''
    returns whether the supplied list of floats are 
    reasonably close to each other
    '''
    combos = list(combinations(num_list,2))
    results = np.array([np.abs(a-b)<=thr for a,b in combos])
    return results.all()

assert areClose([wprofA.value,wprofB.value,wprofC.value]), "different optimal solutions found"

print("The different solutions found are close, displaying one of them...")

####### D ######
# check line 79 of this file for the solution
# x = z/(5*8)

#### E:Summary ####

print(f'Max weekly profit was found to be {np.round(wprofA.value)}')
print('at the following proportions according to ...')
print(f'    Part A:{np.round(x.value,2)}')
print(f'    Part B:{np.round(dpB.value,2)}')
print(f'    Part C:{np.round(dpC.value,2)}')
