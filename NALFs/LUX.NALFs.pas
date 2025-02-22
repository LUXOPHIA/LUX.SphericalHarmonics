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
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCoreNALFs

     TCoreNALFs = class( TNALFs )
     private
     protected
       _DegN :Integer;
       _X    :Double;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :Double; override;
       procedure SetX( const X_:Double ); override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCacheNALFs

     TCacheNALFs = class( TCoreNALFs )
     private
     protected
       _NPs :TArray2<Double>;
       ///// A C C E S S O R
       procedure SetDegN( const DegN_:Integer ); override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToNALFs<TALFs_>

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
       function GetPs( const N_,M_:Integer ) :Double; override;
       function GetNFs( const N_,M_:Integer ) :Double; virtual;
       ///// M E T H O D
       function NormFactor( const N_,M_:Integer ) :Double;
       procedure InitNFs;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property ALFs                       :TALFs_ read   _ALFs;
       property NFs[ const N_,M_:Integer ] :Double read GetNFs ;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCoreNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCoreNALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCoreNALFs.SetDegN( const DegN_:Integer );
begin
     inherited;

     _DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TCoreNALFs.GetX :Double;
begin
     Result := _X;
end;

procedure TCoreNALFs.SetX( const X_:Double );
begin
     inherited;

     _X := X_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCacheNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TCacheNALFs.SetDegN( const DegN_:Integer );
var
   N :Integer;
begin
     inherited;

     SetLength( _NPs, DegN+1 );
     for N := 0 to DegN do SetLength( _NPs[ N ], N+1 );

     _NPs[ 0, 0 ] := 1/Sqrt(2);
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToNALFs<TALFs_>

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

function TALFsToNALFs<TALFs_>.GetPs( const N_,M_:Integer ) :Double;
begin
     Result := NFs[ N_, M_ ] * _ALFs.Ps[ N_, M_ ];
end;

//------------------------------------------------------------------------------

function TALFsToNALFs<TALFs_>.GetNFs( const N_,M_:Integer ) :Double;
begin
     if upNFs then
     begin
          upNFs := False;

          InitNFs;
     end;

     Result := _NFs[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TALFsToNALFs<TALFs_>.NormFactor( const N_,M_:Integer ) :Double;
var
   I :Integer;
begin
     Result := Sqrt( ( 2 * N_ + 1 ) / 2 );

     for I := N_ - M_ + 1 to N_ + M_ do Result := Result / Sqrt( I );
end;

procedure TALFsToNALFs<TALFs_>.InitNFs;
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