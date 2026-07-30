# LUX.SphericalHarmonics

[English](../README.md) | [日本語](README.md)

球面調和関数と、その基礎となるルジャンドル陪関数のための Delphi（Object Pascal）ライブラリ。３種類の正規化と複数の計算手法 — 明示的多項式・３項間漸化式・Belousov の４項間漸化式 — を、単一の差し替え可能なインターフェイスの背後に提供します。すべてのクラスに二重数版の対応クラスがあり、自動微分によって値と導関数が一度の計算で同時に得られます。

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：複素数・二重数の算術、正規化ルジャンドル余弦級数、FireMonkey ユニットで用いるベクトル／行列型を提供する基底ライブラリ。
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：`TSPHarmonics3D` が継承する基底クラス `TF3DShaper` を提供する FireMonkey 3D コンポーネントフレームワーク。

## 1. 概要

本ライブラリは、単一の抽象アクセサ `TALFs` を中心に構成されています。このクラスは、ひとつの引数 `X` において評価されたルジャンドル陪関数の表をインデックス付きプロパティ `Ps[n,m]` として公開し、あわせて最大次数 `DegN` を持ちます。個々の具体的な計算手法 — 明示的多項式・３項間漸化式・４項間漸化式 — はすべてこのクラスの子孫であり、したがって計算手法は球面調和関数クラス内部の分岐ではなく、その型引数として与えられます。

正規化は３種類あり、それぞれが独立したクラス族になっています。

| 族 | 記号 | 正規化 |
|:---|:---:|:---|
| ALFs（無正規化） | $`P_n^m(x)`$ | なし。Condon–Shortley 位相 $(-1)^m$ を含む |
| nALFs（正規化） | $`\tilde{P}_n^m(x)`$ | $`\int_{-1}^{+1}\bigl[\tilde{P}_n^m\bigr]^2dx = 1`$ |
| fnALFs（完全正規化） | $`\overline{P}_n^m(x)`$ | $4\pi$ 完全正規化。測地学の慣例 |

ライブラリ全体および本稿では、次数を $n$、階数を $m$ と表記し、ソース中の識別子 `N`・`M` と一致させています。余緯度 $\theta$ が `AngleY`、経度 $\phi$ が `AngleX` であり、ルジャンドル関数の引数は $x=\cos\theta$ です。

### 1.1 機能

- ３種類の正規化によるルジャンドル陪関数。共通の基底クラスを通じて相互に差し替え可能。
- $n \le 8$ に対する明示的な閉形式多項式。参照実装として有用。
- $(n,m)$ 三角形内のあらゆる進行方向を網羅する８種類の３項間漸化式。
- $\theta$ に関するフーリエ（余弦）級数を初項とする Belousov の４項間漸化式。極めて高次まで安定。
- 複素球面調和関数 $Y_n^m$ および実球面調和関数 $\overline{Y}_n^m$。
- 全クラスの二重数版（ユニット名の接尾辞 `.Diff`、クラス名の接頭辞 `Td`）による厳密な解析的導関数。
- $\bigl|\overline{Y}_n^m\bigr|$ をメッシュとして描画する FireMonkey 3D コンポーネント。法線は二重数の導関数から得る。

### 1.2 依存関係

本リポジトリのユニットは、LUXOPHIA コアライブラリに依存します。すなわち `LUX`・`LUX.Complex`・`LUX.D1.Diff`・`LUX.Complex.Diff`、および ４項間漸化式の初項に用いる正規化ルジャンドル余弦級数を提供する `LUX.D1.Legendre` です。FireMonkey ユニットはさらに `LUX.D2`・`LUX.D3`・`LUX.D4x4`・`LUX.FMX.Graphics.D3` を必要とします。

## 2. 数学的背景

### 2.1 ルジャンドル多項式とロドリゲスの公式

ルジャンドル多項式はロドリゲスの公式

