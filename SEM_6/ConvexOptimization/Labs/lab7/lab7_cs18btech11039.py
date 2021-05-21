#  RAJ PATIL
#  CS18BTECH11039 
#  Convex Optimization : Lab 7

######## IMPORTS AND DATA ##########

import numpy as np
import matplotlib.pyplot as plt
import cvxpy as cp
import pandas as pd

import pv_output_data as data

######### AUXILLARY FUNCTIONS #####

def laplacian(ts):
    '''
    returns the Laplacian given a periodic time series
    '''
    laplacian = 0
    for i in range(ts.size-1):
        laplacian += (ts[i+1]-ts[i])**2
    laplacian+= (ts[0] - ts[-1])**2
    return laplacian



######### FORMULATION #############

c_base = cp.Variable(data.T//7) # cloud-less power outputs for a day
s = cp.Variable(data.T) # power inaccesible due to shade over the week
r = cp.Variable(data.T) # residuals (noise)

###### CONSTRAINTS #################
constr = [] # nonneg=True handles non-negative domain requirements

constr.append(s>=0)
constr.append(c_base>=0)
constr.append(np.mean(cp.abs(r))<=4)

period = data.T//7
for day in range(7):
    mask = slice(day*period,(day+1)*period)
    constr.append(data.p[mask] == c_base - s[mask] + r[mask])
    constr.append(s[mask]<=c_base)

obj = cp.Minimize(laplacian(c_base) + cp.sum(s))

prob = cp.Problem(obj,constr)
prob.solve()

cval = np.tile(c_base.value,7)
sval = s.value
rval = r.value
x = range(data.T)

######### MEANS ####################
print(f'corresponding stats are as follows:')
print(f'average c           :{np.mean(cval)}')
print(f'average s           :{np.mean(sval)}')
print(f'average absolute r  :{np.mean(np.abs(rval))}')

######### Visualizing ##############

plt.title('All Series')
plt.plot(x,data.p,'g-',label='power output')
plt.plot(x,cval,'y-',label='cloudless output')
plt.plot(x,sval,'b-',label='shade loss')
plt.plot(x,rval,'r-',label='errors')
plt.legend()
plt.show()
# saved as All_series.png

fig,axs = plt.subplots(nrows=2,ncols=2)
axs[0,0].plot(x,data.p,'g-',label='power output')
axs[0,0].set_title('power output')
axs[0,1].plot(x,cval,'y-',label='cloudless output')
axs[0,1].set_title('cloudless output')
axs[1,0].plot(x,sval,'b-',label='shade loss')
axs[1,0].set_title('shade loss')
axs[1,1].plot(x,rval,'r-',label='errors')
axs[1,1].set_title('errors')
fig.show()
# saved as Plots.png
