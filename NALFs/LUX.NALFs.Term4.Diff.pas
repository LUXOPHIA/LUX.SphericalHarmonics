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

     TdNALFsTerm4 = class( TdCacheNALFs )
     private
     protected
       _CalcXs :TArray2<TdDouble>;
       ///// A C C E S S O R
       procedure SetDegN( const DegN_:Integer ); override;
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
       ///// M E T H O D
       function PN0( const N_:Integer ) :TdDouble;
       function PN1( const N_:Integer ) :TdDouble;
       function PNM22( const N_,M_:Integer; const P00_,P02_,P20_:TdDouble ) :TdDouble;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFsTerm4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TdNALFsTerm4.SetDegN( const DegN_:Integer );
var
   N, M :Integer;
begin
     inherited;

     SetLength( _CalcXs, DegN+1 );
     for N := 0 to DegN do
     begin
          SetLength( _CalcXs[ N ], N+1 );
          for M := 0 to N do _CalcXs[ N, M ] := TdDouble.NaN;
     end;
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     if N_ < M_ then Exit( 0 );

     if _CalcXs[ N_, M_ ] <> X then
     begin
          case M_ of
            0: _NPs[ N_, M_ ] := PN0( N_ );
            1: _NPs[ N_, M_ ] := PN1( N_ );
          else _NPs[ N_, M_ ] := PNM22( N_, M_, Ps[ N_-2, M_-2 ], Ps[ N_-2, M_ ], Ps[ N_, M_-2 ] );
          end;

          _CalcXs[ N_, M_ ] := X;
     end;

     Result := _NPs[ N_, M_ ];
end;

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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■