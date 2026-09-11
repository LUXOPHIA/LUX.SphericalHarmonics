unit LUX.ALFs.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFs :Associated Legendre functions

     TdALFs = class
     private
     protected
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual; abstract;
       procedure SetDegN( const DegN_:Integer );
       procedure DoSetDegN( const DegN_:Integer ); virtual; abstract;
       function GetX :TdDouble; virtual; abstract;
       procedure SetX( const X_:TdDouble );
       procedure DoSetX( const X_:TdDouble ); virtual; abstract;
       function GetAngle :TdDouble; virtual; abstract;
       procedure DoSetAngle( const Angle_:TdDouble ); virtual; abstract;
       function GetPs( const N_,M_:Integer ) :TdDouble; virtual; abstract;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       procedure SetAngle( const Angle_:TdDouble );
       ///// P R O P E R T Y
       property DegN                      :Integer  read GetDegN write SetDegN;
       property X                         :TdDouble read GetX    write SetX   ;
       property Ps[ const N_,M_:Integer ] :TdDouble read GetPs                ; default;
       property Angle                     :TdDouble read GetAngle write SetAngle;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdCoreALFs

     TdCoreALFs = class( TdALFs )
     private
     protected
       _DegN :Integer;
       _X    :TdDouble;
       _S    :TdDouble;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure DoSetDegN( const DegN_:Integer ); override;
       function GetX :TdDouble; override;
       procedure DoSetX( const X_:TdDouble ); override;
       function GetAngle :TdDouble; override;
       procedure DoSetAngle( const Angle_:TdDouble ); override;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdMapALFs

     TdMapALFs = class( TdCoreALFs )
     private
     protected
       _Ps :TArray2<TdDouble>;
       ///// A C C E S S O R
       procedure DoSetDegN( const DegN_:Integer ); override;
       procedure DoSetX( const X_:TdDouble ); override;
       procedure DoSetAngle( const Angle_:TdDouble ); override;
       function GetPs( const N_,M_:Integer ) :TdDouble; override;
       ///// M E T H O D
       procedure CalcPs; virtual; abstract;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TdALFs.SetDegN( const DegN_:Integer );
begin
     DoSetDegN( DegN_ );

     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

procedure TdALFs.SetX( const X_:TdDouble );
begin
     DoSetX( X_ );

     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

procedure TdALFs.SetAngle( const Angle_:TdDouble );
begin
     DoSetAngle( Angle_ );

     OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdALFs.Create;
begin
     inherited;

     DegN := 0;
     X    := 0;
end;

constructor TdALFs.Create( const DegN_:Integer );
begin
     inherited Create;

     DegN := DegN_;
     X    := 0;
end;

destructor TdALFs.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdCoreALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdCoreALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TdCoreALFs.DoSetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TdCoreALFs.GetX :TdDouble;
begin
     Result := _X;
end;

procedure TdCoreALFs.DoSetX( const X_:TdDouble );
begin
     _X := X_;
     _S := Roo2( 1 - Pow2( X_ ) );
end;

function TdCoreALFs.GetAngle :TdDouble;
begin
     Result := ArcTan2( _S, _X );
end;

procedure TdCoreALFs.DoSetAngle( const Angle_:TdDouble );
begin
     _X := Cos( Angle_ );
     _S := Sin( Angle_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdCoreALFs.Create;
begin
     _S := 1;

     inherited;
end;

constructor TdCoreALFs.Create( const DegN_:Integer );
begin
     _S := 1;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdMapALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TdMapALFs.DoSetDegN( const DegN_:Integer );
var
   N :Integer;
begin
     inherited;

     SetLength( _Ps, DegN+1 );
     for N := 0 to DegN do SetLength( _Ps[ N ], N+1 );

     CalcPs;
end;

//------------------------------------------------------------------------------

procedure TdMapALFs.DoSetX( const X_:TdDouble );
begin
     inherited;

     CalcPs;
end;

procedure TdMapALFs.DoSetAngle( const Angle_:TdDouble );
begin
     inherited;

     CalcPs;
end;

//------------------------------------------------------------------------------

function TdMapALFs.GetPs( const N_,M_:Integer ) :TdDouble;
begin
     Result := _Ps[ N_, M_ ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■