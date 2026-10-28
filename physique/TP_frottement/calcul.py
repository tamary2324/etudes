import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd

m1=345
mes_s = pd.read_csv("mesures_fs.csv", sep=';')
mes_d = pd.read_csv("mesures_fd.csv", sep=';')


mes_s["alpha"]=mes_s["alpha"]*np.pi/180.
h = mes_d["L1"]-40
g=9.81

print("h : " + str(h))
fs = -np.tan(mes_s["alpha"])+mes_s["m"]/((m1+mes_s["m2"])*np.cos(mes_s["alpha"]))
fd = mes_d["m"]*h/((mes_d["L1"]-mes_d["L2"])*(m1+mes_d["m2"]+mes_d["m"])-mes_d["m"]*h)

fsm = np.sum(fs)/len(fs)
fdm = np.sum(fd)/len(fd)
fse = np.sqrt(abs(fsm**2-(np.sum(fs**2)/len(fs)))/len(fs))
fde = np.sqrt(abs(fdm**2-(np.sum(fd**2)/len(fd)))/len(fd))

print("fs : " + str(fs))
print("fs = "+ str(fsm) + "+/-" + str(fse))
print("fd : " + str(fd))
print("fd = "+ str(fdm) + "+/-" + str(fde))