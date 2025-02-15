unit LUX.ALFs.N8;

interface //#################################################################### ■

uses LUX,
     LUX.ALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsN8

     TALFsN8 = class( TMapALFs )
     private
     protected
       X2 :Double;
       S  :Double;
       ///// M E T H O D
       procedure CalcALPs; override;
     public
       ///// M E T H O D
       // n = 0
       function P00 :Double;
       // n = 1
       function P10 :Double;
       function P11 :Double;
       // n = 2
       function P20 :Double;
       function P21 :Double;
       function P22 :Double;
       // n = 3
       function P30 :Double;
       function P31 :Double;
       function P32 :Double;
       function P33 :Double;
       // n = 4
       function P40 :Double;
       function P41 :Double;
       function P42 :Double;
       function P43 :Double;
       function P44 :Double;
       // n = 5
       function P50 :Double;
       function P51 :Double;
       function P52 :Double;
       function P53 :Double;
       function P54 :Double;
       function P55 :Double;
       // n = 6
       function P60 :Double;
       function P61 :Double;
       function P62 :Double;
       function P63 :Double;
       function P64 :Double;
       function P65 :Double;
       function P66 :Double;
       // n = 7
       function P70 :Double;
       function P71 :Double;
       function P72 :Double;
       function P73 :Double;
       function P74 :Double;
       function P75 :Double;
       function P76 :Double;
       function P77 :Double;
       // n = 8
       function P80 :Double;
       function P81 :Double;
       function P82 :Double;
       function P83 :Double;
       function P84 :Double;
       function P85 :Double;
       function P86 :Double;
       function P87 :Double;
       function P88 :Double;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TAssoLegendre

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TALFsN8.CalcALPs;
begin
     X2 := Pow2( X );  S := Sqrt( 1 - X2 );

     _Ps[ 0, 0 ] := P00;

     if DegN < 1 then Exit;

     _Ps[ 1, 0 ] := P10;
     _Ps[ 1, 1 ] := P11;

     if DegN < 2 then Exit;

     _Ps[ 2, 0 ] := P20;
     _Ps[ 2, 1 ] := P21;
     _Ps[ 2, 2 ] := P22;

     if DegN < 3 then Exit;

     _Ps[ 3, 0 ] := P30;
     _Ps[ 3, 1 ] := P31;
     _Ps[ 3, 2 ] := P32;
     _Ps[ 3, 3 ] := P33;

     if DegN < 4 then Exit;

     _Ps[ 4, 0 ] := P40;
     _Ps[ 4, 1 ] := P41;
     _Ps[ 4, 2 ] := P42;
     _Ps[ 4, 3 ] := P43;
     _Ps[ 4, 4 ] := P44;

     if DegN < 5 then Exit;

     _Ps[ 5, 0 ] := P50;
     _Ps[ 5, 1 ] := P51;
     _Ps[ 5, 2 ] := P52;
     _Ps[ 5, 3 ] := P53;
     _Ps[ 5, 4 ] := P54;
     _Ps[ 5, 5 ] := P55;

     if DegN < 6 then Exit;

     _Ps[ 6, 0 ] := P60;
     _Ps[ 6, 1 ] := P61;
     _Ps[ 6, 2 ] := P62;
     _Ps[ 6, 3 ] := P63;
     _Ps[ 6, 4 ] := P64;
     _Ps[ 6, 5 ] := P65;
     _Ps[ 6, 6 ] := P66;

     if DegN < 7 then Exit;

     _Ps[ 7, 0 ] := P70;
     _Ps[ 7, 1 ] := P71;
     _Ps[ 7, 2 ] := P72;
     _Ps[ 7, 3 ] := P73;
     _Ps[ 7, 4 ] := P74;
     _Ps[ 7, 5 ] := P75;
     _Ps[ 7, 6 ] := P76;
     _Ps[ 7, 7 ] := P77;

     if DegN < 8 then Exit;

     _Ps[ 8, 0 ] := P80;
     _Ps[ 8, 1 ] := P81;
     _Ps[ 8, 2 ] := P82;
     _Ps[ 8, 3 ] := P83;
     _Ps[ 8, 4 ] := P84;
     _Ps[ 8, 5 ] := P85;
     _Ps[ 8, 6 ] := P86;
     _Ps[ 8, 7 ] := P87;
     _Ps[ 8, 8 ] := P88;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TALFsN8.P00 :Double;
