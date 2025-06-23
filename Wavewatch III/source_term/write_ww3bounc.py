# -*- coding: utf-8 -*-
"""
Created on Thu Sep 12 18:23:48 2024

@author: chezh583
"""

import numpy as np
import math


i=197
j=20
i=i-1


dictionary=np.genfromtxt('interpolated_variables/dictionary.txt',delimiter=' ')
label=str(math.floor(dictionary[i]))

fgrid='input/spec1.list'
with open(fgrid, 'r') as file:
    lines = file.readlines()
    lines[0]="interpolated_variables/"+label+"/cut"+str(j)+".nc"
with open(fgrid, 'w') as file:
     file.writelines(lines)
