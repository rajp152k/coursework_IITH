#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 4.2 

#################################
import numpy as np
import cvxpy as cp
import matplotlib.pyplot as plt


# Function definitions
produce_domain = lambda N: np.linspace(-1,1,2*N+1,endpoint=True).reshape(2*N+1,1)

def Loss_L2(preds,actuals):
    delta  = (preds - actuals) 
    return cp.norm(delta,2)**2

def Loss_L1(preds,actuals):
    delta  = (preds - actuals) 
    return cp.norm(delta,1)
    

def approximate_for(n,N,loss_fn):
    '''
    returns the coefficients and optimal cost for approximating a polynomial of order n using the given loss function
    '''
    coeffs = cp.Variable((n,1))
    x = produce_domain(N)
    actuals = x**n
    powers = np.array(range(n)).reshape(1,n) # produces range from 0 to n-1
    # duplicating domain row-wise to use numpy broadcasting and then use element wise exponentiation 
    row_dup_x = x@np.ones((1,n)) # 2N+1 x n
    intermediate_powers = row_dup_x**powers # 2N+1 x n

    #preds = intermediate_powers@coeffs
    preds  = intermediate_powers@coeffs

    l = loss_fn(preds,actuals)
    obj = cp.Minimize(l)
    prob = cp.Problem(obj)
    prob.solve()

    return coeffs.value,l.value

# grid search results

gridN = [10,50,100,1000]
gridn = [5,10,20]

grid_l1 = np.zeros((len(gridN),len(gridn)))
grid_l2 = np.zeros((len(gridN),len(gridn)))
grids = [grid_l1,grid_l2]
losses = [Loss_L1,Loss_L2]


for N_i,N in enumerate(gridN):
    for n_i,n in enumerate(gridn):
        for loss_fn,grid in zip(losses,grids):
            _,grid[N_i,n_i] = approximate_for(n,N,loss_fn)

# check report for observations

# Part B: 
# proceeding with N = 100
coeffs_l1 = []
coeffs_l2 = []

N = 100
for n in gridn:
    for coeffs,loss_fn in zip([coeffs_l1,coeffs_l2],losses):
        cfs,_ = approximate_for(n,N,loss_fn)
        coeffs.append([np.round(cfs,3)]) # rounding for easier grasping

print('='*50)
print('*'*50)
print('='*50)
print('Coefficients for L1 Loss')
for i in range(3):
    print(f'for n = {gridn[i]}')
    print(coeffs_l1[i])
    print('='*50)
print('='*50)
print('*'*50)
print('='*50)
print('Coefficients for L2 Loss')
for i in range(3):
    print(f'for n = {gridn[i]}')
    print(coeffs_l2[i])
    print('='*50)
print('='*50)
print('*'*50)
print('='*50)

# Plots
plot_n = range(1,21)

loss_l1 = []
loss_l2 = []
for n in plot_n:
    for l,f in zip([loss_l1,loss_l2],losses):
        _,l_item = approximate_for(n,N,f)
        l.append(l_item)


plt.plot(plot_n,loss_l1,label="optimal L1 cost")
plt.plot(plot_n,loss_l2,label="optimal L2 cost")
plt.xlabel("n")
plt.ylabel("cost / loss")
plt.legend()
plt.show()
