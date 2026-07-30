# LUX.SphericalHarmonics

[English](README.md) | [日本語](ja/README.md)

A Delphi (Object Pascal) library for spherical harmonics and the associated Legendre functions on which they are built. Three normalization conventions and several evaluation strategies — explicit polynomials, three-term recurrences and the Belousov four-term recurrence — are provided behind a single interchangeable interface. Every class has a dual-number twin, so values and their derivatives are obtained in one pass by automatic differentiation.

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：Base library supplying the complex and dual-number arithmetic, the normalized Legendre cosine series and the vector/matrix types used by the FireMonkey unit.
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：FireMonkey 3D component framework providing the `TF3DShaper` base class from which `TSPHarmonics3D` derives.

## 1. Overview

The library is organised around one abstract accessor, `TALFs`, that exposes an associated Legendre function table as an indexed property `Ps[n,m]` evaluated at a single argument `X`, together with a maximum degree `DegN`. Every concrete strategy — explicit polynomials, a three-term recurrence, a four-term recurrence — is a descendant of that class, so the evaluation method is a type parameter of the spherical-harmonics classes rather than a branch inside them.

Three normalizations are provided, each as its own class family:

| Family | Symbol | Normalization |
|:---|:---:|:---|
| ALFs (unnormalized) | $`P_n^m(x)`$ | none; Condon–Shortley phase $(-1)^m$ included |
| nALFs (semi-normalized) | $`\tilde{P}_n^m(x)`$ | $`\int_{-1}^{+1}\bigl[\tilde{P}_n^m\bigr]^2dx = 1`$ |
| fnALFs (fully normalized) | $`\overline{P}_n^m(x)`$ | $4\pi$-full, the geodesy convention |

Throughout the library and this document the degree is written $n$ and the order $m$, matching the identifiers `N` and `M` in the source. The colatitude $\theta$ is `AngleY` and the longitude $\phi$ is `AngleX`; the argument of the Legendre functions is $x=\cos\theta$.

### 1.1 Features

- Associated Legendre functions in three normalizations, interchangeable through a common base class.
- Explicit closed-form polynomials for $n \le 8$, useful as a reference implementation.
- Eight three-term recurrences covering every direction of travel through the $(n,m)$ triangle.
- The Belousov four-term recurrence, seeded by a Fourier (cosine) series in $\theta$, which remains stable to very high degree.
- Complex spherical harmonics $Y_n^m$ and real spherical harmonics $\overline{Y}_n^m$.
- A dual-number twin of every class (units suffixed `.Diff`, classes prefixed `Td`) giving exact analytic derivatives.
- A FireMonkey 3D component that renders $\bigl|\overline{Y}_n^m\bigr|$ as a mesh, taking its surface normals from the dual-number derivatives.

### 1.2 Dependencies

The units in this repository depend on the core LUXOPHIA libraries: `LUX`, `LUX.Complex`, `LUX.D1.Diff`, `LUX.Complex.Diff` and `LUX.D1.Legendre` (which supplies the normalized Legendre cosine series used to seed the four-term recurrence). The FireMonkey unit additionally requires `LUX.D2`, `LUX.D3`, `LUX.D4x4` and `LUX.FMX.Graphics.D3`.

## 2. Mathematical Background

### 2.1 Legendre Polynomials and the Rodrigues Formula

The Legendre polynomials are given by the Rodrigues formula

```math
P_n(x) = \frac{1}{2^n\,n!}\,\frac{d^n}{dx^n}\left(x^2-1\right)^n
\qquad \text{(2.1)}
```

and satisfy $P_n(1)=1$, so that $P_0(x)=1$, $P_1(x)=x$ and $P_2(x)=\tfrac{1}{2}(3x^2-1)$.

### 2.2 Associated Legendre Functions

