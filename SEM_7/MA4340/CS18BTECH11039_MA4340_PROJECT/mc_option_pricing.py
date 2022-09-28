# MA4340: Option Pricing via Monte Carlo Simulations
# RAJ PATIL : CS18BTECH11039
# pricer for European calls/puts

import numpy as np
import scipy.stats as si
import pandas as pd
from tqdm import tqdm
from pathlib import Path
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--num_sim",type=int,default=1000,help="number of simulations")
parser.add_argument("--gran",type=int,default=1000,help="granularity for markov approximation")
parser.add_argument("--r",type=float,default=0.04,help="annual risk free interest rate")
parser.add_argument("--sigma",type=float,default=0.25,help="annual fractional volatility of stock")
parser.add_argument("--T",type=float,default=0.25,help="time to maturity in years")
parser.add_argument("--S",type=float,default=100,help="initial stock price")
parser.add_argument("--K",type=float,default=105,help="strike price of option")
parser.add_argument("--test_all",action="store_true",help="to carry out all the experiments")
parser.add_argument("--exp_dir",default="./experiments",help="storage directory for experiment results")

class EuropeanOptions:
    """
    Option pricing for European options (call and put)
     - Monte Carlo (basic and antithetic variate)
     - Black Scholes 
    
    """

    def __init__(self, S: int, K: int, T: float, r: float, sigma: float):             
        """
        Args:
        S: initial stock price
        K: strike price at maturity
        T: time to maturity in years
        r: risk free interest rate (drift)
        sigma: stock volality
        """

        self.S = S
        self.K = K
        self.T = T
        self.r = r
        self.mu = r
        self.sigma = sigma

        self.bs_call = self.black_scholes('call')
        self.bs_put = self.black_scholes('put')


    def gen_sim(self, granularity: int, num_sim: int, antithetic_variate = False):
        """
        Generate num_sim monte carlo simluations with granularity time steps
        Args:
         - granularity : number of time steps to T
         - num_sim     : number of monte carlo simulations
        
        return:
         - num_sim monte carlo simulations
        """
        dt = self.T/granularity
        scaler = np.sqrt(dt)

        sims = np.zeros(num_sim)

        # generating final realisations of geometric brownian motion
        # only need the final value for European calls/puts
        for i in range(num_sim):
            # generating delta W for N timesteps
            # sampling from N(0,1) and later scaling by variance
            delta_W = np.random.standard_normal(size=granularity)
            sims[i] = np.sum(delta_W)*scaler

        St = self.S*np.exp((self.mu - 0.5*self.sigma**2)*self.T + self.sigma*sims)

        if antithetic_variate:
            St_antithetic = self.S*np.exp((self.mu - 0.5*sigma**2)*self.T + self.sigma*sims)
            # concatentating the antethetic path as well
            St = np.array([St,St_antithetic])

        return St

    def monte_carlo(self, CP : str, granularity: int, num_sim: int, antithetic_variate = False)-> (float,float):
        """
        Args:
         - CP                 : Call-Put flag: 'call' or 'put'
         - granularity        : number of time steps to T
         - num_sim            : number of monte carlo simulations
         - antithetic_variate : flag to indicate usage of antithetic paths
        
        return:
         - suggested option price                    : float
         - standard deviation of the paths generated : float
         - standard error of the estimate            : float
        """
        simulations = self.gen_sim(granularity,num_sim,antithetic_variate=antithetic_variate)

        if CP == 'call':
            # value of option will be max(S_t - K,0)
            simulations = simulations - self.K
            simulations[simulations<0] = 0

        if CP == 'put':
            # value of option will be max(K - S_t,0)
            simulations = self.K - simulations
            simulations[simulations<0] = 0


        if antithetic_variate:
            # means with the antithetic
            # for calculating std,ste
            # should reduce the variance
            # more precision due to more simlutions
            simulations = np.mean(simulations,axis=0)

        # discounting the mean of the value to present
        price = np.mean(simulations)*np.exp(-self.r*self.T)

        # standard deviation of the estimate
        std = np.sqrt(np.sum((simulations*np.exp(-self.r*-self.T) - price)**2)/(num_sim - 1))
        # standard error of the estimate
        ste = std/np.sqrt(num_sim)

        return price,std,ste

    def black_scholes(self,CP:str):
        """
        Args:
         - CP : 'call'/'put' flag

        return:
         - the black-scholes estimate  : float
        """
        d1 = (np.log(self.S/self.K) + (self.mu + 0.5*self.sigma**2)*self.T)/(self.sigma * np.sqrt(self.T))
        d2 = (np.log(self.S/self.K) + (self.mu - 0.5*self.sigma**2)*self.T)/(self.sigma * np.sqrt(self.T))

        # cumulative distribution fucntion for N(0,1)
        cdf = lambda x: si.norm.cdf(x,0.,1.)

        if CP == 'call':
            return self.S*cdf(d1) - self.K*np.exp(-self.r*self.T)*cdf(d2)

        if CP == 'put':
            return self.K*np.exp(-self.r*self.T)*cdf(-d2) - self.S*cdf(-d1)


