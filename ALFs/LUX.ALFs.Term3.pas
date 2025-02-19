unit LUX.ALFs.Term3;

interface //#################################################################### ■

uses LUX,
     LUX.ALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsTerm3

     TALFsTerm3 = class( TCacheALFs )
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
       function PN10( const M_:Integer; const PN1_:Double ) :Double;
       function PM012( const N_,M_:Integer; const PM0_,PM1_:Double ) :Double;
       function PM201( const N_,M_:Integer; const PM2_,PM0_:Double ) :Double;
       function PM120( const N_,M_:Integer; const PM1_,PM2_:Double ) :Double;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
       function PN201( const N_,M_:Integer; const PN2_,PN0_:Double ) :Double;
       function PN120( const N_,M_:Integer; const PN1_,PN2_:Double ) :Double;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsTerm3

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TALFsTerm3.SetDegN( const DegN_:Integer );
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
     for M := _MaxM+1 to DegN do _MaxNs[ M ] := M;
end;

//------------------------------------------------------------------------------

procedure TALFsTerm3.SetX( const X_:Double );
var
   M :Integer;
begin
     inherited;

     _MaxM := 0;

     for M := 0 to _DegN do _MaxNs[ M ] := M;

     _S := Sqrt( 1 - Pow2( X ) );
end;

//------------------------------------------------------------------------------

function TALFsTerm3.GetPs( const N_,M_:Integer ) :Double;
var
   M, N :Integer;
begin
     if _MaxM < M_ then
     begin
          ///// N = M
          for M := _MaxM+1 to M_ do _Ps[ M, M ] := P01( M, _Ps[ M-1, M-1 ] );

          _MaxM := M_;
     end;

     if _MaxNs[ M_ ] < N_ then
     begin
          ///// N = M+1
          if _MaxNs[ M_ ] = M_ then
          begin
               _Ps[ M_+1, M_ ] := PN01( M_, _Ps[ M_, M_ ] );

               _MaxNs[ M_ ] := M_+1;
          end;

          ///// M+2 <= N
          for N := _MaxNs[ M_ ]+1 to N_ do _Ps[ N, M_ ] := PN012( N, M_, _Ps[ N-2, M_ ], _Ps[ N-1, M_ ] );

          _MaxNs[ M_ ] := N_;
     end;

     Result := _Ps[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TALFsTerm3.P01( const M_:Integer; const P0_:Double ) :Double;
begin
     Result := ( 1 - 2 * M_ ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TALFsTerm3.PN01( const M_:Integer; const PN0_:Double ) :Double;
begin
     Result := ( 2 * M_ + 1 ) * X * PN0_;
end;

function TALFsTerm3.PN10( const M_:Integer; const PN1_:Double ) :Double;
begin
     Result := PN1_ / ( ( 2 * M_ + 1 ) * X );
end;

//------------------------------------------------------------------------------

function TALFsTerm3.PM012( const N_,M_:Integer; const PM0_,PM1_:Double ) :Double;
begin
     Result := ( ( 2 * M_ - 1 ) * X / M_ ) * PM1_ - ( ( N_ + M_ - 1 ) / M_ ) * PM0_;
end;

function TALFsTerm3.PM201( const N_,M_:Integer; const PM2_,PM0_:Double ) :Double;
begin
     Result := ( ( M_ + 1 ) * PM2_ + ( N_ + M_ ) * PM0_ ) / ( ( 2 * M_ + 1 ) * X );
end;

function TALFsTerm3.PM120( const N_,M_:Integer; const PM1_,PM2_:Double ) :Double;
begin
     Result := ( ( 2 * M_ + 3 ) * X * PM1_ - ( M_ + 2 ) * PM2_ ) / ( N_ + M_ + 1 );
end;

//------------------------------------------------------------------------------

function TALFsTerm3.PN012( const N_,M_:Integer; const PN0_,PN1_:Double ) :Double;
begin
     Result := ( ( 2 * N_ - 1 ) * X * PN1_ - ( N_ + M_ - 1 ) * PN0_ ) / ( N_ - M_ );
end;

function TALFsTerm3.PN201( const N_,M_:Integer; const PN2_,PN0_:Double ) :Double;
begin
     Result := ( ( N_ + M_ ) * PN0_ + ( N_ - M_ + 1 ) * PN2_ ) / ( ( 2 * N_ + 1 ) * X );
end;

function TALFsTerm3.PN120( const N_,M_:Integer; const PN1_,PN2_:Double ) :Double;
begin
     Result := ( ( 2 * N_ + 3 ) * X * PN1_ - ( N_ - M_ + 2 ) * PN2_ ) / ( N_ + M_ + 1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■