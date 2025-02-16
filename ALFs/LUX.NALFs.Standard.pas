unit LUX.NALFs.Standard;

interface //#################################################################### ■

uses LUX,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsStandard

     TNALFsStandard = class( TMapNALFs )
     private
     protected
       _S :Double;
       ///// M E T H O D
       procedure CalcALPs; override;
       function P01( const M_:Integer; const P0_:Double ) :Double;
       function PN01( const M_:Integer; const PN0_:Double ) :Double;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsStandard

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TNALFsStandard.CalcALPs;
var
   M, N :Integer;
   P0, P1, P2 :Double;
begin
     _S := Sqrt( 1 - Pow2( X ) );
     P0 := 1/Sqrt(2);  _NPs[ 0, 0 ] := P0;
     for M := 1 to DegN do
     begin
          P1 := P01( M, P0 );

          _NPs[ M, M ] := P1;

          P0 := P1;
     end;

     for M := 0 to DegN-1 do
     begin
          P0 := _NPs[ M, M ];
          P1 := PN01( M, P0 );

          _NPs[ M+1, M ] := P1;
     end;

     for M := 0 to DegN-2 do
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
end;

//------------------------------------------------------------------------------

function TNALFsStandard.P01( const M_:Integer; const P0_:Double ) :Double;
begin
     Result := -Sqrt( ( 2 * M_ + 1 ) / ( 2 * M_ ) ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TNALFsStandard.PN01( const M_:Integer; const PN0_:Double ) :Double;
begin
     Result := Sqrt( 2 * M_ + 3 ) * X * PN0_;
end;

//------------------------------------------------------------------------------

function TNALFsStandard.PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■