The [associated Legendre polynomials](https://en.wikipedia.org/wiki/Associated_Legendre_polynomials) are the solutions on $[-1,+1]$ of the [associated Legendre differential equation](https://mathworld.wolfram.com/AssociatedLegendreDifferentialEquation.html)

```math
\left(1-x^2\right)\frac{d^2}{dx^2}P_n^m(x)-2x\,\frac{d}{dx}P_n^m(x)+\biggl[n\left(n+1\right)-\frac{m^2}{1-x^2}\biggr]P_n^m(x)=0
\qquad \text{(2.2)}
```

and are defined, with the Condon–Shortley phase factor $(-1)^m$, by

```math
\begin{aligned}
P_{n}^{m}(x)
&= (-1)^{m}\left(1-x^2\right)^{m/2}\frac{d^m}{dx^m}P_{n}(x)\\
&= \frac{(-1)^{m}}{2^{n}\,n!}\left(1-x^2\right)^{m/2}\frac{d^{n+m}}{dx^{n+m}}\left(x^2-1\right)^{n}
\end{aligned}
\qquad \text{(2.3)}
```

The library carries this phase: `TALFsN8.P11` returns $-\sqrt{1-x^2}$, and the sign alternates with $m$ throughout the tables of §2.3.

### 2.3 Low-Degree Explicit Polynomials

`LUX.ALFs.N8` evaluates the following closed forms directly, for $0 \le n \le 8$. Here

```math
x = \cos\theta, \qquad s = \sqrt{1-x^2} = \sin\theta
```

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 0 | 0 | $`P_0^0(x) = 1`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 1 | 0 | $`P_1^0(x) = x`$ |
| 1 | 1 | $`P_1^1(x) = -s`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 2 | 0 | $`P_2^0(x) = \frac{1}{2}\,(3x^2 - 1)`$ |
| 2 | 1 | $`P_2^1(x) = -3\,x\,s`$ |
| 2 | 2 | $`P_2^2(x) = 3\,s^2`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 3 | 0 | $`P_3^0(x) = \frac{1}{2}\,x\,(5x^2 - 3)`$ |
| 3 | 1 | $`P_3^1(x) = -\frac{3}{2}\,(5x^2 - 1)\,s`$ |
| 3 | 2 | $`P_3^2(x) = 15\,x\,s^2`$ |
| 3 | 3 | $`P_3^3(x) = -15\,s^3`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 4 | 0 | $`P_4^0(x) = \frac{1}{8}\,(35x^4 - 30x^2 + 3)`$ |
| 4 | 1 | $`P_4^1(x) = -\frac{5}{2}\,s\,(7x^3 - 3x)`$ |
| 4 | 2 | $`P_4^2(x) = \frac{15}{2}\,s^2\,(7x^2 - 1)`$ |
| 4 | 3 | $`P_4^3(x) = -105\,x\,s^3`$ |
| 4 | 4 | $`P_4^4(x) = 105\,s^4`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 5 | 0 | $`P_5^0(x) = \frac{1}{8}\,x\,(63x^4 - 70x^2 + 15)`$ |
| 5 | 1 | $`P_5^1(x) = -\frac{15}{8}\,s\,(21x^4 - 14x^2 + 1)`$ |
| 5 | 2 | $`P_5^2(x) = \frac{105}{2}\,x\,s^2\,(3x^2 - 1)`$ |
| 5 | 3 | $`P_5^3(x) = -\frac{105}{2}\,s^3\,(9x^2 - 1)`$ |
| 5 | 4 | $`P_5^4(x) = 945\,x\,s^4`$ |
| 5 | 5 | $`P_5^5(x) = -945\,s^5`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 6 | 0 | $`P_6^0(x) = \frac{1}{16}\,(231x^6 - 315x^4 + 105x^2 - 5)`$ |
| 6 | 1 | $`P_6^1(x) = -\frac{21}{8}\,x\,s\,(33x^4 - 30x^2 + 5)`$ |
| 6 | 2 | $`P_6^2(x) = \frac{105}{8}\,s^2\,(33x^4 - 18x^2 + 1)`$ |
| 6 | 3 | $`P_6^3(x) = -\frac{315}{2}\,x\,s^3\,(11x^2 - 3)`$ |
| 6 | 4 | $`P_6^4(x) = \frac{945}{2}\,s^4\,(11x^2 - 1)`$ |
| 6 | 5 | $`P_6^5(x) = -10395\,x\,s^5`$ |
| 6 | 6 | $`P_6^6(x) = 10395\,s^6`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 7 | 0 | $`P_7^0(x) = \frac{1}{16}\,x\,(429x^6 - 693x^4 + 315x^2 - 35)`$ |
| 7 | 1 | $`P_7^1(x) = -\frac{7}{16}\,s\,(429x^6 - 495x^4 + 135x^2 - 5)`$ |
| 7 | 2 | $`P_7^2(x) = \frac{63}{8}\,x\,s^2\,(143x^4 - 110x^2 + 15)`$ |
| 7 | 3 | $`P_7^3(x) = -\frac{315}{8}\,s^3\,(143x^4 - 66x^2 + 3)`$ |
| 7 | 4 | $`P_7^4(x) = \frac{3465}{2}\,x\,s^4\,(13x^2 - 3)`$ |
| 7 | 5 | $`P_7^5(x) = -\frac{10395}{2}\,s^5\,(13x^2 - 1)`$ |
| 7 | 6 | $`P_7^6(x) = 135135\,x\,s^6`$ |
| 7 | 7 | $`P_7^7(x) = -135135\,s^7`$ |

| $`n`$ | $`m`$ | $`P_n^m`$ |
|:---:|:---:|:---|
| 8 | 0 | $`P_8^0(x) = \frac{1}{128}\,(6435x^8 - 12012x^6 + 6930x^4 - 1260x^2 + 35)`$ |
| 8 | 1 | $`P_8^1(x) = -\frac{9}{16}\,x\,s\,(715x^6 - 1001x^4 + 385x^2 - 35)`$ |
| 8 | 2 | $`P_8^2(x) = \frac{315}{16}\,s^2\,(143x^6 - 143x^4 + 33x^2 - 1)`$ |
| 8 | 3 | $`P_8^3(x) = -\frac{3465}{8}\,x\,s^3\,(39x^4 - 26x^2 + 3)`$ |
| 8 | 4 | $`P_8^4(x) = \frac{10395}{8}\,s^4\,(65x^4 - 26x^2 + 1)`$ |
| 8 | 5 | $`P_8^5(x) = -\frac{135135}{2}\,x\,s^5\,(5x^2 - 1)`$ |
| 8 | 6 | $`P_8^6(x) = \frac{135135}{2}\,s^6\,(15x^2 - 1)`$ |
| 8 | 7 | $`P_8^7(x) = -2027025\,x\,s^7`$ |
| 8 | 8 | $`P_8^8(x) = 2027025\,s^8`$ |

### 2.4 Recurrence Relations for the ALFs

Recurrences are the practical route to arbitrary degree. The diagonal of the $(n,m)$ triangle is closed in $x$,

```math
P_n^n(x) = (-1)^n\,(2n-1)!!\,\left(1-x^2\right)^{n/2}
\qquad \text{(2.4)}
```

which `LUX.ALFs.Term3` reaches one step at a time from $P_0^0(x)=1$ by $P_m^m(x) = (1-2m)\,s\,P_{m-1}^{m-1}(x)$:

> Delphi (Object Pascal)
> ```Delphi
> function ALFsPNN( const N:Integer; const X:Double ) :Double;
> var
>    S :Double;
>    I :Integer;
> begin
>      S := Sqrt( 1 - Sqr( X ) );
>      Result := 1;  // N = 0
>      for I := 1 to N do Result := -Result * ( 2 * I - 1 ) * S;
> end;
> ```

`TALFsTerm3` implements all eight three-term relations below, one for each direction of travel through the triangle. The first column of the table shows the stencil — the shaded cells are the operands and the arrow points at the cell being produced — and the second column names the method.

|  |  | Recurrence Relation |
|:----:|:----:|:----|
| ![](--------/Associated%20Legendre%20polynomials/Symbol_ED.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_ED_ON.png) | $`P_n^m(x) = (2m+1)\,x\,P_{n-1}^m(x)\,, \quad n = m + 1`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_EU.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_EU_ON.png) | $`P_n^m(x) = \dfrac{1}{(2m+1)x}P_{n+1}^m(x)\,, \quad n = m`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_RR.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_RR_ON.png) | $`P_n^m(x) = \dfrac{(2m-1)x}{m}\,P_n^{m-1}(x) - \dfrac{n+m-1}{m}\,P_n^{m-2}(x)`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_LR.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_LR_ON.png) | $`P_n^m(x) = \dfrac{1}{(2m+1)x}\Bigl\lbrace(m+1)\,P_n^{m+1}(x) + (n+m)\,P_n^{m-1}(x)\Bigr\rbrace`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_LL.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_LL_ON.png) | $`P_n^m(x) = \dfrac{1}{n+m+1}\Bigl\lbrace(2m+3)x\,P_n^{m+1}(x) - (m+2)\,P_n^{m+2}(x)\Bigr\rbrace`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_DD.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_DD_ON.png) | $`P_n^m(x) = \dfrac{1}{n-m}\Bigl\lbrace (2n-1)\,x\,P_{n-1}^m(x)-(n+m-1)\,P_{n-2}^m(x)\Bigr\rbrace`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_UD.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_UD_ON.png) | $`P_n^m(x) = \dfrac{1}{(2n+1)\,x}\Bigl\lbrace (n+m)\,P_{n-1}^m(x)+(n-m+1)\,P_{n+1}^m(x)\Bigr\rbrace`$ |
| ![](--------/Associated%20Legendre%20polynomials/Symbol_UU.png) | ![](--------/Associated%20Legendre%20polynomials/Icon_UU_ON.png) | $`P_n^m(x) = \dfrac{1}{n+m+1}\Bigl\lbrace (2n+3)\,x\,P_{n+1}^m(x)-(n-m+2)\,P_{n+2}^m(x)\Bigr\rbrace`$ |

