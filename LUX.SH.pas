unit LUX.SH;

interface //#################################################################### ■

uses LUX,
     LUX.Complex,
     LUX.ALFs,
     LUX.NALFs,
     LUX.NALFs.Term4;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSPHarmonics

     TSPHarmonics = class
     private
     protected
       _ALFs   :TALFs;
       _AngleX :Double;
       _AngleY :Double;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       procedure OnUpALFs( Sender:TObject );
       function GetALFs :TALFs;
       procedure SetALFs( const ALFs_:TALFs );
       function GetDegN :Integer;
       procedure SetDegN( const DegN_:Integer );
       function GetAngleX :Double;
       procedure SetAngleX( const AngleX_:Double );
       function GetAngleY :Double;
       procedure SetAngleY( const AngleY_:Double );
       function GetSHs( const N_,M_:Integer ) :TDoubleC; virtual; abstract;
     public
       constructor Create( const DegN_:Integer ); overload;
       ///// P R O P E R T Y
       property ALFs                       :TALFs    read GetALFs   write SetALFs  ;
       property DegN                       :Integer  read GetDegN   write SetDegN  ;
       property AngleX                     :Double   read GetAngleX write SetAngleX;
       property AngleY                     :Double   read GetAngleY write SetAngleY;
       property SHs[ const N_,M_:Integer ] :TDoubleC read GetSHs                   ; default;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSPHarmonics<TNALFs_>

     TSPHarmonics<TNALFs_:TNALFs,constructor> = class( TSPHarmonics )
     private
     protected
       ///// A C C E S S O R
       function GetSHs( const N_,M_:Integer ) :TDoubleC; override;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSPHarmonicsT4

     TSPHarmonicsT4 = TSPHarmonics<TNALFsTerm4>;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSPHarmonics

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TSPHarmonics.OnUpALFs( Sender:TObject );
begin
     _OnChange.Run( Self );
end;

function TSPHarmonics.GetALFs :TALFs;
begin
     Result := _ALFs;
end;

procedure TSPHarmonics.SetALFs( const ALFs_:TALFs );
begin
     if _ALFs = ALFs_ then Exit;

     if Assigned( _ALFs ) then _ALFs.OnChange.Del( OnUpALFs );

     _ALFs := ALFs_;

     if Assigned( _ALFs ) then _ALFs.OnChange.Add( OnUpALFs );

     OnUpALFs( Self );
end;

//------------------------------------------------------------------------------

function TSPHarmonics.GetDegN :Integer;
begin
     Result := _ALFs.DegN;
end;

procedure TSPHarmonics.SetDegN( const DegN_:Integer );
begin
     if _ALFs.DegN = DegN_ then Exit;

     _ALFs.DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TSPHarmonics.GetAngleX :Double;
begin
     Result := _AngleX;
end;

procedure TSPHarmonics.SetAngleX( const AngleX_:Double );
begin
     if _AngleX = AngleX_ then Exit;

     _AngleX := AngleX_;
end;

function TSPHarmonics.GetAngleY :Double;
begin
     Result := _AngleY;
end;

procedure TSPHarmonics.SetAngleY( const AngleY_:Double );
begin
     if _AngleY = AngleY_ then Exit;

     _AngleY := AngleY_;

     _ALFs.X := Cos( _AngleY );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSPHarmonics.Create( const DegN_:Integer );
begin
     inherited Create;

     _ALFs.DegN := DegN_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSPHarmonics<TNALFs_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSPHarmonics<TNALFs_>.GetSHs( const N_,M_:Integer ) :TDoubleC;
var
   A, C, S :Double;
begin
     A := _ALFs[ N_, M_ ] / Sqrt( Pi2 );

     SinCos( M_ * _AngleX, S, C );

     Result.R := A * C;
     Result.I := A * S;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSPHarmonics<TNALFs_>.Create;
begin
     _ALFs := TNALFs_.Create;

     inherited;
end;

constructor TSPHarmonics<TNALFs_>.Create( const DegN_:Integer );
begin
     _ALFs := TNALFs_.Create;

     inherited Create;

     _ALFs.DegN := DegN_;
end;

destructor TSPHarmonics<TNALFs_>.Destroy;
begin
     _ALFs.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■