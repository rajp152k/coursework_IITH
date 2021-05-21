# CS5590: Foundations of Machine Learning
## Assignment 1
## Question 4
## Authors 
#|Name|Roll number|
#|:--|--:|
#|Raj Patil|CS18BTECH11039|
#|Karan Bhukar|CS18BTECH11021|




import numpy as np
from tqdm import tqdm
num_params=13 #only for when testing the module
split_index=-1 # defaults
target_index=-2 # defaults

MIN = 1e-6
MAX = 1e-2

class BaseModel:
    # base class for unregularized model
    eps = 1e-1 # controlling zero div exception without explosion

    def __init__(self,lr,num_params,data,split_index,target_index):
        '''
        lr is the learning rate for W
        num_params is the number of features+1 (for bias)
        data represents the rocessed DataFrame
        split_index is the categorical variable indicating split info
        target index is the index of count
        expecting the constant to be embedded in the data 
        '''
        self.lr = lr

        self.data = data
        self.split_index,self.target_index = split_index,target_index

        assert type(num_params) is np.int and num_params > 0 , 'invalid num_params'
        self.W = np.random.randn(num_params) # random init for now
        # W[0] is for bias
        self.preds = [] # predictions vector

        self.train_count=0
        self.val_count=0
        self.test_count=0

    def featureFetcher(self,index):
        '''
         does all the cleaning up for a record being passed
         note: the relevant data is already normalized
         norm  = ['weathersit','season','mnth','hr','weekday']
         only integers are some indicator variables and year(already normalized)
         also appending a 1 for bias

         returns a 13-vec : this should be the size of W

            In [262]: data.info()
            <class 'pandas.core.frame.DataFrame'>
            RangeIndex: 17379 entries, 0 to 17378
            Data columns (total 14 columns):
             #   Column      Non-Null Count  Dtype  
            ---  ------      --------------  -----  
             0   season      17379 non-null  float64
             1   yr          17379 non-null  int64  
             2   mnth        17379 non-null  float64
             3   hr          17379 non-null  float64
             4   holiday     17379 non-null  int64  
             5   weekday     17379 non-null  float64
             6   workingday  17379 non-null  int64  
             7   weathersit  17379 non-null  float64
             8   temp        17379 non-null  float64
             9   atemp       17379 non-null  float64
             10  hum         17379 non-null  float64
             11  windspeed   17379 non-null  float64
             12  cnt         17379 non-null  int64  
             13  split       17379 non-null  int64  
            dtypes: float64(9), int64(5)
            memory usage: 1.9 MB
        '''
        return np.concatenate([np.ones(1),np.array(self.data.iloc[index,:12],dtype=np.float64)])

    def NLL(self,index):
        '''
        get only the relevant negative log likelihood for a particular record index from data
        ignoring the factorial part
        NLL(y) = exp(W^TX) - yW^TX
        '''
        X = self.featureFetcher(index)
        y = self.data.iloc[index,self.target_index]
        ln_lambda = self.W @ X

        return np.exp( ln_lambda ) - y*ln_lambda

    def nabla_NLL(self,index):
        '''
        get the derivative of the relevant NLL w.r.t W
        nabla NLL = (exp(W^TX) - y)X
        '''
        X = self.featureFetcher(index)
        y = self.data.iloc[index,self.target_index]
        ln_lambda = self.W @ X

        return X*(np.exp(ln_lambda) - y)
   
    def netLoss(self,index):
        ''' 
        only NLL in this case 
        will be overriden in case of L1 and L2 regularization
        '''
        return self.NLL(index)

    def W_grad(self,index):
        '''
        only nabla_NLL in this case
        will be overriden in case of L1 and L2 regularization
        '''
        return self.nabla_NLL(index)
    
    def update_W(self,index,lr):
        '''
        basic backprop for W
        '''
        self.W  -= lr * self.W_grad(index)

    def lr_grid_search(self,index):
        '''
        grid search for lr if current split_index is 1(val)
        compare losses after stepping after lr, 2*lr and lr/2
        update lr with the lowest loss after stepping
        '''
        backup_W = self.W.copy()

        if(self.lr >MAX):
            self.lr = self.lr/2
        elif (self.lr < MIN):
            self.lr = self.lr*2
        else:
            search = [self.lr/2,self.lr,2*self.lr]
            losses = []
            for lr in search:
                self.update_W(index,lr)
                losses.append(self.netLoss(index))
                self.W = backup_W.copy()
            self.lr = search[np.argmin(losses)]

    def process(self,index):
        '''
        only check split type and dispatch corresponding subroutine
        '''
        phase = self.data.iloc[index][self.split_index]

        if phase==0:
           # train
           self.train(index)
        if phase==1:
            self.val(index)

        if phase==2:
            self.predict(index)

        #self.sfm[self.data.iloc[index,self.split_index]](index)
        #print(f'called {self.sfm[self.data.iloc[index,self.split_index]](index)}')
        #self.predict(index)

    def full_pass(self):
        '''
        a full data pass
        '''
        for i in tqdm(range(len(self.data))):
            self.process(i)

    def train(self,index):
        '''
            primary function is to update W for an index
        '''
        self.update_W(index,self.lr)
        self.train_count +=1
         
    def val(self,index):
        '''
        grid searches for hyperparams for an index
        '''
        #self.lr_grid_search(index)
        self.val_count+=1

    def predict(self,index):
        ''' 
        printing test predictions
        '''
        self.preds.append(self.get_pred(index))

    def get_pred(self,index):
        '''
        only get predictions 
        floor of lambda for our case
        '''
        return np.floor(np.exp(self.W @ self.featureFetcher(index)))

    def test_rms(self):
        '''
            report root mean square error on test set
        '''
        test_actuals = self.data.loc[self.data.iloc[:,self.split_index]==2].iloc[:,self.target_index]
        test_preds = np.array(self.preds)

        return np.sqrt(((test_actuals - test_preds)**2).mean())

        