```math
P_n(x) = \frac{1}{2^n\,n!}\,\frac{d^n}{dx^n}\left(x^2-1\right)^n
\qquad \text{(2.1)}
```

によって与えられ、$P_n(1)=1$ を満たします。したがって $P_0(x)=1$、$P_1(x)=x$、$P_2(x)=\tfrac{1}{2}(3x^2-1)$ となります。

### 2.2 ルジャンドル陪関数

[ルジャンドル陪関数](https://ja.wikipedia.org/wiki/%E3%83%AB%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%89%E3%83%AB%E5%A4%9A%E9%A0%85%E5%BC%8F#%E3%83%AB%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%89%E3%83%AB%E9%99%AA%E5%A4%9A%E9%A0%85%E5%BC%8F)は、[ルジャンドル陪微分方程式](https://mathworld.wolfram.com/AssociatedLegendreDifferentialEquation.html)

```math
\left(1-x^2\right)\frac{d^2}{dx^2}P_n^m(x)-2x\,\frac{d}{dx}P_n^m(x)+\biggl[n\left(n+1\right)-\frac{m^2}{1-x^2}\biggr]P_n^m(x)=0
\qquad \text{(2.2)}
```

の $[-1,+1]$ における解であり、Condon–Shortley 位相因子 $(-1)^m$ を含めて次式のように定義されます。

```math
\begin{aligned}
P_{n}^{m}(x)
&= (-1)^{m}\left(1-x^2\right)^{m/2}\frac{d^m}{dx^m}P_{n}(x)\\
&= \frac{(-1)^{m}}{2^{n}\,n!}\left(1-x^2\right)^{m/2}\frac{d^{n+m}}{dx^{n+m}}\left(x^2-1\right)^{n}
\end{aligned}
\qquad \text{(2.3)}
```

本ライブラリはこの位相を保持します。`TALFsN8.P11` は $-\sqrt{1-x^2}$ を返し、2.3 節の表全体を通じて符号が $m$ とともに交替します。

### 2.3 低次の明示的多項式

`LUX.ALFs.N8` は $0 \le n \le 8$ に対して、以下の閉形式を直接評価します。ここで

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

### 2.4 ルジャンドル陪関数の漸化式

任意次数へ到達する実用的な経路は漸化式です。$(n,m)$ 三角形の対角成分は $x$ について閉じた形をもち、

```math
P_n^n(x) = (-1)^n\,(2n-1)!!\,\left(1-x^2\right)^{n/2}
\qquad \text{(2.4)}
```

`LUX.ALFs.Term3` はこれを、$P_0^0(x)=1$ から $P_m^m(x) = (1-2m)\,s\,P_{m-1}^{m-1}(x)$ によって一段ずつたどって求めます。

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

`TALFsTerm3` は、三角形内の進行方向ごとに対応する以下の８種すべての３項間漸化式を実装しています。第１列はステンシル（網掛けのセルが被演算子、矢印の先が生成されるセル）を示し、第２列はメソッドを表します。

|  |  | 漸化式 |
|:----:|:----:|:----|
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_ED.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_ED_ON.png) | $`P_n^m(x) = (2m+1)\,x\,P_{n-1}^m(x)\,, \quad n = m + 1`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_EU.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_EU_ON.png) | $`P_n^m(x) = \dfrac{1}{(2m+1)x}P_{n+1}^m(x)\,, \quad n = m`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_RR.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_RR_ON.png) | $`P_n^m(x) = \dfrac{(2m-1)x}{m}\,P_n^{m-1}(x) - \dfrac{n+m-1}{m}\,P_n^{m-2}(x)`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_LR.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_LR_ON.png) | $`P_n^m(x) = \dfrac{1}{(2m+1)x}\Bigl\lbrace(m+1)\,P_n^{m+1}(x) + (n+m)\,P_n^{m-1}(x)\Bigr\rbrace`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_LL.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_LL_ON.png) | $`P_n^m(x) = \dfrac{1}{n+m+1}\Bigl\lbrace(2m+3)x\,P_n^{m+1}(x) - (m+2)\,P_n^{m+2}(x)\Bigr\rbrace`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_DD.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_DD_ON.png) | $`P_n^m(x) = \dfrac{1}{n-m}\Bigl\lbrace (2n-1)\,x\,P_{n-1}^m(x)-(n+m-1)\,P_{n-2}^m(x)\Bigr\rbrace`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_UD.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_UD_ON.png) | $`P_n^m(x) = \dfrac{1}{(2n+1)\,x}\Bigl\lbrace (n+m)\,P_{n-1}^m(x)+(n-m+1)\,P_{n+1}^m(x)\Bigr\rbrace`$ |
| ![](../--------/Associated%20Legendre%20polynomials/Symbol_UU.png) | ![](../--------/Associated%20Legendre%20polynomials/Icon_UU_ON.png) | $`P_n^m(x) = \dfrac{1}{n+m+1}\Bigl\lbrace (2n+3)\,x\,P_{n+1}^m(x)-(n-m+2)\,P_{n+2}^m(x)\Bigr\rbrace`$ |

