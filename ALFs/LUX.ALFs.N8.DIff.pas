unit LUX.ALFs.N8.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.ALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsN8

     TdALFsN8 = class( TdMapALFs )
     private
     protected
       X2 :TdDouble;
       S  :TdDouble;
       ///// M E T H O D
       procedure CalcALPs; override;
     public
       ///// M E T H O D
       // n = 0
       function P00 :TdDouble;
       // n = 1
       function P10 :TdDouble;
       function P11 :TdDouble;
       // n = 2
       function P20 :TdDouble;
       function P21 :TdDouble;
       function P22 :TdDouble;
       // n = 3
       function P30 :TdDouble;
       function P31 :TdDouble;
       function P32 :TdDouble;
       function P33 :TdDouble;
       // n = 4
       function P40 :TdDouble;
       function P41 :TdDouble;
       function P42 :TdDouble;
       function P43 :TdDouble;
       function P44 :TdDouble;
       // n = 5
       function P50 :TdDouble;
       function P51 :TdDouble;
       function P52 :TdDouble;
       function P53 :TdDouble;
       function P54 :TdDouble;
       function P55 :TdDouble;
       // n = 6
       function P60 :TdDouble;
       function P61 :TdDouble;
       function P62 :TdDouble;
       function P63 :TdDouble;
       function P64 :TdDouble;
       function P65 :TdDouble;
       function P66 :TdDouble;
       // n = 7
       function P70 :TdDouble;
       function P71 :TdDouble;
       function P72 :TdDouble;
       function P73 :TdDouble;
       function P74 :TdDouble;
       function P75 :TdDouble;
       function P76 :TdDouble;
       function P77 :TdDouble;
       // n = 8
       function P80 :TdDouble;
       function P81 :TdDouble;
       function P82 :TdDouble;
       function P83 :TdDouble;
       function P84 :TdDouble;
       function P85 :TdDouble;
       function P86 :TdDouble;
       function P87 :TdDouble;
       function P88 :TdDouble;
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

procedure TdALFsN8.CalcALPs;
begin
     X2 := Pow2( X );  S := Roo2( 1 - X2 );

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

function TdALFsN8.P00 :TdDouble;
begin
     Result := 1;
end;

//------------------------------------------------------------------------------

function TdALFsN8.P10 :TdDouble;
begin
     Result := X;
end;

function TdALFsN8.P11 :TdDouble;
begin
     Result := -S;
end;

//------------------------------------------------------------------------------

function TdALFsN8.P20 :TdDouble;
begin
     Result := 1/2 * ( 3 * X2 - 1 );
end;

function TdALFsN8.P21 :TdDouble;
begin
     Result := -3 * X * S;
end;

function TdALFsN8.P22 :TdDouble;
begin
     Result := 3 * ( 1 - X2 );  //= 3 * Pow2( S )
end;

//------------------------------------------------------------------------------

function TdALFsN8.P30 :TdDouble;
begin
     Result := 1/2 * X * ( 5 * X2 - 3 );
end;

function TdALFsN8.P31 :TdDouble;
begin
     Result := -3/2 * ( 5 * X2 - 1 ) * S;
end;

function TdALFsN8.P32 :TdDouble;
begin
     Result := 15 * X * ( 1 - X2 );  //= 15 * X * Pow2( S )
end;

function TdALFsN8.P33 :TdDouble;
begin
     Result := -15 * Pow3( S );
end;

//------------------------------------------------------------------------------

function TdALFsN8.P40 :TdDouble;
begin
     Result := 1/8 * ( ( 35 * X2 - 30 ) * X2 + 3 );
end;

function TdALFsN8.P41 :TdDouble;
begin
     Result := -5/2 * S * ( X * ( 7 * X2 - 3 ) );
end;

function TdALFsN8.P42 :TdDouble;
begin
     Result := 15/2 * ( 1 - X2 ) * ( 7 * X2 - 1 );  //= 15/2 * Pow2( S ) * ( 7 * X2 - 1 )
end;

function TdALFsN8.P43 :TdDouble;
begin
     Result := -105 * X * Pow3( S );
end;

function TdALFsN8.P44 :TdDouble;
begin
     Result := 105 * Pow2( 1 - X2 );  //= 105 * Pow4( S )
end;

//------------------------------------------------------------------------------

function TdALFsN8.P50 :TdDouble;
begin
     Result := 1/8 * X * ( ( 63 * X2 - 70 ) * X2 + 15 );
end;

function TdALFsN8.P51 :TdDouble;
begin
     Result := -15/8 * S * ( ( 21 * X2 - 14 ) * X2 + 1 );
end;

function TdALFsN8.P52 :TdDouble;
begin
     Result := 105/2 * X * ( 1 - X2 ) * ( 3 * X2 - 1 );  //= 105/2 * X * Pow2( S ) * ( 3 * X2 - 1 )
end;

