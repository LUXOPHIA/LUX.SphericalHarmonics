unit LUX.ALFs;

interface //#################################################################### ■

uses LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFs :Associated Legendre functions

     TALFs = class
     private
     protected
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual; abstract;
       procedure SetDegN( const DegN_:Integer );
       procedure DoSetDegN( const DegN_:Integer ); virtual; abstract;
       function GetX :Double; virtual; abstract;
       procedure SetX( const X_:Double );
       procedure DoSetX( const X_:Double ); virtual; abstract;
       function GetAngle :Double; virtual; abstract;
       procedure DoSetAngle( const Angle_:Double ); virtual; abstract;
       function GetPs( const N_,M_:Integer ) :Double; virtual; abstract;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       procedure SetAngle( const Angle_:Double );
       ///// P R O P E R T Y
       property DegN                      :Integer read GetDegN write SetDegN;
       property X                         :Double  read GetX    write SetX   ;
       property Ps[ const N_,M_:Integer ] :Double  read GetPs                ; default;
       property Angle                     :Double   read GetAngle write SetAngle;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCoreALFs

     TCoreALFs = class( TALFs )
     private
     protected
       _DegN :Integer;
       _X    :Double;
       _S    :Double;
       ///// A C C E S S O R
       function GetDegN :Integer; override;
       procedure DoSetDegN( const DegN_:Integer ); override;
       function GetX :Double; override;
       procedure DoSetX( const X_:Double ); override;
       function GetAngle :Double; override;
       procedure DoSetAngle( const Angle_:Double ); override;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapALFs

     TMapALFs = class( TCoreALFs )
     private
     protected
       _Ps :TArray2<Double>;
       ///// A C C E S S O R
       procedure DoSetDegN( const DegN_:Integer ); override;
       procedure DoSetX( const X_:Double ); override;
       procedure DoSetAngle( const Angle_:Double ); override;
       function GetPs( const N_,M_:Integer ) :Double; override;
       ///// M E T H O D
       procedure CalcPs; virtual; abstract;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TALFs.SetDegN( const DegN_:Integer );
begin
     DoSetDegN( DegN_ );

     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

procedure TALFs.SetX( const X_:Double );
begin
     DoSetX( X_ );

     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

procedure TALFs.SetAngle( const Angle_:Double );
begin
     DoSetAngle( Angle_ );

     OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TALFs.Create;
begin
     inherited;

     DegN := 0;
     X    := 0;
end;

constructor TALFs.Create( const DegN_:Integer );
begin
     inherited Create;

     DegN := DegN_;
     X    := 0;
end;

destructor TALFs.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCoreALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCoreALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCoreALFs.DoSetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;
end;

//------------------------------------------------------------------------------

function TCoreALFs.GetX :Double;
begin
     Result := _X;
end;

procedure TCoreALFs.DoSetX( const X_:Double );
begin
     _X := X_;
     _S := Roo2( 1 - Pow2( X_ ) );
end;

function TCoreALFs.GetAngle :Double;
begin
     Result := ArcTan2( _S, _X );
end;

procedure TCoreALFs.DoSetAngle( const Angle_:Double );
begin
     _X := Cos( Angle_ );
     _S := Sin( Angle_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCoreALFs.Create;
begin
     _S := 1;

     inherited;
end;

constructor TCoreALFs.Create( const DegN_:Integer );
begin
     _S := 1;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TMapALFs.DoSetDegN( const DegN_:Integer );
var
   N :Integer;
begin
     inherited;

     SetLength( _Ps, DegN+1 );
     for N := 0 to DegN do SetLength( _Ps[ N ], N+1 );

     CalcPs;
end;

//------------------------------------------------------------------------------

procedure TMapALFs.DoSetX( const X_:Double );
begin
     inherited;

     CalcPs;
end;

procedure TMapALFs.DoSetAngle( const Angle_:Double );
begin
     inherited;

     CalcPs;
end;

//------------------------------------------------------------------------------

function TMapALFs.GetPs( const N_,M_:Integer ) :Double;
begin
     Result := _Ps[ N_, M_ ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■