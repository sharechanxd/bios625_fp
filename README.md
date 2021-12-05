# Story of Airbnb: Price Predicting and Superhost Selection
 This is a final project for the BIOSTAT625: Computing with big data at University of Michigan. 

 In this project, we explore the Airbnb datasets with several visualization method. 
 
 say something.
 
 We build our train and test dataset with feature selection and deal with text data using bag-of-words model. After this we train classifier models to predict labels of superhost and regressor models to predict houses' prices. And we found using tuned XGBoost with grid-search cross validations help us got not bad results on both host and price dataset. And our models could help host to determine their prices at New York and how they could improve their host services to be named as "Superhost" and acquire priority. 
 
 However, due to imbalance dataset, our superhost model perform worse predicting "superhost" label than "non-superhost" label. As future work, we could combine feature selection data with bag-of-words model for reviews text data to conduct a multi-modal learning for better results. Features in this two modal data could possibly enhance final models' performance as we see in their single results. And below are our results.

### Prices models evaluation result with MAE and RMSE
| Esti\\Models | Linear Reg | Random Forest | RF Tuned | GBDT   | GBDT Tuned | XGBoost | XGBoost Tuned | MLP    | MLP Tuned |
|:---------------:|:----------:|:-------------:|:--------:|:------:|:----------:|:-------:|:-------------:|:------:|:---------:|
|  MAE            | 0.2926     | 0.1972        | 0.1979   | 0.2365 | 0.2028     | 0.2058  | 0.2043        | 0.2562 | 0.2476    |
| RMSE            | 0.4705     | 0.3915        | 0.381    | 0.4115 | 0.3783     | 0.3806  | 0.3776        | 0.4485 | 0.4312    |

<img src="https://raw.githubusercontent.com/sharechanxd/bios625_fp/main/plot/price_results.png" width="60%">

### Superhost models results 

<img src="https://raw.githubusercontent.com/sharechanxd/bios625_fp/main/plot/host_tab.png" width="80%">


Contributor: 

Contribution: 
