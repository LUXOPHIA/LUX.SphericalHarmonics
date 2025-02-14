unit LUX.SH.Legendre.Flo64;

interface //#################################################################### ■

uses LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLegendre

     TLegendre = class
     private
     protected
     public
       ///// M E T H O D
       // Recurrence relation
       class function NM( const NM_:Integer; const X_:Double ) :Double;
       class function PN01( const M_:Integer; const X_,PN0_:Double ) :Double;
       class function PN10( const M_:Integer; const X_,PN1_:Double ) :Double;
       class function PM012( const N_,M_:Integer; const X_,PM0_,PM1_:Double ) :Double;
       class function PM201( const N_,M_:Integer; const X_,PM2_,PM0_:Double ) :Double;
       class function PM120( const N_,M_:Integer; const X_,PM1_,PM2_:Double ) :Double;
       class function PN012( const N_,M_:Integer; const X_,PN0_,PN1_:Double ) :Double;
       class function PN201( const N_,M_:Integer; const X_,PN2_,PN0_:Double ) :Double;
       class function PN120( const N_,M_:Integer; const X_,PN1_,PN2_:Double ) :Double;
       // n = 0
       class function P00( const X_:Double ) :Double;
       // n = 1
       class function P10( const X_:Double ) :Double;
       class function P11( const X_:Double ) :Double;
       // n = 2
       class function P20( const X_:Double ) :Double;
       class function P21( const X_:Double ) :Double;
       class function P22( const X_:Double ) :Double;
       // n = 3
       class function P30( const X_:Double ) :Double;
       class function P31( const X_:Double ) :Double;
       class function P32( const X_:Double ) :Double;
       class function P33( const X_:Double ) :Double;
       // n = 4
       class function P40( const X_:Double ) :Double;
       class function P41( const X_:Double ) :Double;
       class function P42( const X_:Double ) :Double;
       class function P43( const X_:Double ) :Double;
       class function P44( const X_:Double ) :Double;
       // n = 5
       class function P50( const X_:Double ) :Double;
       class function P51( const X_:Double ) :Double;
       class function P52( const X_:Double ) :Double;
       class function P53( const X_:Double ) :Double;
       class function P54( const X_:Double ) :Double;
       class function P55( const X_:Double ) :Double;
       // n = 6
       class function P60( const X_:Double ) :Double;
       class function P61( const X_:Double ) :Double;
       class function P62( const X_:Double ) :Double;
       class function P63( const X_:Double ) :Double;
       class function P64( const X_:Double ) :Double;
       class function P65( const X_:Double ) :Double;
       class function P66( const X_:Double ) :Double;
       // n = 7
       class function P70( const X_:Double ) :Double;
       class function P71( const X_:Double ) :Double;
       class function P72( const X_:Double ) :Double;
       class function P73( const X_:Double ) :Double;
       class function P74( const X_:Double ) :Double;
       class function P75( const X_:Double ) :Double;
       class function P76( const X_:Double ) :Double;
       class function P77( const X_:Double ) :Double;
       // n = 8
       class function P80( const X_:Double ) :Double;
       class function P81( const X_:Double ) :Double;
       class function P82( const X_:Double ) :Double;
       class function P83( const X_:Double ) :Double;
       class function P84( const X_:Double ) :Double;
       class function P85( const X_:Double ) :Double;
       class function P86( const X_:Double ) :Double;
       class function P87( const X_:Double ) :Double;
       class function P88( const X_:Double ) :Double;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLegendre

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TLegendre.NM( const NM_:Integer; const X_:Double ) :Double;
var
   I :Integer;
   S :Double;
begin
     Result := 1;
     for I := 1 to NM_ do Result := Result * ( 2 * I - 1 );
     S := Sqrt( 1 - Pow2( X_ ) );
     Result := Result * IntPower( -S, NM_ );
end;

//------------------------------------------------------------------------------

class function TLegendre.PN01( const M_:Integer; const X_,PN0_:Double ) :Double;
begin
     Result := ( 2 * M_ + 1 ) * X_ * PN0_;
end;

class function TLegendre.PN10( const M_:Integer; const X_,PN1_:Double ) :Double;
begin
     Result := PN1_ / ( ( 2 * M_ + 1 ) * X_ );
end;

//------------------------------------------------------------------------------