class L1Model(BaseModel):
    def __init__(self,lr,num_params,data,split_index,target_index,alpha):
        super().__init__(lr,num_params,data,split_index,target_index)
        self.a = alpha # initial value of a

    def netLoss(self,index):
        '''
        NLL + L1 penalty
        '''
        return self.NLL(index) + self.a * np.abs(self.W).sum()

    def W_grad(self,index,_a=None):
        '''
       nabla_NLL + nabla_L1_penalty
        '''
        a = self.a if _a is None else _a
        return self.nabla_NLL(index) + a * self.W /(self.eps + np.abs(self.W).sum())

    def update_W(self,index,lr,a=None):
        '''
        basic backprop for W
        '''
        self.W  -= lr * self.W_grad(index,a)

    def val(self,index):
        '''
        lr_grid_search from super and also for alpha
        '''
        #self.lr_grid_search(index)
        #self.a_grid_search(index)
        self.val_count+=1


    def a_grid_search(self,index):
        backup_W = self.W.copy()
        if(self.a >MAX):
            self.a = self.a/2
        elif (self.a < MIN):
            self.a = self.a*2
        else:
            search = [self.a/2,self.a,2*self.a]
            losses = []
            for a in search:
                self.update_W(index,self.lr,a)
                losses.append(self.netLoss(index))
                self.W = backup_W.copy()
            self.a = search[np.argmin(losses)]

class L2Model(BaseModel):
    def __init__(self,lr,num_params,data,split_index,target_index,beta):
        super().__init__(lr,num_params,data,split_index,target_index)
        self.b = beta # initial value of b

    def netLoss(self,index):
        '''
        NLL + L2 penalty
        '''
        return self.NLL(index) + self.b * self.W @ self.W

    def W_grad(self,index,_b=None):
        '''
        nabla_NLL + nabla_L2_penalty
        '''
        b = self.b if _b is None else _b
        return self.nabla_NLL(index) + 2*b * self.W

    def update_W(self,index,lr,b=None):
        '''
        basic backprop for W
        '''
        self.W  -= lr * self.W_grad(index,b)

    def val(self,index):
        '''
        lr_grid_search from super and also for beta 
        '''
        #self.lr_grid_search(index)
        #self.b_grid_search(index)
        self.val_count+=1

    def b_grid_search(self,index):
        backup_W = self.W.copy()
        if(self.b >MAX):
            self.b = self.b/2
        elif (self.b < MIN):
            self.b = self.b*2
        else:
            search = [self.b/2,self.b,2*self.b]
            losses = []
            for b in search:
                self.update_W(index,self.lr,b)
                losses.append(self.netLoss(index))
                self.W = backup_W.copy()
            self.b = search[np.argmin(losses)]