class Experiment:
    def __init__(self,pricer,all,exp_dir,base_num_sim,base_gran):

        self.exp_dir = Path(exp_dir)
        self.exp_dir.mkdir(exist_ok=True)
        self.base_num_sim = base_num_sim
        self.base_gran = base_gran

        if all:
            print("checking variation with number of simulations")
            self.exp_num_sim(pricer)

            print("checking variation with granularity")
            self.exp_granularity(pricer)

            print("checking variation with use of antithetic variate")
            self.exp_antithetic(pricer)

            print(f"All results saved in {self.exp_dir}")

    def exp_granularity(self,pricer):
        call_cols = ['call_price','std','ste','black_scholes_call']
        put_cols = ['put_price','std','ste','black_scholes_put']

        Ns = range(100,10000,100)
        res_call = pd.DataFrame(index = [ "Granularity" ], columns = call_cols)
        res_put = pd.DataFrame(index = [ "Granularity" ], columns = put_cols)

        for N in tqdm(Ns):
            call_price,call_std,call_ste = pricer.monte_carlo('call',N,self.base_num_sim)
            put_price,put_std,put_ste = pricer.monte_carlo('put',N,self.base_num_sim)

            res_call.loc[N] = [call_price,call_std,call_ste,pricer.bs_call]
            res_put.loc[N] = [put_price,put_std,put_ste,pricer.bs_put]

        res_call.to_csv(self.exp_dir/"granularity_call.csv")
        res_put.to_csv(self.exp_dir/"granularity_put.csv")

    def exp_num_sim(self, pricer):
        call_cols = ['call_price','std','ste','black_scholes_call']
        put_cols = ['put_price','std','ste','black_scholes_put']

        Ms = range(100,10000,100)
        res_call = pd.DataFrame(index = [ "Num Sims" ], columns = call_cols)
        res_put = pd.DataFrame(index = [ "Num Sims" ], columns = put_cols)

        for M in tqdm(Ms):
            call_price,call_std,call_ste = pricer.monte_carlo('call',self.base_gran,M)
            put_price,put_std,put_ste = pricer.monte_carlo('put',self.base_gran,M)

            res_call.loc[M] = [call_price,call_std,call_ste,pricer.bs_call]
            res_put.loc[M] = [put_price,put_std,put_ste,pricer.bs_put]

        res_call.to_csv(self.exp_dir/"num_sim_call.csv")
        res_put.to_csv(self.exp_dir/"num_sim_put.csv")


    def exp_antithetic(self,pricer):
        call_cols = ['call_price','call_antithetic','std','std_antithetic','black_scholes_call']
        put_cols = ['put_price','put_antithetic','std','std_antithetic','black_scholes_put']

        Ms = range(100,10000,100)
        res_call = pd.DataFrame(index = [ "Num Sims" ], columns = call_cols)
        res_put = pd.DataFrame(index = [ "Num Sims" ], columns = put_cols)

        for M in tqdm(Ms):
            call_price,call_std,_ = pricer.monte_carlo('call',self.base_gran,M)
            call_a_price,call_a_std,_ = pricer.monte_carlo('call',self.base_gran,M,True)

            put_price,put_std,_ = pricer.monte_carlo('put',self.base_gran,M)
            put_a_price,put_a_std,_ = pricer.monte_carlo('put',self.base_gran,M,True)

            res_call.loc[M] = [call_price,call_a_price,call_std,call_a_std,pricer.bs_call]
            res_put.loc[M] = [put_price,put_a_price,put_std,put_a_std,pricer.bs_put]

        res_call.to_csv(self.exp_dir/"antithetic_call.csv")
        res_put.to_csv(self.exp_dir/"antithetic_put.csv")

    

if (__name__ == '__main__'):
    args = parser.parse_args()
    price_EO = EuropeanOptions(args.S,args.K,args.T,args.r,args.sigma)
    exp  = Experiment(price_EO,
                      all=args.test_all,
                      exp_dir=args.exp_dir,
                      base_num_sim = args.num_sim,
                      base_gran = args.gran)
