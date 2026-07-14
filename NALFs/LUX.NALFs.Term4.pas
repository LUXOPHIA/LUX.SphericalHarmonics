unit LUX.NALFs.Term4;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Legendre,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsTerm4

     TNALFsTerm4 = class( TMapNALFs )
     private
     protected
       _S :Double;
       ///// M E T H O D
       function PN0( const N_:Integer ) :Double;
       function PN1( const N_:Integer ) :Double;
       function P01( const M_:Integer; const P0_:Double ) :Double;
       function PN01( const M_:Integer; const PN0_:Double ) :Double;
       function PNM22( const N_,M_:Integer; const P00_,P02_,P20_:Double ) :Double;
       procedure CalcPs; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsTerm4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TNALFsTerm4.PN0( const N_:Integer ) :Double;
begin
     Result := NLegendre( X, N_ );
end;

//------------------------------------------------------------------------------

function TNALFsTerm4.PN1( const N_:Integer ) :Double;
begin
     Result := dNLegendreCos( ArcCos( X ), N_ ) / Sqrt( N_ * ( N_ + 1 ) );
end;

//------------------------------------------------------------------------------

function TNALFsTerm4.P01( const M_:Integer; const P0_:Double ) :Double;
begin
     Result := -Sqrt( ( 2 * M_ + 1 ) / ( 2 * M_ ) ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TNALFsTerm4.PN01( const M_:Integer; const PN0_:Double ) :Double;
begin
     Result := Sqrt( 2 * M_ + 3 ) * X * PN0_;
end;

//------------------------------------------------------------------------------

//      0     1     2   M
//  0 [P00]--P01--[P02]
//      |     |     |
//  1  P10---P11---P12
//      |     |     |
//  2 [P20]--P21--[P22]
//  N

function TNALFsTerm4.PNM22( const N_,M_:Integer; const P00_,P02_,P20_:Double ) :Double;
var
   N2, NM0, NM1,
   A00, A02, A20 :Double;
begin
     N2  := N_ * 2 ;
     NM0 := N_ - M_;
     NM1 := N_ + M_;

     A00 := Sqrt( ( ( N2 + 1 ) * ( NM1 - 3 ) * ( NM1 - 2 ) )
                / ( ( N2 - 3 ) * ( NM1 - 1 ) * ( NM1     ) ) );
     A02 := Sqrt( ( ( N2 + 1 ) * ( NM0 - 1 ) * ( NM0     ) )
                / ( ( N2 - 3 ) * ( NM1 - 1 ) * ( NM1     ) ) );
     A20 := Sqrt( (              ( NM0 + 1 ) * ( NM0 + 2 ) )
                / (              ( NM1 - 1 ) * ( NM1     ) ) );

     Result := A00 * P00_ + A02 * P02_ - A20 * P20_;
end;

//------------------------------------------------------------------------------

procedure TNALFsTerm4.CalcPs;
var
   N, M :Integer;
begin
     _S := Sqrt( 1 - Pow2( X ) );

     ///// M = 0
     for N := 0 to DegN do _NPs[ N, 0 ] := PN0( N );

     ///// M = 1
     for N := 1 to DegN do _NPs[ N, 1 ] := PN1( N );

     ///// N = M
     for M := 2 to DegN do _NPs[ M, M ] := P01( M, _NPs[ M-1, M-1 ] );

     ///// N = M+1
     for M := 2 to DegN-1 do _NPs[ M+1, M ] := PN01( M, _NPs[ M, M ] );

     ///// M+2 <= N
     for M := 2 to DegN do
     begin
          for N := M+2 to DegN do _NPs[ N, M ] := PNM22( N, M, _NPs[ N-2, M-2 ], _NPs[ N-2, M ], _NPs[ N, M-2 ] );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■