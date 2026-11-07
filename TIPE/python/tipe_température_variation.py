import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
#import odrpack as odr

### distance from the origine (1/4 of the total length (564mm)) ###


# model exponetiel
beta0 = [-2.0, 2.0, -0.01]
def f(x: np.ndarray, beta: np.ndarray) -> np.ndarray:
    "Model function."
    return beta[0] + beta[1] * np.exp(beta[2]*x)


# créeation des listes de mesures
list_mesures = []
list_mesures.append(pd.read_csv("mesure1.csv", sep=';'))
list_mesures.append(pd.read_csv("mesure2.csv", sep=';'))
list_mesures.append(pd.read_csv("mesure3.csv", sep=';'))
list_mesures.append(pd.read_csv("mesure4_mod.csv", sep=';'))
color = ["red", "blue", "green", "purple", "black"]


# definition de la figure
fig, axs = plt.subplots(2,2, figsize = (12, 12))
fig.suptitle("diagramme mesure 1")


#graphe par expèrience
for i in range(len(list_mesures)) :
    t1 = list_mesures[i]["Text"]
    t2 = list_mesures[i]["Tint"]
    dt = t1-t2
#    dt_aprox = odr.odr_fit(f, list_mesures[i]["t"], dt, beta0)
    print("")

    axs[0,0].scatter(list_mesures[i]["t"], t1, color=color[i], marker="+", label="T ext n°"+str(i))
    axs[0,0].scatter(list_mesures[i]["t"], t2, color=color[i], marker="x", label="T int n°"+str(i))
    axs[1,0].scatter(list_mesures[i]["t"], dt, color=color[i], marker=".", label="Delta T n°"+str(i))
#    axs[1,0].plot(list_mesures[i]["t"], f(list_mesures[i]["t"],dt_aprox.beta), color=color[i], ls=":", label="model Delta T n°"+str(i))
    axs[0,0].grid(True, which='both', ls='dotted')
    axs[1,0].grid(True, which='both', ls='dotted')
    axs[0,0].set_ylabel("T (°C)")
    axs[0,0].set_xlabel("t (s)")
    axs[1,0].set_ylabel("T (K)")
    axs[1,0].set_xlabel("t (s)")
    axs[0,0].set_title("temperature exterieur et interieur dans chaque expèrience")
    axs[1,0].set_title("difference de temperature dans chaque expèrience")
    axs[0,0].legend(bbox_to_anchor=(.5,.7,.5,.3), ncol=2, mode="expand", loc="upper left")
    axs[1,0].legend(bbox_to_anchor=(.3,.7,.7,.3), ncol=2, mode="expand", loc="upper left")


# graph moyen
t1 = list_mesures[0]["Text"]
t2 = list_mesures[0]["Tint"]
dt = t1 - t2
for i in range(1, len(list_mesures)) :
    t1 += list_mesures[i]["Text"]
    t2 += list_mesures[i]["Tint"]
    dt += list_mesures[i]["Text"] - list_mesures[i]["Tint"]
t1 = t1/len(list_mesures)
t2 = t2/len(list_mesures)
dt = dt/len(list_mesures)
#dt_aprox = odr.odr_fit(f, list_mesures[0]["t"], dt, beta0)

axs[0,1].scatter(list_mesures[0]["t"], t1, color="red", marker="+", label="T ext")
axs[0,1].scatter(list_mesures[0]["t"], t2, color="blue", marker="x", label="T int")
axs[1,1].scatter(list_mesures[0]["t"], dt, color="green", marker=".", label="Delta T")
#axs[1,1].plot(list_mesures[0]["t"], f(list_mesures[0]["t"],dt_aprox.beta), color="purple", ls=":", label="model Delta T")
axs[0,1].grid(True, which='both', ls='dotted')
axs[1,1].grid(True, which='both', ls='dotted')
axs[0,1].set_ylabel("T (°C)")
axs[0,1].set_xlabel("t (s)")
axs[1,1].set_ylabel("T (K)")
axs[1,1].set_xlabel("t (s)")
axs[0,1].set_title("temperature exterieur et interieur moyenne")
axs[1,1].set_title("difference de temperature moyenne")
axs[0,1].legend(bbox_to_anchor=(.6,.9,.4,.1), ncol=2, mode="expand", loc="lower left")
axs[1,1].legend(bbox_to_anchor=(.4,.9,.6,.1), ncol=2, mode="expand", loc="lower left")

#print(dt_aprox.beta)


fig.tight_layout()
fig.savefig("mesure123.pdf")
fig.show()
