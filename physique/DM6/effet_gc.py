import matplotlib.pyplot as plt

k = 4.0
m = 0.1
fs = 0.7
# fd = 0.4
fd = 0.25
g = 9.81
V0 = 1.0

N = 10000
duree = 4.0
dt = duree / (N - 1)

w2 = k / m
seuil = 10 * fd * g * dt

t = [i * dt for i in range(N)]
x = [0]
v = [0]
for i in range(N - 1):
    x.append(x[i] + v[i] * dt)
    if v[i] > seuil:
        v.append(v[i] + (-g * fd + w2 * (V0 * t[i] - x[i])) * dt)
    elif v[i] < -seuil:
        v.append(v[i] + (g * fd + w2 * (V0 * t[i] - x[i])) * dt)
    elif abs(k * (V0 * t[i] - x[i])) > fs * m * g:
        if v[i] >= 0:
            v.append(v[i] + (-g * fd + w2 * (V0 * t[i] - x[i])) * dt)
        else:
            v.append(v[i] + (g * fd + w2 * (V0 * t[i] - x[i])) * dt)
    else:
        v.append(0)

fig, (ax0, ax1) = plt.subplots(2, 1, figsize=(8, 10))
ax0.plot(t, x, color="red", marker=".", label="x(t)")
ax1.plot(t, v, color="blue", marker=".", label="v(t)")


ax0.set_ylabel("x (m)")
ax0.set_xlabel("t (s)")
ax1.set_ylabel("v (m.s-1)")
ax1.set_xlabel("t (s)")
fig.suptitle("effet collé-glissé")
ax0.legend(bbox_to_anchor=(0, 1, 1, 0.1), ncol=2, mode="expand", loc="lower left")
ax1.legend(bbox_to_anchor=(0, 1, 1, 0.1), ncol=2, mode="expand", loc="lower left")
ax0.grid(True, which="both", ls="dotted")
ax1.grid(True, which="both", ls="dotted")
fig.tight_layout()
fig.savefig("figure.pdf")

plt.show()