function TdALFsN8.P53 :TdDouble;
begin
     Result := -105/2 * Pow3( S ) * ( 9 * X2 - 1 );
end;

function TdALFsN8.P54 :TdDouble;
begin
     Result := 945 * X * Pow2( 1 - X2 );  //= 945 * X * Pow4( S )
end;

function TdALFsN8.P55 :TdDouble;
begin
     Result := -945 * Pow5( S );
end;

//------------------------------------------------------------------------------

function TdALFsN8.P60 :TdDouble;
begin
     Result := 1/16 * ( ( ( 231 * X2 - 315 ) * X2 + 105 ) * X2 - 5 );
end;

function TdALFsN8.P61 :TdDouble;
begin
     Result := -21/8 * X * S * ( ( 33 * X2 - 30 ) * X2 + 5 );
end;

function TdALFsN8.P62 :TdDouble;
begin
     Result := 105/8 * ( 1 - X2 ) * ( ( 33 * X2 - 18 ) * X2 + 1 );  //= 105/8 * Pow2( S ) * ( ( 33 * X2 - 18 ) * X2 + 1 )
end;

function TdALFsN8.P63 :TdDouble;
begin
     Result := -315/2 * X * Pow3( S ) * ( 11 * X2 - 3 );
end;

function TdALFsN8.P64 :TdDouble;
begin
     Result := 945/2 * Pow2( 1 - X2 ) * ( 11 * X2 - 1 );  //= 945/2 * Pow4( S ) * ( 11 * X2 - 1 )
end;

function TdALFsN8.P65 :TdDouble;
begin
     Result := -10395 * X * Pow5( S );
end;

function TdALFsN8.P66 :TdDouble;
begin
     Result := 10395 * Pow3( 1 - X2 );  //= 10395 * Pow6( S )
end;

//------------------------------------------------------------------------------

function TdALFsN8.P70 :TdDouble;
begin
     Result := 1/16 * X * ( ( ( 429 * X2 - 693 ) * X2 + 315 ) * X2 - 35 );
end;

function TdALFsN8.P71 :TdDouble;
begin
     Result := -7/16 * S * ( ( ( 429 * X2 - 495 ) * X2 + 135 ) * X2 - 5 );
end;

function TdALFsN8.P72 :TdDouble;
begin
     Result := 63/8 * X * ( 1 - X2 ) * ( ( 143 * X2 - 110 ) * X2 + 15 );
end;

function TdALFsN8.P73 :TdDouble;
begin
     Result := -315/8 * Pow3( S ) * ( ( 143 * X2 - 66 ) * X2 + 3 );
end;

function TdALFsN8.P74 :TdDouble;
begin
     Result := 3465/2 * X * Pow2( 1 - X2 ) * ( 13 * X2 - 3 );
end;

function TdALFsN8.P75 :TdDouble;
begin
     Result := -10395/2 * Pow5( S ) * ( 13 * X2 - 1 );
end;

function TdALFsN8.P76 :TdDouble;
begin
     Result := 135135 * X * Pow3( 1 - X2 );
end;

function TdALFsN8.P77 :TdDouble;
begin
     Result := -135135 * IntPower( S, 7 );
end;

//------------------------------------------------------------------------------

function TdALFsN8.P80 :TdDouble;
begin
     Result := 1/128 * ( ( ( ( 6435 * X2 - 12012 ) * X2 + 6930 ) * X2 - 1260 ) * X2 + 35 );
end;

function TdALFsN8.P81 :TdDouble;
begin
     Result := -9/16 * X * S * ( ( ( 715 * X2 - 1001 ) * X2 + 385 ) * X2 - 35 );
end;

function TdALFsN8.P82 :TdDouble;
begin
     Result := 315/16 * ( 1 - X2 ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 );  //= 315/16 * Pow2( S ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 )
end;

function TdALFsN8.P83 :TdDouble;
begin
     Result := -3465/8 * X * Pow3( S ) * ( ( 39 * X2 - 26 ) * X2 + 3 );
end;

function TdALFsN8.P84 :TdDouble;
begin
     Result := 10395/8 * Pow2( 1 - X2 ) * ( ( 65 * X2 - 26 ) * X2 + 1 );  //= 10395/8 * Pow4( S ) * ( ( 65 * X2 - 26 ) * X2 + 1 )
end;

function TdALFsN8.P85 :TdDouble;
begin
     Result := -135135/2 * X * Pow5( S ) * ( 5 * X2 - 1 );
end;

function TdALFsN8.P86 :TdDouble;
begin
     Result := 135135/2 * Pow3( 1 - X2 ) * ( 15 * X2 - 1 );  //= 135135/2 * Pow6( S ) * ( 15 * X2 - 1 )
end;

function TdALFsN8.P87 :TdDouble;
begin
     Result := -2027025 * X * IntPower( S, 7 );
end;

function TdALFsN8.P88 :TdDouble;
begin
     Result := 2027025 * Pow4( 1 - X2 );  //= 2027025 * Pow8( S )
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■