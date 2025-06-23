# -*- coding: utf-8 -*-
"""
Created on Thu Sep 12 18:39:23 2024

@author: chezh583
"""

import numpy as np
import math
from metpy.calc import wind_direction
from metpy.units import units
i=197
j=20
i=i-1


dictionary=np.genfromtxt('interpolated_variables/dictionary.txt',delimiter=' ')
label=str(math.floor(dictionary[i]))

winddata = np.genfromtxt('interpolated_variables/'+label+'/wind.txt',delimiter=' ')
curdata = np.genfromtxt('interpolated_variables/'+label+'/cur.txt',delimiter=' ')



fgrid='ww3_shel.nml'
with open(fgrid, 'r') as file:
    lines = file.readlines()
    uwnd=winddata[j-1,0]
    vwnd=winddata[j-1,1]
    ucur=curdata[j-1,0]
    vcur=curdata[j-1,1]
    
    wdsp=math.sqrt(uwnd*uwnd+vwnd*vwnd)
    wdsp=str(round(wdsp,2)) # wind speed
    direction=wind_direction(uwnd * units('m/s'), vwnd * units('m/s'))
    direction=direction._magnitude
    wddir=str(math.floor(direction)) # wind direction
        
    cusp=math.sqrt(ucur*ucur+vcur*vcur)
    cusp=str(round(cusp,2)) # current speed
    direction=wind_direction(ucur * units('m/s'), vcur * units('m/s'))
    direction=direction._magnitude
    cudir=str(math.floor(direction)) # current direction
        
    lines[340]="  HOMOG_INPUT(1)%VALUE1      = "+wdsp+"\n"
    lines[341]="  HOMOG_INPUT(1)%VALUE2      = "+wddir+"\n"
    lines[346]="  HOMOG_INPUT(2)%VALUE1      = "+cusp+"\n"
    lines[347]="  HOMOG_INPUT(2)%VALUE2      = "+cudir+"\n"

with open(fgrid, 'w') as file:
    file.writelines(lines)
    
    
    
    
