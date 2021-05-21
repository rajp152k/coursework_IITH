#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 11 : problem 3

#################################
import cvxpy as cp
import numpy as np

print('PART A : showing that the problem is quasiconvex')
PartA = '''
To show that the problem is quasiconvex, showing that the alpha sublevel set of g(x) is convex.
That would be given by:
    g(x) <= alpha 
==> max(norm2(fk(x) - yk)) <= alpha
==> for all k, norm2(fk(x) - yk) <= alpha

Showing that this is the intersection of multiple convex sets:
    for each k,
    fk(x) = (Ak@x + b) / (c.T @ x + d) where the denominator is positive
    re-aranging individual convex sets :
    norm2(fk(x) - yk) =>
    norm2((Ak@x + b) - yk(c.T@x + d)) <= (c.T@x + d) * alpha
    changing variables
    norm2(s) <= t note that this is a convex cone
    Hence each of these sets will be convex. Consequently, their intersection will also be convex.
'''
print(PartA)

### PART B #####
print('PART B')

P = np.array([
        [
        [1.,0.,0.,0.],
        [0.,1.,0.,0.],
        [0.,0.,1.,0.]
        ],
        [
        [1.,0.,0.,0.],
        [0.,0.,1.,0.],
        [0.,-1.,0.,10.]
        ],
        [
        [1.,1.,1.,-10.],
        [-1.,1.,1.,0.],
        [-1.,-1.,1.,10.]
        ],
        [
        [0.,1.,1.,0.],
        [0.,-1.,1.,0.],
        [-1.,0.,0.,10.]
        ]
    ])

Y = np.array([
        [.98, .93],
        [1.01,1.01],
        [0.95,1.05],
        [2.04,0.00]
    ])

N = 4
A = lambda i: P[i,:2,:3]
b = lambda i: P[i,:2,-1]
c = lambda i: P[i,-1,:3]
d = lambda i: P[i,-1,-1]

y = lambda i: Y[i] # 2d point projections on camera planes 

x = cp.Variable(3) # 3d convex optimization variable

# denominator of f ( should be positive )
f_dr = lambda i: lambda x: c(i).T@x + d(i)

# left hand side of ith constraint
g_c_lhs = lambda i: lambda x: cp.norm2(A(i)@x + b(i) - y(i)*f_dr(i)(x))

alpha = cp.Parameter()

# right hand side of ith constraint
g_c_rhs = lambda i: lambda x: f_dr(i)(x) * alpha 

constr = []
eps = 1e-10
constr += [f_dr(i)(x) >= eps for i in range(N)] # positive denominators
constr += [g_c_lhs(i)(x) <= g_c_rhs(i)(x) for i in range(N)] # constraints derived from g

u = 1e2
l = 1e-2
obj = cp.Minimize(alpha)

thresh = 1e-4

prob = cp.Problem(obj,constr)
alpha_cache = None
opt_x = None
opt_res = None
convergence = []
while  u-l > thresh:
    alpha.value = (u + l)/2
    convergence.append(alpha.value)
    opt = prob.solve()
    if prob.status == 'infeasible':
        l = alpha.value
    else:
        u = alpha_cache = alpha.value
        opt_x = x.value
        opt_res = opt
    
print('Optimal x found to be ',np.round(opt_x,2))
print('at the optimal error of', opt_res)
print()
print('Convergence  occured as follows: ')
capture = [print(f'{np.round(i,4)}-->',end='') for i in convergence[:-1]] + [print(np.round(convergence[-1],4))]
del capture