class function TLegendre.PM012( const N_,M_:Integer; const X_,PM0_,PM1_:Double ) :Double;
begin
     Result := ( ( 2 * M_ - 1 ) * X_ / M_ ) * PM1_ - ( ( N_ + M_ - 1 ) / M_ ) * PM0_;
end;

class function TLegendre.PM201( const N_,M_:Integer; const X_,PM2_,PM0_:Double ) :Double;
begin
     Result := ( ( M_ + 1 ) * PM2_ + ( N_ + M_ ) * PM0_ ) / ( ( 2 * M_ + 1 ) * X_ );
end;

class function TLegendre.PM120( const N_,M_:Integer; const X_,PM1_,PM2_:Double ) :Double;
begin
     Result := ( ( 2 * M_ + 3 ) * X_ * PM1_ - ( M_ + 2 ) * PM2_ ) / ( N_ + M_ + 1 );
end;

//------------------------------------------------------------------------------

class function TLegendre.PN012( const N_,M_:Integer; const X_,PN0_,PN1_:Double ) :Double;
begin
     Result := ( ( 2 * N_ - 1 ) * X_ * PN1_ - ( N_ + M_ - 1 ) * PN0_ ) / ( N_ - M_ );
end;

class function TLegendre.PN201( const N_,M_:Integer; const X_,PN2_,PN0_:Double ) :Double;
begin
     Result := ( ( N_ + M_ ) * PN0_ + ( N_ - M_ + 1 ) * PN2_ ) / ( ( 2 * N_ + 1 ) * X_ );
end;

class function TLegendre.PN120( const N_,M_:Integer; const X_,PN1_,PN2_:Double ) :Double;
begin
     Result := ( ( 2 * N_ + 3 ) * X_ * PN1_ - ( N_ - M_ + 2 ) * PN2_ ) / ( N_ + M_ + 1 );
end;

//------------------------------------------------------------------------------

class function TLegendre.P00( const X_:Double ) :Double;
begin
     Result := 1;
end;

//------------------------------------------------------------------------------

class function TLegendre.P10( const X_:Double ) :Double;
begin
     Result := X_;
end;