$x$ で除する関係式は赤道上で特異であり、完全性のために用意されています。`TALFsTerm3.CalcPs` による表の充填が用いるのは、対角成分の初項・$n=m+1$ の関係式・次数を増やす `DD` の関係式のみです。

### 2.5 正規化ルジャンドル陪関数

正規化された関数は、$[-1,+1]$ 上で $x$ について正規直交となるように尺度づけされています。

```math
\tilde{P}_n^m(x) = \sqrt{\dfrac{2n+1}{2}\,\dfrac{(n-m)!}{(n+m)!}}\;P_n^m(x)
\qquad \text{(2.5)}
```

```math
\int_{-1}^{+1}\bigl[\tilde{P}_n^m(x)\bigr]^2\,dx = 1
\qquad \text{(2.6)}
```

`TALFsToNALFs<TALFs_>` は、任意の `TALFs` 子孫の上に (2.5) を事前計算した係数表として適用します。その際、積 $`\sqrt{(2n+1)/2}\prod_{i=n-m+1}^{n+m}i^{-1/2}`$ の形をとることで、階乗が明示的に現れないようにしています。一方 `TNALFsTerm3` と `TNALFsTerm4` は正規化された関数そのものについて漸化するため、高次でも尺度が良好に保たれます。

### 2.6 nALFs の初項

#### 2.6.1 対角成分 $`\tilde{P}_n^n(x)`$

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

#### 2.6.2 階数 0 の列 $`\tilde{P}_n^0(\cos\theta) = \tilde{P}_n(\cos\theta)`$

2.7.3 節の４項間漸化式は、$m=0$ と $m=1$ の列を所与のデータとして必要とします。Belousov [1] にしたがい、本ライブラリはこれらを $\theta$ に関する有限余弦級数から得ます。有界な項の和であるため、どの次数でも数値的に良性です。

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

(2.8) を項別に微分する追加費用はありません。

```math
\frac{d}{d\theta}\tilde{P}_n(\cos \theta) =
\begin{cases}
\displaystyle \sum_{k=1}^{\tfrac{n}{2}} -2k\,A_n^{\,2k}\,\sin\left(2k\,\theta\right), & \text{$n$ :even}, \\
\displaystyle \sum_{k=0}^{\tfrac{n-1}{2}} -\left(2k+1\right)\,A_n^{\,2k+1}\,\sin\Bigl\{\left(2k+1\right)\theta\Bigr\}, & \text{$n$ :odd}.
\end{cases}
\qquad \text{(2.10)}
```

式 (2.8)〜(2.10) は `LUX.D1.Legendre` の `NLegendreCos` および `dNLegendreCos` が実装しています。