The relations that divide by $x$ are singular at the equator and are provided for completeness; the table fill performed by `TALFsTerm3.CalcPs` uses only the diagonal seed, the $n=m+1$ relation and the increasing-degree relation `DD`.

### 2.5 Normalized Associated Legendre Functions

The semi-normalized functions are scaled so that they are orthonormal in $x$ on $[-1,+1]$:

```math
\tilde{P}_n^m(x) = \sqrt{\dfrac{2n+1}{2}\,\dfrac{(n-m)!}{(n+m)!}}\;P_n^m(x)
\qquad \text{(2.5)}
```

```math
\int_{-1}^{+1}\bigl[\tilde{P}_n^m(x)\bigr]^2\,dx = 1
\qquad \text{(2.6)}
```

`TALFsToNALFs<TALFs_>` applies (2.5) as a precomputed factor table on top of any `TALFs` descendant, forming the product $`\sqrt{(2n+1)/2}\prod_{i=n-m+1}^{n+m}i^{-1/2}`$ so that the factorials never appear explicitly. `TNALFsTerm3` and `TNALFsTerm4` instead recur in the normalized functions directly, which is what keeps them well scaled at high degree.

### 2.6 Seed Values for the nALFs

#### 2.6.1 The Diagonal $`\tilde{P}_n^n(x)`$

