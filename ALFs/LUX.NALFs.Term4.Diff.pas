unit LUX.NALFs.Term4.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.NALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFsTerm4

     TdNALFsTerm4 = class( TdCacheNALFs )
     private
     protected
       upALPs:Boolean;
       ///// A C C E S S O R
       procedure SetDegN( const DegN_:Integer ); override;
       procedure SetX( const X_:TdDouble ); override;
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
       ///// M E T H O D
       procedure CalcALPs;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:TdDouble ) :TdDouble;
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
begin
     inherited;

     upALPs := True;
end;

//------------------------------------------------------------------------------

procedure TdNALFsTerm4.SetX( const X_:TdDouble );
begin
     inherited;

     upALPs := True;
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     if upALPs then
     begin
          upALPs := False;

          CalcALPs;
     end;

     Result := _NPs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TdNALFsTerm4.CalcALPs;
var
   S :TdDouble;
   N, M :Integer;
   P0, P1, P2, P00, P02, P20, P22 :TdDouble;
begin
     S := Roo2( 1 - Pow2( X ) );

     _NPs[ 0, 0 ] :=  Roo2(1/2);

     if DegN = 0 then Exit;

     _NPs[ 1, 0 ] :=  Roo2(3/2) * X;
     _NPs[ 1, 1 ] := -Roo2(3)/2 * S;

     if DegN = 1 then Exit;

     _NPs[ 2, 0 ] :=  Roo2(5/2)/2 * ( 3 * Pow2( X ) - 1 );
     _NPs[ 2, 1 ] := -Roo2(5/12)*3 * X * S;

     for M := 0 to 1 do
     begin
          P0 := _NPs[ M+0, M ];
          P1 := _NPs[ M+1, M ];

          for N := M+2 to DegN do
          begin
               P2 := PN012( N, M, P0, P1 );

               _NPs[ N, M ] := P2;

               P0 := P1; P1 := P2;
          end;
     end;

     for M := 2 to DegN do
     begin
          //                    M
          //        0     1     2
          //    0 (P00)       (P02) = 0
          //        |
          //    1  P10---P11
          //        |     |
          //  N 2 (P20)--P21--[P22]

          N := M;

          P00:= _NPs[ N-2, M-2 ];  P02 := 0;
          P20:= _NPs[ N  , M-2 ];  P22 := PNM22( N, M, P00, P02, P20 );

          _NPs[ N, M ] := P22;

          if DegN = N then Break;

          //                    M
          //        0     1     2
          //    0  P00
          //        |
          //    1 (P10)--P11  (P12) = 0
          //        |     |
          //    2  P20---P21---P22
          //        |     |     |
          //  N 3 (P30)--P31--[P32]

          N := M+1;

          P00:= _NPs[ N-2, M-2 ];  P02 := 0;
          P20:= _NPs[ N  , M-2 ];  P22 := PNM22( N, M, P00, P02, P20 );

          _NPs[ N, M ] := P22;

          for N := M+2 to DegN do
          begin
               P00:= _NPs[ N-2, M-2 ];  P02 := _NPs[ N-2, M   ];
               P20:= _NPs[ N  , M-2 ];  P22 := PNM22( N, M, P00, P02, P20 );

               _NPs[ N, M ] := P22;
          end;
     end;
end;

//------------------------------------------------------------------------------

function TdNALFsTerm4.PN012( const N_,M_:Integer; const PN0_,PN1_:TdDouble ) :TdDouble;
var
   N2, NuM, NnM, NM2, A, B :Double;
begin
     N2  := N_ * 2 ;
     NuM := N_ + M_;
     NnM := N_ - M_;
     NM2 := NuM * NnM;

     A := Roo2( ( N2 + 1 ) * ( N2 - 1 )                /                NM2   );
     B := Roo2( ( N2 + 1 ) * ( NuM - 1 ) * ( NnM - 1 ) / ( ( N2 - 3 ) * NM2 ) );

     Result := A * X * PN1_ - B * PN0_;
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