#### 2.6.3 階数 1 の列 $`\tilde{P}_n^1(x)`$

$m=1$ の列は (2.10) のみから導かれます。２つの $\sqrt{1-x^2}$ が相殺します。

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

### 2.7 nALFs の漸化式

#### 2.7.1 ２項間漸化式

対角成分から、その直下のセルへ進む一段。

```math
\tilde{P}_n^m(x) = x\,\sqrt{2m+3}\;\tilde{P}_{n-1}^m(x), \qquad n = m + 1
\qquad \text{(2.12)}
```

#### 2.7.2 ３項間漸化式

階数を固定して次数を増やす関係式 — 2.4 節の `DD` の正規化版であり、`TNALFsTerm3` が用います。

```math
\begin{aligned}
\tilde{P}_n^m(x) &= \sqrt{\dfrac{(2n+1)(2n-1)}{(n+m)(n-m)}}\;x\,\tilde{P}_{n-1}^m(x)\\
&- \sqrt{\dfrac{(2n+1)(n+m-1)(n-m-1)}{(2n-3)(n+m)(n-m)}}\;\tilde{P}_{n-2}^m(x)
\end{aligned}
\qquad \text{(2.13)}
```

対角成分の初項 (2.7) と ２項間の一段 (2.12) とあわせれば三角形全体を充填できますが、$n$ が大きくなると対角成分の初項がアンダーフローするため、実用可能な次数が制限されます。

#### 2.7.3 ４項間漸化式

Belousov の関係式 [1] [5] は、次数について２段・階数について２段を一度に進め、$n$ とともに増大する因子を含みません。

```math
\begin{aligned}
\tilde{P}_n^m(x) &= \sqrt{\frac{(2n+1)(n+m-3)(n+m-2)}{(2n-3)(n+m-1)(n+m)}}\;\tilde{P}_{n-2}^{m-2}(x)\\[10pt]
&+ \sqrt{\frac{(2n+1)(n-m-1)(n-m)}{(2n-3)(n+m-1)(n+m)}}\;\tilde{P}_{n-2}^m(x)\\[10pt]
&- \sqrt{\frac{(n-m+1)(n-m+2)}{(n+m-1)(n+m)}}\;\tilde{P}_n^{m-2}(x)\\[10pt]
\tilde{P}_n^m(x) &= 0, \qquad n < m
\end{aligned}
\qquad \text{(2.14)}
```

階数を２段さかのぼるため、この式は対角成分ではなく 2.6.2 節・2.6.3 節の $m=0$・$m=1$ の２列から開始しなければなりません。`TNALFsTerm4` はこれを行っており、そのため ３項間漸化式が既に尺度を失っている領域でも精度を保ちます。