begin
     Result := 1;
end;

//------------------------------------------------------------------------------

function TALFsN8.P10 :Double;
begin
     Result := X;
end;

function TALFsN8.P11 :Double;
begin
     Result := -S;
end;

//------------------------------------------------------------------------------

function TALFsN8.P20 :Double;
begin
     Result := 1/2 * ( 3 * X2 - 1 );
end;

function TALFsN8.P21 :Double;
begin
     Result := -3 * X * S;
end;

function TALFsN8.P22 :Double;
begin
     Result := 3 * ( 1 - X2 );  //= 3 * Pow2( S )
end;

//------------------------------------------------------------------------------

function TALFsN8.P30 :Double;
begin
     Result := 1/2 * X * ( 5 * X2 - 3 );
end;

function TALFsN8.P31 :Double;
begin
     Result := -3/2 * ( 5 * X2 - 1 ) * S;
end;

function TALFsN8.P32 :Double;
begin
     Result := 15 * X * ( 1 - X2 );  //= 15 * X * Pow2( S )
end;

function TALFsN8.P33 :Double;
begin
     Result := -15 * Pow3( S );
end;

//------------------------------------------------------------------------------

function TALFsN8.P40 :Double;
begin
     Result := 1/8 * ( ( 35 * X2 - 30 ) * X2 + 3 );
end;

function TALFsN8.P41 :Double;
begin
     Result := -5/2 * S * ( X * ( 7 * X2 - 3 ) );
end;

function TALFsN8.P42 :Double;
begin
     Result := 15/2 * ( 1 - X2 ) * ( 7 * X2 - 1 );  //= 15/2 * Pow2( S ) * ( 7 * X2 - 1 )
end;

function TALFsN8.P43 :Double;
begin
     Result := -105 * X * Pow3( S );
end;

function TALFsN8.P44 :Double;
begin
     Result := 105 * Pow2( 1 - X2 );  //= 105 * Pow4( S )
end;

//------------------------------------------------------------------------------

function TALFsN8.P50 :Double;
begin
     Result := 1/8 * X * ( ( 63 * X2 - 70 ) * X2 + 15 );
end;

function TALFsN8.P51 :Double;
begin
     Result := -15/8 * S * ( ( 21 * X2 - 14 ) * X2 + 1 );
end;

function TALFsN8.P52 :Double;
begin
     Result := 105/2 * X * ( 1 - X2 ) * ( 3 * X2 - 1 );  //= 105/2 * X * Pow2( S ) * ( 3 * X2 - 1 )
end;

function TALFsN8.P53 :Double;
begin
     Result := -105/2 * Pow3( S ) * ( 9 * X2 - 1 );
end;

function TALFsN8.P54 :Double;
begin
     Result := 945 * X * Pow2( 1 - X2 );  //= 945 * X * Pow4( S )
end;

function TALFsN8.P55 :Double;
begin
     Result := -945 * Pow5( S );
end;

//------------------------------------------------------------------------------

function TALFsN8.P60 :Double;
begin
     Result := 1/16 * ( ( ( 231 * X2 - 315 ) * X2 + 105 ) * X2 - 5 );
end;

function TALFsN8.P61 :Double;
begin
     Result := -21/8 * X * S * ( ( 33 * X2 - 30 ) * X2 + 5 );
end;

