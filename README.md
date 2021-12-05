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

<img src="https://raw.githubusercontent.com/sharechanxd/bios625_fp/main/plot/price_results.png" width="100%">

Considering both **MAE** and **RMSE**, the tuned Random forest and tuned XGBoost models perform best on test dataset. But it's still possible that we would get better results with more tuning on important hyperparameters.And we would just show residual plot and predictions v.s. lables plot for tuned XGBoot here.

<img src="https://raw.githubusercontent.com/sharechanxd/bios625_fp/main/plot/price_res.png" width="100%">

### Superhost models results 

We use **TfidfVectorizer** (abbr. **Tfidf**) and **CountVectorizer** (abbr. **CV**) as bag-of-words model for text data. CountVectorizer converts a collection of text documents to a matrix of token counts: the occurrences of tokens in each document. This implementation produces a sparse representation of the counts. TfidfVectorizer weights the word counts by a measure of how often they appear in the documents. Besides, we have feature selected data from **listings.csv**. So we would fit differnt classifier models to check their performence on predicting superhost. We would build models with feature selected data (abbr. **FSD**) from previous sections or bag-of-words alone. We tried to combine them together as multi-modal model but this encountered computing ability issue with extreme large memory usage. And this could be a future work direction. Here is the results of our superhost models. Notice that due to the imbalance, after spliting train and test data, we do upsampling for labels **superhost** in train data. Number of superhost and Non-superhost is $1581:4647$ in test data.

#### For feature selection data

| **Model**           | **Label**     | **percision** | **recall** | **F1 score** | **Test accuracy** |
|---------------------|---------------|---------------|------------|--------------|-------------------|
| Logistic Regression | Not_Superhost | 0.88          | 0.72       | 0.79         | 0.71              |
|                     | Superhost     | 0.46          | 0.71       | 0.56         |                   |
| Naive Bayesian      | Not_Superhost | 0.88          | 0.18       | 0.3          | 0.37              |
|                     | Superhost     | 0.28          | 0.93       | 0.43         |                   |
| Random forest       | Not_Superhost | 0.88          | 0.92       | 0.9          | 0.76              |
|                     | Superhost     | 0.73          | 0.65       | 0.69         |                   |
| XGBoost             | Not_Superhost | 0.89          | 0.91       | 0.9          | 0.86            |
|                     | Superhost     | 0.72          | 0.67       | 0.69         |                   |

#### With bag-of-words: CountVectorizer

| **Model**           | **Label**     | **percision** | **recall** | **F1 score** | **Test accuracy** |
|---------------------|---------------|---------------|------------|--------------|-------------------|
| Logistic Regression | Not_Superhost | 0.84          | 0.86       | 0.85         | 0.77              |
|                     | Superhost     | 0.56          | 0.51       | 0.53         |                   |
| Naive Bayesian      | Not_Superhost | 0.87          | 0.55       | 0.67         | 0.6               |
|                     | Superhost     | 0.37          | 0.77       | 0.5          |                   |
| Random forest       | Not_Superhost | 0.82          | 0.86       | 0.84         | 0.76              |
|                     | Superhost     | 0.37          | 0.77       | 0.5          |                   |
| XGBoost             | Not_Superhost | 0.84          | 0.9        | 0.87         | 0.79              |
|                     | Superhost     | 0.62          | 0.48       | 0.54         |                   |

#### With bag-of-words: TfidfVectorizer

| **Model**           | **Label**     | **percision** | **recall** | **F1 score** | **Test accuracy** |
|---------------------|---------------|---------------|------------|--------------|-------------------|
| Logistic Regression | Not_Superhost | 0.89          | 0.75       | 0.81         | 0.74              |
|                     | Superhost     | 0.49          | 0.73       | 0.59         |                   |
| Naive Bayesian      | Not_Superhost | 0.98          | 0.12       | 0.21         | 0.34              |
|                     | Superhost     | 0.28          | 0.99       | 0.43         |                   |
| Random forest       | Not_Superhost | 0.81          | 0.91       | 0.86         | 0.77              |
|                     | Superhost     | 0.59          | 0.38       | 0.46         |                   |
| XGBoost             | Not_Superhost | 0.84          | 0.91       | 0.87         | 0.80              |
|                     | Superhost     | 0.63          | 0.47       | 0.54         |                   |

From the results we could see that using **feature selected data** with **XGBoost** would get better models. But due to the imbalance, our model could not predict superhost labels as well as non-superhost.

---------------------------
Contributor: 

Contribution: 
