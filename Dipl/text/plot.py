import matplotlib.pyplot as plt

def cords(gen):
    def nxt(x,y,c):
        if c == 'A': return x-1,y
        if c == 'G': return x+1,y
        if c == 'C': return x,y+1
        return x, y-1
    x,y=0,0
    xs = [0]
    ys = [0]
    for c in gen:
        x,y = nxt(x,y,c)
        xs.append(x)
        ys.append(y)
    return xs,ys

gen = "ATGCTGCTGA"
xs,ys = cords(gen)
plt.axis([-3,3,-3,3])
plt.plot(xs,ys,'b',alpha=1.)
plt.plot(xs,ys,'ro',alpha=1.)
print(xs,ys)
for xy,i in zip(zip(xs[1:], ys[1:]),range(0,len(gen))):
    print(xy,i)
    plt.annotate(gen[0:i+1], xy=xy,alpha=0.7)
plt.grid()
plt.savefig('meth3.png')