```math
\tilde{P}_n^n(x) = (-1)^n\,\sqrt{\frac{(2n+1)!!}{2^{\,n+1}\,n!}}\;\left(1-x^2\right)^{n/2}
\qquad \text{(2.7)}
```

> Delphi (Object Pascal)
> ```Delphi
> function NALFsPNN( const N:Integer; const X:Double ) :Double;
> var
>    S :Double;
>    I :Integer;
> begin
>      S := Sqrt( 1 - Sqr( X ) );
>      Result := 1/Sqrt(2);  // N = 0
>      for I := 1 to N do Result := -Result * Sqrt( ( 2 * I + 1 ) / ( 2 * I ) ) * S;
> end;
> ```

#### 2.6.2 The Order-Zero Column $`\tilde{P}_n^0(\cos\theta) = \tilde{P}_n(\cos\theta)`$

The four-term recurrence of §2.7.3 needs the columns $m=0$ and $m=1$ as data. Following Belousov [1], the library obtains them from a finite cosine series in $\theta$, which is numerically benign for every degree because it is a sum of bounded terms:

```math
\tilde{P}_n(\cos \theta) =
\begin{cases}
\dfrac{A_n^0}{2} + \displaystyle\sum_{k=1}^{\tfrac{n}{2}} A_n^{\,2k}\,\cos\left(2k\,\theta\right), & \text{$n$ :even}, \\[1.0em]
\displaystyle\sum_{k=0}^{\tfrac{n-1}{2}} A_n^{\,2k+1}\,\cos\Bigl\{\left(2k+1\right)\theta\Bigr\}, & \text{$n$ :odd}.
\end{cases}
\qquad \text{(2.8)}
```

```math
\begin{aligned}
A_0^0 &= \sqrt{2}\\
A_n^n &= \frac{\sqrt{(2n-1)(2n+1)}}{2n}\,A_{n-1}^{n-1}\\
A_n^k &= \frac{(n-k-1)\,(n+k+2)}{(n-k)\,(n+k+1)}\,A_n^{k+2}\\
\end{aligned}
\qquad \text{(2.9)}
```

Differentiating (2.8) term by term costs nothing extra:

```math
\frac{d}{d\theta}\tilde{P}_n(\cos \theta) =
\begin{cases}
\displaystyle \sum_{k=1}^{\tfrac{n}{2}} -2k\,A_n^{\,2k}\,\sin\left(2k\,\theta\right), & \text{$n$ :even}, \\
\displaystyle \sum_{k=0}^{\tfrac{n-1}{2}} -\left(2k+1\right)\,A_n^{\,2k+1}\,\sin\Bigl\{\left(2k+1\right)\theta\Bigr\}, & \text{$n$ :odd}.
\end{cases}
\qquad \text{(2.10)}
```

Equations (2.8)–(2.10) are implemented by `NLegendreCos` and `dNLegendreCos` in `LUX.D1.Legendre`.

#### 2.6.3 The Order-One Column $`\tilde{P}_n^1(x)`$

The $m=1$ column follows from (2.10) alone, the two square roots of $1-x^2$ cancelling:

```math
\begin{gathered}
\begin{aligned}
\tilde{P}_n^1(x)
&= -\frac{\sqrt{1-x^2}}{\sqrt{n(n+1)}}\,\frac{d}{dx}\,\tilde{P}_n^0(x)\\
&= -\frac{\sqrt{1-x^2}}{\sqrt{n(n+1)}}\,\frac{d\theta}{dx}\frac{d}{d\theta}\,\tilde{P}_n^0(\cos\,\theta)\\
&= -\frac{\sqrt{1-x^2}}{\sqrt{n(n+1)}}\,\frac{-1}{\sqrt{1-x^2}}\,\frac{d}{d\theta}\,\tilde{P}_n^0(\cos\,\theta)\\
&= \frac{1}{\sqrt{n(n+1)}}\,\frac{d}{d\theta}\,\tilde{P}_n^0(\cos\,\theta)\\
\end{aligned}\\
\theta = \cos^{-1}\,x
\end{gathered}
\qquad \text{(2.11)}
```

### 2.7 Recurrence Relations for the nALFs

#### 2.7.1 Two-Term Recurrence

The step from the diagonal to the cell immediately below it:

```math
\tilde{P}_n^m(x) = x\,\sqrt{2m+3}\;\tilde{P}_{n-1}^m(x), \qquad n = m + 1
\qquad \text{(2.12)}
```

#### 2.7.2 Three-Term Recurrence

Fixed order, increasing degree — the normalized counterpart of the `DD` relation of §2.4, used by `TNALFsTerm3`:

```math
\begin{aligned}
\tilde{P}_n^m(x) &= \sqrt{\dfrac{(2n+1)(2n-1)}{(n+m)(n-m)}}\;x\,\tilde{P}_{n-1}^m(x)\\
&- \sqrt{\dfrac{(2n+1)(n+m-1)(n-m-1)}{(2n-3)(n+m)(n-m)}}\;\tilde{P}_{n-2}^m(x)
\end{aligned}
\qquad \text{(2.13)}
```

