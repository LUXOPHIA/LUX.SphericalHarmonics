unit LUX.ALFs.Term3.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.ALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsTerm3

     TdALFsTerm3 = class( TdMapALFs )
     private
     protected
       _S :TdDouble;
       ///// M E T H O D
       function P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
       function PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
       function PN10( const M_:Integer; const PN1_:TdDouble ) :TdDouble;
       function PM012( const N_,M_:Integer; const PM0_,PM1_:TdDouble ) :TdDouble;
       function PM201( const N_,M_:Integer; const PM2_,PM0_:TdDouble ) :TdDouble;
       function PM120( const N_,M_:Integer; const PM1_,PM2_:TdDouble ) :TdDouble;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:TdDouble ) :TdDouble;
       function PN201( const N_,M_:Integer; const PN2_,PN0_:TdDouble ) :TdDouble;
       function PN120( const N_,M_:Integer; const PN1_,PN2_:TdDouble ) :TdDouble;
       procedure CalcPs; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsTerm3

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TdALFsTerm3.P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
begin
     Result := ( 1 - 2 * M_ ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
begin
     Result := ( 2 * M_ + 1 ) * X * PN0_;
end;

function TdALFsTerm3.PN10( const M_:Integer; const PN1_:TdDouble ) :TdDouble;  // X <> 0
begin
     Result := PN1_ / ( ( 2 * M_ + 1 ) * X );
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.PM012( const N_,M_:Integer; const PM0_,PM1_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * M_ - 1 ) * X / M_ ) * PM1_ - ( ( N_ + M_ - 1 ) / M_ ) * PM0_;
end;

function TdALFsTerm3.PM201( const N_,M_:Integer; const PM2_,PM0_:TdDouble ) :TdDouble;  // X <> 0
begin
     Result := ( ( M_ + 1 ) * PM2_ + ( N_ + M_ ) * PM0_ ) / ( ( 2 * M_ + 1 ) * X );
end;

function TdALFsTerm3.PM120( const N_,M_:Integer; const PM1_,PM2_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * M_ + 3 ) * X * PM1_ - ( M_ + 2 ) * PM2_ ) / ( N_ + M_ + 1 );
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.PN012( const N_,M_:Integer; const PN0_,PN1_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * N_ - 1 ) * X * PN1_ - ( N_ + M_ - 1 ) * PN0_ ) / ( N_ - M_ );
end;

function TdALFsTerm3.PN201( const N_,M_:Integer; const PN2_,PN0_:TdDouble ) :TdDouble;  // X <> 0
begin
     Result := ( ( N_ + M_ ) * PN0_ + ( N_ - M_ + 1 ) * PN2_ ) / ( ( 2 * N_ + 1 ) * X );
end;

function TdALFsTerm3.PN120( const N_,M_:Integer; const PN1_,PN2_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * N_ + 3 ) * X * PN1_ - ( N_ - M_ + 2 ) * PN2_ ) / ( N_ + M_ + 1 );
end;

//------------------------------------------------------------------------------

procedure TdALFsTerm3.CalcPs;
var
   N, M :Integer;
begin
     _S := Roo2( 1 - Pow2( X ) );

     _Ps[ 0, 0 ] := 1;

     ///// N = M
     for M := 1 to DegN do _Ps[ M, M ] := P01( M, _Ps[ M-1, M-1 ] );

     ///// N = M+1
     for M := 0 to DegN-1 do _Ps[ M+1, M ] := PN01( M, _Ps[ M, M ] );

     ///// M+2 <= N
     for M := 0 to DegN do
     begin
          for N := M+2 to DegN do _Ps[ N, M ] := PN012( N, M, _Ps[ N-2, M ], _Ps[ N-1, M ] );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■