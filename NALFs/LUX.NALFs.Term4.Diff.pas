unit LUX.NALFs.Term4.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.D1.Legendre.Diff,
     LUX.NALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFsTerm4

     TdNALFsTerm4 = class( TdMapNALFs )
     private
     protected
       _S :TdDouble;
       ///// M E T H O D
       function PN0( const N_:Integer ) :TdDouble;
       function PN1( const N_:Integer ) :TdDouble;
       function P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
       function PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
       function PNM22( const N_,M_:Integer; const P00_,P02_,P20_:TdDouble ) :TdDouble;
       procedure CalcPs; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFsTerm4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TdNALFsTerm4.PN0( const N_:Integer ) :TdDouble;
begin
     Result := NLegendre( X, N_ );
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.PN1( const N_:Integer ) :TdDouble;
begin
     Result := dNLegendreCos( ArcCos( X ), N_ ) / Sqrt( N_ * ( N_ + 1 ) );
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
begin
     Result := -Sqrt( ( 2 * M_ + 1 ) / ( 2 * M_ ) ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
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

function TdNALFsTerm4.PNM22( const N_,M_:Integer; const P00_,P02_,P20_:TdDouble ) :TdDouble;
var
   N2, NM0, NM1,
   A00, A02, A20 :Double;
begin
     N2  := N_ * 2 ;
     NM0 := N_ - M_;
     NM1 := N_ + M_;

     A00 := Roo2( ( ( N2 + 1 ) * ( NM1 - 3 ) * ( NM1 - 2 ) )
                / ( ( N2 - 3 ) * ( NM1 - 1 ) * ( NM1     ) ) );
     A02 := Roo2( ( ( N2 + 1 ) * ( NM0 - 1 ) * ( NM0     ) )
                / ( ( N2 - 3 ) * ( NM1 - 1 ) * ( NM1     ) ) );
     A20 := Roo2( (              ( NM0 + 1 ) * ( NM0 + 2 ) )
                / (              ( NM1 - 1 ) * ( NM1     ) ) );

     Result := A00 * P00_ + A02 * P02_ - A20 * P20_;
end;

//------------------------------------------------------------------------------

procedure TdNALFsTerm4.CalcPs;
var
   N, M :Integer;
begin
     _S := Roo2( 1 - Pow2( X ) );

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