Together with the diagonal seed (2.7) and the two-term step (2.12) this fills the whole triangle, but the diagonal seed underflows for large $n$, which bounds the usable degree.

#### 2.7.3 Four-Term Recurrence

The Belousov relation [1] [5] advances two steps in degree and two in order at once, and involves no factor that grows with $n$:

```math
\begin{aligned}
\tilde{P}_n^m(x) &= \sqrt{\frac{(2n+1)(n+m-3)(n+m-2)}{(2n-3)(n+m-1)(n+m)}}\;\tilde{P}_{n-2}^{m-2}(x)\\[10pt]
&+ \sqrt{\frac{(2n+1)(n-m-1)(n-m)}{(2n-3)(n+m-1)(n+m)}}\;\tilde{P}_{n-2}^m(x)\\[10pt]
&- \sqrt{\frac{(n-m+1)(n-m+2)}{(n+m-1)(n+m)}}\;\tilde{P}_n^{m-2}(x)\\[10pt]
\tilde{P}_n^m(x) &= 0, \qquad n < m
\end{aligned}
\qquad \text{(2.14)}
```

Because it reaches back two orders, it must be started from the two columns $m=0$ and $m=1$ of §2.6.2 and §2.6.3 rather than from the diagonal. This is what `TNALFsTerm4` does, and it is the reason that class stays accurate where the three-term recurrence has already lost its scale.

> Delphi (Object Pascal)
> ```
> Stencil of NALFsPNM22 — branches are the rows N, leaves are the columns M
> (both counted as offsets from the corner cell P00 = P(n-2,m-2))
>   ┣・N = 0    ：degree n-2
>   ┃  ┣・M = 0    ：(P00)  operand  P(n-2,m-2)  coefficient +A00
>   ┃  ┣・M = 1    ：P01  not used by this stencil
>   ┃  ┗・M = 2    ：(P02)  operand  P(n-2,m)  coefficient +A02
>   ┣・N = 1    ：degree n-1
>   ┃  ┣・M = 0    ：P10  not used by this stencil
>   ┃  ┣・M = 1    ：P11  not used by this stencil
>   ┃  ┗・M = 2    ：P12  not used by this stencil
>   ┗・N = 2    ：degree n
>      ┣・M = 0    ：(P20)  operand  P(n,m-2)  coefficient -A20
>      ┣・M = 1    ：P21  not used by this stencil
>      ┗・M = 2    ：[P22]  result  P(n,m)  produced by eq. (2.14)
> ```
> ```Delphi
> function NALFsPNM22( const N,M:Integer; const P00,P02,P20:Double ) :Double;
> var
>    A00, A02, A20 :Double;
> begin
>      A00 := Sqrt( ( ( 2 * N + 1 ) * ( N + M - 3 ) * ( N + M - 2 ) )
>                 / ( ( 2 * N - 3 ) * ( N + M - 1 ) * ( N + M     ) ) );
>      A02 := Sqrt( ( ( 2 * N + 1 ) * ( N - M - 1 ) * ( N - M     ) )
>                 / ( ( 2 * N - 3 ) * ( N + M - 1 ) * ( N + M     ) ) );
>      A20 := Sqrt( (                 ( N - M + 1 ) * ( N - M + 2 ) )
>                 / (                 ( N + M - 1 ) * ( N + M     ) ) );
>      Result := A00 * P00 + A02 * P02 - A20 * P20;
> end;
> ```

### 2.8 Fully Normalized Associated Legendre Functions

The $4\pi$-fully-normalized functions of geodesy [4] absorb the longitude integral as well, so that the real surface harmonics built from them are orthonormal with respect to the mean over the sphere:

```math
\begin{aligned}
\overline{P}_n^m(x) &= \sqrt{k\,(2n+1)\,\frac{(n-m)!}{(n+m)!}}\;P_n^m(x),\qquad
k =
\begin{cases}
1 & m = 0\\
2 & m \neq 0
\end{cases}\\
&= \sqrt{2k}\;\tilde{P}_n^m(x)
\end{aligned}
\qquad \text{(2.15)}
```

```math
\int_{-1}^{+1}\bigl[\overline{P}_n^m(x)\bigr]^2\,dx = 2k = 2\left(2-\delta_{m0}\right)
\qquad \text{(2.16)}
```

Both routes of (2.15) exist in the library: `TALFsToFNALFs<TALFs_>` normalizes unnormalized ALFs in one step, while `TNALFsToFNALFs<TNALFs_>` rescales already-normalized nALFs by the constant $\sqrt{2k}$, that is by $\sqrt{2}$ for $m=0$ and by $2$ otherwise.

### 2.9 Complex Spherical Harmonics

```math
\begin{aligned}
Y_n^m(\theta,\phi) &= \sqrt{\frac{2n+1}{4\pi}\,\frac{(n-m)!}{(n+m)!}}\;P_n^m\left(\cos\theta\right)\,e^{\,i\,m\,\phi}\\
&= \frac{1}{\sqrt{2\pi}}\;\tilde{P}_n^m\left(\cos\theta\right)\,e^{\,i\,m\,\phi}
\end{aligned}
\qquad \text{(2.17)}
```

