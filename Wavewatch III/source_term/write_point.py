# -*- coding: utf-8 -*-
"""
Created on Fri Sep 13 10:10:04 2024

@author: chezh583
"""

import numpy as np
import math



i=2
i=i-1


position=np.genfromtxt('input/position.txt',delimiter=' ')
flag=position[i,0]
dx=math.floor(position[i,1])
dy=math.floor(position[i,2])

fgrid='input/point.list'
with open(fgrid, 'r') as file:
    lines = file.readlines()
    lines[0]="10000 0 'bound'\n"
    lines[1]="10000 "+str(dy)+" 'check'"
with open(fgrid, 'w') as file:
    file.writelines(lines)
