from sage.all import *

R.<th> = PolynomialRing(QQ)

def nonnegative_coefficients(P):
    return all(P[i] >= 0 for i in range(P.degree()+1))

def T_matrix(N):
    T = matrix(R, N, N, 0)
    for i in range(N):
        if i == N-1:
            T[i,i] = 1
        else:
            T[i,i] = 2
    for i in range(N-1):
        T[i,i+1] = 1
        T[i+1,i] = 1
    return T

def moment_poly(N, j):
    T = T_matrix(N)
    b = matrix(R, N, 1, [1] + [0]*(N-2) + [1])
    P = b * b.transpose()
    M = T + th*P
    return (b.transpose() * (M^j) * b)[0,0]

q1 = 4*th + 3
q2 = 8*th^2 + 12*th + 7
q3 = 16*th^3 + 36*th^2 + 37*th + 19
q4 = 32*th^4 + 96*th^3 + 138*th^2 + 118*th + 56
q5 = 64*th^5 + 240*th^4 + 440*th^3 + 507*th^2 + 387*th + 174

assert moment_poly(7,1) == q1
assert moment_poly(7,2) == q2
assert moment_poly(7,3) == q3
assert moment_poly(7,4) == q4
assert moment_poly(7,5) == q5

for N in [3,4,5,6]:
    assert nonnegative_coefficients(moment_poly(N,5) - q5)

S.<t,z> = PolynomialRing(QQ)

A = 1812 - 7*t^4
B = 4001 - 4*t^4

Pt1z = (64*(1-z)^5 + 240*(1-z)^4 + 440*(1-z)^3
                + 507*(1-z)^2 + 387*(1-z) + 174) - t^4*(3 + 4*(1-z))
assert Pt1z == A - B*z + 3907*z^2 - 2040*z^3 + 560*z^4 - 64*z^5

num = A.derivative(t)*B - A*B.derivative(t)
assert num == -83036*t^3

h3 = QQ(1245) / QQ(3677)
assert A.subs(t=3) == 1245
assert B.subs(t=3) == 3677

Dlb = QQ(3907) - QQ(2040)*h3 - QQ(64)*h3^3
assert Dlb > 3000

print("All local fifth-moment and envelope algebra checks passed.")
