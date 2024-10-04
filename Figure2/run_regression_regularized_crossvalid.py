from __future__ import division #to force float division
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
# import h5py
import scipy.io
import os
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

from sklearn.model_selection import LeaveOneOut
import pdb
# from luke
#import brewer2mpl as b2mpl
import seaborn as sns

sns.set(style="whitegrid", font_scale=1.3, color_codes=True)

def same_lim(hax=None):
    if not hax:
        hax=plt.gca()

    xli = hax.get_xlim()
    yli = hax.get_ylim()

    a = np.min([np.min(xli),np.min(yli)])
    b = np.max([np.max(xli),np.max(yli)])

    hax.set_xlim(a,b)
    hax.set_ylim(a,b)

    return (a,b)

source = 0
#sample_logistic_choices_flag = True
sample_logistic_choices_flag = False

if source==0:
    mat = scipy.io.loadmat('../../data_from_akram/prepro_data.mat')
    extension = ''
elif source==1:
    mat = dict()
    mat['dat'] = scipy.io.loadmat('../../data_from_akram_amnesics/MA.mat')
    extension = 'MA'

if source==0:
    rt = np.asarray(mat['dat']['rt'][0][0]) # annoying
    values = np.asarray(mat['dat']['values'][0][0]) # annoying
    v = np.asarray(mat['dat']['v'][0][0]) # annoying
    group = np.asarray(mat['dat']['group'][0][0]).astype(int).flatten() # annoying
    trials = np.asarray(mat['dat']['trials'][0][0]).astype(int) # annoying
    choices = np.asarray(mat['dat']['choices'][0][0]).astype(int).flatten() # annoying
    uni_group = np.unique(group)
    
    num_app_pair = np.asarray(mat['dat']['num_app_pair'][0][0]).flatten() # annoying
    
    
    # remove second presentations - could be done differently, e.g. by removing iteratively only the pair that's
    I = num_app_pair == 1
    rt = rt[I]
    values = values[I,:]
    group = group[I]
    trials = trials[I,:]
    choices = choices[I]
    

    
else:
    rt = np.asarray(mat['dat']['rt'])
    values = np.asarray(mat['dat']['values'])
    v = np.asarray(mat['dat']['v'])
    group = np.asarray(mat['dat']['group']).astype(int).flatten()
    trials = np.asarray(mat['dat']['trials']).astype(int)
    choices = np.asarray(mat['dat']['choices']).astype(int).flatten()
    uni_group = np.unique(group)

if sample_logistic_choices_flag:
    choices_simu = np.empty(choices.size)
    for g in uni_group:
        I = group==g
        model = LogisticRegression(penalty = None)
        #model = LogisticRegression(C=1e42)
        y = choices[I]
#        X = np.stack((values[I,0],values[I,1],np.ones(sum(I))),axis=1)
        X = np.stack((values[I,1]-values[I,0],np.ones(sum(I))),axis=1)
        model.fit(X, y)
        predicted_prob = model.predict_proba(X)
        # overwrite choices !!
        choices_simu[I] = np.random.rand(sum(I))<predicted_prob[:,1]
    choices = choices_simu.astype(int)

ng = uni_group.size
logl_FROM_CHOICES = np.empty(ng)
logl_BDM = np.empty(ng)

ntr = np.size(rt)
pright_cross_from_choices = np.empty(ntr)
pright_cross_from_BDM = np.empty(ntr)

for ig,g in enumerate(uni_group):
    I = group == g
    I = I.flatten()
    fI = np.where(I)
    fI = np.array(fI).flatten()

    nitems = np.size(v,0)
    ntr = np.sum(I)

    M = np.zeros([ntr,nitems])

    dims = [ntr,nitems]
    multi_index = np.asarray([np.arange(0,ntr),trials[I,0]-1]) #left item
    J1 = np.ravel_multi_index(multi_index, dims, mode='raise', order='C')

    multi_index = np.asarray([np.arange(0,ntr),trials[I,1]-1]) #left item
    J2 = np.ravel_multi_index(multi_index, dims, mode='raise', order='C')

    M.flat[J1] = -1 #left item
    M.flat[J2] = 1 #right item

    II = np.all(M==0,axis=0)
    M = M[:,~II] #remove

    #clf = LogisticRegression(random_state=0, solver='lbfgs',multi_class='multinomial').fit(X, y)

    #X = M # how it was
    X = np.column_stack((M,np.ones(sum(I)))) # NEW
    y = choices[I]
    loo = LeaveOneOut()


    # predictions from all other choices
    p_crossvalid = np.empty(0)
    for train_index, test_index in loo.split(X):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        model = LogisticRegression(penalty='l2',C = 2)
#        model = LogisticRegression(penalty=None)
        model.fit(X_train, y_train)
        predicted_prob = model.predict_proba(X_test)
        p_crossvalid = np.append ( p_crossvalid, predicted_prob[0][y_test.flatten().astype(int)] )

        pright_cross_from_choices[fI[test_index]] = predicted_prob[0][1]

    logl_FROM_CHOICES[ig] = np.sum(np.log(p_crossvalid))

    # predictions from BDM
    p_crossvalid = np.empty(0)
#    X = np.stack((values[I,0],values[I,1],np.ones(sum(I))),axis=1)
    X = np.stack((values[I,1]-values[I,0],np.ones(sum(I))),axis=1)
    for train_index, test_index in loo.split(X):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        #model = LogisticRegression(penalty='l2',C=100000)
        model = LogisticRegression(penalty=None)
        model.fit(X_train, y_train)
        predicted_prob = model.predict_proba(X_test)
        p_crossvalid = np.append ( p_crossvalid, predicted_prob[0][y_test.flatten().astype(int)] )

        pright_cross_from_BDM[fI[test_index]] = predicted_prob[0][1]

    logl_BDM[ig] = np.sum(np.log(p_crossvalid))
#print np.sum(np.log(p_crossvalid))

pLOC_from_choices = np.multiply(pright_cross_from_choices, choices) + np.multiply(1-pright_cross_from_choices, 1-choices)
pLOC_from_BDM = np.multiply(pright_cross_from_BDM, choices) + np.multiply(1-pright_cross_from_BDM, 1-choices)

# save for matlab
result_dict = {'logl_BDM': logl_BDM, 'logl_FROM_CHOICES': logl_FROM_CHOICES,'p_leftoutchoice_from_BDM':pLOC_from_BDM,'p_leftoutchoice_from_choices':pLOC_from_choices}
#result_dict = {'logl_BDM': logl_BDM, 'logl_FROM_CHOICES': logl_FROM_CHOICES,'pright_cross_from_BDM':pright_cross_from_BDM,'pright_cross_from_choices':pright_cross_from_choices}

if sample_logistic_choices_flag:
    scipy.io.savemat('from_reg_crossvalid_simulated' + extension + '.mat', result_dict)
else:
    scipy.io.savemat('from_reg_crossvalid' + extension + '.mat', result_dict)


plt.figure()
#plt.plot(vC,logl)
#plt.plot(plt.xlim(),(logl_BDM,logl_BDM))
plt.scatter(-1*logl_BDM,-1*logl_FROM_CHOICES)
ax = plt.gca()
ax.set_aspect('equal')
lim = same_lim(ax)
plt.plot(lim,lim)
plt.xlabel('nlogl BDM')
plt.ylabel('nlogl FROM CHOICES')
plt.title('Cross validated neg likelihoods')
#ax.margins(0.1)
plt.show()

#plt.figure()
#plt.plot(np.sort(predicted_prob[:,1]))
#plt.show()
