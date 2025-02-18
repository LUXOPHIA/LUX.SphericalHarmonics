unit LUX.ALFs.N8.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.ALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsN8

     TdALFsN8 = class( TdCoreALFs )
     private
     protected
       X2 :TdDouble;
       S  :TdDouble;
       ///// M E T H O D
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
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

function TdALFsN8.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     X2 := Pow2( X );  S := Roo2( 1 - X2 );

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