import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
from scipy.integrate import odeint


G = 9.8  # Gravitational constant


def force(t):
    """
    Returns force and angle at the given time t.
    """
    f = np.exp(np.sqrt(t)) * np.sin(np.pi*t/10)
    f = t  # * np.sin(np.pi*t)
    angle = np.pi/4 if f > 0 else -np.pi / 4
    angle = (int(t / np.pi) % 360)*np.pi
    return f, angle


def pend(y, t, l, m):
    theta, omega = y
    f, alpha = force(t)
    f = f / l / m
    dydt = [omega, (-G/l + f*np.sin(alpha))*np.sin(theta) - omega/m +
                   (f*np.cos(alpha))*np.cos(theta)]
    return dydt


l = 2  # Length of string
m = 2  # Mass of pendulum
y0 = [np.pi, 0.0]  # Initial conditions

fps = 30
T = 60
frames = fps * T

t = np.linspace(0, T, frames)

sol = odeint(pend, y0, t, args=(l, m))

plt.plot(t, sol[:, 0], 'b', label='theta(t)')
# plt.plot(t, sol[:, 1], 'g', label='omega(t)')
plt.legend(loc='best')
plt.xlabel('t')
plt.grid()
plt.show()
plt.savefig('pendulum.png')

print("Found function:")
for x, theta in zip(t, sol[:, 0]):
    print(x, theta)

plt.clf()

fig = plt.figure()
ax = plt.axes(xlim=(-l-0.5, l+0.5), ylim=(-l-0.5, l+0.5))
ax.grid()
line, = ax.plot([], [], 'o-', lw=2)
time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes)
force_text = ax.text(0.02, 0.85, '', transform=ax.transAxes)
angle_text = ax.text(0.02, 0.90, '', transform=ax.transAxes)


def init():
    line.set_data([], [])
    time_text.set_text('')
    force_text.set_text('')
    angle_text.set_text('')
    return line, time_text


def animate(i):
    if i > len(t):
        i = -1
    x = np.cumsum([0, l * np.sin(sol[i, 0])])
    y = np.cumsum([0, -l * np.cos(sol[i, 0])])
    time_text.set_text("time = %.1f" % t[i])
    f, angle = force(t[i])
    force_text.set_text("force = %.1f" % f)
    angle_text.set_text("angle = %.1f" % (angle*180/np.pi))
    line.set_data(x, y)
    return line, time_text

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
                               frames=frames, interval=10, blit=True)

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
anim.save('basic_animation.mp4', fps=fps, extra_args=['-vcodec', 'libx264'])

plt.show()