The second line of (2.17) is the form `TSPHarmonics<TNALFs_>.GetSHs` evaluates: the nALF table divided by $\sqrt{2\pi}$, times $\cos m\phi + i\sin m\phi$. Only $m \ge 0$ is tabulated, negative orders being obtained from the Condon–Shortley symmetry

```math
Y_n^{-m}(\theta,\phi) = (-1)^m\,\bigl[Y_n^{m}(\theta,\phi)\bigr]^{*}
\qquad \text{(2.18)}
```

which the accessor applies by conjugating and, when $m$ is odd, negating.

### 2.10 Real Spherical Harmonics

```math
\overline{Y}_n^m(\theta,\phi)
= \dfrac{1}{\sqrt{4\pi}}\,
\begin{cases}
\overline{P}_n^{|m|}\left(\cos\theta\right)\,\sin\left(|m|\,\phi\right) & m < 0\\
\overline{P}_n^0\left(\cos\theta\right) & m = 0\\
\overline{P}_n^m\left(\cos\theta\right)\,\cos\left(m\,\phi\right) & m > 0\\
\end{cases}
\qquad \text{(2.19)}
```

Substituting (2.15) into (2.19) gives the equivalent expression in terms of the semi-normalized functions,

```math
\overline{Y}_n^m(\theta,\phi)
= \dfrac{1}{\sqrt{2\pi}}\,
\begin{cases}
\sqrt{2}\;\tilde{P}_n^{|m|}\left(\cos\theta\right)\,\sin\left(|m|\,\phi\right) & m < 0\\
\tilde{P}_n^0\left(\cos\theta\right) & m = 0\\
\sqrt{2}\;\tilde{P}_n^m\left(\cos\theta\right)\,\cos\left(m\,\phi\right) & m > 0\\
\end{cases}
\qquad \text{(2.20)}
```

so the real harmonics are reachable from either family. `TRSPHarmonics<TFNALFs_>` evaluates (2.19) and `TSPHarmonics<TNALFs_>` exposes (2.20) through the same `RSHs[n,m]` property; the two agree identically.

### 2.11 Orthonormality and the Addition Theorem

Here $d\Omega = \sin\theta\,d\theta\,d\phi$, and an asterisk denotes complex conjugation; the overline on $\overline{Y}_n^m$ and $\overline{P}_n^m$ is part of the symbol for the real and fully normalized quantities, never a conjugate. The harmonics of (2.17) form an orthonormal basis of $L^2$ on the sphere,

```math
\int_{0}^{2\pi}\!\!\int_{0}^{\pi} Y_n^m(\theta,\phi)\,\bigl[Y_{n'}^{m'}(\theta,\phi)\bigr]^{*}\;d\Omega = \delta_{nn'}\,\delta_{mm'}
\qquad \text{(2.21)}
```

and so do the real harmonics of (2.19), which is exactly the statement that the factor $k$ of (2.15) was chosen to produce:

```math
\int_{0}^{2\pi}\!\!\int_{0}^{\pi} \overline{Y}_n^m(\theta,\phi)\;\overline{Y}_{n'}^{m'}(\theta,\phi)\;d\Omega = \delta_{nn'}\,\delta_{mm'}
\qquad \text{(2.22)}
```

The addition theorem collapses a full order sum onto a single Legendre polynomial of the angle $\gamma$ between two directions,

```math
\sum_{m=-n}^{n} Y_n^m(\theta_1,\phi_1)\,\bigl[Y_n^m(\theta_2,\phi_2)\bigr]^{*} = \frac{2n+1}{4\pi}\,P_n\!\left(\cos\gamma\right)
\qquad \text{(2.23)}
```

```math
\cos\gamma = \cos\theta_1\cos\theta_2 + \sin\theta_1\sin\theta_2\cos\left(\phi_1-\phi_2\right)
\qquad \text{(2.24)}
```

Setting $\gamma=0$ in (2.23) gives $`\sum_m \bigl|Y_n^m\bigr|^2 = (2n+1)/4\pi`$, a convenient check on a filled table.

### 2.12 The Spectral Laplacian

Every harmonic of degree $n$ is an eigenfunction of the Laplace–Beltrami operator on the unit sphere,

```math
\nabla^2 = \frac{1}{\sin\theta}\frac{\partial}{\partial\theta}\left(\sin\theta\,\frac{\partial}{\partial\theta}\right) + \frac{1}{\sin^2\theta}\frac{\partial^2}{\partial\phi^2}
\qquad \text{(2.25)}
```

with eigenvalue depending on the degree alone,

```math
\nabla^2 Y_n^m = -n(n+1)\,Y_n^m
\qquad \text{(2.26)}
```

and identically for $\overline{Y}_n^m$. Equation (2.26) is the origin of the $n(n+1)$ in the associated Legendre equation (2.2), and of the $\sqrt{n(n+1)}$ in the order-one seed (2.11).

### 2.13 Automatic Differentiation with Dual Numbers

