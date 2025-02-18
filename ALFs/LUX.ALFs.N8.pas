unit LUX.ALFs.N8;

interface //#################################################################### ■

uses LUX,
     LUX.ALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsN8

     TALFsN8 = class( TCoreALFs )
     private
     protected
       X2 :Double;
       S  :Double;
       ///// M E T H O D
       function GetPs( const N_,M_:Integer ) :Double; override;
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

function TALFsN8.GetPs( const N_,M_:Integer ) :Double;
begin
     X2 := Pow2( X );  S := Sqrt( 1 - X2 );

     case N_ of
       0: case M_ of
            0: Result := P00;
          else Result := 0;
          end;
       1: case M_ of
            0: Result := P10;
            1: Result := P11;
          else Result := 0;
          end;
       2: case M_ of
            0: Result := P20;
            1: Result := P21;
            2: Result := P22;
          else Result := 0;
          end;
       3: case M_ of
            0: Result := P30;
            1: Result := P31;
            2: Result := P32;
            3: Result := P33;
          else Result := 0;
          end;
       4: case M_ of
            0: Result := P40;
            1: Result := P41;
            2: Result := P42;
            3: Result := P43;
            4: Result := P44;
          else Result := 0;
          end;
       5: case M_ of
            0: Result := P50;
            1: Result := P51;
            2: Result := P52;
            3: Result := P53;
            4: Result := P54;
            5: Result := P55;
          else Result := 0;
          end;
       6: case M_ of
            0: Result := P60;
            1: Result := P61;
            2: Result := P62;
            3: Result := P63;
            4: Result := P64;
            5: Result := P65;
            6: Result := P66;
          else Result := 0;
          end;
       7: case M_ of
            0: Result := P70;
            1: Result := P71;
            2: Result := P72;
            3: Result := P73;
            4: Result := P74;
            5: Result := P75;
            6: Result := P76;
            7: Result := P77;
          else Result := 0;
          end;
       8: case M_ of
            0: Result := P80;
            1: Result := P81;
            2: Result := P82;
            3: Result := P83;
            4: Result := P84;
            5: Result := P85;
            6: Result := P86;
            7: Result := P87;
            8: Result := P88;
          else Result := 0;
          end;
     else Result := 0;
     end;
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