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
       procedure SetDegN( const DegN_:Integer ); virtual;
       function GetX :Double; virtual; abstract;
       procedure SetX( const X_:Double ); virtual;
       function GetPs( const N_,M_:Integer ) :Double; virtual; abstract;
       function GetdPs( const N_,M_:Integer ) :Double; virtual;
     public
       constructor Create; overload;
       constructor Create( const DegN_:Integer ); overload;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property DegN                       :Integer read GetDegN write SetDegN;
       property X                          :Double  read GetX    write SetX   ;
       property Ps[ const N_,M_:Integer ]  :Double  read GetPs                ; default;
       property dPs[ const N_,M_:Integer ] :Double  read GetdPs               ;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapALFs

     TMapALFs = class( TALFs )
     private
     protected
       _DegN :Integer;
       _X    :Double;
       _Ps   :TArray2<Double>;  upALPs:Boolean;
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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TALFs.SetDegN( const DegN_:Integer );
begin
     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

procedure TALFs.SetX( const X_:Double );
begin
     OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

function TALFs.GetdPs( const N_,M_:Integer ) :Double;
begin
     Result := N_ * X * Ps[ N_, M_ ];

     if M_ < N_ then Result := Result - ( N_ + M_ ) * Ps[ N_-1, M_ ];

     Result := Result / ( 1 - Pow2( X ) );
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMapALFs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TMapALFs.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TMapALFs.SetDegN( const DegN_:Integer );
begin
     if _DegN = DegN_ then Exit;

     inherited;

     _DegN := DegN_;  InitALPs;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TMapALFs.GetX :Double;
begin
     Result := _X;
end;

procedure TMapALFs.SetX( const X_:Double );
begin
     if _X = X_ then Exit;

     inherited;

     _X := X_;  upALPs := True;
end;

//------------------------------------------------------------------------------

function TMapALFs.GetPs( const N_,M_:Integer ) :Double;
begin
     if upALPs then
     begin
          upALPs := False;

          CalcALPs;
     end;

     Result := _Ps[ N_, M_ ];
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TMapALFs.InitALPs;
var
   N :Integer;
begin
     SetLength( _Ps, DegN+1 );
     for N := 0 to DegN do SetLength( _Ps[ N ], N+1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■