function TALFsN8.P62 :Double;
begin
     Result := 105/8 * ( 1 - X2 ) * ( ( 33 * X2 - 18 ) * X2 + 1 );  //= 105/8 * Pow2( S ) * ( ( 33 * X2 - 18 ) * X2 + 1 )
end;

function TALFsN8.P63 :Double;
begin
     Result := -315/2 * X * Pow3( S ) * ( 11 * X2 - 3 );
end;

function TALFsN8.P64 :Double;
begin
     Result := 945/2 * Pow2( 1 - X2 ) * ( 11 * X2 - 1 );  //= 945/2 * Pow4( S ) * ( 11 * X2 - 1 )
end;

function TALFsN8.P65 :Double;
begin
     Result := -10395 * X * Pow5( S );
end;

function TALFsN8.P66 :Double;
begin
     Result := 10395 * Pow3( 1 - X2 );  //= 10395 * Pow6( S )
end;

//------------------------------------------------------------------------------

function TALFsN8.P70 :Double;
begin
     Result := 1/16 * X * ( ( ( 429 * X2 - 693 ) * X2 + 315 ) * X2 - 35 );
end;

function TALFsN8.P71 :Double;
begin
     Result := -7/16 * S * ( ( ( 429 * X2 - 495 ) * X2 + 135 ) * X2 - 5 );
end;

function TALFsN8.P72 :Double;
begin
     Result := 63/8 * X * ( 1 - X2 ) * ( ( 143 * X2 - 110 ) * X2 + 15 );
end;

function TALFsN8.P73 :Double;
begin
     Result := -315/8 * Pow3( S ) * ( ( 143 * X2 - 66 ) * X2 + 3 );
end;

function TALFsN8.P74 :Double;
begin
     Result := 3465/2 * X * Pow2( 1 - X2 ) * ( 13 * X2 - 3 );
end;

function TALFsN8.P75 :Double;
begin
     Result := -10395/2 * Pow5( S ) * ( 13 * X2 - 1 );
end;

function TALFsN8.P76 :Double;
begin
     Result := 135135 * X * Pow3( 1 - X2 );
end;

function TALFsN8.P77 :Double;
begin
     Result := -135135 * IntPower( S, 7 );
end;

//------------------------------------------------------------------------------

function TALFsN8.P80 :Double;
begin
     Result := 1/128 * ( ( ( ( 6435 * X2 - 12012 ) * X2 + 6930 ) * X2 - 1260 ) * X2 + 35 );
end;

function TALFsN8.P81 :Double;
begin
     Result := -9/16 * X * S * ( ( ( 715 * X2 - 1001 ) * X2 + 385 ) * X2 - 35 );
end;

function TALFsN8.P82 :Double;
begin
     Result := 315/16 * ( 1 - X2 ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 );  //= 315/16 * Pow2( S ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 )
end;

function TALFsN8.P83 :Double;
begin
     Result := -3465/8 * X * Pow3( S ) * ( ( 39 * X2 - 26 ) * X2 + 3 );
end;

function TALFsN8.P84 :Double;
begin
     Result := 10395/8 * Pow2( 1 - X2 ) * ( ( 65 * X2 - 26 ) * X2 + 1 );  //= 10395/8 * Pow4( S ) * ( ( 65 * X2 - 26 ) * X2 + 1 )
end;

function TALFsN8.P85 :Double;
begin
     Result := -135135/2 * X * Pow5( S ) * ( 5 * X2 - 1 );
end;

function TALFsN8.P86 :Double;
begin
     Result := 135135/2 * Pow3( 1 - X2 ) * ( 15 * X2 - 1 );  //= 135135/2 * Pow6( S ) * ( 15 * X2 - 1 )
end;

function TALFsN8.P87 :Double;
begin
     Result := -2027025 * X * IntPower( S, 7 );
end;

function TALFsN8.P88 :Double;
begin
     Result := 2027025 * Pow4( 1 - X2 );  //= 2027025 * Pow8( S )
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■