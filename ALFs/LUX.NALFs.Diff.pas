unit LUX.NALFs.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.ALFs.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFs :Normalized Associated Legendre functions

     TdNALFs = class( TdALFs )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdMapNALFs

     TdMapNALFs = class( TdNALFs )
     private
     protected
       _DegN :Integer;
       _X    :TdDouble;
       _NPs  :TArray2<TdDouble>;  upALPs:Boolean;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :TdDouble; override;
       procedure SetX( const X_:TdDouble ); override;
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
       ///// M E T H O D
       procedure InitALPs;
       procedure CalcALPs; virtual; abstract;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsToNALFs<TdALFs_>

     TdALFsToNALFs<TdALFs_:TdALFs,constructor> = class( TdNALFs )
     private
     protected
       _dALFs :TdALFs_;
       _NFs   :TArray2<TdDouble>;  upNFs:Boolean;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :TdDouble; override;
       procedure SetX( const X_:TdDouble ); override;
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
       function GetNFs( const N_,M_:Integer ) :TdDouble; virtual;
       ///// M E T H O D
       function NormFactor( const N_,M_:Integer ) :TdDouble;
       procedure InitNFs;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property dALFs                      :TdALFs_  read   _dALFs;
       property NFs[ const N_,M_:Integer ] :TdDouble read GetNFs  ;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdMapNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdMapNALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TdMapNALFs.SetDegN( const DegN_:Integer );
begin
     inherited;

     _DegN := DegN_;  InitALPs;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TdMapNALFs.GetX :TdDouble;
begin
     Result := _X;
end;

procedure TdMapNALFs.SetX( const X_:TdDouble );
begin
     inherited;

     _X := X_;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TdMapNALFs.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     if upALPs then
     begin
          upALPs := False;

          CalcALPs;
     end;

     Result := _NPs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TdMapNALFs.InitALPs;
var
   N :Integer;
begin
     SetLength( _NPs, DegN+1 );
     for N := 0 to DegN do SetLength( _NPs[ N ], N+1 );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFsToNALFs<TdALFs_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdALFsToNALFs<TdALFs_>.GetDegN :Integer;
begin
     Result := _dALFs.DegN;
end;

procedure TdALFsToNALFs<TdALFs_>.SetDegN( const DegN_:Integer );
begin
     inherited;

     _dALFs.DegN := DegN_;  upNFs := True;
end;

//------------------------------------------------------------------------------

function TdALFsToNALFs<TdALFs_>.GetX :TdDouble;
begin
     Result := _dALFs.X;
end;

procedure TdALFsToNALFs<TdALFs_>.SetX( const X_:TdDouble );
begin
     inherited;

     _dALFs.X := X_;
end;

//------------------------------------------------------------------------------

function TdALFsToNALFs<TdALFs_>.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     Result := NFs[ N_, M_ ] * _dALFs.Ps[ N_, M_ ];
end;

//------------------------------------------------------------------------------

function TdALFsToNALFs<TdALFs_>.GetNFs( const N_,M_:Integer ) :TdDouble;
begin
     if upNFs then
     begin
          upNFs := False;

          InitNFs;
     end;

     Result := _NFs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdALFsToNALFs<TdALFs_>.NormFactor( const N_,M_:Integer ) :TdDouble;
var
   I :Integer;
begin
     Result := Sqrt( ( 2 * N_ + 1 ) / 2 );

     for I := N_ - M_ + 1 to N_ + M_ do Result := Result / Sqrt( I );
end;

procedure TdALFsToNALFs<TdALFs_>.InitNFs;
var
   N, M :Integer;
begin
     SetLength( _NFs, DegN+1 );
     for N := 0 to DegN do
     begin
          SetLength( _NFs[ N ], N+1 );

          for M := 0 to N do _NFs[ N, M ] := NormFactor( N, M );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdALFsToNALFs<TdALFs_>.Create;
begin
     _dALFs := TdALFs_.Create;

     inherited;
end;

constructor TdALFsToNALFs<TdALFs_>.Create( const DegN_:Integer );
begin
     _dALFs := TdALFs_.Create;

     inherited;
end;

destructor TdALFsToNALFs<TdALFs_>.Destroy;
begin
     _dALFs.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■