# Step 1 - Load data
import pandas as pd
import numpy as np

dataset = pd.read_csv('train.csv')

# Step 2 - Convert prognosis to number
# dataset.replace({'prognosis': {'negative': 0, 'positive': 1}}, inplace=True)

X = dataset[['cough', 'fever', 'sore_throat', 'shortness_of_breath', 'head_ache']]
y = dataset[['prognosis']]
np.ravel(y)

# Step 3 - Feature scaling
from sklearn.preprocessing import StandardScaler

sc = StandardScaler()
X = sc.fit_transform(X)

# Step 4 - Compare classification algorithms
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC

classification_models = [('Logistic Regression', LogisticRegression(solver='liblinear')),
                         ('K Nearest Neighbor', KNeighborsClassifier(n_neighbors=5, metric='minkowski', p=2)),
                         ('Kernel SVM', SVC(kernel='rbf', gamma='scale')), ('Naive Bayes', GaussianNB()),
                         ('Decision Tree', DecisionTreeClassifier(criterion='gini')),
                         ('Random Forest', RandomForestClassifier(n_estimators=100, criterion='gini'))]

for name, model in classification_models:
    kfold = KFold(n_splits=10, random_state=7, shuffle=True)
    result = cross_val_score(model, X, y.values.ravel(), cv=kfold, scoring='accuracy')
    print('%s: Mean Accuracy = %.2f%% - SD Accuracy = %.2f%%' % (name, result.mean() * 100, result.std() * 100))

# Draw decision tree
from sklearn import tree
import graphviz
import os
os.environ["PATH"] += os.pathsep + 'E:/Graphviz/bin/'

plot_data = tree.export_graphviz(DecisionTreeClassifier(criterion='gini').fit(X=X, y=y),
                                 out_file=None,
                                 feature_names=['cough', 'fever', 'sore_throat', 'shortness_of_breath', 'head_ache'],
                                 class_names=['negative', 'positive'],
                                 )
graph = graphviz.Source(plot_data)
graph.render("decision-tree")
