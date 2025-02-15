unit LUX.NALFs.Enomoto;

interface //#################################################################### ■

uses LUX,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsEnomoto

     TNALFsEnomoto = class( TMapNALFs )
     private
     protected
       _S :Double;
       ///// M E T H O D
       procedure CalcALPs; override;
       function P01( const M_:Integer; const P0_:Double ) :Double;
       function PN01( const M_:Integer; const PN0_:Double ) :Double;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
       function PNM22( const N_,M_:Integer; const P00_,P02_,P20_:Double ) :Double;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math, System.Threading;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsEnomoto

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TNALFsEnomoto.CalcALPs;
var
   N, M :Integer;
   P0, P1, P2, P00, P02, P20, P22 :Double;
begin
     _S := Sqrt( 1 - Pow2( X ) );

     _NPs[ 0, 0 ] :=  Sqrt(1/2);
     _NPs[ 1, 0 ] :=  Sqrt(3/2) * X;
     _NPs[ 1, 1 ] := -Sqrt(3)/2 * _S;
     _NPs[ 2, 0 ] :=  Sqrt(5/2)/2 * ( 3 * Pow2( X ) - 1 );
     _NPs[ 2, 1 ] := -Sqrt(5/12)*3 * X * _S;

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
          //      0     1     2   M
          //  0 (P00)       (P02) = 0
          //      |
          //  1  P10---P11
          //      |     |
          //  2 (P20)--P21--[P22]
          //  N

          N := M;

          P00:= _NPs[ N-2, M-2 ];  P02 := 0;
          P20:= _NPs[ N  , M-2 ];  P22 := PNM22( N, M, P00, P02, P20 );

          _NPs[ N, M ] := P22;

          if N = DegN then Break;

          //      0     1     2   M
          //  0  P00
          //      |
          //  1 (P10)--P11  (P12) = 0
          //      |     |
          //  2  P20---P21---P22
          //      |     |     |
          //  3 (P30)--P31--[P32]
          //  N

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

function TNALFsEnomoto.P01( const M_:Integer; const P0_:Double ) :Double;
begin
     Result := -Sqrt( ( 2 * M_ + 1 ) / ( 2 * M_ ) ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TNALFsEnomoto.PN01( const M_:Integer; const PN0_:Double ) :Double;
begin
     Result := Sqrt( 2 * M_ + 3 ) * X * PN0_;
end;

//------------------------------------------------------------------------------

function TNALFsEnomoto.PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
var
   N2, NuM, NnM, NM2, A, B :Double;
begin
     N2  := 2 * N_;
     NuM := N_ + M_;
     NnM := N_ - M_;
     NM2 := NuM * NnM;

     A := Sqrt( ( N2 + 1 ) * ( N2 - 1 )                /                NM2   );
     B := Sqrt( ( N2 + 1 ) * ( NuM - 1 ) * ( NnM - 1 ) / ( ( N2 - 3 ) * NM2 ) );

     Result := A * X * PN1_ - B * PN0_;
end;

//------------------------------------------------------------------------------

function TNALFsEnomoto.PNM22( const N_,M_:Integer; const P00_,P02_,P20_:Double ) :Double;
var
   A00, A02, A20 :Double;
begin
     //      0     1     2   M
     //  0 [P00]--P01--[P02]
     //      |     |     |
     //  1  P10---P11---P12
     //      |     |     |
     //  2 [P20]--P21--[P22]
     //  N

     A00 := Sqrt( ( ( 2 * N_ + 1 ) * ( N_ + M_ - 3 ) * ( N_ + M_ - 2) )
                / ( ( 2 * N_ - 3 ) * ( N_ + M_ - 1 ) * ( N_ + M_    ) ) );

     A02 := Sqrt( ( ( 2 * N_ + 1 ) * ( N_ - M_ - 1 ) * ( N_ - M_ ) )
                / ( ( 2 * N_ - 3 ) * ( N_ + M_ - 1 ) * ( N_ + M_ ) ) );

     A20 := Sqrt( ( ( N_ - M_ + 1 ) * ( N_ - M_ + 2 ) )
                / ( ( N_ + M_ - 1 ) * ( N_ + M_     ) ) );

     Result := A00 * P00_ + A02 * P02_ - A20 * P20_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■