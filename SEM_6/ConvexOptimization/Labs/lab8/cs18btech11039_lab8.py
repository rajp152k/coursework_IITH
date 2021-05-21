#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 8

###### ###### ###### ###### ######

import matplotlib.pyplot as plt
import cvxpy as cp
import numpy as np

###### DATA FORMULATION ######
n = 100 # sample number
d = 1   # discretization unit
D1 = 0.08
D2 = 0.025
D3 = 0.005
###### AUXILLARY FUNCTIONS ###

def diff_series(s,d=1):
    '''
    differentiates a discrete series given the discreization unit
    '''
    #note that we do not need to handle the end points as they are set to 0 and not computed
    grads = []
    for i in range(s.size-1):
        diff = s[i+1]-s[i]
        grads.append(diff/d)
    return np.array(grads)

def generate_elevation(n):
    '''
    get the desired size of elevation series
    '''
    sin,pi = np.sin,np.pi
    get_e = lambda x : 5*sin(3*pi*x/n) + sin(10*pi*x/n)
    x = np.arange(1,n+1)
    return get_e(x)

def get_cost(s):
    '''
    get total cost for a series of height differences given the corresponding cost function
    '''
    relu = lambda u: cp.maximum(0,u)
    fill_cost = lambda u : 2*relu(u)**2 + 30*relu(u)
    cut_cost = lambda u : 12*relu(-u)**2 + relu(-u)

    fill_costs = np.vectorize(fill_cost)(s)
    cut_costs = np.vectorize(cut_cost)(s)
    return cp.sum(fill_costs + cut_costs)
    
###### PROBLEM FORMULATION ###

h = cp.Variable(n)
e = generate_elevation(n)
u = h - e

# computing grads
G1 = diff_series(h,1)
G2 = diff_series(G1,1)
G3 = diff_series(G2,1)

# objective

objective = cp.Minimize(get_cost(u))

# constraints
constr = []
constr += [cp.abs(g)<=D1 for g in G1]
constr += [cp.abs(g)<=D2 for g in G2]
constr += [cp.abs(g)<=D3 for g in G3]

# solving
prob = cp.Problem(objective,constr)
#prob.solve(verbose=True) # max iter reached on the OSQP solver, using ECOS instead
prob.solve(solver=cp.ECOS)

print(f'optimal cost was found to be {np.round(objective.value,2)}')

############ PLOTS ###########
#3 array plots : h e and u
x = range(n)
plt.plot(x,h.value,'g-',label = 'optimal heights')
plt.plot(x,e,'b-',label = 'hill elevation')
plt.plot(x,u.value,'r--',label = 'difference')
plt.xlabel('distance')
plt.ylabel('height')
plt.legend()
plt.title('Elevation plots')
plt.show()
# saved as elevation_plots.png

# cost convexity check plots

relu = lambda u: max(0,u)
fill_cost = lambda u : 2*relu(u)**2 + 30*relu(u)
cut_cost = lambda u : 12*relu(-u)**2 + relu(-u)

x = np.array(np.arange(1,10,0.1))
fig,axs = plt.subplots(2)
axs[0].plot(x,np.vectorize(fill_cost)(x))
axs[0].set_title('fill cost')
axs[0].set_xlabel('+u')
axs[0].set_ylabel('cost')
axs[1].plot(x,np.vectorize(cut_cost)(-x))
axs[1].set_title('cut cost')
axs[1].set_xlabel('-u')
axs[1].set_ylabel('cost')
fig.title('cost plots')
fig.show()