> Delphi (Object Pascal)
> ```
> NALFsPNM22 のステンシル — 枝が行 N、葉が列 M
> （いずれも隅のセル P00 = P(n-2,m-2) からのオフセット）
>   ┣・N = 0    ：次数 n-2
>   ┃  ┣・M = 0    ：(P00)  被演算子  P(n-2,m-2)  係数 +A00
>   ┃  ┣・M = 1    ：P01  このステンシルでは未使用
>   ┃  ┗・M = 2    ：(P02)  被演算子  P(n-2,m)  係数 +A02
>   ┣・N = 1    ：次数 n-1
>   ┃  ┣・M = 0    ：P10  このステンシルでは未使用
>   ┃  ┣・M = 1    ：P11  このステンシルでは未使用
>   ┃  ┗・M = 2    ：P12  このステンシルでは未使用
>   ┗・N = 2    ：次数 n
>      ┣・M = 0    ：(P20)  被演算子  P(n,m-2)  係数 -A20
>      ┣・M = 1    ：P21  このステンシルでは未使用
>      ┗・M = 2    ：[P22]  結果  P(n,m)  式 (2.14) が求めるセル
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

### 2.8 完全正規化ルジャンドル陪関数

測地学における $4\pi$ 完全正規化関数 [4] は経度方向の積分も吸収するため、そこから構成される実表面調和関数は球面平均に関して正規直交になります。

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

(2.15) の両方の経路がライブラリに存在します。`TALFsToFNALFs<TALFs_>` は無正規化 ALFs を一段で正規化し、`TNALFsToFNALFs<TNALFs_>` は既に正規化された nALFs を定数 $\sqrt{2k}$、すなわち $m=0$ では $\sqrt{2}$、それ以外では $2$ で再尺度づけします。

### 2.9 複素球面調和関数

```math
\begin{aligned}
Y_n^m(\theta,\phi) &= \sqrt{\frac{2n+1}{4\pi}\,\frac{(n-m)!}{(n+m)!}}\;P_n^m\left(\cos\theta\right)\,e^{\,i\,m\,\phi}\\
&= \frac{1}{\sqrt{2\pi}}\;\tilde{P}_n^m\left(\cos\theta\right)\,e^{\,i\,m\,\phi}
\end{aligned}
\qquad \text{(2.17)}
```

(2.17) の第２式が `TSPHarmonics<TNALFs_>.GetSHs` が評価する形です。すなわち nALF の表を $\sqrt{2\pi}$ で除し、$\cos m\phi + i\sin m\phi$ を掛けます。表に保持されるのは $m \ge 0$ のみで、負の階数は Condon–Shortley 対称性

```math
Y_n^{-m}(\theta,\phi) = (-1)^m\,\bigl[Y_n^{m}(\theta,\phi)\bigr]^{*}
\qquad \text{(2.18)}
```

から得られます。アクセサは共役をとり、$m$ が奇数のときは符号を反転させることでこれを適用します。

### 2.10 実球面調和関数

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

(2.19) に (2.15) を代入すると、正規化された関数による等価な表式が得られます。

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

したがって実調和関数はいずれの族からも到達できます。`TRSPHarmonics<TFNALFs_>` は (2.19) を評価し、`TSPHarmonics<TNALFs_>` は同じ `RSHs[n,m]` プロパティを通じて (2.20) を公開します。両者は恒等的に一致します。

### 2.11 正規直交性と加法定理

ここで $d\Omega = \sin\theta\,d\theta\,d\phi$ であり、アスタリスクは複素共役を表します。$\overline{Y}_n^m$ および $\overline{P}_n^m$ の上線は実量・完全正規化量を表す記号の一部であって、共役ではありません。(2.17) の調和関数は球面上の $L^2$ の正規直交基底をなし、

```math
\int_{0}^{2\pi}\!\!\int_{0}^{\pi} Y_n^m(\theta,\phi)\,\bigl[Y_{n'}^{m'}(\theta,\phi)\bigr]^{*}\;d\Omega = \delta_{nn'}\,\delta_{mm'}
\qquad \text{(2.21)}
```

(2.19) の実調和関数もまた同様です。これはまさに、(2.15) の因子 $k$ がそのために選ばれた性質です。

```math
\int_{0}^{2\pi}\!\!\int_{0}^{\pi} \overline{Y}_n^m(\theta,\phi)\;\overline{Y}_{n'}^{m'}(\theta,\phi)\;d\Omega = \delta_{nn'}\,\delta_{mm'}
\qquad \text{(2.22)}
```

加法定理は、階数についての総和を２方向のなす角 $\gamma$ のルジャンドル多項式ひとつに帰着させます。

```math
\sum_{m=-n}^{n} Y_n^m(\theta_1,\phi_1)\,\bigl[Y_n^m(\theta_2,\phi_2)\bigr]^{*} = \frac{2n+1}{4\pi}\,P_n\!\left(\cos\gamma\right)
\qquad \text{(2.23)}
```

```math
\cos\gamma = \cos\theta_1\cos\theta_2 + \sin\theta_1\sin\theta_2\cos\left(\phi_1-\phi_2\right)
\qquad \text{(2.24)}
```

(2.23) で $\gamma=0$ とおくと $`\sum_m \bigl|Y_n^m\bigr|^2 = (2n+1)/4\pi`$ が得られ、充填済みの表に対する簡便な検算になります。

### 2.12 スペクトルラプラシアン

次数 $n$ のすべての調和関数は、単位球面上のラプラス–ベルトラミ作用素

```math
\nabla^2 = \frac{1}{\sin\theta}\frac{\partial}{\partial\theta}\left(\sin\theta\,\frac{\partial}{\partial\theta}\right) + \frac{1}{\sin^2\theta}\frac{\partial^2}{\partial\phi^2}
\qquad \text{(2.25)}
```

の固有関数であり、その固有値は次数のみに依存します。

```math
\nabla^2 Y_n^m = -n(n+1)\,Y_n^m
\qquad \text{(2.26)}
```

$\overline{Y}_n^m$ についても同様です。式 (2.26) は、ルジャンドル陪微分方程式 (2.2) における $n(n+1)$ と、階数 1 の初項 (2.11) における $\sqrt{n(n+1)}$ の起源です。

### 2.13 二重数による自動微分

`.Diff` 系ユニットは、`Double` を二重数 `TdDouble` — 通常部 `o` と導関数部 `d` の対 — に置き換えて全クラスを再現したものです。

```math
\hat{a} = a + a'\,\varepsilon, \qquad \varepsilon^2 = 0
\qquad \text{(2.27)}
```

この環上の演算は連鎖律を厳密に伝播させるため、漸化式を変更せずに二重数の引数で評価するだけで、値とともに導関数が得られます。

```math
f\!\left(a + a'\,\varepsilon\right) = f(a) + f'(a)\,a'\,\varepsilon
\qquad \text{(2.28)}
```

手による式の微分も差分近似も行いません。`TdNALFsTerm4.CalcPs` は `TNALFsTerm4.CalcPs` とスカラー型だけが異なる同一の漸化式です。`TSPHarmonics3D` はこれを利用し、二重数値の角度で調和関数を評価して導関数部から２本の接ベクトルを読み取り、その外積を描画メッシュの厳密な法線とします。

## 3. アーキテクチャ

### 3.1 クラス階層

唯一の抽象インターフェイスは `TALFs` です。最大次数 `DegN`、引数 `X`、既定のインデックス付きプロパティ `Ps[n,m]`、および無効化を伝播する `OnChange` デリゲートリストを持ちます。それ以外はすべてその背後の計算手法です。`TCoreALFs` は `DegN` と `X` の素朴な格納を加え、`TMapALFs` は三角形状の表 `_Ps` と、`DegN` または `X` が変化するたびにそれを充填する `CalcPs` フックを加えます。

```
・TALFs                               ･･･ LUX.ALFs
  ┣・TCoreALFs                       ･･･ LUX.ALFs
  ┃  ┣・TALFsN8                     ･･･ LUX.ALFs.N8  明示的、n <= 8
  ┃  ┗・TMapALFs                    ･･･ LUX.ALFs
  ┃     ┗・TALFsTerm3               ･･･ LUX.ALFs.Term3  式 (2.4) ＋ 8 関係式
  ┗・TNALFs                          ･･･ LUX.NALFs
     ┣・TCoreNALFs                   ･･･ LUX.NALFs
     ┃  ┗・TMapNALFs                ･･･ LUX.NALFs
     ┃     ┣・TNALFsTerm3           ･･･ LUX.NALFs.Term3  式 (2.7)(2.12)(2.13)
     ┃     ┗・TNALFsTerm4           ･･･ LUX.NALFs.Term4  式 (2.8)-(2.11)(2.14)
     ┣・TALFsToNALFs<TALFs_>         ･･･ LUX.NALFs  式 (2.5) の係数表
     ┗・TFNALFs                      ･･･ LUX.FNALFs
        ┣・TALFsToFNALFs<TALFs_>     ･･･ LUX.FNALFs  式 (2.15)：P から
        ┗・TNALFsToFNALFs<TNALFs_>   ･･･ LUX.FNALFs  式 (2.15)：P~ から

・TSPHarmonics                        ･･･ LUX.SH
  ┣・TSPHarmonics<TNALFs_:TNALFs>    ･･･ LUX.SH  SHs[n,m], RSHs[n,m]
  ┗・TRSPHarmonics<TFNALFs_:TFNALFs> ･･･ LUX.SH  RSHs[n,m]

・TF3DShaper                          ･･･ LUX.FMX.Graphics.D3.Shaper
  ┗・TSPHarmonics3D                  ･･･ LUX.SH.FMX.Graphics.D3
```

二重数版の階層はこれをクラス単位で正確に写したもので、`T` の代わりに `Td` を接頭辞とします。すなわち `TdALFs`・`TdCoreALFs`・`TdMapALFs`・`TdALFsN8`・`TdALFsTerm3`・`TdNALFs`・`TdCoreNALFs`・`TdMapNALFs`・`TdNALFsTerm3`・`TdNALFsTerm4`・`TdALFsToNALFs<>`・`TdFNALFs`・`TdALFsToFNALFs<>`・`TdNALFsToFNALFs<>`・`TdSPHarmonics`・`TdSPHarmonics<>`・`TdRSPHarmonics<>` です。

なお、ジェネリック制約が正規化を担っていることに注意してください。`TSPHarmonics<TNALFs_:TNALFs>` は (2.17) が $\tilde{P}_n^m$ で書かれているため正規化された供給元のみを受け付け、`TRSPHarmonics<TFNALFs_:TFNALFs>` は (2.19) が $\overline{P}_n^m$ で書かれているため完全正規化されたもののみを受け付けます。したがって正規化の不一致は、振幅が黙って誤るのではなくコンパイル時エラーになります。

### 3.2 ファイル構成

```
・LUX.SphericalHarmonics/
  ┣・LUX.SH.pas                           ･･･ TSPHarmonics とジェネリック版
  ┣・LUX.SH.Diff.pas                      ･･･ 上記の二重数版
  ┣・ALFs/
  ┃  ┣・LUX.ALFs.pas                     ･･･ 抽象 API：DegN, X, Ps[n,m]
  ┃  ┣・LUX.ALFs.Diff.pas
  ┃  ┣・LUX.ALFs.N8.pas                  ･･･ 2.3 節の閉形式
  ┃  ┣・LUX.ALFs.N8.Diff.pas
  ┃  ┣・LUX.ALFs.Term3.pas               ･･･ 2.4 節の 8 種の関係式
  ┃  ┗・LUX.ALFs.Term3.Diff.pas
  ┣・NALFs/
  ┃  ┣・LUX.NALFs.pas                    ･･･ 式 (2.5) の正規化係数
  ┃  ┣・LUX.NALFs.Diff.pas
  ┃  ┣・LUX.NALFs.Term3.pas              ･･･ ３項間漸化式、式 (2.13)
  ┃  ┣・LUX.NALFs.Term3.Diff.pas
  ┃  ┣・LUX.NALFs.Term4.pas              ･･･ ４項間漸化式、式 (2.14)
  ┃  ┗・LUX.NALFs.Term4.Diff.pas
  ┣・FNALFs/
  ┃  ┣・LUX.FNALFs.pas                   ･･･ 式 (2.15) の 4π 正規化
  ┃  ┗・LUX.FNALFs.Diff.pas
  ┣・FMX/
  ┃  ┗・LUX.SH.FMX.Graphics.D3.pas       ･･･ TSPHarmonics3D：3D メッシュ
  ┣・--------/
  ┃  ┗・Associated Legendre polynomials/ ･･･ 2.4 節で用いるステンシル図
  ┣・LICENSE
  ┣・README.md
  ┗・ja/
     ┗・README.md
```

## 4. 使い方

計算手法を型引数として選び、２つの角度を設定して、インデックス付きプロパティから調和関数を読み出します。`SHs[n,m]` は既定プロパティなので、オブジェクト自身へのインデックスとして書けます。

```Delphi
uses LUX, LUX.Complex,
     LUX.SH, LUX.NALFs.Term4, LUX.FNALFs;

procedure Sample;
var
   SH  :TSPHarmonics<TNALFsTerm4>;
   RSH :TRSPHarmonics<TNALFsToFNALFs<TNALFsTerm4>>;
   Y   :TDoubleC;
begin
     ///// 複素調和関数、式 (2.17)

     SH := TSPHarmonics<TNALFsTerm4>.Create( 64 );  // 最大次数 n = 64
     try
        SH.AngleY := Pi / 3;  // theta :余緯度
        SH.AngleX := Pi / 4;  // phi   :経度

        Y := SH[ 10, 3 ];     // Y(n=10,m=+3) を TDoubleC として

        Writeln( Y.R:0:12, ' ', Y.I:0:12 );
     finally
        SH.Free;
     end;

     ///// 実調和関数、式 (2.19)

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

`TNALFsTerm4` を `TNALFsTerm3`、あるいは `TALFsToNALFs<TALFsTerm3>` や `TALFsToNALFs<TALFsN8>` に差し替えても、変わるのは計算経路だけです。低次においてある手法を別の手法と相互検証する際に有用です。

単一の調和関数を可視化するには、FireMonkey 3D シーンに `TSPHarmonics3D` を配置し、`SPHarm` プロパティに `TdSPHarmonics` の子孫を割り当て、`N` と `M` を設定します。このコンポーネントは `DivX` × `DivY` の格子上で $\bigl|\sqrt{4\pi}\,\overline{Y}_n^m\bigr|$ を半径としてサンプリングし、法線を 2.13 節の二重数の導関数から得ます。

## 5. ライセンス

[MIT License](../LICENSE) の下で公開されています。

## 6. 参考文献

1. Belousov, S. L., [*Tables of Normalized Associated Legendre Polynomials*](https://www.sciencedirect.com/book/9780080097237/tables-of-normalized-associated-legendre-polynomials), Mathematical Tables Series, Vol. 18, Pergamon Press, 1962.
2. Abramowitz, M. and Stegun, I. A. (eds.), [*Handbook of Mathematical Functions with Formulas, Graphs, and Mathematical Tables*](https://personal.math.ubc.ca/~cbm/aands/), National Bureau of Standards Applied Mathematics Series 55, 1964. Chapter 8, "Legendre Functions", pp. 331–341.
3. Nehrkorn, T., [*On the Computation of Legendre Functions in Spectral Models*](https://doi.org/10.1175/1520-0493(1990)118%3C2248:OTCOLF%3E2.0.CO;2), Monthly Weather Review, 118, 2248–2251, 1990.
4. Holmes, S. A. and Featherstone, W. E., [*A unified approach to the Clenshaw summation and the recursive computation of very high degree and order normalised associated Legendre functions*](https://doi.org/10.1007/s00190-002-0216-2), Journal of Geodesy, 76, 279–299, 2002.
5. Enomoto, T., [*Comparison of Computational Methods of Associated Legendre Functions*](https://doi.org/10.2151/sola.2015-033), SOLA (Scientific Online Letters on the Atmosphere), 11, 144–149, 2015.
6. Fang, Y., Wang, Q. and Yang, Y., [*Realizing the Calculation of a Fully Normalized Associated Legendre Function Based on an FPGA*](https://doi.org/10.3390/s24227262), Sensors, 24, 7262, 2024.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
