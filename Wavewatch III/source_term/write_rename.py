# -*- coding: utf-8 -*-
"""
Created on Thu Sep 12 17:58:11 2024

@author: chezh583
"""
import numpy as np
import math
import os


i=197
j=20
i=i-1


dictionary=np.genfromtxt('interpolated_variables/dictionary.txt',delimiter=' ')
label=str(math.floor(dictionary[i]))

os.rename('output/ww3.199001_tab.nc','output/'+label+'_cut'+str(j)+'.nc')
