#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 11 : problem 2

#################################
import matplotlib.pyplot as plt
import cvxpy as cp
import numpy as np
from sp_ln_sp_data import *

# data imported :
#n , N , M
#X : n x N
#Y : n x M

a = cp.Variable(n)
b = cp.Variable()

constr = [ 
        cp.transpose(cp.matmul(cp.transpose(a),X)) - b*np.ones(N) >= np.ones(N),
        cp.transpose(cp.matmul(cp.transpose(a),Y)) - b*np.ones(M) <= -1*np.ones(M)
        ]

gammas = [2**(i-50) for i in range(101)]


card = lambda x : (np.abs(x) > 1e-4).sum()
slab = lambda x : 2/np.sqrt((x**2).sum())

def solve_for(gamma):
    obj = cp.Minimize(cp.norm2(a) + gamma*cp.norm1(a))
    prob = cp.Problem(obj,constr)
    try:
        prob.solve(solver='ECOS')
    except :
        return [np.inf,np.inf]
    return [slab(a.value),card(a.value)]


cache = np.array([solve_for(gamma) for gamma in gammas])
clean = lambda x: x[x!=np.inf]
slabs = clean(cache[:,0])
cards = clean(cache[:,1])


plt.plot(cards,slabs)
plt.xlabel('cardinality')
plt.ylabel('slab width')
plt.title('slab width vs cardinality')
plt.show()
#plt.savefig('slabs_vs_cards.png')

# solving with the last valid non-explosive gamma to find 10 most features 

gamma = gammas[len(slabs) - 1]
obj = cp.Minimize(cp.norm2(a) + gamma*cp.norm1(a))
prob = cp.Problem(obj,constr)
prob.solve(solver='ECOS')
mask = np.zeros(n)
idxs = sorted(list(range(n)),key = lambda x:abs(a.value[x])) # sorting w.r.t  prominence of features and selecting top 10
mask[idxs[-10:]] = 1 # sorted by ascending order
assert mask.sum() == 10

# clamping corresponding a's to 0 to ignore those features
constr += [a[i] == 0 for  i in range(len(mask)) if mask[i] == 0]

obj = cp.Minimize(cp.norm2(a)) # non L1-regularized objective
prob = cp.Problem(obj,constr)
prob.solve()
print(f'Maximum thickness of slab with chosen features : {slab(a.value)}')
