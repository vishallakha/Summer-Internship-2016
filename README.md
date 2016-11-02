# Summer-Internship-2016
Predictive Control Modelling for Hot Metal Quality of Blast Furnaces.

# Input Details 

The dataset consists of numeric values of several variables which are monitored during the hot metal generation process in a blast furnace. eg Hot Top Temperature, Coke Rate, Pressure, Pellet Rate etc. (Data can't be Disclosed)

All of these parameters are considered as "X" and percentage of silicon in hot metal is treated as "Y". the target is to minimize the %age of Silicon in Hotmetal, by finding out the hidden relationships among several variables.

# Process Flow

1. The data has some missing values already and some outliers were removed after analysing the histograms of every variable. the missing values are treated using MICE (multivariate Imputation by Chained Equations).
2. Smoothing Spline graphs are drawn for each variable in X vs. Y. and the dips in the graphs are noted down.
3. Using the new minimum values of each variable in X, a predictive model is built using XGBOOST (extreme gradient boosting algorithm).
4. a special function is also made to find out the optimal hyper parameters for best performance of the XGBOOST program.
