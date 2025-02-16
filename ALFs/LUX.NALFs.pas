unit LUX.NALFs;

interface //#################################################################### ■

uses LUX,
     LUX.ALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFs :Normalized Associated Legendre functions

     TNALFs = class( TALFs )
     private
     protected
       ///// A C C E S S O R
       function GetNFs( const N_,M_:Integer ) :Double; virtual;
       function GetdPs( const N_,M_:Integer ) :Double; override;
     public
       ///// P R O P E R T Y
       property NFs[ const N_,M_:Integer ] :Double read GetNFs;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapNALFs

     TMapNALFs = class( TNALFs )
     private
     protected
       _DegN :Integer;
       _X    :Double;
       _NPs  :TArray2<Double>;  upALPs:Boolean;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :Double; override;
       procedure SetX( const X_:Double ); override;
       function GetPs( const N_,M_:Integer ) :Double; override;
       ///// M E T H O D
       procedure InitALPs;
       procedure CalcALPs; virtual; abstract;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToNALFs

     TALFsToNALFs<TALFs_:TALFs,constructor> = class( TNALFs )
     private
     protected
       _ALFs :TALFs_;
       _NFs  :TArray2<Double>;  upNFs:Boolean;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :Double; override;
       procedure SetX( const X_:Double ); override;
       function GetNFs( const N_,M_:Integer ) :Double; override;
       function GetPs( const N_,M_:Integer ) :Double; override;
       function GetdPs( const N_,M_:Integer ) :Double; override;
       ///// M E T H O D
       procedure InitNs;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property ALFs :TALFs_ read _ALFs;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TNALFs.GetNFs( const N_,M_:Integer ) :Double;
var
   I :Integer;
begin
     Result := Sqrt( ( 2 * N_ + 1 ) / 2 );

     for I := N_ - M_ + 1 to N_ + M_ do Result := Result / Sqrt( I );
end;

//------------------------------------------------------------------------------

function TNALFs.GetdPs( const N_,M_:Integer ) :Double;
begin
     Result := N_ * X * Ps[ N_, M_ ];

     if M_ < N_ then Result := Result - Sqrt( ( 2 * N_ + 1 ) / ( 2 * N_ - 1 ) * ( N_ + M_ ) * ( N_ - M_ ) ) * Ps[ N_-1, M_ ];

     Result := Result / ( 1 - Pow2( X ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TMapNALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TMapNALFs.SetDegN( const DegN_:Integer );
begin
     inherited;

     _DegN := DegN_;  InitALPs;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TMapNALFs.GetX :Double;
begin
     Result := _X;
end;

procedure TMapNALFs.SetX( const X_:Double );
begin
     inherited;

     _X := X_;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TMapNALFs.GetPs( const N_,M_:Integer ) :Double;
begin
     if upALPs then
     begin
          upALPs := False;

          CalcALPs;
     end;

     Result := _NPs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TMapNALFs.InitALPs;
var
   N :Integer;
begin
     SetLength( _NPs, DegN+1 );
     for N := 0 to DegN do SetLength( _NPs[ N ], N+1 );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TALFsToNALFs<TALFs_>.GetDegN :Integer;
begin
     Result := _ALFs.DegN;
end;

procedure TALFsToNALFs<TALFs_>.SetDegN( const DegN_:Integer );
begin
     inherited;

     _ALFs.DegN := DegN_;  upNFs := True;
end;

//------------------------------------------------------------------------------

function TALFsToNALFs<TALFs_>.GetX :Double;
begin
     Result := _ALFs.X;
end;

procedure TALFsToNALFs<TALFs_>.SetX( const X_:Double );
begin
     inherited;

     _ALFs.X := X_;
end;

//------------------------------------------------------------------------------

function TALFsToNALFs<TALFs_>.GetNFs( const N_,M_:Integer ) :Double;
begin
     if upNFs then
     begin
          upNFs := False;

          InitNs;
     end;

     Result := _NFs[ N_, M_ ];
end;

//------------------------------------------------------------------------------

function TALFsToNALFs<TALFs_>.GetPs( const N_,M_:Integer ) :Double;
begin
     Result := NFs[ N_, M_ ] * _ALFs.Ps[ N_, M_ ];
end;

function TALFsToNALFs<TALFs_>.GetdPs( const N_,M_:Integer ) :Double;
begin
     Result := NFs[ N_, M_ ] * _ALFs.dPs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TALFsToNALFs<TALFs_>.InitNs;
var
   N, M :Integer;
begin
     SetLength( _NFs, DegN+1 );
     for N := 0 to DegN do
     begin
          SetLength( _NFs[ N ], N+1 );

          for M := 0 to N do _NFs[ N, M ] := inherited GetNFs( N, M );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TALFsToNALFs<TALFs_>.Create;
begin
     _ALFs := TALFs_.Create;

     inherited;
end;

constructor TALFsToNALFs<TALFs_>.Create( const DegN_:Integer );
begin
     _ALFs := TALFs_.Create;

     inherited;
end;

destructor TALFsToNALFs<TALFs_>.Destroy;
begin
     _ALFs.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■