class function TLegendre.P11( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -S;
end;

//------------------------------------------------------------------------------

class function TLegendre.P20( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/2 * ( 3 * X2 - 1 );
end;

class function TLegendre.P21( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -3 * X_ * S;
end;

class function TLegendre.P22( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 3 * ( 1 - X2 );  //= 3 * Pow2( S )
end;

//------------------------------------------------------------------------------

class function TLegendre.P30( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/2 * X_ * ( 5 * X2 - 3 );
end;

class function TLegendre.P31( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -3/2 * ( 5 * X2 - 1 ) * S;
end;

class function TLegendre.P32( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 15 * X_ * ( 1 - X2 );  //= 15 * X_ * Pow2( S )
end;

class function TLegendre.P33( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -15 * Pow3( S );
end;

//------------------------------------------------------------------------------

class function TLegendre.P40( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/8 * ( ( 35 * X2 - 30 ) * X2 + 3 );
end;

class function TLegendre.P41( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -5/2 * S * ( X_ * ( 7 * X2 - 3 ) );
end;

class function TLegendre.P42( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 15/2 * ( 1 - X2 ) * ( 7 * X2 - 1 );  //= 15/2 * Pow2( S ) * ( 7 * X2 - 1 )
end;

class function TLegendre.P43( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -105 * X_ * Pow3( S );
end;

class function TLegendre.P44( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 105 * Pow2( 1 - X2 );  //= 105 * Pow4( S )
end;

//------------------------------------------------------------------------------

class function TLegendre.P50( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/8 * X_ * ( ( 63 * X2 - 70 ) * X2 + 15 );
end;

class function TLegendre.P51( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -15/8 * S * ( ( 21 * X2 - 14 ) * X2 + 1 );
end;

class function TLegendre.P52( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 105/2 * X_ * ( 1 - X2 ) * ( 3 * X2 - 1 );  //= 105/2 * X_ * Pow2( S ) * ( 3 * X2 - 1 )
end;

class function TLegendre.P53( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -105/2 * Pow3( S ) * ( 9 * X2 - 1 );
end;

class function TLegendre.P54( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 945 * X_ * Pow2( 1 - X2 );  //= 945 * X_ * Pow4( S )
end;

class function TLegendre.P55( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -945 * Pow5( S );
end;

//------------------------------------------------------------------------------

class function TLegendre.P60( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/16 * ( ( ( 231 * X2 - 315 ) * X2 + 105 ) * X2 - 5 );
end;

class function TLegendre.P61( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -21/8 * X_ * S * ( ( 33 * X2 - 30 ) * X2 + 5 );
end;

class function TLegendre.P62( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 105/8 * ( 1 - X2 ) * ( ( 33 * X2 - 18 ) * X2 + 1 );  //= 105/8 * Pow2( S ) * ( ( 33 * X2 - 18 ) * X2 + 1 )
end;

class function TLegendre.P63( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -315/2 * X_ * Pow3( S ) * ( 11 * X2 - 3 );
end;

class function TLegendre.P64( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 945/2 * Pow2( 1 - X2 ) * ( 11 * X2 - 1 );  //= 945/2 * Pow4( S ) * ( 11 * X2 - 1 )
end;

class function TLegendre.P65( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -10395 * X_ * Pow5( S );
end;

class function TLegendre.P66( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 10395 * Pow3( 1 - X2 );  //= 10395 * Pow6( S )
end;

//------------------------------------------------------------------------------

class function TLegendre.P70( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/16 * X_ * ( ( ( 429 * X2 - 693 ) * X2 + 315 ) * X2 - 35 );
end;

class function TLegendre.P71( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -7/16 * S * ( ( ( 429 * X2 - 495 ) * X2 + 135 ) * X2 - 5 );
end;

class function TLegendre.P72( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 63/8 * X_ * ( 1 - X2 ) * ( ( 143 * X2 - 110 ) * X2 + 15 );
end;

class function TLegendre.P73( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -315/8 * Pow3( S ) * ( ( 143 * X2 - 66 ) * X2 + 3 );
end;

class function TLegendre.P74( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 3465/2 * X_ * Pow2( 1 - X2 ) * ( 13 * X2 - 3 );
end;

class function TLegendre.P75( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -10395/2 * Pow5( S ) * ( 13 * X2 - 1 );
end;

class function TLegendre.P76( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 135135 * X_ * Pow3( 1 - X2 );
end;

class function TLegendre.P77( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -135135 * IntPower( S, 7 );
end;

//------------------------------------------------------------------------------

class function TLegendre.P80( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );
     Result := 1/128 * ( ( ( ( 6435 * X2 - 12012 ) * X2 + 6930 ) * X2 - 1260 ) * X2 + 35 );
end;

class function TLegendre.P81( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -9/16 * X_ * S * ( ( ( 715 * X2 - 1001 ) * X2 + 385 ) * X2 - 35 );
end;

class function TLegendre.P82( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 315/16 * ( 1 - X2 ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 );  //= 315/16 * Pow2( S ) * ( ( ( 143 * X2 - 143 ) * X2 + 33 ) * X2 - 1 )
end;

class function TLegendre.P83( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -3465/8 * X_ * Pow3( S ) * ( ( 39 * X2 - 26 ) * X2 + 3 );
end;

class function TLegendre.P84( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 10395/8 * Pow2( 1 - X2 ) * ( ( 65 * X2 - 26 ) * X2 + 1 );  //= 10395/8 * Pow4( S ) * ( ( 65 * X2 - 26 ) * X2 + 1 )
end;

class function TLegendre.P85( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -135135/2 * X_ * Pow5( S ) * ( 5 * X2 - 1 );
end;

class function TLegendre.P86( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 135135/2 * Pow3( 1 - X2 ) * ( 15 * X2 - 1 );  //= 135135/2 * Pow6( S ) * ( 15 * X2 - 1 )
end;

class function TLegendre.P87( const X_:Double ) :Double;
var
   X2, S :Double;
begin
     X2 := Pow2( X_ );  S := Sqrt( 1 - X2 );
     Result := -2027025 * X_ * IntPower( S, 7 );
end;

class function TLegendre.P88( const X_:Double ) :Double;
var
   X2 :Double;
begin
     X2 := Pow2( X_ );  //S := Sqrt( 1 - X2 );
     Result := 2027025 * Pow4( 1 - X2 );  //= 2027025 * Pow8( S )
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■