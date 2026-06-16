RBF = RealBallField(256)

def rb_exact(q):
    return RBF(QQ(q))

def rb_ball(lo, hi):
    mid = (lo + hi) / 2
    rad = (hi - lo) / 2
    return RBF(mid, rad)

def rb_pos(x):
    return bool(x.lower() > 0)

PI3     = RBF.pi()
CSTAR3  = 17 * RBF(3).sqrt() * PI3**2 / 27   # C_* = 17*sqrt(3)*pi^2/27
TARGET3 = rb_exact(QQ(1) / 10000)             # tolerance 10^{-4}

_QH  = QQ(1) / 6
_QH2 = QQ(1) / 2

def bkpts(p):
    pts = {QQ(0), _QH, _QH2}
    for k in range(p + 1):
        xk = QQ(k) / p
        if QQ(0) <= xk <= _QH2:
            pts.add(xk)
    return sorted(pts)

def sub_intervals(points, lo=None, hi=None):
    if lo is None: lo = _QH
    if hi is None: hi = _QH2
    pts = sorted({lo, hi} | {QQ(v) for v in points if lo <= QQ(v) <= hi})
    return [(pts[i], pts[i+1]) for i in range(len(pts) - 1)]

# Antiderivatives for A(u) = alpha + beta*u  (alpha, beta in QQ):
#   F2_anti = integral A(u) sin(2*pi*u) du
#   F1_anti = integral A(u) sin(2*pi*u) cos(2*pi*u) du

def F2_anti(u, alpha, beta):
    a, b = rb_exact(alpha), rb_exact(beta)
    return (-(a + b*u) * (2*u * PI3).cos() / (2*PI3)
            + b * (2*u * PI3).sin() / (4*PI3**2))

def F1_anti(u, alpha, beta):
    a, b = rb_exact(alpha), rb_exact(beta)
    return (-(a + b*u) * (4*u * PI3).cos() / (8*PI3)
            + b * (4*u * PI3).sin() / (32*PI3**2))

def cell_coeff(p, u_mid):
    ind = 1 if u_mid < _QH else 0
    k   = ZZ(floor(p * u_mid))
    return QQ(ind + k), QQ(1 - p)

def D_interval3(p, lo, hi):
    R     = rb_ball(lo, hi)
    c_rho = (2*R * PI3).cos()
    total = RBF(0)
    pts   = bkpts(p)
    for i in range(len(pts) - 1):
        a, b        = pts[i], pts[i+1]
        alpha, beta = cell_coeff(p, (a + b) / 2)
        aa = rb_ball(a, a)
        if b <= lo:
            bb = rb_ball(b, b)
            total += F1_anti(bb, alpha, beta) - F1_anti(aa, alpha, beta)
            total -= c_rho * (F2_anti(bb, alpha, beta) - F2_anti(aa, alpha, beta))
        elif a <= lo <= hi <= b:
            total += F1_anti(R, alpha, beta) - F1_anti(aa, alpha, beta)
            total -= c_rho * (F2_anti(R, alpha, beta) - F2_anti(aa, alpha, beta))
            break
    return 16 * PI3 * total

def K_interval3(p, q, lo, hi):
    L     = p + q - 1
    R     = rb_ball(lo, hi)
    c     = (2*R * PI3).cos()
    terms = [(QQ(0), 1), (_QH, -1)]
    for n, wt in [(p, 1), (q, 1), (L, -1)]:
        for i in range(1, n//2 + 1):
            terms.append((QQ(i) / n, wt))
    total = RBF(0)
    for alpha, wt in terms:
        if alpha <= lo:
            ca    = (2 * rb_ball(alpha, alpha) * PI3).cos()
            total += RBF(wt) * (ca - c)**2
    return 4 * total

def certify3(func, intervals, threshold=None, max_depth=80):
    if threshold is None:
        threshold = RBF(0)
    stack  = [(lo, hi, 0) for lo, hi in intervals if lo < hi]
    boxes  = 0
    d_max  = 0
    min_lb = None
    while stack:
        lo, hi, depth = stack.pop()
        val = func(lo, hi) - threshold - TARGET3
        if rb_pos(val):
            boxes  += 1
            d_max   = max(d_max, depth)
            lb      = val.lower()
            min_lb  = lb if min_lb is None else min(min_lb, lb)
            continue
        if depth >= max_depth:
            raise RuntimeError(
                f"Certification failed on [{lo},{hi}] at depth {depth}")
        mid = (lo + hi) / 2
        stack.append((lo, mid, depth + 1))
        stack.append((mid, hi, depth + 1))
    return boxes, d_max, min_lb

print("Checking strip certificates "
      "(D_p(rho) - C_*(1/49 + 1/(p+6)^2) >= 1e-4)...")
for p in range(2, 7):
    tail = CSTAR3 * (rb_exact(QQ(1) / 49) + rb_exact(QQ(1) / (p + 6)**2))
    ivs  = sub_intervals(bkpts(p))
    boxes, depth, margin = certify3(
        lambda lo, hi, p=p: D_interval3(p, lo, hi),
        ivs,
        threshold=tail,
    )
    print(f"p={p}: boxes={boxes}, max_depth={depth}, "
          f"margin-after-target>={margin.n(digits=22)}")

print("Checking small-box certificates (K_{p,q}(rho) >= 1e-4)...")
for p in range(2, 7):
    for q in range(p, 7):
        L   = p + q - 1
        pts = {_QH, _QH2}
        for n in [p, q, L]:
            for i in range(1, n//2 + 1):
                xk = QQ(i) / n
                if _QH <= xk <= _QH2:
                    pts.add(xk)
        ivs = sub_intervals(sorted(pts))
        boxes, depth, margin = certify3(
            lambda lo, hi, p=p, q=q: K_interval3(p, q, lo, hi),
            ivs,
            threshold=RBF(0),
        )
        print(f"p={p}, q={q}: boxes={boxes}, max_depth={depth}, "
              f"margin-after-target>={margin.n(digits=22)}")

print("All finite path-splicing certificates passed.")
