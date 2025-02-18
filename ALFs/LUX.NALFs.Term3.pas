unit LUX.NALFs.Term3;

interface //#################################################################### ■

uses LUX,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsTerm3

     TNALFsTerm3 = class( TMapNALFs )
     private
     protected
       _S     :Double;
       _MaxM  :Integer;
       _MaxNs :TArray<Integer>;
       ///// A C C E S S O R
       procedure SetDegN( const DegN_:Integer ); override;
       procedure SetX( const X_:Double ); override;
       function GetPs( const N_,M_:Integer ) :Double; override;
       ///// M E T H O D
       function P01( const M_:Integer; const P0_:Double ) :Double;
       function PN01( const M_:Integer; const PN0_:Double ) :Double;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsTerm3

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TNALFsTerm3.SetDegN( const DegN_:Integer );
var
   M :Integer;
begin
     inherited;

     if DegN < _MaxM then _MaxM := DegN;

     SetLength( _MaxNs, DegN+1 );
     for M := 0 to _MaxM do
     begin
          if DegN < _MaxNs[ M ] then _MaxNs[ M ] := DegN;
     end;
     for M := _MaxM to DegN do _MaxNs[ M ] := M;
end;

//------------------------------------------------------------------------------

procedure TNALFsTerm3.SetX( const X_:Double );
var
   M :Integer;
begin
     inherited;

     _MaxM := 0;

     for M := 0 to _DegN do _MaxNs[ M ] := M;

     _S := Sqrt( 1 - Pow2( X ) );
end;

//------------------------------------------------------------------------------

function TNALFsTerm3.GetPs( const N_,M_:Integer ) :Double;
var
   M, N :Integer;
begin
     if _MaxM < M_ then
     begin
          ///// N = M
          for M := _MaxM+1 to M_ do _NPs[ M, M ] := P01( M, _NPs[ M-1, M-1 ] );

          _MaxM := M_;
     end;

     if _MaxNs[ M_ ] < N_ then
     begin
          ///// N = M+1
          if _MaxNs[ M_ ] = M_ then
          begin
               _NPs[ M_+1, M_ ] := PN01( M_, _NPs[ M_, M_ ] );

               _MaxNs[ M_ ] := M_+1;
          end;

          ///// M+2 <= N
          for N := _MaxNs[ M_ ]+1 to N_ do _NPs[ N, M_ ] := PN012( N, M_, _NPs[ N-2, M_ ], _NPs[ N-1, M_ ] );

          _MaxNs[ M_ ] := N_;
     end;

     Result := _NPs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TNALFsTerm3.P01( const M_:Integer; const P0_:Double ) :Double;
begin
     Result := -Sqrt( ( 2 * M_ + 1 ) / ( 2 * M_ ) ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TNALFsTerm3.PN01( const M_:Integer; const PN0_:Double ) :Double;
begin
     Result := Sqrt( 2 * M_ + 3 ) * X * PN0_;
end;

//------------------------------------------------------------------------------

function TNALFsTerm3.PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
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