The `.Diff` units repeat every class with `Double` replaced by the dual number `TdDouble`, a pair of an ordinary part `o` and a derivative part `d`:

```math
\hat{a} = a + a'\,\varepsilon, \qquad \varepsilon^2 = 0
\qquad \text{(2.27)}
```

Arithmetic on this ring propagates the chain rule exactly, so evaluating an unmodified recurrence on dual arguments yields the derivative alongside the value:

```math
f\!\left(a + a'\,\varepsilon\right) = f(a) + f'(a)\,a'\,\varepsilon
\qquad \text{(2.28)}
```

No formula is differentiated by hand and no finite difference is taken: `TdNALFsTerm4.CalcPs` is the same recurrence as `TNALFsTerm4.CalcPs` with a different scalar type. `TSPHarmonics3D` exploits this by evaluating the harmonic at dual-valued angles, reading the two tangent vectors off the derivative parts, and taking their cross product as the exact surface normal of the rendered mesh.

## 3. Architecture

### 3.1 Class Hierarchy

`TALFs` is the sole abstract interface: a maximum degree `DegN`, an argument `X`, a default indexed property `Ps[n,m]`, and an `OnChange` delegate list that propagates invalidation. Everything else is a strategy behind it. `TCoreALFs` adds plain storage of `DegN` and `X`; `TMapALFs` adds the triangular table `_Ps` and the `CalcPs` hook that fills it whenever `DegN` or `X` changes.

```
・TALFs                               ･･･ LUX.ALFs
  ┣・TCoreALFs                       ･･･ LUX.ALFs
  ┃  ┣・TALFsN8                     ･･･ LUX.ALFs.N8  explicit, n <= 8
  ┃  ┗・TMapALFs                    ･･･ LUX.ALFs
  ┃     ┗・TALFsTerm3               ･･･ LUX.ALFs.Term3  (2.4) + 8 relations
  ┗・TNALFs                          ･･･ LUX.NALFs
     ┣・TCoreNALFs                   ･･･ LUX.NALFs
     ┃  ┗・TMapNALFs                ･･･ LUX.NALFs
     ┃     ┣・TNALFsTerm3           ･･･ LUX.NALFs.Term3  eq. (2.7)(2.12)(2.13)
     ┃     ┗・TNALFsTerm4           ･･･ LUX.NALFs.Term4  (2.8)-(2.11)(2.14)
     ┣・TALFsToNALFs<TALFs_>         ･･･ LUX.NALFs  eq. (2.5) as factor table
     ┗・TFNALFs                      ･･･ LUX.FNALFs
        ┣・TALFsToFNALFs<TALFs_>     ･･･ LUX.FNALFs  eq. (2.15) from P
        ┗・TNALFsToFNALFs<TNALFs_>   ･･･ LUX.FNALFs  eq. (2.15) from P~

・TSPHarmonics                        ･･･ LUX.SH
  ┣・TSPHarmonics<TNALFs_:TNALFs>    ･･･ LUX.SH  SHs[n,m], RSHs[n,m]
  ┗・TRSPHarmonics<TFNALFs_:TFNALFs> ･･･ LUX.SH  RSHs[n,m]

・TF3DShaper                          ･･･ LUX.FMX.Graphics.D3.Shaper
  ┗・TSPHarmonics3D                  ･･･ LUX.SH.FMX.Graphics.D3
```

The dual-number hierarchy mirrors this one exactly, class for class, with a `Td` prefix in place of `T`: `TdALFs`, `TdCoreALFs`, `TdMapALFs`, `TdALFsN8`, `TdALFsTerm3`, `TdNALFs`, `TdCoreNALFs`, `TdMapNALFs`, `TdNALFsTerm3`, `TdNALFsTerm4`, `TdALFsToNALFs<>`, `TdFNALFs`, `TdALFsToFNALFs<>`, `TdNALFsToFNALFs<>`, `TdSPHarmonics`, `TdSPHarmonics<>` and `TdRSPHarmonics<>`.

Note that the generic constraints carry the normalization: `TSPHarmonics<TNALFs_:TNALFs>` accepts only semi-normalized providers, because (2.17) is written in terms of $\tilde{P}_n^m$, while `TRSPHarmonics<TFNALFs_:TFNALFs>` accepts only fully normalized ones, because (2.19) is written in terms of $\overline{P}_n^m$. A mismatched normalization is therefore a compile-time error rather than a silently wrong amplitude.

### 3.2 File Layout

