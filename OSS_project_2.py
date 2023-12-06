import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error
from sklearn.svm import SVR
from sklearn.pipeline import Pipeline

def sort_dataset(dataset_df):
    dataFrame = pd.DataFrame(dataset_df)
    sorted_dataFrame = dataFrame.sort_values(by='year', ascending=True)
    return sorted_dataFrame

def split_dataset(dataset_df):
    X = dataset_df.drop(columns=['salary'])
    Y = dataset_df['salary']
    dataset_df['salary'] *= 0.001
    X_train = X.loc[dataset_df.index[:1718]]
    Y_train = Y.loc[dataset_df.index[:1718]]
    X_test = X.loc[dataset_df.index[1718:]]
    Y_test = Y.loc[dataset_df.index[1718:]]
    return X_train, X_test, Y_train, Y_test

def extract_numerical_cols(dataset_df):
    dataFrame = pd.DataFrame(dataset_df)
    numerical_dataFrame = dataFrame[['age', 'G', 'PA', 'AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'SB', 'CS', 'BB', 'HBP', 'SO', 'GDP', 'fly', 'war']]
    return numerical_dataFrame

def train_predict_decision_tree(X_train, Y_train, X_test):
    model = DecisionTreeRegressor(random_state=None)
    model.fit(X_train, Y_train)
    return model.predict(X_test)

def train_predict_random_forest(X_train, Y_train, X_test):
    model = RandomForestRegressor(random_state=None)
    model.fit(X_train, Y_train)
    return model.predict(X_test)

def train_predict_svm(X_train, Y_train, X_test):
    model = SVR(kernel='linear')
    pipeLine = Pipeline([('scaler', StandardScaler()), ('svm', model)])
    pipeLine.fit(X_train, Y_train)
    return pipeLine.predict(X_test)

def calculate_RMSE(labels, predictions):
    mse = mean_squared_error(labels, predictions)
    return np.sqrt(mse)

if __name__ == '__main__':
    # DO NOT MODIFY THIS FUNCTION UNLESS PATH TO THE CSV MUST BE CHANGED.
    data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')

    sorted_df = sort_dataset(data_df)
    X_train, X_test, Y_train, Y_test = split_dataset(sorted_df)

    X_train = extract_numerical_cols(X_train)
    X_test = extract_numerical_cols(X_test)

    dt_predictions = train_predict_decision_tree(X_train, Y_train, X_test)
    rf_predictions = train_predict_random_forest(X_train, Y_train, X_test)
    svm_predictions = train_predict_svm(X_train, Y_train, X_test)

    print("Decision Tree Test RMSE: ", calculate_RMSE(Y_test, dt_predictions))
    print("Random Forest Test RMSE: ", calculate_RMSE(Y_test, rf_predictions))
    print("SVM Test RMSE: ", calculate_RMSE(Y_test, svm_predictions))