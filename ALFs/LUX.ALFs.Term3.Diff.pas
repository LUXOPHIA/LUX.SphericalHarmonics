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
       procedure CalcALPs; override;
       function P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
       function PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
       function PN10( const M_:Integer; const PN1_:TdDouble ) :TdDouble;
       function PM012( const N_,M_:Integer; const PM0_,PM1_:TdDouble ) :TdDouble;
       function PM201( const N_,M_:Integer; const PM2_,PM0_:TdDouble ) :TdDouble;
       function PM120( const N_,M_:Integer; const PM1_,PM2_:TdDouble ) :TdDouble;
       function PN012( const N_,M_:Integer; const PN0_,PN1_:TdDouble ) :TdDouble;
       function PN201( const N_,M_:Integer; const PN2_,PN0_:TdDouble ) :TdDouble;
       function PN120( const N_,M_:Integer; const PN1_,PN2_:TdDouble ) :TdDouble;
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

procedure TdALFsTerm3.CalcALPs;
var
   M, N :Integer;
   P0, P1, P2 :TdDouble;
begin
     _S := Roo2( 1 - Pow2( X ) );
     P0 := 1;  _Ps[ 0, 0 ] := P0;
     for M := 1 to DegN do
     begin
          P1 := P01( M, P0 );

          _Ps[ M, M ] := P1;

          P0 := P1;
     end;

     for M := 0 to DegN-1 do
     begin
          P0 := _Ps[ M, M ];
          P1 := PN01( M, P0 );

          _Ps[ M+1, M ] := P1;
     end;

     for M := 0 to DegN-2 do
     begin
          P0 := _Ps[ M+0, M ];
          P1 := _Ps[ M+1, M ];

          for N := M+2 to DegN do
          begin
               P2 := PN012( N, M, P0, P1 );

               _Ps[ N, M ] := P2;

               P0 := P1; P1 := P2;
          end;
     end;
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.P01( const M_:Integer; const P0_:TdDouble ) :TdDouble;
begin
     Result := ( 1 - 2 * M_ ) * _S * P0_;
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.PN01( const M_:Integer; const PN0_:TdDouble ) :TdDouble;
begin
     Result := ( 2 * M_ + 1 ) * X * PN0_;
end;

function TdALFsTerm3.PN10( const M_:Integer; const PN1_:TdDouble ) :TdDouble;
begin
     Result := PN1_ / ( ( 2 * M_ + 1 ) * X );
end;

//------------------------------------------------------------------------------

function TdALFsTerm3.PM012( const N_,M_:Integer; const PM0_,PM1_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * M_ - 1 ) * X / M_ ) * PM1_ - ( ( N_ + M_ - 1 ) / M_ ) * PM0_;
end;

function TdALFsTerm3.PM201( const N_,M_:Integer; const PM2_,PM0_:TdDouble ) :TdDouble;
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

function TdALFsTerm3.PN201( const N_,M_:Integer; const PN2_,PN0_:TdDouble ) :TdDouble;
begin
     Result := ( ( N_ + M_ ) * PN0_ + ( N_ - M_ + 1 ) * PN2_ ) / ( ( 2 * N_ + 1 ) * X );
end;

function TdALFsTerm3.PN120( const N_,M_:Integer; const PN1_,PN2_:TdDouble ) :TdDouble;
begin
     Result := ( ( 2 * N_ + 3 ) * X * PN1_ - ( N_ - M_ + 2 ) * PN2_ ) / ( N_ + M_ + 1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■