```
・LUX.SphericalHarmonics/
  ┣・LUX.SH.pas                           ･･･ TSPHarmonics and the generics
  ┣・LUX.SH.Diff.pas                      ･･･ dual-number twin of the above
  ┣・ALFs/
  ┃  ┣・LUX.ALFs.pas                     ･･･ abstract API: DegN, X, Ps[n,m]
  ┃  ┣・LUX.ALFs.Diff.pas
  ┃  ┣・LUX.ALFs.N8.pas                  ･･･ closed forms of section 2.3
  ┃  ┣・LUX.ALFs.N8.Diff.pas
  ┃  ┣・LUX.ALFs.Term3.pas               ･･･ eight relations of section 2.4
  ┃  ┗・LUX.ALFs.Term3.Diff.pas
  ┣・NALFs/
  ┃  ┣・LUX.NALFs.pas                    ･･･ normalization factors of (2.5)
  ┃  ┣・LUX.NALFs.Diff.pas
  ┃  ┣・LUX.NALFs.Term3.pas              ･･･ three-term recurrence, eq. (2.13)
  ┃  ┣・LUX.NALFs.Term3.Diff.pas
  ┃  ┣・LUX.NALFs.Term4.pas              ･･･ four-term recurrence, eq. (2.14)
  ┃  ┗・LUX.NALFs.Term4.Diff.pas
  ┣・FNALFs/
  ┃  ┣・LUX.FNALFs.pas                   ･･･ 4-pi normalization of eq. (2.15)
  ┃  ┗・LUX.FNALFs.Diff.pas
  ┣・FMX/
  ┃  ┗・LUX.SH.FMX.Graphics.D3.pas       ･･･ TSPHarmonics3D, a 3D mesh
  ┣・--------/
  ┃  ┗・Associated Legendre polynomials/ ･･･ stencil figures of section 2.4
  ┣・LICENSE
  ┣・README.md
  ┗・ja/
     ┗・README.md
```

## 4. Usage

Choose an evaluation strategy as the type parameter, set the two angles, and read the harmonics out of the indexed property. `SHs[n,m]` is the default property, so it may be written as an index on the object itself.

```Delphi
uses LUX, LUX.Complex,
     LUX.SH, LUX.NALFs.Term4, LUX.FNALFs;

procedure Sample;
var
   SH  :TSPHarmonics<TNALFsTerm4>;
   RSH :TRSPHarmonics<TNALFsToFNALFs<TNALFsTerm4>>;
   Y   :TDoubleC;
begin
     ///// complex harmonics, eq. (2.17)

     SH := TSPHarmonics<TNALFsTerm4>.Create( 64 );  // maximum degree n = 64
     try
        SH.AngleY := Pi / 3;  // theta :colatitude
        SH.AngleX := Pi / 4;  // phi   :longitude

        Y := SH[ 10, 3 ];     // Y(n=10,m=+3) as TDoubleC

        Writeln( Y.R:0:12, ' ', Y.I:0:12 );
     finally
        SH.Free;
     end;

     ///// real harmonics, eq. (2.19)

     RSH := TRSPHarmonics<TNALFsToFNALFs<TNALFsTerm4>>.Create( 64 );
     try
        RSH.AngleY := Pi / 3;
        RSH.AngleX := Pi / 4;

        Writeln( RSH.RSHs[ 10, -3 ]:0:12 );
     finally
        RSH.Free;
     end;
end;
```

Swapping `TNALFsTerm4` for `TNALFsTerm3`, or for `TALFsToNALFs<TALFsTerm3>` or `TALFsToNALFs<TALFsN8>`, changes nothing but the evaluation path — useful for cross-checking one strategy against another at low degree.

To visualise a single harmonic, drop a `TSPHarmonics3D` into a FireMonkey 3D scene, assign a `TdSPHarmonics` descendant to its `SPHarm` property and set `N` and `M`. The component samples $\bigl|\sqrt{4\pi}\,\overline{Y}_n^m\bigr|$ as the radius over a `DivX` by `DivY` grid and takes its normals from the dual-number derivatives of §2.13.

## 5. License

Released under the [MIT License](LICENSE).

## 6. References

1. Belousov, S. L., [*Tables of Normalized Associated Legendre Polynomials*](https://www.sciencedirect.com/book/9780080097237/tables-of-normalized-associated-legendre-polynomials), Mathematical Tables Series, Vol. 18, Pergamon Press, 1962.
2. Abramowitz, M. and Stegun, I. A. (eds.), [*Handbook of Mathematical Functions with Formulas, Graphs, and Mathematical Tables*](https://personal.math.ubc.ca/~cbm/aands/), National Bureau of Standards Applied Mathematics Series 55, 1964. Chapter 8, "Legendre Functions", pp. 331–341.
3. Nehrkorn, T., [*On the Computation of Legendre Functions in Spectral Models*](https://doi.org/10.1175/1520-0493(1990)118%3C2248:OTCOLF%3E2.0.CO;2), Monthly Weather Review, 118, 2248–2251, 1990.
4. Holmes, S. A. and Featherstone, W. E., [*A unified approach to the Clenshaw summation and the recursive computation of very high degree and order normalised associated Legendre functions*](https://doi.org/10.1007/s00190-002-0216-2), Journal of Geodesy, 76, 279–299, 2002.
5. Enomoto, T., [*Comparison of Computational Methods of Associated Legendre Functions*](https://doi.org/10.2151/sola.2015-033), SOLA (Scientific Online Letters on the Atmosphere), 11, 144–149, 2015.
6. Fang, Y., Wang, Q. and Yang, Y., [*Realizing the Calculation of a Fully Normalized Associated Legendre Function Based on an FPGA*](https://doi.org/10.3390/s24227262), Sensors, 24, 7262, 2024.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
