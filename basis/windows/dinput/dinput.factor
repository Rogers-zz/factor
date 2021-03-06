USING: windows.kernel32 windows.ole32 windows.com windows.com.syntax
alien alien.c-types alien.syntax kernel system namespaces math ;
IN: windows.dinput

<<
    os windows?
    [ "dinput" "dinput8.dll" "stdcall" add-library ]
    when
>>

LIBRARY: dinput

TYPEDEF: void* LPDIENUMDEVICESCALLBACKW
: LPDIENUMDEVICESCALLBACKW ( quot -- alien )
    [ "BOOL" { "LPCDIDEVICEINSTANCEW" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDIENUMDEVICESBYSEMANTICSCBW
: LPDIENUMDEVICESBYSEMANTICSCBW ( quot -- alien )
    [ "BOOL" { "LPCDIDEVICEINSTANCEW" "IDirectInputDevice8W*" "DWORD" "DWORD" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDICONFIGUREDEVICESCALLBACK
: LPDICONFIGUREDEVICESCALLBACK ( quot -- alien )
    [ "BOOL" { "IUnknown*" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDIENUMEFFECTSCALLBACKW
: LPDIENUMEFFECTSCALLBACKW ( quot -- alien )
    [ "BOOL" { "LPCDIEFFECTINFOW" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDIENUMCREATEDEFFECTOBJECTSCALLBACK
: LPDIENUMCREATEDEFFECTOBJECTSCALLBACK
    [ "BOOL" { "LPDIRECTINPUTEFFECT" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDIENUMEFFECTSINFILECALLBACK
: LPDIENUMEFFECTSINFILECALLBACK
    [ "BOOL" { "LPCDIFILEEFFECT" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline
TYPEDEF: void* LPDIENUMDEVICEOBJECTSCALLBACKW
: LPDIENUMDEVICEOBJECTSCALLBACKW
    [ "BOOL" { "LPCDIDEVICEOBJECTINSTANCEW" "LPVOID" } "stdcall" ]
    dip alien-callback ; inline

TYPEDEF: DWORD D3DCOLOR

C-STRUCT: DIDEVICEINSTANCEW
    { "DWORD"      "dwSize" }
    { "GUID"       "guidInstance" }
    { "GUID"       "guidProduct" }
    { "DWORD"      "dwDevType" }
    { "WCHAR[260]" "tszInstanceName" }
    { "WCHAR[260]" "tszProductName" }
    { "GUID"       "guidFFDriver" }
    { "WORD"       "wUsagePage" }
    { "WORD"       "wUsage" } ;
TYPEDEF: DIDEVICEINSTANCEW* LPDIDEVICEINSTANCEW
TYPEDEF: DIDEVICEINSTANCEW* LPCDIDEVICEINSTANCEW
C-UNION: DIACTION-union "LPCWSTR" "UINT" ;
C-STRUCT: DIACTIONW
    { "UINT_PTR"       "uAppData" }
    { "DWORD"          "dwSemantic" }
    { "DWORD"          "dwFlags" }
    { "DIACTION-union" "lptszActionName-or-uResIdString" }
    { "GUID"           "guidInstance" }
    { "DWORD"          "dwObjID" }
    { "DWORD"          "dwHow" } ;
TYPEDEF: DIACTIONW* LPDIACTIONW
TYPEDEF: DIACTIONW* LPCDIACTIONW
C-STRUCT: DIACTIONFORMATW
    { "DWORD"       "dwSize" }
    { "DWORD"       "dwActionSize" }
    { "DWORD"       "dwDataSize" }
    { "DWORD"       "dwNumActions" }
    { "LPDIACTIONW" "rgoAction" }
    { "GUID"        "guidActionMap" }
    { "DWORD"       "dwGenre" }
    { "DWORD"       "dwBufferSize" }
    { "LONG"        "lAxisMin" }
    { "LONG"        "lAxisMax" }
    { "HINSTANCE"   "hInstString" }
    { "FILETIME"    "ftTimeStamp" }
    { "DWORD"       "dwCRC" }
    { "WCHAR[260]"  "tszActionMap" } ;
TYPEDEF: DIACTIONFORMATW* LPDIACTIONFORMATW
TYPEDEF: DIACTIONFORMATW* LPCDIACTIONFORMATW
C-STRUCT: DICOLORSET
    { "DWORD"    "dwSize" }
    { "D3DCOLOR" "cTextFore" }
    { "D3DCOLOR" "cTextHighlight" }
    { "D3DCOLOR" "cCalloutLine" }
    { "D3DCOLOR" "cCalloutHighlight" }
    { "D3DCOLOR" "cBorder" }
    { "D3DCOLOR" "cControlFill" }
    { "D3DCOLOR" "cHighlightFill" }
    { "D3DCOLOR" "cAreaFill" } ;
TYPEDEF: DICOLORSET* LPDICOLORSET
TYPEDEF: DICOLORSET* LPCDICOLORSET

C-STRUCT: DICONFIGUREDEVICESPARAMSW
    { "DWORD"             "dwSize" }
    { "DWORD"             "dwcUsers" }
    { "LPWSTR"            "lptszUserNames" }
    { "DWORD"             "dwcFormats" }
    { "LPDIACTIONFORMATW" "lprgFormats" }
    { "HWND"              "hwnd" }
    { "DICOLORSET"        "dics" }
    { "IUnknown*"         "lpUnkDDSTarget" } ;
TYPEDEF: DICONFIGUREDEVICESPARAMSW* LPDICONFIGUREDEVICESPARAMSW
TYPEDEF: DICONFIGUREDEVICESPARAMSW* LPDICONFIGUREDEVICESPARAMSW

C-STRUCT: DIDEVCAPS
    { "DWORD" "dwSize" }
    { "DWORD" "dwFlags" }
    { "DWORD" "dwDevType" }
    { "DWORD" "dwAxes" }
    { "DWORD" "dwButtons" }
    { "DWORD" "dwPOVs" }
    { "DWORD" "dwFFSamplePeriod" }
    { "DWORD" "dwFFMinTimeResolution" }
    { "DWORD" "dwFirmwareRevision" }
    { "DWORD" "dwHardwareRevision" }
    { "DWORD" "dwFFDriverVersion" } ;
TYPEDEF: DIDEVCAPS* LPDIDEVCAPS
TYPEDEF: DIDEVCAPS* LPCDIDEVCAPS
C-STRUCT: DIDEVICEOBJECTINSTANCEW
    { "DWORD" "dwSize" }
    { "GUID" "guidType" }
    { "DWORD" "dwOfs" }
    { "DWORD" "dwType" }
    { "DWORD" "dwFlags" }
    { "WCHAR[260]" "tszName" }
    { "DWORD" "dwFFMaxForce" }
    { "DWORD" "dwFFForceResolution" }
    { "WORD" "wCollectionNumber" }
    { "WORD" "wDesignatorIndex" }
    { "WORD" "wUsagePage" }
    { "WORD" "wUsage" }
    { "DWORD" "dwDimension" }
    { "WORD" "wExponent" }
    { "WORD" "wReportId" } ;
TYPEDEF: DIDEVICEOBJECTINSTANCEW* LPDIDEVICEOBJECTINSTANCEW
TYPEDEF: DIDEVICEOBJECTINSTANCEW* LPCDIDEVICEOBJECTINSTANCEW
C-STRUCT: DIDEVICEOBJECTDATA
    { "DWORD"    "dwOfs" }
    { "DWORD"    "dwData" }
    { "DWORD"    "dwTimeStamp" }
    { "DWORD"    "dwSequence" }
    { "UINT_PTR" "uAppData" } ;
TYPEDEF: DIDEVICEOBJECTDATA* LPDIDEVICEOBJECTDATA
TYPEDEF: DIDEVICEOBJECTDATA* LPCDIDEVICEOBJECTDATA
C-STRUCT: DIOBJECTDATAFORMAT
    { "GUID*" "pguid" }
    { "DWORD" "dwOfs" }
    { "DWORD" "dwType" }
    { "DWORD" "dwFlags" } ;
TYPEDEF: DIOBJECTDATAFORMAT* LPDIOBJECTDATAFORMAT
TYPEDEF: DIOBJECTDATAFORMAT* LPCDIOBJECTDATAFORMAT
C-STRUCT: DIDATAFORMAT
    { "DWORD" "dwSize" }
    { "DWORD" "dwObjSize" }
    { "DWORD" "dwFlags" }
    { "DWORD" "dwDataSize" }
    { "DWORD" "dwNumObjs" }
    { "LPDIOBJECTDATAFORMAT" "rgodf" } ;
TYPEDEF: DIDATAFORMAT* LPDIDATAFORMAT
TYPEDEF: DIDATAFORMAT* LPCDIDATAFORMAT
C-STRUCT: DIPROPHEADER
    { "DWORD" "dwSize" }
    { "DWORD" "dwHeaderSize" }
    { "DWORD" "dwObj" }
    { "DWORD" "dwHow" } ;
TYPEDEF: DIPROPHEADER* LPDIPROPHEADER
TYPEDEF: DIPROPHEADER* LPCDIPROPHEADER
C-STRUCT: DIPROPDWORD
    { "DIPROPHEADER" "diph" }
    { "DWORD"        "dwData" } ;
TYPEDEF: DIPROPDWORD* LPDIPROPDWORD
TYPEDEF: DIPROPDWORD* LPCDIPROPDWORD
C-STRUCT: DIPROPPOINTER
    { "DIPROPHEADER" "diph" }
    { "UINT_PTR" "uData" } ;
TYPEDEF: DIPROPPOINTER* LPDIPROPPOINTER
TYPEDEF: DIPROPPOINTER* LPCDIPROPPOINTER
C-STRUCT: DIPROPRANGE
    { "DIPROPHEADER" "diph" }
    { "LONG" "lMin" }
    { "LONG" "lMax" } ;
TYPEDEF: DIPROPRANGE* LPDIPROPRANGE
TYPEDEF: DIPROPRANGE* LPCDIPROPRANGE
C-STRUCT: DIPROPCAL
    { "DIPROPHEADER" "diph" }
    { "LONG" "lMin" }
    { "LONG" "lCenter" }
    { "LONG" "lMax" } ;
TYPEDEF: DIPROPCAL* LPDIPROPCAL
TYPEDEF: DIPROPCAL* LPCDIPROPCAL
C-STRUCT: DIPROPGUIDANDPATH
    { "DIPROPHEADER" "diph" }
    { "GUID" "guidClass" }
    { "WCHAR[260]"   "wszPath" } ;
TYPEDEF: DIPROPGUIDANDPATH* LPDIPROPGUIDANDPATH
TYPEDEF: DIPROPGUIDANDPATH* LPCDIPROPGUIDANDPATH
C-STRUCT: DIPROPSTRING
    { "DIPROPHEADER" "diph" }
    { "WCHAR[260]"   "wsz" } ;
TYPEDEF: DIPROPSTRING* LPDIPROPSTRING
TYPEDEF: DIPROPSTRING* LPCDIPROPSTRING
C-STRUCT: CPOINT
    { "LONG" "lP" }
    { "DWORD" "dwLog" } ;
C-STRUCT: DIPROPCPOINTS
    { "DIPROPHEADER" "diph" }
    { "DWORD" "dwCPointsNum" }
    { "CPOINT[8]" "cp" } ;
TYPEDEF: DIPROPCPOINTS* LPDIPROPCPOINTS
TYPEDEF: DIPROPCPOINTS* LPCDIPROPCPOINTS
C-STRUCT: DIENVELOPE
    { "DWORD" "dwSize" }
    { "DWORD" "dwAttackLevel" }
    { "DWORD" "dwAttackTime" }
    { "DWORD" "dwFadeLevel" }
    { "DWORD" "dwFadeTime" } ;
TYPEDEF: DIENVELOPE* LPDIENVELOPE
TYPEDEF: DIENVELOPE* LPCDIENVELOPE
C-STRUCT: DIEFFECT
    { "DWORD" "dwSize" }
    { "DWORD" "dwFlags" }
    { "DWORD" "dwDuration" }
    { "DWORD" "dwSamplePeriod" }
    { "DWORD" "dwGain" }
    { "DWORD" "dwTriggerButton" }
    { "DWORD" "dwTriggerRepeatInterval" }
    { "DWORD" "cAxes" }
    { "LPDWORD" "rgdwAxes" }
    { "LPLONG" "rglDirection" }
    { "LPDIENVELOPE" "lpEnvelope" }
    { "DWORD" "cbTypeSpecificParams" }
    { "LPVOID" "lpvTypeSpecificParams" }
    { "DWORD" "dwStartDelay" } ;
TYPEDEF: DIEFFECT* LPDIEFFECT
TYPEDEF: DIEFFECT* LPCDIEFFECT
C-STRUCT: DIEFFECTINFOW
    { "DWORD"      "dwSize" }
    { "GUID"       "guid" }
    { "DWORD"      "dwEffType" }
    { "DWORD"      "dwStaticParams" }
    { "DWORD"      "dwDynamicParams" }
    { "WCHAR[260]" "tszName" } ;
TYPEDEF: DIEFFECTINFOW* LPDIEFFECTINFOW
TYPEDEF: DIEFFECTINFOW* LPCDIEFFECTINFOW
C-STRUCT: DIEFFESCAPE
    { "DWORD"  "dwSize" }
    { "DWORD"  "dwCommand" }
    { "LPVOID" "lpvInBuffer" }
    { "DWORD"  "cbInBuffer" }
    { "LPVOID" "lpvOutBuffer" }
    { "DWORD"  "cbOutBuffer" } ;
TYPEDEF: DIEFFESCAPE* LPDIEFFESCAPE
TYPEDEF: DIEFFESCAPE* LPCDIEFFESCAPE
C-STRUCT: DIFILEEFFECT
    { "DWORD"       "dwSize" }
    { "GUID"        "GuidEffect" }
    { "LPCDIEFFECT" "lpDiEffect" }
    { "CHAR[260]"   "szFriendlyName" } ;
TYPEDEF: DIFILEEFFECT* LPDIFILEEFFECT
TYPEDEF: DIFILEEFFECT* LPCDIFILEEFFECT
C-STRUCT: DIDEVICEIMAGEINFOW
    { "WCHAR[260]" "tszImagePath" }
    { "DWORD"      "dwFlags" }
    { "DWORD"      "dwViewID" }
    { "RECT"       "rcOverlay" }
    { "DWORD"      "dwObjID" }
    { "DWORD"      "dwcValidPts" }
    { "POINT[5]"   "rgptCalloutLine" }
    { "RECT"       "rcCalloutRect" }
    { "DWORD"      "dwTextAlign" } ;
TYPEDEF: DIDEVICEIMAGEINFOW* LPDIDEVICEIMAGEINFOW
TYPEDEF: DIDEVICEIMAGEINFOW* LPCDIDEVICEIMAGEINFOW
C-STRUCT: DIDEVICEIMAGEINFOHEADERW
    { "DWORD" "dwSize" }
    { "DWORD" "dwSizeImageInfo" }
    { "DWORD" "dwcViews" }
    { "DWORD" "dwcButtons" }
    { "DWORD" "dwcAxes" }
    { "DWORD" "dwcPOVs" }
    { "DWORD" "dwBufferSize" }
    { "DWORD" "dwBufferUsed" }
    { "DIDEVICEIMAGEINFOW*" "lprgImageInfoArray" } ;
TYPEDEF: DIDEVICEIMAGEINFOHEADERW* LPDIDEVICEIMAGEINFOHEADERW
TYPEDEF: DIDEVICEIMAGEINFOHEADERW* LPCDIDEVICEIMAGEINFOHEADERW

C-STRUCT: DIMOUSESTATE2
    { "LONG"    "lX" }
    { "LONG"    "lY" }
    { "LONG"    "lZ" }
    { "BYTE[8]" "rgbButtons" } ;
TYPEDEF: DIMOUSESTATE2* LPDIMOUSESTATE2
TYPEDEF: DIMOUSESTATE2* LPCDIMOUSESTATE2

C-STRUCT: DIJOYSTATE2
    { "LONG"      "lX" }
    { "LONG"      "lY" }
    { "LONG"      "lZ" }
    { "LONG"      "lRx" }
    { "LONG"      "lRy" }
    { "LONG"      "lRz" }
    { "LONG[2]"   "rglSlider" }
    { "DWORD[4]"  "rgdwPOV" }
    { "BYTE[128]" "rgbButtons" }
    { "LONG"      "lVX" }
    { "LONG"      "lVY" }
    { "LONG"      "lVZ" }
    { "LONG"      "lVRx" }
    { "LONG"      "lVRy" }
    { "LONG"      "lVRz" }
    { "LONG[2]"   "rglVSlider" }
    { "LONG"      "lAX" }
    { "LONG"      "lAY" }
    { "LONG"      "lAZ" }
    { "LONG"      "lARx" }
    { "LONG"      "lARy" }
    { "LONG"      "lARz" }
    { "LONG[2]"   "rglASlider" }
    { "LONG"      "lFX" }
    { "LONG"      "lFY" }
    { "LONG"      "lFZ" }
    { "LONG"      "lFRx" }
    { "LONG"      "lFRy" }
    { "LONG"      "lFRz" }
    { "LONG[2]"   "rglFSlider" } ;
TYPEDEF: DIJOYSTATE2* LPDIJOYSTATE2
TYPEDEF: DIJOYSTATE2* LPCDIJOYSTATE2

COM-INTERFACE: IDirectInputEffect IUnknown {E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}
    HRESULT Initialize ( HINSTANCE hinst, DWORD dwVersion, REFGUID rguid )
    HRESULT GetEffectGuid ( LPGUID pguid )
    HRESULT GetParameters ( LPDIEFFECT peff, DWORD dwFlags )
    HRESULT SetParameters ( LPCDIEFFECT peff, DWORD dwFlags )
    HRESULT Start ( DWORD dwIterations, DWORD dwFlags )
    HRESULT Stop ( )
    HRESULT GetEffectStatus ( LPDWORD pdwFlags )
    HRESULT Download ( )
    HRESULT Unload ( )
    HRESULT Escape ( LPDIEFFESCAPE pesc ) ;

COM-INTERFACE: IDirectInputDevice8W IUnknown {54D41081-DC15-4833-A41B-748F73A38179}
    HRESULT GetCapabilities ( LPDIDEVCAPS lpDIDeviceCaps )
    HRESULT EnumObjects ( LPDIENUMDEVICEOBJECTSCALLBACKW lpCallback, LPVOID pvRef, DWORD dwFlags )
    HRESULT GetProperty ( REFGUID rguidProp, LPDIPROPHEADER pdiph )
    HRESULT SetProperty ( REFGUID rguidProp, LPCDIPROPHEADER pdiph )
    HRESULT Acquire ( )
    HRESULT Unacquire ( )
    HRESULT GetDeviceState ( DWORD cbData, LPVOID lpvData )
    HRESULT GetDeviceData ( DWORD cbObjectData, LPDIDEVICEOBJECTDATA rgdod, LPDWORD pdwInOut, DWORD dwFlags )
    HRESULT SetDataFormat ( LPCDIDATAFORMAT lpdf )
    HRESULT SetEventNotification ( HANDLE hEvent )
    HRESULT SetCooperativeLevel ( HWND hwnd, DWORD dwFlags )
    HRESULT GetObjectInfo ( LPDIDEVICEOBJECTINSTANCEW rdidoi, DWORD dwObj, DWORD dwHow )
    HRESULT GetDeviceInfo ( LPDIDEVICEINSTANCEW pdidi )
    HRESULT RunControlPanel ( HWND hwndOwner, DWORD dwFlags )
    HRESULT Initialize ( HINSTANCE hinst, DWORD dwVersion, REFGUID rguid )
    HRESULT CreateEffect ( REFGUID rguid, LPCDIEFFECT lpeff, IDirectInputEffect** ppdeff, LPUNKNOWN punkOuter )
    HRESULT EnumEffects ( LPDIENUMEFFECTSCALLBACKW lpCallback, LPVOID pvRef, DWORD dwEffType )
    HRESULT GetEffectInfo ( LPDIEFFECTINFOW pdei, REFGUID rguid )
    HRESULT GetForceFeedbackState ( LPDWORD pdwOut )
    HRESULT SendForceFeedbackCommand ( DWORD dwFlags )
    HRESULT EnumCreatedEffectObjects ( LPDIENUMCREATEDEFFECTOBJECTSCALLBACK lpCallback, LPVOID pvRef, DWORD fl )
    HRESULT Escape ( LPDIEFFESCAPE pesc )
    HRESULT Poll ( )
    HRESULT SendDeviceData ( DWORD cbObjectData, LPCDIDEVICEOBJECTDATA rgdod, LPDWORD pdwInOut, DWORD fl )
    HRESULT EnumEffectsInFile ( LPCWSTR lpszFileName, LPDIENUMEFFECTSINFILECALLBACK lpCallback, LPVOID pvRef, DWORD dwFlags )
    HRESULT WriteEffectToFile ( LPCWSTR lpszFileName, DWORD dwEntries, LPDIFILEEFFECT rgDiFileEffect, DWORD dwFlags )
    HRESULT BuildActionMap ( LPDIACTIONFORMATW lpdiaf, LPCWSTR lpszUserName, DWORD dwFlags )
    HRESULT SetActionMap ( LPDIACTIONFORMATW lpdiActionFormat, LPCWSTR lpwszUserName, DWORD dwFlags )
    HRESULT GetImageInfo ( LPDIDEVICEIMAGEINFOHEADERW lpdiDeviceImageInfoHeader ) ;

COM-INTERFACE: IDirectInput8W IUnknown {BF798031-483A-4DA2-AA99-5D64ED369700}
    HRESULT CreateDevice ( REFGUID rguid, IDirectInputDevice8W** lplpDevice, LPUNKNOWN pUnkOuter )
    HRESULT EnumDevices ( DWORD dwDevType, LPDIENUMDEVICESCALLBACKW lpCallback, LPVOID pvRef, DWORD dwFlags )
    HRESULT GetDeviceStatus ( REFGUID rguidInstance )
    HRESULT RunControlPanel ( HWND hwndOwner, DWORD dwFlags )
    HRESULT Initialize ( HINSTANCE hinst, DWORD dwVersion )
    HRESULT FindDevice ( REFGUID rguidClass, LPCWSTR pwszName, LPGUID pguidInstance )
    HRESULT EnumDevicesBySemantics ( LPCWSTR pwszUserName, LPDIACTIONFORMATW lpdiActionFormat, LPDIENUMDEVICESBYSEMANTICSCBW lpCallback, LPVOID pvRef, DWORD dwFlags )
    HRESULT ConfigureDevices ( LPDICONFIGUREDEVICESCALLBACK lpdiCallback, LPDICONFIGUREDEVICESPARAMSW lpdiCDParams, DWORD dwFlags, LPVOID pvRefData ) ;

FUNCTION: HRESULT DirectInput8Create ( HINSTANCE hinst, DWORD dwVersion, REFIID riidtlf, LPVOID* ppvOut, LPUNKNOWN punkOuter ) ;

: DIRECTINPUT_VERSION HEX: 0800 ; inline

: DI8DEVCLASS_ALL             0 ; inline
: DI8DEVCLASS_DEVICE          1 ; inline
: DI8DEVCLASS_POINTER         2 ; inline
: DI8DEVCLASS_KEYBOARD        3 ; inline
: DI8DEVCLASS_GAMECTRL        4 ; inline

: DIEDFL_ALLDEVICES       HEX: 00000000 ; inline
: DIEDFL_ATTACHEDONLY     HEX: 00000001 ; inline
: DIEDFL_FORCEFEEDBACK    HEX: 00000100 ; inline
: DIEDFL_INCLUDEALIASES   HEX: 00010000 ; inline
: DIEDFL_INCLUDEPHANTOMS  HEX: 00020000 ; inline
: DIEDFL_INCLUDEHIDDEN    HEX: 00040000 ; inline

: DIENUM_STOP             0 ; inline
: DIENUM_CONTINUE         1 ; inline

: DIDF_ABSAXIS            1 ;
: DIDF_RELAXIS            2 ;

: DIDFT_ALL           HEX: 00000000 ; inline

: DIDFT_RELAXIS       HEX: 00000001 ; inline
: DIDFT_ABSAXIS       HEX: 00000002 ; inline
: DIDFT_AXIS          HEX: 00000003 ; inline

: DIDFT_PSHBUTTON     HEX: 00000004 ; inline
: DIDFT_TGLBUTTON     HEX: 00000008 ; inline
: DIDFT_BUTTON        HEX: 0000000C ; inline

: DIDFT_POV           HEX: 00000010 ; inline
: DIDFT_COLLECTION    HEX: 00000040 ; inline
: DIDFT_NODATA        HEX: 00000080 ; inline

: DIDFT_ANYINSTANCE   HEX: 00FFFF00 ; inline
: DIDFT_INSTANCEMASK  DIDFT_ANYINSTANCE ; inline
: DIDFT_MAKEINSTANCE ( n -- instance ) 8 shift                   ; inline
: DIDFT_GETTYPE      ( n -- type     ) HEX: FF bitand            ; inline
: DIDFT_GETINSTANCE  ( n -- instance ) -8 shift HEX: FFFF bitand ; inline
: DIDFT_FFACTUATOR        HEX: 01000000 ; inline
: DIDFT_FFEFFECTTRIGGER   HEX: 02000000 ; inline
: DIDFT_OUTPUT            HEX: 10000000 ; inline
: DIDFT_VENDORDEFINED     HEX: 04000000 ; inline
: DIDFT_ALIAS             HEX: 08000000 ; inline
: DIDFT_OPTIONAL          HEX: 80000000 ; inline

: DIDFT_ENUMCOLLECTION ( n -- instance ) 8 shift HEX: FFFF bitand ; inline
: DIDFT_NOCOLLECTION      HEX: 00FFFF00 ; inline

: DIDOI_FFACTUATOR        HEX: 00000001 ; inline
: DIDOI_FFEFFECTTRIGGER   HEX: 00000002 ; inline
: DIDOI_POLLED            HEX: 00008000 ; inline
: DIDOI_ASPECTPOSITION    HEX: 00000100 ; inline
: DIDOI_ASPECTVELOCITY    HEX: 00000200 ; inline
: DIDOI_ASPECTACCEL       HEX: 00000300 ; inline
: DIDOI_ASPECTFORCE       HEX: 00000400 ; inline
: DIDOI_ASPECTMASK        HEX: 00000F00 ; inline
: DIDOI_GUIDISUSAGE       HEX: 00010000 ; inline

: DISCL_EXCLUSIVE     HEX: 00000001 ; inline
: DISCL_NONEXCLUSIVE  HEX: 00000002 ; inline
: DISCL_FOREGROUND    HEX: 00000004 ; inline
: DISCL_BACKGROUND    HEX: 00000008 ; inline
: DISCL_NOWINKEY      HEX: 00000010 ; inline

: DIK_ESCAPE          HEX: 01 ; inline
: DIK_1               HEX: 02 ; inline
: DIK_2               HEX: 03 ; inline
: DIK_3               HEX: 04 ; inline
: DIK_4               HEX: 05 ; inline
: DIK_5               HEX: 06 ; inline
: DIK_6               HEX: 07 ; inline
: DIK_7               HEX: 08 ; inline
: DIK_8               HEX: 09 ; inline
: DIK_9               HEX: 0A ; inline
: DIK_0               HEX: 0B ; inline
: DIK_MINUS           HEX: 0C ; inline
: DIK_EQUALS          HEX: 0D ; inline
: DIK_BACK            HEX: 0E ; inline
: DIK_TAB             HEX: 0F ; inline
: DIK_Q               HEX: 10 ; inline
: DIK_W               HEX: 11 ; inline
: DIK_E               HEX: 12 ; inline
: DIK_R               HEX: 13 ; inline
: DIK_T               HEX: 14 ; inline
: DIK_Y               HEX: 15 ; inline
: DIK_U               HEX: 16 ; inline
: DIK_I               HEX: 17 ; inline
: DIK_O               HEX: 18 ; inline
: DIK_P               HEX: 19 ; inline
: DIK_LBRACKET        HEX: 1A ; inline
: DIK_RBRACKET        HEX: 1B ; inline
: DIK_RETURN          HEX: 1C ; inline
: DIK_LCONTROL        HEX: 1D ; inline
: DIK_A               HEX: 1E ; inline
: DIK_S               HEX: 1F ; inline
: DIK_D               HEX: 20 ; inline
: DIK_F               HEX: 21 ; inline
: DIK_G               HEX: 22 ; inline
: DIK_H               HEX: 23 ; inline
: DIK_J               HEX: 24 ; inline
: DIK_K               HEX: 25 ; inline
: DIK_L               HEX: 26 ; inline
: DIK_SEMICOLON       HEX: 27 ; inline
: DIK_APOSTROPHE      HEX: 28 ; inline
: DIK_GRAVE           HEX: 29 ; inline
: DIK_LSHIFT          HEX: 2A ; inline
: DIK_BACKSLASH       HEX: 2B ; inline
: DIK_Z               HEX: 2C ; inline
: DIK_X               HEX: 2D ; inline
: DIK_C               HEX: 2E ; inline
: DIK_V               HEX: 2F ; inline
: DIK_B               HEX: 30 ; inline
: DIK_N               HEX: 31 ; inline
: DIK_M               HEX: 32 ; inline
: DIK_COMMA           HEX: 33 ; inline
: DIK_PERIOD          HEX: 34 ; inline
: DIK_SLASH           HEX: 35 ; inline
: DIK_RSHIFT          HEX: 36 ; inline
: DIK_MULTIPLY        HEX: 37 ; inline
: DIK_LMENU           HEX: 38 ; inline
: DIK_SPACE           HEX: 39 ; inline
: DIK_CAPITAL         HEX: 3A ; inline
: DIK_F1              HEX: 3B ; inline
: DIK_F2              HEX: 3C ; inline
: DIK_F3              HEX: 3D ; inline
: DIK_F4              HEX: 3E ; inline
: DIK_F5              HEX: 3F ; inline
: DIK_F6              HEX: 40 ; inline
: DIK_F7              HEX: 41 ; inline
: DIK_F8              HEX: 42 ; inline
: DIK_F9              HEX: 43 ; inline
: DIK_F10             HEX: 44 ; inline
: DIK_NUMLOCK         HEX: 45 ; inline
: DIK_SCROLL          HEX: 46 ; inline
: DIK_NUMPAD7         HEX: 47 ; inline
: DIK_NUMPAD8         HEX: 48 ; inline
: DIK_NUMPAD9         HEX: 49 ; inline
: DIK_SUBTRACT        HEX: 4A ; inline
: DIK_NUMPAD4         HEX: 4B ; inline
: DIK_NUMPAD5         HEX: 4C ; inline
: DIK_NUMPAD6         HEX: 4D ; inline
: DIK_ADD             HEX: 4E ; inline
: DIK_NUMPAD1         HEX: 4F ; inline
: DIK_NUMPAD2         HEX: 50 ; inline
: DIK_NUMPAD3         HEX: 51 ; inline
: DIK_NUMPAD0         HEX: 52 ; inline
: DIK_DECIMAL         HEX: 53 ; inline
: DIK_OEM_102         HEX: 56 ; inline
: DIK_F11             HEX: 57 ; inline
: DIK_F12             HEX: 58 ; inline
: DIK_F13             HEX: 64 ; inline
: DIK_F14             HEX: 65 ; inline
: DIK_F15             HEX: 66 ; inline
: DIK_KANA            HEX: 70 ; inline
: DIK_ABNT_C1         HEX: 73 ; inline
: DIK_CONVERT         HEX: 79 ; inline
: DIK_NOCONVERT       HEX: 7B ; inline
: DIK_YEN             HEX: 7D ; inline
: DIK_ABNT_C2         HEX: 7E ; inline
: DIK_NUMPADEQUALS    HEX: 8D ; inline
: DIK_PREVTRACK       HEX: 90 ; inline
: DIK_AT              HEX: 91 ; inline
: DIK_COLON           HEX: 92 ; inline
: DIK_UNDERLINE       HEX: 93 ; inline
: DIK_KANJI           HEX: 94 ; inline
: DIK_STOP            HEX: 95 ; inline
: DIK_AX              HEX: 96 ; inline
: DIK_UNLABELED       HEX: 97 ; inline
: DIK_NEXTTRACK       HEX: 99 ; inline
: DIK_NUMPADENTER     HEX: 9C ; inline
: DIK_RCONTROL        HEX: 9D ; inline
: DIK_MUTE            HEX: A0 ; inline
: DIK_CALCULATOR      HEX: A1 ; inline
: DIK_PLAYPAUSE       HEX: A2 ; inline
: DIK_MEDIASTOP       HEX: A4 ; inline
: DIK_VOLUMEDOWN      HEX: AE ; inline
: DIK_VOLUMEUP        HEX: B0 ; inline
: DIK_WEBHOME         HEX: B2 ; inline
: DIK_NUMPADCOMMA     HEX: B3 ; inline
: DIK_DIVIDE          HEX: B5 ; inline
: DIK_SYSRQ           HEX: B7 ; inline
: DIK_RMENU           HEX: B8 ; inline
: DIK_PAUSE           HEX: C5 ; inline
: DIK_HOME            HEX: C7 ; inline
: DIK_UP              HEX: C8 ; inline
: DIK_PRIOR           HEX: C9 ; inline
: DIK_LEFT            HEX: CB ; inline
: DIK_RIGHT           HEX: CD ; inline
: DIK_END             HEX: CF ; inline
: DIK_DOWN            HEX: D0 ; inline
: DIK_NEXT            HEX: D1 ; inline
: DIK_INSERT          HEX: D2 ; inline
: DIK_DELETE          HEX: D3 ; inline
: DIK_LWIN            HEX: DB ; inline
: DIK_RWIN            HEX: DC ; inline
: DIK_APPS            HEX: DD ; inline
: DIK_POWER           HEX: DE ; inline
: DIK_SLEEP           HEX: DF ; inline
: DIK_WAKE            HEX: E3 ; inline
: DIK_WEBSEARCH       HEX: E5 ; inline
: DIK_WEBFAVORITES    HEX: E6 ; inline
: DIK_WEBREFRESH      HEX: E7 ; inline
: DIK_WEBSTOP         HEX: E8 ; inline
: DIK_WEBFORWARD      HEX: E9 ; inline
: DIK_WEBBACK         HEX: EA ; inline
: DIK_MYCOMPUTER      HEX: EB ; inline
: DIK_MAIL            HEX: EC ; inline
: DIK_MEDIASELECT     HEX: ED ; inline

: DIK_BACKSPACE       DIK_BACK ; inline
: DIK_NUMPADSTAR      DIK_MULTIPLY ; inline
: DIK_LALT            DIK_LMENU ; inline
: DIK_CAPSLOCK        DIK_CAPITAL ; inline
: DIK_NUMPADMINUS     DIK_SUBTRACT ; inline
: DIK_NUMPADPLUS      DIK_ADD ; inline
: DIK_NUMPADPERIOD    DIK_DECIMAL ; inline
: DIK_NUMPADSLASH     DIK_DIVIDE ; inline
: DIK_RALT            DIK_RMENU ; inline
: DIK_UPARROW         DIK_UP ; inline
: DIK_PGUP            DIK_PRIOR ; inline
: DIK_LEFTARROW       DIK_LEFT ; inline
: DIK_RIGHTARROW      DIK_RIGHT ; inline
: DIK_DOWNARROW       DIK_DOWN ; inline
: DIK_PGDN            DIK_NEXT ; inline

: DIK_CIRCUMFLEX      DIK_PREVTRACK ; inline

: DI8DEVTYPE_DEVICE           HEX: 11 ; inline
: DI8DEVTYPE_MOUSE            HEX: 12 ; inline
: DI8DEVTYPE_KEYBOARD         HEX: 13 ; inline
: DI8DEVTYPE_JOYSTICK         HEX: 14 ; inline
: DI8DEVTYPE_GAMEPAD          HEX: 15 ; inline
: DI8DEVTYPE_DRIVING          HEX: 16 ; inline
: DI8DEVTYPE_FLIGHT           HEX: 17 ; inline
: DI8DEVTYPE_1STPERSON        HEX: 18 ; inline
: DI8DEVTYPE_DEVICECTRL       HEX: 19 ; inline
: DI8DEVTYPE_SCREENPOINTER    HEX: 1A ; inline
: DI8DEVTYPE_REMOTE           HEX: 1B ; inline
: DI8DEVTYPE_SUPPLEMENTAL     HEX: 1C ; inline

: GET_DIDEVICE_TYPE ( dwType -- type ) HEX: FF bitand ; inline

: DIPROPRANGE_NOMIN       HEX: 80000000 ; inline
: DIPROPRANGE_NOMAX       HEX: 7FFFFFFF ; inline
: MAXCPOINTSNUM           8 ; inline

: DIPH_DEVICE             0 ; inline
: DIPH_BYOFFSET           1 ; inline
: DIPH_BYID               2 ; inline
: DIPH_BYUSAGE            3 ; inline

: DIMAKEUSAGEDWORD ( UsagePage Usage -- DWORD ) 16 shift bitor ; inline

: DIPROP_BUFFERSIZE           1 <alien> ; inline
: DIPROP_AXISMODE             2 <alien> ; inline

: DIPROPAXISMODE_ABS      0 ; inline
: DIPROPAXISMODE_REL      1 ; inline

: DIPROP_GRANULARITY          3 <alien> ; inline
: DIPROP_RANGE                4 <alien> ; inline
: DIPROP_DEADZONE             5 <alien> ; inline
: DIPROP_SATURATION           6 <alien> ; inline
: DIPROP_FFGAIN               7 <alien> ; inline
: DIPROP_FFLOAD               8 <alien> ; inline
: DIPROP_AUTOCENTER           9 <alien> ; inline

: DIPROPAUTOCENTER_OFF    0 ; inline
: DIPROPAUTOCENTER_ON     1 ; inline

: DIPROP_CALIBRATIONMODE     10 <alien> ; inline

: DIPROPCALIBRATIONMODE_COOKED    0 ; inline
: DIPROPCALIBRATIONMODE_RAW       1 ; inline

: DIPROP_CALIBRATION         11 <alien> ; inline
: DIPROP_GUIDANDPATH         12 <alien> ; inline
: DIPROP_INSTANCENAME        13 <alien> ; inline
: DIPROP_PRODUCTNAME         14 <alien> ; inline
: DIPROP_JOYSTICKID          15 <alien> ; inline
: DIPROP_GETPORTDISPLAYNAME  16 <alien> ; inline
: DIPROP_PHYSICALRANGE       18 <alien> ; inline
: DIPROP_LOGICALRANGE        19 <alien> ; inline
: DIPROP_KEYNAME             20 <alien> ; inline
: DIPROP_CPOINTS             21 <alien> ; inline
: DIPROP_APPDATA             22 <alien> ; inline
: DIPROP_SCANCODE            23 <alien> ; inline
: DIPROP_VIDPID              24 <alien> ; inline
: DIPROP_USERNAME            25 <alien> ; inline
: DIPROP_TYPENAME            26 <alien> ; inline

: GUID_XAxis          GUID: {A36D02E0-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_YAxis          GUID: {A36D02E1-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_ZAxis          GUID: {A36D02E2-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_RxAxis         GUID: {A36D02F4-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_RyAxis         GUID: {A36D02F5-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_RzAxis         GUID: {A36D02E3-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_Slider         GUID: {A36D02E4-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_Button         GUID: {A36D02F0-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_Key            GUID: {55728220-D33C-11CF-BFC7-444553540000} ; inline
: GUID_POV            GUID: {A36D02F2-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_Unknown        GUID: {A36D02F3-C9F3-11CF-BFC7-444553540000} ; inline
: GUID_SysMouse       GUID: {6F1D2B60-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_SysKeyboard    GUID: {6F1D2B61-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_Joystick       GUID: {6F1D2B70-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_SysMouseEm     GUID: {6F1D2B80-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_SysMouseEm2    GUID: {6F1D2B81-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_SysKeyboardEm  GUID: {6F1D2B82-D5A0-11CF-BFC7-444553540000} ; inline
: GUID_SysKeyboardEm2 GUID: {6F1D2B83-D5A0-11CF-BFC7-444553540000} ; inline
