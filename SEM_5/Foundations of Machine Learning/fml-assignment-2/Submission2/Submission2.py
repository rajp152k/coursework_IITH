import pandas as pd
import numpy as np
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.ensemble import RandomForestClassifier
import xgboost as xgb
from sklearn.metrics import accuracy_score
import sys

train = pd.read_csv('iith_foml_2020_train.csv')


try:
    test = pd.read_csv('test_input.csv')
except FileNotFoundError:
    print('Place test_input.csv in this directory and run again, exiting for now')
    sys.exit()

atleast = 200 # hyperparameter

train_os = train.copy()
for r in range(18):
    if(len(train[train.iloc[:,-1] == r]) < atleast):
        num = atleast//len(train[train.iloc[:,-1] == r])
        train_os = train_os.append([train[train.iloc[:,-1] == r]]*(1+num))

X = train_os.iloc[:,:-1]
Y = np.array(train_os.iloc[:,-1])

drop = [f'Feature {i}' for i in range(16,19)]

X.drop(drop,axis=1,inplace=True)

X.fillna(X.mean(),inplace=True)
X.index = range(len(X))

strat_splits = StratifiedShuffleSplit(n_splits = 4,test_size=0.5)

scores = []
xg_stratcv = xgb.XGBClassifier()

for train_index,val_index in strat_splits.split(X,Y):
    x_train, x_val = X.iloc[train_index], X.iloc[val_index] 
    y_train, y_val = Y[train_index], Y[val_index]
    xg_stratcv.fit(x_train,y_train)
    yval_pred= xg_stratcv.predict(x_val)
    scores.append(accuracy_score(y_val,yval_pred))

#print(scores)

test.fillna(test.mean(),inplace=True)
test.drop(drop,axis=1,inplace=True)
preds = xg_stratcv.predict(test)


out = pd.DataFrame(preds,columns=["Category"],index=range(1,len(test)+1))
out.index.name = 'Id'
out.to_csv("test_output.csv")

