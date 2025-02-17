unit LUX.FNALFs;

interface //#################################################################### ■

uses LUX,
     LUX.ALFs,
     LUX.NALFs;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFNALFs :Fully Normalized Associated Legendre functions

     TFNALFs = class( TNALFs )
     private
     protected
       ///// A C C E S S O R
       function GetNFs( const N_,M_:Integer ) :Double; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToFNALFs

     TALFsToFNALFs<TALFs_:TALFs,constructor> = class( TNALFs )
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
       ///// M E T H O D
       procedure InitNFs;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property ALFs :TALFs_ read _ALFs;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsToFNALFs

     TNALFsToFNALFs<TNALFs_:TNALFs,constructor> = class( TFNALFs )
     private
     protected
       _NALFs :TNALFs_;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure SetDegN( const DegN_:Integer ); override;
       function GetX :Double; override;
       procedure SetX( const X_:Double ); override;
       function GetNFs( const N_,M_:Integer ) :Double; override;
       function GetPs( const N_,M_:Integer ) :Double; override;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property NALFs :TNALFs_ read _NALFs;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TFNALFs.GetNFs( const N_,M_:Integer ) :Double;
var
   K :Double;
   I :Integer;
begin
     if M_ = 0 then K := 1
               else K := 2;

     Result := Sqrt( K * ( 2 * N_ + 1 ) );

     for I := N_ - M_ + 1 to N_ + M_ do Result := Result / Sqrt( I );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFsToFNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TALFsToFNALFs<TALFs_>.GetDegN :Integer;
begin
     Result := _ALFs.DegN;
end;

procedure TALFsToFNALFs<TALFs_>.SetDegN( const DegN_:Integer );
begin
     inherited;

     _ALFs.DegN := DegN_;  upNFs := True;
end;

//------------------------------------------------------------------------------

function TALFsToFNALFs<TALFs_>.GetX :Double;
begin
     Result := _ALFs.X;
end;

procedure TALFsToFNALFs<TALFs_>.SetX( const X_:Double );
begin
     inherited;

     _ALFs.X := X_;
end;

//------------------------------------------------------------------------------

function TALFsToFNALFs<TALFs_>.GetNFs( const N_,M_:Integer ) :Double;
begin
     if upNFs then
     begin
          upNFs := False;

          InitNFs;
     end;

     Result := _NFs[ N_, M_ ];
end;

//------------------------------------------------------------------------------

function TALFsToFNALFs<TALFs_>.GetPs( const N_,M_:Integer ) :Double;
begin
     Result := NFs[ N_, M_ ] * _ALFs.Ps[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TALFsToFNALFs<TALFs_>.InitNFs;
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

constructor TALFsToFNALFs<TALFs_>.Create;
begin
     _ALFs := TALFs_.Create;

     inherited;
end;

constructor TALFsToFNALFs<TALFs_>.Create( const DegN_:Integer );
begin
     _ALFs := TALFs_.Create;

     inherited;
end;

destructor TALFsToFNALFs<TALFs_>.Destroy;
begin
     _ALFs.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNALFsToFNALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TNALFsToFNALFs<TNALFs_>.GetDegN :Integer;
begin
     Result := _NALFs.DegN;
end;

procedure TNALFsToFNALFs<TNALFs_>.SetDegN( const DegN_:Integer );
begin
     inherited;

     _NALFs.DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TNALFsToFNALFs<TNALFs_>.GetX :Double;
begin
     Result := _NALFs.X;
end;

procedure TNALFsToFNALFs<TNALFs_>.SetX( const X_:Double );
begin
     inherited;

     _NALFs.X := X_;
end;

//------------------------------------------------------------------------------

function TNALFsToFNALFs<TNALFs_>.GetNFs( const N_,M_:Integer ) :Double;
begin
     if M_ = 0 then Result := 1
               else Result := Sqrt(2);
end;
//------------------------------------------------------------------------------

function TNALFsToFNALFs<TNALFs_>.GetPs( const N_,M_:Integer ) :Double;
begin
     Result := NFs[ N_, M_ ] * _NALFs.Ps[ N_, M_ ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TNALFsToFNALFs<TNALFs_>.Create;
begin
     inherited;

     _NALFs := TNALFs_.Create;
end;

constructor TNALFsToFNALFs<TNALFs_>.Create( const DegN_:Integer );
begin
     Create;

     _NALFs.DegN := DegN_;
end;

destructor TNALFsToFNALFs<TNALFs_>.Destroy;
begin
     _NALFs.Free;

     inherited;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■