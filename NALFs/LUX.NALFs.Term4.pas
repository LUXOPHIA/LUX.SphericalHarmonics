unit LUX.NALFs.Term4;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Legendre,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsTerm4

     TNALFsTerm4 = class( TCacheNALFs )
     private
     protected
       _MaxNM :TArray2<Integer>;
       ///// A C C E S S O R
       procedure SetDegN( const DegN_:Integer ); override;
       procedure SetX( const X_:Double ); override;
       function GetPs( const N_,M_:Integer ) :Double; override;
       ///// M E T H O D
       function PN0( const N_:Integer ) :Double;
       function PN1( const N_:Integer ) :Double;
       function PNM22( const N_,M_:Integer; const P00_,P02_,P20_:Double ) :Double;
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

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TNALFsTerm4.SetDegN( const DegN_:Integer );
begin
     inherited;

     SetLength( _MaxNM, DegN+1, 2 );

     X := 0;
end;

//------------------------------------------------------------------------------

procedure TNALFsTerm4.SetX( const X_:Double );
var
   N :Integer;
begin
     inherited;

     for N := 0 to DegN do _MaxNM[ N, 0 ] := -1;
     for N := 1 to DegN do _MaxNM[ N, 1 ] :=  0;
end;

//------------------------------------------------------------------------------

function TNALFsTerm4.GetPs( const N_,M_:Integer ) :Double;
begin
     if N_ < M_ then Exit( 0 );

     if _MaxNM[ N_, M_ mod 2 ] < M_ then
     begin
          case M_ of
            0: _NPs[ N_, M_ ] := PN0( N_ );
            1: _NPs[ N_, M_ ] := PN1( N_ );
          else _NPs[ N_, M_ ] := PNM22( N_, M_, Ps[ N_-2, M_-2 ], Ps[ N_-2, M_ ], Ps[ N_, M_-2 ] );
          end;

          _MaxNM[ N_, M_ mod 2 ] := M_;
     end;

     Result := _NPs[ N_, M_ ];
end;

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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■