import numpy as np
T = int(input("Temperature ? ")) + 273.15
L = 0.891              # longueur du tube [m]
c = 20.05*np.sqrt(T)   # célérité du son [m.s-1]
f = int(input("fréquence ? "))
k = 2*np.pi*f/c        # nombre d'onde acoustique [m-1]
print("f0 = "+str(f)+"Hz")
print("k = "+str(k))
print("xc = "+str(0.6/k*100)+"cm")