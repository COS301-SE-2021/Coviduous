# importing Flask and other modules 
from flask import Flask, jsonify, request, render_template 
import numpy as np
import pandas as pd


# list of attributes
l1=['cough','fever','sore_throat','shortness_of_breath','head_ache']

# classes
disease=['negative','positive']
# TESTING DATA df 
df=pd.read_csv("dataset/test.csv")

df.replace({'prognosis':{'negative':0,'positive':1}},inplace=True)


X= df[l1]
y = df[["prognosis"]]
np.ravel(y)


# TRAINING DATA tr 
tr=pd.read_csv("dataset/train.csv")
tr.replace({'prognosis':{'negative':0,'positive':1}},inplace=True)

X_test= tr[l1]
y_test = tr[["prognosis"]]
np.ravel(y_test)
# --------------------

# Flask constructor 
app = Flask(__name__) 

#Decision Tree Algorithm
def DecisionTree(psymptoms):
    #import tree 
    from sklearn import tree

    # empty model of the decision tree
    clf3 = tree.DecisionTreeClassifier()  
    clf3 = clf3.fit(X,y)

    # calculating accuracy-----------------------
    from sklearn.metrics import accuracy_score
    y_pred=clf3.predict(X_test)
    # --------------------------------------------

    # Prediction
    inputtest = [psymptoms]
    predict = clf3.predict(inputtest)
    predicted=predict[0]

    # check if prediction is done successfully 
    h='no'
    for a in range(0,len(disease)):
        if(predicted == a):
            h='yes' 
            break
        
    if (h=='yes'):
        return(disease[a], accuracy_score(y_test, y_pred,normalize=True)) 
    else:
        return("Not Found", "Not Found")

#Naive Bayes Algorithm
def NaiveBayes(psymptoms):
    # import gaussian
    from sklearn.naive_bayes import GaussianNB

    # empty model of naive gaussian
    gnb = GaussianNB()
    gnb=gnb.fit(X,np.ravel(y))

    # calculating accuracy--------------------------
    from sklearn.metrics import accuracy_score
    y_pred=gnb.predict(X_test)
    # ----------------------------------------------

    # Prediction
    inputtest = [psymptoms]
    predict = gnb.predict(inputtest)
    predicted=predict[0]

    # check if prediction is done successfully 
    h='no'
    for a in range(0,len(disease)):
        if(predicted == a):
            h='yes'
            break

    if (h=='yes'):
        return(disease[a], accuracy_score(y_test, y_pred,normalize=True)) 
    else:
        return("Not Found", "Not Found")


@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/prognosis', methods=['POST'])
def prognosis():
    data = request.get_json()
    cough = data.get('cough', '')
    fever = data.get('fever', '')
    sore_throat = data.get('sore_throat', '')
    shortness_of_breath = data.get('shortness_of_breath', '')
    head_ache = data.get('head_ache', '')
    psymptoms = [cough, fever, sore_throat, shortness_of_breath, head_ache]
    naive_prediction , nb_accuracy = NaiveBayes(psymptoms)
    d_t_prediction, dt_accuracy = DecisionTree(psymptoms)
    responseData={"naive_prediction":naive_prediction,
    "nb_accuracy":nb_accuracy,
    "d_t_prediction":d_t_prediction,
    "dt_accuracy":dt_accuracy
    }
    return jsonify(responseData)

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == "POST":
        # Take user inputs from html form
        name = request.form.get("name")
        cough = int(request.form.get("cough"))
        fever = int(request.form.get("fever"))
        sore_throat = int(request.form.get("sore_throat"))
        shortness_of_breath = int(request.form.get("shortness_of_breath"))
        head_ache = int(request.form.get("head_ache"))
        psymptoms = [cough, fever, sore_throat, shortness_of_breath, head_ache]
        naive_prediction , nb_accuracy = NaiveBayes(psymptoms)
        d_t_prediction, dt_accuracy = DecisionTree(psymptoms)
        
    return render_template("index.html", name = name, prediction_nb = naive_prediction,accuracy_nb = nb_accuracy , prediction_dt = d_t_prediction, accuracy_dt = dt_accuracy)
	
 
if __name__=='__main__':  
    app.run(debug=True) 