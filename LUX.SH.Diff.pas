unit LUX.SH.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.Complex.Diff,
     LUX.ALFs.Diff,
     LUX.NALFs.Diff,
     LUX.NALFs.Term4.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSPHarmonics

     TdSPHarmonics = class
     private
     protected
       _dALFs  :TdALFs;
       _AngleX :TdDouble;
       _AngleY :TdDouble;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       procedure OnUpALFs( Sender:TObject );
       function GetALFs :TdALFs;
       procedure SetALFs( const ALFs_:TdALFs );
       function GetDegN :Integer;
       procedure SetDegN( const DegN_:Integer );
       function GetAngleX :TdDouble;
       procedure SetAngleX( const AngleX_:TdDouble );
       function GetAngleY :TdDouble;
       procedure SetAngleY( const AngleY_:TdDouble );
       function GetSHs( const N_,M_:Integer ) :TdDoubleC; virtual; abstract;
     public
       constructor Create( const DegN_:Integer ); overload;
       ///// P R O P E R T Y
       property dALFs                      :TdALFs    read GetALFs   write SetALFs  ;
       property DegN                       :Integer   read GetDegN   write SetDegN  ;
       property AngleX                     :TdDouble  read GetAngleX write SetAngleX;
       property AngleY                     :TdDouble  read GetAngleY write SetAngleY;
       property SHs[ const N_,M_:Integer ] :TdDoubleC read GetSHs                   ; default;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSPHarmonics<TdNALFs_>

     TdSPHarmonics<TdNALFs_:TdNALFs,constructor> = class( TdSPHarmonics )
     private
     protected
       ///// A C C E S S O R
       function GetSHs( const N_,M_:Integer ) :TdDoubleC; override;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSPHarmonicsT4

     TdSPHarmonicsT4 = TdSPHarmonics<TdNALFsTerm4>;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSPHarmonics

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TdSPHarmonics.OnUpALFs( Sender:TObject );
begin
     _OnChange.Run( Self );
end;

function TdSPHarmonics.GetALFs :TdALFs;
begin
     Result := _dALFs;
end;

procedure TdSPHarmonics.SetALFs( const ALFs_:TdALFs );
begin
     if _dALFs = ALFs_ then Exit;

     if Assigned( _dALFs ) then _dALFs.OnChange.Del( OnUpALFs );

     _dALFs := ALFs_;

     if Assigned( _dALFs ) then _dALFs.OnChange.Add( OnUpALFs );

     OnUpALFs( Self );
end;

//------------------------------------------------------------------------------

function TdSPHarmonics.GetDegN :Integer;
begin
     Result := _dALFs.DegN;
end;

procedure TdSPHarmonics.SetDegN( const DegN_:Integer );
begin
     if _dALFs.DegN = DegN_ then Exit;

     _dALFs.DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TdSPHarmonics.GetAngleX :TdDouble;
begin
     Result := _AngleX;
end;

procedure TdSPHarmonics.SetAngleX( const AngleX_:TdDouble );
begin
     if _AngleX = AngleX_ then Exit;

     _AngleX := AngleX_;
end;

function TdSPHarmonics.GetAngleY :TdDouble;
begin
     Result := _AngleY;
end;

procedure TdSPHarmonics.SetAngleY( const AngleY_:TdDouble );
begin
     if _AngleY = AngleY_ then Exit;

     _AngleY := AngleY_;

     _dALFs.X := Cos( _AngleY );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSPHarmonics.Create( const DegN_:Integer );
begin
     inherited Create;

     _dALFs.DegN := DegN_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSPHarmonics<TdNALFs_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSPHarmonics<TdNALFs_>.GetSHs( const N_,M_:Integer ) :TdDoubleC;
var
   A, C, S :TdDouble;
begin
     A := _dALFs[ N_, M_ ] / Sqrt( Pi2 );

     SinCos( M_ * _AngleX, S, C );

     Result.R := A * C;
     Result.I := A * S;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSPHarmonics<TdNALFs_>.Create;
begin
     _dALFs := TdNALFs_.Create;

     inherited;
end;

constructor TdSPHarmonics<TdNALFs_>.Create( const DegN_:Integer );
begin
     _dALFs := TdNALFs_.Create;

     inherited Create;

     _dALFs.DegN := DegN_;
end;

destructor TdSPHarmonics<TdNALFs_>.Destroy;
begin
     _dALFs.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■