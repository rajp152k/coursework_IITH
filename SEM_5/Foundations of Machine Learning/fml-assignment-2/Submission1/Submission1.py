import numpy as np
import pandas as pd
from pandas import DataFrame
import sklearn 
import xgboost as xgb
from sklearn.ensemble import RandomForestClassifier
import sys

df = pd.read_csv('iith_foml_2020_train.csv')
df = df.drop(['Feature 16','Feature 17','Feature 18'], axis=1)

x = df.drop(['Target Variable (Discrete)'], axis=1)
x.fillna(x.mean(),inplace=True)

y = df['Target Variable (Discrete)']
y=y.values.tolist()

xgbtrain = xgb.DMatrix(x, label=y)

model_random_forest = RandomForestClassifier()
model_random_forest.fit(x,y)

bst = xgb.XGBClassifier()
bst.fit(x,y)


try:
    x_test = pd.read_csv('test_input.csv')
except FileNotFoundError:
    print('Place test_input.csv in this directory and run again, exiting for now')
    sys.exit()



x_test = x_test.drop(['Feature 16','Feature 17','Feature 18'], axis=1)
x_test.fillna(x_test.mean(),inplace=True)
x_test.head()

pre = model_random_forest.predict_proba(x_test)


y_xgb = bst.predict_proba(x_test)


y_pred = y_xgb + pre
y_pred_1 = np.asarray([np.argmax(line) for line in y_pred])

l = np.arange(1,len(y_pred_1)+1)    
dicti = {'Id':l,'Category':y_pred_1}     
pred = pd.DataFrame(dicti)  

# saving the dataframe  
pred.to_csv('test_output.csv',index=False) 
