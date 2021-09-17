# importing Flask and other modules
import numpy
import sklearn.metrics
from flask import Flask, jsonify, request, render_template
from flask_cors import CORS, cross_origin
import numpy as np
import pandas as pd

# list of attributes
l1 = ['cough', 'fever', 'sore_throat', 'shortness_of_breath', 'head_ache', 'age60_and_above', 'gender',
      'contact_with_infected']

# classes
disease = ['negative', 'positive']
# TESTING DATA df 
df = pd.read_csv("dataset/extended_features_test.csv")

df.replace({'prognosis': {'negative': 0, 'positive': 1}}, inplace=True)

X = df[l1]
X = pd.DataFrame(X).fillna(1)  # To account for any NaNs we may have missed in the dataset
y = df[["prognosis"]]
y = pd.DataFrame(y).fillna(1)  # To account for any NaNs we may have missed in the dataset
np.ravel(y)

# TRAINING DATA tr
tr = pd.read_csv("dataset/extended_feature_train.csv")
tr.replace({'prognosis': {'negative': 0, 'positive': 1}}, inplace=True)

X_test = tr[l1]
X_test = pd.DataFrame(X_test).fillna(1)  # To account for any NaNs we may have missed in the dataset
y_test = tr[["prognosis"]]
y_test = pd.DataFrame(y_test).fillna(1)  # To account for any NaNs we may have missed in the dataset
np.ravel(y_test)
# --------------------

# Flask constructor 
app = Flask(__name__)
cors = CORS(app, resources={r"/api/prognosis": {"origins": "*"}})
app.config['CORS_HEADERS'] = 'Content-Type'


# Decision Tree Algorithm
def DecisionTree(psymptoms):
    # import tree
    from sklearn import tree

    # empty model of the decision tree
    clf3 = tree.DecisionTreeClassifier()
    clf3 = clf3.fit(X, y)

    # calculating accuracy-----------------------
    from sklearn.metrics import accuracy_score
    y_pred = clf3.predict(X_test)
    # --------------------------------------------

    # Prediction
    inputtest = [psymptoms]
    predict = clf3.predict(inputtest)
    predicted = predict[0]

    # check if prediction is done successfully 
    h = 'no'
    for a in range(0, len(disease)):
        if (predicted == a):
            h = 'yes'
            break

    # calculate confusion matrix and write to file
    dt_confusion_matrix = sklearn.metrics.confusion_matrix(y_test, y_pred)
    file1 = open("dt_confusion_matrix.txt", "w")
    file1.write(str(dt_confusion_matrix))
    file1.close()

    if (h == 'yes'):
        return (disease[a], accuracy_score(y_test, y_pred, normalize=True))
    else:
        return ("Not Found", "Not Found")


# Naive Bayes Algorithm
def NaiveBayes(psymptoms):
    # import gaussian
    from sklearn.naive_bayes import GaussianNB

    # empty model of naive gaussian
    gnb = GaussianNB()
    gnb = gnb.fit(X, np.ravel(y))

    # calculating accuracy--------------------------
    from sklearn.metrics import accuracy_score
    y_pred = gnb.predict(X_test)
    # ----------------------------------------------

    # Prediction
    inputtest = [psymptoms]
    predict = gnb.predict(inputtest)
    predicted = predict[0]

    # check if prediction is done successfully 
    h = 'no'
    for a in range(0, len(disease)):
        if (predicted == a):
            h = 'yes'
            break

    # calculate confusion matrix and write to file
    nb_confusion_matrix = sklearn.metrics.confusion_matrix(y_test, y_pred)
    file2 = open("nb_confusion_matrix.txt", "w")
    file2.write(str(nb_confusion_matrix))
    file2.close()

    if (h == 'yes'):
        return (disease[a], accuracy_score(y_test, y_pred, normalize=True))
    else:
        return ("Not Found", "Not Found")


@app.route('/')
def home():
    return render_template('index_extended.html')


@app.route('/api/prognosis', methods=['POST'])
@cross_origin(origin='*', headers=['Content-Type', 'Authorization'])
def prognosis():
    data = request.get_json()
    cough = data.get('cough', '')
    fever = data.get('fever', '')
    sore_throat = data.get('sore_throat', '')
    shortness_of_breath = data.get('shortness_of_breath', '')
    head_ache = data.get('head_ache', '')
    age60_and_above = data.get('age60_and_above', '')
    gender = data.get('gender', '')
    contact_with_infected = data.get('contact_with_infected', '')
    psymptoms = [cough, fever, sore_throat, shortness_of_breath, head_ache, age60_and_above, gender,
                 contact_with_infected]
    naive_prediction, nb_accuracy = NaiveBayes(psymptoms)
    d_t_prediction, dt_accuracy = DecisionTree(psymptoms)
    responseData = {"naive_prediction": naive_prediction,
                    "nb_accuracy": nb_accuracy,
                    "d_t_prediction": d_t_prediction,
                    "dt_accuracy": dt_accuracy
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
        age60_and_above = int(request.form.get("age60_and_above"))
        gender = int(request.form.get("gender"))
        contact_with_infected = int(request.form.get("contact_with_infected"))
        psymptoms = [cough, fever, sore_throat, shortness_of_breath, head_ache, age60_and_above, gender,
                     contact_with_infected]
        naive_prediction, nb_accuracy = NaiveBayes(psymptoms)
        d_t_prediction, dt_accuracy = DecisionTree(psymptoms)

    return render_template("index_extended.html", name=name, prediction_nb=naive_prediction, accuracy_nb=nb_accuracy,
                           prediction_dt=d_t_prediction, accuracy_dt=dt_accuracy)
