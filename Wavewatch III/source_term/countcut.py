import numpy as np
import math


i=197
i=i-1

dictionary=np.genfromtxt('interpolated_variables/dictionary.txt',delimiter=' ')
label=str(math.floor(dictionary[i]))



icedata = np.genfromtxt('interpolated_variables/'+label+'/sic.txt',delimiter=' ')
l=len(icedata)

print(l)
