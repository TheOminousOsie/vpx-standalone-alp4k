' ****************************************************************
'                       VISUAL PINBALL X
' ****************************************************************
'***********************************
' // User Settings in F12 menu //   
'***********************************
Dim ModeChangeBallActive

Sub Table1_OptionEvent(ByVal eventId)
	' -- pause processes not needed to run --
    If eventId = 1 Then DisableStaticPreRendering = True
	DMDTimer.Enabled = False ' stop FlexDMD timer
	Controller.Pause = True

	ModeChangeBallActive = Table1.Option("ChangeColorBall", 0, 1, 1, 0, 0, Array("Yes","No"))

	' -- start paused processes --
	DMDTimer.Enabled = True
	Controller.Pause = False
    If eventId = 3 Then DisableStaticPreRendering = False
	
End Sub

'**************************
'DOF 
'**************************
'101 Left Flipper
'102 Right Flipper
'103 Left Slingshot
'104 Right Slingshot
'105 
'106 
'107 Bumper Right
'108 Bumper Center
'109 Bumper Left
'110 SlingShot Left Effects MX
'111 SlingShot Right Effects MX
'112 Kicker001
'113 Kicker002
'114 Kicker003
'115 Kicker004
'116 Kicker005
'117 AutoPlunger
'118 
'119 
'120 Shaker
'121 
'122 Knocker
'123 Ball Release
'124 Beacon
'125 
'132 AutoPlunger Right Effects MX
'136 
'138 Bumper 1 Back Effects MX
'139 Bumper 2 Back Effects MX
'140 Bumper 3 Back Effects MX
'144 
'145 
'146 
'147 
'310 PlungerLane Right Effects MX
'323 AtractMode Back+Left+Right Effects MX 
'338 Letter "KARR" Flash - Back Effects MX
'400 TILT Back Effects MX
'432 Multiball Back Effects MX
'441 RampBonus KITT - Left Effects MX
'451 Extraball Back Effects MX

'**************************
'   PinUp Player USER Config
'**************************
    dim usePuPDMD       : usePuPDMD=false       ' set to false to not use PuPDMD for a DMD (different that BG scoring)
	Const PuPDMDDriverType = 2  ' 2=FULLDMD (large/16:9 LCD). This table only supports the 16:9 fullsize option
	Const useRealDMDScale = 0    ' 0 or 1 for RealDMD scaling. No change PLZ
	dim useDMDVideos    : useDMDVideos=false   ' true or false to use DMD splash videos.
	Dim pGameName       : pGameName="Knight_Rider"    'pupvideos foldername, probably set to cGameName in realworld


	dim dmdver : dmdver = PuPDMDDriverType
	if dmdver = 2 Then
	Else
		dmdver = 1 
	end if

Randomize

Const BallSize = 50    ' 50 is the normal size used in the core.vbs, VP kicker routines uses this value divided by 2
Const BallMass = 1
Const SongVolume = 0.3 ' 1 is full volume. Value is from 0 to 1

' Load the core.vbs for supporting Subs and functions

On Error Resume Next
ExecuteGlobal GetTextFile("core.vbs")
If Err Then MsgBox "Can't open core.vbs"
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "Can't open controller.vbs"
On Error Goto 0


'----- Shadow Options -----
Const DynamicBallShadowsOn = 0		'0 = no dynamic ball shadow, 1 = enable dynamic ball shadow

'----- Others Options -----
Const UltraDMDUpdateTime	= 5000	'UltraDMD update time (msec).  Increase value if you encounter stutter with UltraDMD on
Const UseUltraDMD = 0				'0 = Don't use UltraDMD, 1=Use it
Const UseBGB2S = 0					'0 = Don't use B2S, 1=Use it (0 = Displaying Multiplayer Scores on the PUPDMD)

' Define any Constants
Const cGameName = "Knight_Rider"
Const TableName = "Knight_Rider"
Const typefont = "Ruben"
Const numberfont = "Ruben"
Const zoomfont = "Magic School One"
Const zoombgfont = "Magic School One" ' needs to be an outline of the zoomfont
Const myVersion = "1.0.0"
Const MaxPlayers = 4     ' from 1 to 4
Const BallSaverTime = 15 ' in seconds
Const MaxMultiplier = 3  ' limit to 3x in this game, both bonus multiplier and playfield multiplier
Const BallsPerGame = 3  ' usually 3 or 5
Const MaxMultiballs = 6  ' max number of balls during multiballs

Const Special1 = 50000000  ' High score to obtain an extra ball/game
Const Special2 = 100000000
Const Special3 = 200000000

' Use FlexDMD if in FS mode
'Dim UseFlexDMD
'If Table1.ShowDT = True then
'    UseFlexDMD = True
'Else
'    UseFlexDMD = True
'End If

' Define Global Variables
Dim PlayersPlayingGame
Dim CurrentPlayer
Dim Credits
Dim BonusPoints(4)
Dim BonusMultiplier(4)
Dim bBonusHeld
Dim BallsRemaining(4)
Dim BallinGame(4)
Dim ExtraBallsAwards(4)
Dim Special1Awarded(4)
Dim Special2Awarded(4)
Dim Special3Awarded(4)
Dim PlayerScore(4)
Dim HighScore(4)
Dim HighScoreName(4)
Dim Tilt
Dim TiltSensitivity
Dim Tilted
Dim TotalGamesPlayed
Dim bAttractMode
Dim mBalls2Eject
Dim bAutoPlunger

' Define Game Control Variables
Dim BallsOnPlayfield
Dim BallsInLock
Dim BallsInHole
Dim BOT
' Define Game Flags
Dim bFreePlay
Dim bGameInPlay
Dim bOnTheFirstBall
Dim bBallInPlungerLane
Dim bBallSaverActive
Dim bBallSaverReady
Dim bMultiBallMode
Dim MBLock_Sav(4)
Dim	RampMCount
Dim	RampLCount
Dim	RampRCount
Dim GreenCount(4)
Dim BonusGreenCount(4)
Dim YellCount(4)
Dim RedCount(4)
Dim MIGreenActive(4)
Dim MIYellActive(4)
Dim MIRedActive(4)
Dim MBLockActive(4)
Dim KickBackActive(4)
Dim bMusicOn
Dim bJustStarted
Dim bJackpot
Dim plungerIM
Dim LastSwitchHit

'****************************************
'		USER OPTIONS
'****************************************

Dim VolumeDial : VolumeDial = 0.8           	' Overall Mechanical sound effect volume. Recommended values should be no greater than 1.
Dim BallRollVolume : BallRollVolume = 0.8   	' Level of ball rolling volume. Value between 0 and 1
Dim RampRollVolume : RampRollVolume = 0.8 		' Level of ramp rolling volume. Value between 0 and 1
Dim StagedFlippers : StagedFlippers = 0         ' Staged Flippers. 0 = Disabled, 1 = Enabled

Dim tablewidth
tablewidth = Table1.width
Dim tableheight
tableheight = Table1.height
'****************************************
' core.vbs variables

Sub startB2S(aB2S)
    If B2SOn Then
        Controller.B2SSetData 1, 0
        Controller.B2SSetData 2, 0
        Controller.B2SSetData 3, 0
        Controller.B2SSetData 4, 0
        Controller.B2SSetData 5, 0
        Controller.B2SSetData 6, 0
        Controller.B2SSetData 7, 0
        Controller.B2SSetData 8, 0
        Controller.B2SSetData aB2S, 1
    End If
End Sub

Dim UltraDMD
Sub LoadUltraDMD
    Set UltraDMD = CreateObject("UltraDMD.DMDObject")
    UltraDMD.Init
	uDMDScoreTimer.Interval = UltraDMDUpdateTime
	uDMDScoreTimer.Enabled = 1
	uDMDScoreUpdate
End Sub

Sub uDMDScoreTimer_Timer
	uDMDScoreUpdate
End Sub

Sub uDMDScoreUpdate
	If UseUltraDMD = 1 Then
		UltraDMD.DisplayScoreboard00 PlayersPlayingGame, CurrentPlayer, PlayerScore(1), PlayerScore(2), PlayerScore(3), PlayerScore(4), "Credits " & Credits, "Ball " & FormatNumber(BallinGame(CurrentPlayer), 0) & "/" & FormatNumber(BallsPerGame, 0)
	End If

End Sub
' *********************************************************************
'                Visual Pinball Defined Script Events
' *********************************************************************

Sub Table1_Init()
    LoadEM
	If usePUPDMD = True Then PUPInit
'	PUPINIT
	Dim i
	'Randomize

'Impulse Plunger as autoplunger
    Const IMPowerSetting = 36 ' Plunger Power
    Const IMTime = 1.1        ' Time in seconds for Full Plunge
    Set plungerIM = New cvpmImpulseP
    With plungerIM
        .InitImpulseP swplunger, IMPowerSetting, IMTime
        .Random 1.5
        .InitExitSnd SoundFXDOF("fx_kicker", 141, DOFPulse, DOFContactors), SoundFXDOF("fx_solenoid", 141, DOFPulse, DOFContactors)
        .CreateEvents "plungerIM"
    End With

    ' Misc. VP table objects Initialisation, droptargets, animations...
    VPObjects_Init

    ' load saved values, highscore, names, jackpot
    Loadhs
	
    'Init main variables
    For i = 1 To MaxPlayers
        PlayerScore(i) = 0
        BonusPoints(i) = 0
        BonusMultiplier(i) = 1
        BallsRemaining(i) = BallsPerGame
		BallinGame(i) = 1
        ExtraBallsAwards(i) = 0
    Next



	' FlexDMD
'	Flex_Init
'	ShowScene flexScenes(1), FlexDMD_RenderMode_DMD_RGB, 2
	If UseUltraDMD > 0 Then LoadUltraDMD

    ' freeplay or coins
    bFreePlay = True 'we want coins

    'if bFreePlay = false Then DOF 125, DOFOn

	' Turn off the bumper lights
'	FlBumperFadeTarget(1) = 0
'	FlBumperFadeTarget(2) = 0
'	FlBumperFadeTarget(3) = 0

    ' Init main variables and any other flags
    bAttractMode = False
    bOnTheFirstBall = False
    bBallInPlungerLane = False
    bBallSaverActive = False
    bBallSaverReady = False
    bGameInPlay = False
    bMusicOn = True
    BallsOnPlayfield = 0
	bMultiBallMode = False
	'Multiball=false
	bAutoPlunger = False
    BallsInLock = 0
    BallsInHole = 0
	LastSwitchHit = ""
    Tilt = 0
    TiltSensitivity = 6
    Tilted = False
    bJustStarted = True
    ' set any lights for the attract mode
    GiOff
    StartAttractMode
	pAttractStart
	ResetEvents
	B2SGIOff
	'EndOfGame()
End Sub

'**********************************
' 	ZMAT: General Math Functions
'**********************************
' These get used throughout the script. 

Dim PI
PI = 4 * Atn(1)

Function dSin(degrees)
	dsin = Sin(degrees * Pi / 180)
End Function

Function dCos(degrees)
	dcos = Cos(degrees * Pi / 180)
End Function

Function Atn2(dy, dx)
	If dx > 0 Then
		Atn2 = Atn(dy / dx)
	ElseIf dx < 0 Then
		If dy = 0 Then
			Atn2 = pi
		Else
			Atn2 = Sgn(dy) * (pi - Atn(Abs(dy / dx)))
		End If
	ElseIf dx = 0 Then
		If dy = 0 Then
			Atn2 = 0
		Else
			Atn2 = Sgn(dy) * pi / 2
		End If
	End If
End Function

Function ArcCos(x)
	If x = 1 Then
		ArcCos = 0/180*PI
	ElseIf x = -1 Then
		ArcCos = 180/180*PI
	Else
		ArcCos = Atn(-x/Sqr(-x * x + 1)) + 2 * Atn(1)
	End If
End Function

Function max(a,b)
	If a > b Then
		max = a
	Else
		max = b
	End If
End Function

Function min(a,b)
	If a > b Then
		min = b
	Else
		min = a
	End If
End Function

' Used for drop targets
Function InRect(px,py,ax,ay,bx,by,cx,cy,dx,dy) 'Determines if a Points (px,py) is inside a 4 point polygon A-D in Clockwise/CCW order
	Dim AB, BC, CD, DA
	AB = (bx * py) - (by * px) - (ax * py) + (ay * px) + (ax * by) - (ay * bx)
	BC = (cx * py) - (cy * px) - (bx * py) + (by * px) + (bx * cy) - (by * cx)
	CD = (dx * py) - (dy * px) - (cx * py) + (cy * px) + (cx * dy) - (cy * dx)
	DA = (ax * py) - (ay * px) - (dx * py) + (dy * px) + (dx * ay) - (dy * ax)
	
	If (AB <= 0 And BC <= 0 And CD <= 0 And DA <= 0) Or (AB >= 0 And BC >= 0 And CD >= 0 And DA >= 0) Then
		InRect = True
	Else
		InRect = False
	End If
End Function

Function InRotRect(ballx,bally,px,py,angle,ax,ay,bx,by,cx,cy,dx,dy)
	Dim rax,ray,rbx,rby,rcx,rcy,rdx,rdy
	Dim rotxy
	rotxy = RotPoint(ax,ay,angle)
	rax = rotxy(0) + px
	ray = rotxy(1) + py
	rotxy = RotPoint(bx,by,angle)
	rbx = rotxy(0) + px
	rby = rotxy(1) + py
	rotxy = RotPoint(cx,cy,angle)
	rcx = rotxy(0) + px
	rcy = rotxy(1) + py
	rotxy = RotPoint(dx,dy,angle)
	rdx = rotxy(0) + px
	rdy = rotxy(1) + py
	
	InRotRect = InRect(ballx,bally,rax,ray,rbx,rby,rcx,rcy,rdx,rdy)
End Function

Function RotPoint(x,y,angle)
	Dim rx, ry
	rx = x * dCos(angle) - y * dSin(angle)
	ry = x * dSin(angle) + y * dCos(angle)
	RotPoint = Array(rx,ry)
End Function


'******************************************************
' 	ZFLE:  FLEEP MECHANICAL SOUNDS
'******************************************************

' This part in the script is an entire block that is dedicated to the physics sound system.
' Various scripts and sounds that may be pretty generic and could suit other WPC systems, but the most are tailored specifically for the TOM table

' Many of the sounds in this package can be added by creating collections and adding the appropriate objects to those collections.
' Create the following new collections:
'	 Metals (all metal objects, metal walls, metal posts, metal wire guides)
'	 Apron (the apron walls and plunger wall)
'	 Walls (all wood or plastic walls)
'	 Rollovers (wire rollover triggers, star triggers, or button triggers)
'	 Targets (standup or drop targets, these are hit sounds only ... you will want to add separate dropping sounds for drop targets)
'	 Gates (plate gates)
'	 GatesWire (wire gates)
'	 Rubbers (all rubbers including posts, sleeves, pegs, and bands)
' When creating the collections, make sure "Fire events for this collection" is checked.
' You'll also need to make sure "Has Hit Event" is checked for each object placed in these collections (not necessary for gates and triggers).
' Once the collections and objects are added, the save, close, and restart VPX.
'
' Many places in the script need to be modified to include the correct sound effect subroutine calls. The tutorial videos linked below demonstrate
' how to make these updates. But in summary the following needs to be updated:
'	- Nudging, plunger, coin-in, start button sounds will be added to the keydown and keyup subs.
'	- Flipper sounds in the flipper solenoid subs. Flipper collision sounds in the flipper collide subs.
'	- Bumpers, slingshots, drain, ball release, knocker, spinner, and saucers in their respective subs
'	- Ball rolling sounds sub
'
' Tutorial videos by Apophis
' Audio : Adding Fleep Part 1					https://youtu.be/rG35JVHxtx4?si=zdN9W4cZWEyXbOz_
' Audio : Adding Fleep Part 2					https://youtu.be/dk110pWMxGo?si=2iGMImXXZ0SFKVCh
' Audio : Adding Fleep Part 3					https://youtu.be/ESXWGJZY_EI?si=6D20E2nUM-xAw7xy


'///////////////////////////////  SOUNDS PARAMETERS  //////////////////////////////
Dim GlobalSoundLevel, CoinSoundLevel, PlungerReleaseSoundLevel, PlungerPullSoundLevel, NudgeLeftSoundLevel
Dim NudgeRightSoundLevel, NudgeCenterSoundLevel, StartButtonSoundLevel, RollingSoundFactor

CoinSoundLevel = 1					  'volume level; range [0, 1]
NudgeLeftSoundLevel = 1				 'volume level; range [0, 1]
NudgeRightSoundLevel = 1				'volume level; range [0, 1]
NudgeCenterSoundLevel = 1			   'volume level; range [0, 1]
StartButtonSoundLevel = 0.1			 'volume level; range [0, 1]
PlungerReleaseSoundLevel = 0.8 '1 wjr   'volume level; range [0, 1]
PlungerPullSoundLevel = 1			   'volume level; range [0, 1]
RollingSoundFactor = 1.1 / 5

'///////////////////////-----Solenoids, Kickers and Flash Relays-----///////////////////////
Dim FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel, FlipperUpAttackLeftSoundLevel, FlipperUpAttackRightSoundLevel
Dim FlipperUpSoundLevel, FlipperDownSoundLevel, FlipperLeftHitParm, FlipperRightHitParm
Dim SlingshotSoundLevel, BumperSoundFactor, KnockerSoundLevel

FlipperUpAttackMinimumSoundLevel = 0.010		'volume level; range [0, 1]
FlipperUpAttackMaximumSoundLevel = 0.635		'volume level; range [0, 1]
FlipperUpSoundLevel = 1.0					   'volume level; range [0, 1]
FlipperDownSoundLevel = 0.45					'volume level; range [0, 1]
FlipperLeftHitParm = FlipperUpSoundLevel		'sound helper; not configurable
FlipperRightHitParm = FlipperUpSoundLevel	   'sound helper; not configurable
SlingshotSoundLevel = 0.95					  'volume level; range [0, 1]
BumperSoundFactor = 4.25						'volume multiplier; must not be zero
KnockerSoundLevel = 1						   'volume level; range [0, 1]

'///////////////////////-----Ball Drops, Bumps and Collisions-----///////////////////////
Dim RubberStrongSoundFactor, RubberWeakSoundFactor, RubberFlipperSoundFactor,BallWithBallCollisionSoundFactor
Dim BallBouncePlayfieldSoftFactor, BallBouncePlayfieldHardFactor, PlasticRampDropToPlayfieldSoundLevel, WireRampDropToPlayfieldSoundLevel, DelayedBallDropOnPlayfieldSoundLevel
Dim WallImpactSoundFactor, MetalImpactSoundFactor, SubwaySoundLevel, SubwayEntrySoundLevel, ScoopEntrySoundLevel
Dim SaucerLockSoundLevel, SaucerKickSoundLevel

BallWithBallCollisionSoundFactor = 3.2		  'volume multiplier; must not be zero
RubberStrongSoundFactor = 0.055 / 5			 'volume multiplier; must not be zero
RubberWeakSoundFactor = 0.075 / 5			   'volume multiplier; must not be zero
RubberFlipperSoundFactor = 0.075 / 5			'volume multiplier; must not be zero
BallBouncePlayfieldSoftFactor = 0.025		   'volume multiplier; must not be zero
BallBouncePlayfieldHardFactor = 0.025		   'volume multiplier; must not be zero
DelayedBallDropOnPlayfieldSoundLevel = 0.8	  'volume level; range [0, 1]
WallImpactSoundFactor = 0.075				   'volume multiplier; must not be zero
MetalImpactSoundFactor = 0.075 / 3
SaucerLockSoundLevel = 0.8
SaucerKickSoundLevel = 0.8

'///////////////////////-----Gates, Spinners, Rollovers and Targets-----///////////////////////

Dim GateSoundLevel, TargetSoundFactor, SpinnerSoundLevel, RolloverSoundLevel, DTSoundLevel

GateSoundLevel = 0.5 / 5			'volume level; range [0, 1]
TargetSoundFactor = 0.0025 * 10	 'volume multiplier; must not be zero
DTSoundLevel = 0.25				 'volume multiplier; must not be zero
RolloverSoundLevel = 0.25		   'volume level; range [0, 1]
SpinnerSoundLevel = 0.5			 'volume level; range [0, 1]

'///////////////////////-----Ball Release, Guides and Drain-----///////////////////////
Dim DrainSoundLevel, BallReleaseSoundLevel, BottomArchBallGuideSoundFactor, FlipperBallGuideSoundFactor

DrainSoundLevel = 0.8				   'volume level; range [0, 1]
BallReleaseSoundLevel = 1			   'volume level; range [0, 1]
BottomArchBallGuideSoundFactor = 0.2	'volume multiplier; must not be zero
FlipperBallGuideSoundFactor = 0.015	 'volume multiplier; must not be zero

'///////////////////////-----Loops and Lanes-----///////////////////////
Dim ArchSoundFactor
ArchSoundFactor = 0.025 / 5			 'volume multiplier; must not be zero

'/////////////////////////////  SOUND PLAYBACK FUNCTIONS  ////////////////////////////
'/////////////////////////////  POSITIONAL SOUND PLAYBACK METHODS  ////////////////////////////
' Positional sound playback methods will play a sound, depending on the X,Y position of the table element or depending on ActiveBall object position
' These are similar subroutines that are less complicated to use (e.g. simply use standard parameters for the PlaySound call)
' For surround setup - positional sound playback functions will fade between front and rear surround channels and pan between left and right channels
' For stereo setup - positional sound playback functions will only pan between left and right channels
' For mono setup - positional sound playback functions will not pan between left and right channels and will not fade between front and rear channels

' PlaySound full syntax - PlaySound(string, int loopcount, float volume, float pan, float randompitch, int pitch, bool useexisting, bool restart, float front_rear_fade)
' Note - These functions will not work (currently) for walls/slingshots as these do not feature a simple, single X,Y position
Sub PlaySoundAtLevelStatic(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelExistingStatic(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(tableobj), 0, 0, 1, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticLoop(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, - 1, min(aVol,1) * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticRandomPitch(playsoundparams, aVol, randomPitch, tableobj)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelActiveBall(playsoundparams, aVol)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(ActiveBall), 0, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLevelExistingActiveBall(playsoundparams, aVol)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(ActiveBall), 0, 0, 1, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLeveTimerActiveBall(playsoundparams, aVol, ballvariable)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(ballvariable), 0, 0, 0, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelTimerExistingActiveBall(playsoundparams, aVol, ballvariable)
	PlaySound playsoundparams, 0, min(aVol,1) * VolumeDial, AudioPan(ballvariable), 0, 0, 1, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelRoll(playsoundparams, aVol, pitch)
	PlaySound playsoundparams, - 1, min(aVol,1) * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

' Previous Positional Sound Subs

'Sub PlaySoundAt(soundname, tableobj)
'	PlaySound soundname, 1, 1 * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
'End Sub

Sub PlaySoundAtVol(soundname, tableobj, aVol)
	PlaySound soundname, 1, min(aVol,1) * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

'Sub PlaySoundAtBall(soundname)
'	PlaySoundAt soundname, ActiveBall
'End Sub

Sub PlaySoundAtBallVol (Soundname, aVol)
	PlaySound soundname, 1,min(aVol,1) * VolumeDial, AudioPan(ActiveBall), 0,0,0, 1, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtBallVolM (Soundname, aVol)
	PlaySound soundname, 1,min(aVol,1) * VolumeDial, AudioPan(ActiveBall), 0,0,0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtVolLoops(sound, tableobj, Vol, Loops)
	PlaySound sound, Loops, Vol * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

'******************************************************
'  Fleep  Supporting Ball & Sound Functions
'******************************************************
Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
	Dim tmp
	tmp = tableobj.y * 2 / tableheight - 1
	
	If tmp > 7000 Then
		tmp = 7000
	ElseIf tmp <  - 7000 Then
		tmp =  - 7000
	End If
	
	If tmp > 0 Then
		AudioFade = CSng(tmp ^ 10)
	Else
		AudioFade = CSng( - (( - tmp) ^ 10) )
	End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
	Dim tmp
	tmp = tableobj.x * 2 / tablewidth - 1
	
	If tmp > 7000 Then
		tmp = 7000
	ElseIf tmp <  - 7000 Then
		tmp =  - 7000
	End If
	
	If tmp > 0 Then
		AudioPan = CSng(tmp ^ 10)
	Else
		AudioPan = CSng( - (( - tmp) ^ 10) )
	End If
End Function

Function Volz(ball) ' Calculates the volume of the sound based on the ball speed
	Volz = CSng((ball.velz) ^ 2)
End Function

Function VolPlayfieldRoll(ball) ' Calculates the roll volume of the sound based on the ball speed
	VolPlayfieldRoll = RollingSoundFactor * 0.0005 * CSng(BallVel(ball) ^ 3)
End Function

Function PitchPlayfieldRoll(ball) ' Calculates the roll pitch of the sound based on the ball speed
	PitchPlayfieldRoll = BallVel(ball) ^ 2 * 15
End Function

Function RndInt(min, max) ' Sets a random number integer between min and max
	RndInt = Int(Rnd() * (max - min + 1) + min)
End Function

Function RndNum(min, max) ' Sets a random number between min and max
	RndNum = Rnd() * (max - min) + min
End Function

'/////////////////////////////  GENERAL SOUND SUBROUTINES  ////////////////////////////

Sub SoundStartButton()
	PlaySound ("Start_Button"), 0, StartButtonSoundLevel, 0, 0.25
End Sub

Sub SoundNudgeLeft()
	PlaySound ("Nudge_" & Int(Rnd * 2) + 1), 0, NudgeLeftSoundLevel * VolumeDial, - 0.1, 0.25
End Sub

Sub SoundNudgeRight()
	PlaySound ("Nudge_" & Int(Rnd * 2) + 1), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
End Sub

Sub SoundNudgeCenter()
	PlaySound ("Nudge_" & Int(Rnd * 2) + 1), 0, NudgeCenterSoundLevel * VolumeDial, 0, 0.25
End Sub

Sub SoundPlungerPull()
	PlaySoundAtLevelStatic ("Plunger_Pull_1"), PlungerPullSoundLevel, Plunger
End Sub

Sub SoundPlungerReleaseBall()
	PlaySoundAtLevelStatic ("Plunger_Release_Ball"), PlungerReleaseSoundLevel, Plunger
End Sub

Sub SoundPlungerReleaseNoBall()
	PlaySoundAtLevelStatic ("Plunger_Release_No_Ball"), PlungerReleaseSoundLevel, Plunger
End Sub

'/////////////////////////////  KNOCKER SOLENOID  ////////////////////////////

Sub KnockerSolenoid()
	PlaySoundAtLevelStatic SoundFX("Knocker_1",DOFKnocker), KnockerSoundLevel, KnockerPosition
End Sub

'/////////////////////////////  DRAIN SOUNDS  ////////////////////////////

Sub RandomSoundDrain(drainswitch)
	PlaySoundAtLevelStatic ("Drain_" & Int(Rnd * 11) + 1), DrainSoundLevel, drainswitch
End Sub

'/////////////////////////////  TROUGH BALL RELEASE SOLENOID SOUNDS  ////////////////////////////

Sub RandomSoundBallRelease(drainswitch)
	PlaySoundAtLevelStatic SoundFX("BallRelease" & Int(Rnd * 7) + 1,DOFContactors), BallReleaseSoundLevel, drainswitch
End Sub

'/////////////////////////////  SLINGSHOT SOLENOID SOUNDS  ////////////////////////////

Sub RandomSoundSlingshotLeft(sling)
	PlaySoundAtLevelStatic SoundFX("Sling_L" & Int(Rnd * 10) + 1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

Sub RandomSoundSlingshotRight(sling)
	PlaySoundAtLevelStatic SoundFX("Sling_R" & Int(Rnd * 8) + 1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

'/////////////////////////////  BUMPER SOLENOID SOUNDS  ////////////////////////////

Sub RandomSoundBumperTop(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Top_" & Int(Rnd * 5) + 1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperMiddle(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_" & Int(Rnd * 5) + 1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperBottom(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_" & Int(Rnd * 5) + 1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

'/////////////////////////////  SPINNER SOUNDS  ////////////////////////////

Sub SoundSpinner(spinnerswitch)
	PlaySoundAtLevelStatic ("Spinner"), SpinnerSoundLevel, spinnerswitch
End Sub

'/////////////////////////////  FLIPPER BATS SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  FLIPPER BATS SOLENOID ATTACK SOUND  ////////////////////////////

Sub SoundFlipperUpAttackLeft(flipper)
	FlipperUpAttackLeftSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
	PlaySoundAtLevelStatic SoundFX("Flipper_Attack-L01",DOFFlippers), FlipperUpAttackLeftSoundLevel, flipper
End Sub

Sub SoundFlipperUpAttackRight(flipper)
	FlipperUpAttackRightSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
	PlaySoundAtLevelStatic SoundFX("Flipper_Attack-R01",DOFFlippers), FlipperUpAttackLeftSoundLevel, flipper
End Sub

'/////////////////////////////  FLIPPER BATS SOLENOID CORE SOUND  ////////////////////////////

Sub RandomSoundFlipperUpLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_L0" & Int(Rnd * 9) + 1,DOFFlippers), FlipperLeftHitParm, Flipper
End Sub

Sub RandomSoundFlipperUpRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_R0" & Int(Rnd * 9) + 1,DOFFlippers), FlipperRightHitParm, Flipper
End Sub

Sub RandomSoundReflipUpLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L0" & Int(Rnd * 3) + 1,DOFFlippers), (RndNum(0.8, 1)) * FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundReflipUpRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R0" & Int(Rnd * 3) + 1,DOFFlippers), (RndNum(0.8, 1)) * FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_" & Int(Rnd * 7) + 1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_" & Int(Rnd * 8) + 1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

'/////////////////////////////  FLIPPER BATS BALL COLLIDE SOUND  ////////////////////////////

Sub LeftFlipperCollide(parm)
	FlipperLeftHitParm = parm / 10
	If FlipperLeftHitParm > 1 Then
		FlipperLeftHitParm = 1
	End If
	FlipperLeftHitParm = FlipperUpSoundLevel * FlipperLeftHitParm
	RandomSoundRubberFlipper(parm)
End Sub

Sub RightFlipperCollide(parm)
	FlipperRightHitParm = parm / 10
	If FlipperRightHitParm > 1 Then
		FlipperRightHitParm = 1
	End If
	FlipperRightHitParm = FlipperUpSoundLevel * FlipperRightHitParm
	RandomSoundRubberFlipper(parm)
End Sub

Sub RandomSoundRubberFlipper(parm)
	PlaySoundAtLevelActiveBall ("Flipper_Rubber_" & Int(Rnd * 7) + 1), parm * RubberFlipperSoundFactor
End Sub

'/////////////////////////////  ROLLOVER SOUNDS  ////////////////////////////

Sub RandomSoundRollover()
	PlaySoundAtLevelActiveBall ("Rollover_" & Int(Rnd * 4) + 1), RolloverSoundLevel
End Sub

Sub Rollovers_Hit(idx)
	RandomSoundRollover
End Sub

'/////////////////////////////  VARIOUS PLAYFIELD SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  RUBBERS AND POSTS  ////////////////////////////
'/////////////////////////////  RUBBERS - EVENTS  ////////////////////////////

Sub Rubbers_Hit(idx)
	Dim finalspeed
	finalspeed = Sqr(ActiveBall.velx * ActiveBall.velx + ActiveBall.vely * ActiveBall.vely)
	If finalspeed > 5 Then
		RandomSoundRubberStrong 1
	End If
	If finalspeed <= 5 Then
		RandomSoundRubberWeak()
	End If
End Sub

'/////////////////////////////  RUBBERS AND POSTS - STRONG IMPACTS  ////////////////////////////

Sub RandomSoundRubberStrong(voladj)
	Select Case Int(Rnd * 10) + 1
		Case 1
			PlaySoundAtLevelActiveBall ("Rubber_Strong_1"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 2
			PlaySoundAtLevelActiveBall ("Rubber_Strong_2"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 3
			PlaySoundAtLevelActiveBall ("Rubber_Strong_3"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 4
			PlaySoundAtLevelActiveBall ("Rubber_Strong_4"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 5
			PlaySoundAtLevelActiveBall ("Rubber_Strong_5"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 6
			PlaySoundAtLevelActiveBall ("Rubber_Strong_6"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 7
			PlaySoundAtLevelActiveBall ("Rubber_Strong_7"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 8
			PlaySoundAtLevelActiveBall ("Rubber_Strong_8"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 9
			PlaySoundAtLevelActiveBall ("Rubber_Strong_9"), Vol(ActiveBall) * RubberStrongSoundFactor * voladj
		Case 10
			PlaySoundAtLevelActiveBall ("Rubber_1_Hard"), Vol(ActiveBall) * RubberStrongSoundFactor * 0.6 * voladj
	End Select
End Sub

'/////////////////////////////  RUBBERS AND POSTS - WEAK IMPACTS  ////////////////////////////

Sub RandomSoundRubberWeak()
	PlaySoundAtLevelActiveBall ("Rubber_" & Int(Rnd * 9) + 1), Vol(ActiveBall) * RubberWeakSoundFactor
End Sub

'/////////////////////////////  WALL IMPACTS  ////////////////////////////

Sub Walls_Hit(idx)
	RandomSoundWall()
End Sub

Sub RandomSoundWall()
	Dim finalspeed
	finalspeed = Sqr(ActiveBall.velx * ActiveBall.velx + ActiveBall.vely * ActiveBall.vely)
	If finalspeed > 16 Then
		Select Case Int(Rnd * 5) + 1
			Case 1
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_1"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_2"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_5"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 4
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_7"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 5
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_9"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End If
	If finalspeed >= 6 And finalspeed <= 16 Then
		Select Case Int(Rnd * 4) + 1
			Case 1
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_3"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 4
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End If
	If finalspeed < 6 Then
		Select Case Int(Rnd * 3) + 1
			Case 1
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3
				PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End If
End Sub

'/////////////////////////////  METAL TOUCH SOUNDS  ////////////////////////////

Sub RandomSoundMetal()
	PlaySoundAtLevelActiveBall ("Metal_Touch_" & Int(Rnd * 13) + 1), Vol(ActiveBall) * MetalImpactSoundFactor
End Sub

'/////////////////////////////  METAL - EVENTS  ////////////////////////////

Sub Metals_Hit (idx)
	RandomSoundMetal
End Sub

Sub ShooterDiverter_collide(idx)
	RandomSoundMetal
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE  ////////////////////////////
'/////////////////////////////  BOTTOM ARCH BALL GUIDE - SOFT BOUNCES  ////////////////////////////

Sub RandomSoundBottomArchBallGuide()
	Dim finalspeed
	finalspeed = Sqr(ActiveBall.velx * ActiveBall.velx + ActiveBall.vely * ActiveBall.vely)
	If finalspeed > 16 Then
		PlaySoundAtLevelActiveBall ("Apron_Bounce_" & Int(Rnd * 2) + 1), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
	End If
	If finalspeed >= 6 And finalspeed <= 16 Then
		Select Case Int(Rnd * 2) + 1
			Case 1
				PlaySoundAtLevelActiveBall ("Apron_Bounce_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
			Case 2
				PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
		End Select
	End If
	If finalspeed < 6 Then
		Select Case Int(Rnd * 2) + 1
			Case 1
				PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
			Case 2
				PlaySoundAtLevelActiveBall ("Apron_Medium_3"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
		End Select
	End If
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE - HARD HITS  ////////////////////////////

Sub RandomSoundBottomArchBallGuideHardHit()
	PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_" & Int(Rnd * 3) + 1), BottomArchBallGuideSoundFactor * 0.25
End Sub

Sub Apron_Hit (idx)
	If Abs(cor.ballvelx(ActiveBall.id) < 4) And cor.ballvely(ActiveBall.id) > 7 Then
		RandomSoundBottomArchBallGuideHardHit()
	Else
		RandomSoundBottomArchBallGuide
	End If
End Sub

'/////////////////////////////  FLIPPER BALL GUIDE  ////////////////////////////

Sub RandomSoundFlipperBallGuide()
	Dim finalspeed
	finalspeed = Sqr(ActiveBall.velx * ActiveBall.velx + ActiveBall.vely * ActiveBall.vely)
	If finalspeed > 16 Then
		Select Case Int(Rnd * 2) + 1
			Case 1
				PlaySoundAtLevelActiveBall ("Apron_Hard_1"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 2
				PlaySoundAtLevelActiveBall ("Apron_Hard_2"),  Vol(ActiveBall) * 0.8 * FlipperBallGuideSoundFactor
		End Select
	End If
	If finalspeed >= 6 And finalspeed <= 16 Then
		PlaySoundAtLevelActiveBall ("Apron_Medium_" & Int(Rnd * 3) + 1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
	End If
	If finalspeed < 6 Then
		PlaySoundAtLevelActiveBall ("Apron_Soft_" & Int(Rnd * 7) + 1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
	End If
End Sub

'/////////////////////////////  TARGET HIT SOUNDS  ////////////////////////////

Sub RandomSoundTargetHitStrong()
	PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd * 4) + 5,DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
End Sub

Sub RandomSoundTargetHitWeak()
	PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd * 4) + 1,DOFTargets), Vol(ActiveBall) * TargetSoundFactor
End Sub

Sub PlayTargetSound()
	Dim finalspeed
	finalspeed = Sqr(ActiveBall.velx * ActiveBall.velx + ActiveBall.vely * ActiveBall.vely)
	If finalspeed > 10 Then
		RandomSoundTargetHitStrong()
		RandomSoundBallBouncePlayfieldSoft ActiveBall
	Else
		RandomSoundTargetHitWeak()
	End If
End Sub

Sub Targets_Hit (idx)
	PlayTargetSound
End Sub

'/////////////////////////////  BALL BOUNCE SOUNDS  ////////////////////////////

Sub RandomSoundBallBouncePlayfieldSoft(aBall)
	Select Case Int(Rnd * 9) + 1
		Case 1
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_1"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
		Case 2
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
		Case 3
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_3"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.8, aBall
		Case 4
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_4"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
		Case 5
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_5"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
		Case 6
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_1"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 7
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 8
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_5"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 9
			PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_7"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.3, aBall
	End Select
End Sub

Sub RandomSoundBallBouncePlayfieldHard(aBall)
	PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_" & Int(Rnd * 7) + 1), volz(aBall) * BallBouncePlayfieldHardFactor, aBall
End Sub

'/////////////////////////////  DELAYED DROP - TO PLAYFIELD - SOUND  ////////////////////////////

Sub RandomSoundDelayedBallDropOnPlayfield(aBall)
	Select Case Int(Rnd * 5) + 1
		Case 1
			PlaySoundAtLevelStatic ("Ball_Drop_Playfield_1_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 2
			PlaySoundAtLevelStatic ("Ball_Drop_Playfield_2_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 3
			PlaySoundAtLevelStatic ("Ball_Drop_Playfield_3_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 4
			PlaySoundAtLevelStatic ("Ball_Drop_Playfield_4_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 5
			PlaySoundAtLevelStatic ("Ball_Drop_Playfield_5_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
	End Select
End Sub

'/////////////////////////////  BALL GATES AND BRACKET GATES SOUNDS  ////////////////////////////

Sub SoundPlayfieldGate()
	PlaySoundAtLevelStatic ("Gate_FastTrigger_" & Int(Rnd * 2) + 1), GateSoundLevel, ActiveBall
End Sub

Sub SoundHeavyGate()
	PlaySoundAtLevelStatic ("Gate_2"), GateSoundLevel, ActiveBall
End Sub

Sub Gates_hit(idx)
	SoundHeavyGate
End Sub

Sub GatesWire_hit(idx)
	SoundPlayfieldGate
End Sub

'/////////////////////////////  LEFT LANE ENTRANCE - SOUNDS  ////////////////////////////

Sub RandomSoundLeftArch()
	PlaySoundAtLevelActiveBall ("Arch_L" & Int(Rnd * 4) + 1), Vol(ActiveBall) * ArchSoundFactor
End Sub

Sub RandomSoundRightArch()
	PlaySoundAtLevelActiveBall ("Arch_R" & Int(Rnd * 4) + 1), Vol(ActiveBall) * ArchSoundFactor
End Sub

Sub Arch1_hit()
	If ActiveBall.velx > 1 Then SoundPlayfieldGate
	StopSound "Arch_L1"
	StopSound "Arch_L2"
	StopSound "Arch_L3"
	StopSound "Arch_L4"
End Sub

Sub Arch1_unhit()
	If ActiveBall.velx <  - 8 Then
		RandomSoundRightArch
	End If
End Sub

Sub Arch2_hit()
	If ActiveBall.velx < 1 Then SoundPlayfieldGate
	StopSound "Arch_R1"
	StopSound "Arch_R2"
	StopSound "Arch_R3"
	StopSound "Arch_R4"
End Sub

Sub Arch2_unhit()
	If ActiveBall.velx > 10 Then
		RandomSoundLeftArch
	End If
End Sub

'/////////////////////////////  SAUCERS (KICKER HOLES)  ////////////////////////////

Sub SoundSaucerLock()
	PlaySoundAtLevelStatic ("Saucer_Enter_" & Int(Rnd * 2) + 1), SaucerLockSoundLevel, ActiveBall
End Sub

Sub SoundSaucerKick(scenario, saucer)
	Select Case scenario
		Case 0
			PlaySoundAtLevelStatic SoundFX("Saucer_Empty", DOFContactors), SaucerKickSoundLevel, saucer
		Case 1
			PlaySoundAtLevelStatic SoundFX("Saucer_Kick", DOFContactors), SaucerKickSoundLevel, saucer
	End Select
End Sub

'///////////////////////////  DROP TARGET HIT SOUNDS  ///////////////////////////

Sub RandomSoundDropTargetReset(obj)
	PlaySoundAtLevelStatic SoundFX("Drop_Target_Reset_" & Int(Rnd * 6) + 1,DOFContactors), 1, obj
End Sub

Sub SoundDropTargetDrop(obj)
	PlaySoundAtLevelStatic ("Drop_Target_Down_" & Int(Rnd * 6) + 1), 200, obj
End Sub

'/////////////////////////////  GI AND FLASHER RELAYS  ////////////////////////////

Const RelayFlashSoundLevel = 0.315  'volume level; range [0, 1];
Const RelayGISoundLevel = 1.05	  'volume level; range [0, 1];

Sub Sound_GI_Relay(toggle, obj)
	Select Case toggle
		Case 1
			PlaySoundAtLevelStatic ("Relay_GI_On"), 0.025 * RelayGISoundLevel, obj
		Case 0
			PlaySoundAtLevelStatic ("Relay_GI_Off"), 0.025 * RelayGISoundLevel, obj
	End Select
End Sub

Sub Sound_Flash_Relay(toggle, obj)
	Select Case toggle
		Case 1
			PlaySoundAtLevelStatic ("Relay_Flash_On"), 0.025 * RelayFlashSoundLevel, obj
		Case 0
			PlaySoundAtLevelStatic ("Relay_Flash_Off"), 0.025 * RelayFlashSoundLevel, obj
	End Select
End Sub

'/////////////////////////////////////////////////////////////////
'					End Mechanical Sounds
'/////////////////////////////////////////////////////////////////

'******************************************************
'****  FLEEP MECHANICAL SOUNDS
'******************************************************



'******************************************************
'  ZANI: Misc Animations
'******************************************************

Sub LeftFlipper_Animate
	dim a: a = LeftFlipper.CurrentAngle
	FlipperLSh.RotZ = a
	LFLogo.RotZ = a
	'Add any left flipper related animations here
End Sub

Sub RightFlipper_Animate
	dim a: a = RightFlipper.CurrentAngle
	FlipperRSh.RotZ = a
	RFLogo.RotZ = a
	'Add any right flipper related animations here
End Sub

Sub LeftFlipper001_Animate
	dim a: a = LeftFlipper001.CurrentAngle
	FlipperULSh.RotZ = a
	LFLogo001.RotZ = a
	'Add any left flipper related animations here
End Sub

Sub RightFlipper001_Animate
	dim a: a = RightFlipper001.CurrentAngle
	FlipperURSh.RotZ = a
	RFLogo001.RotZ = a
	'Add any right flipper related animations here
End Sub



'****************************************
' Real Time updatess using the GameTimer
'****************************************
'used for all the real time updates

Sub GameTimer_Timer
    RollingUpdate
    ' add any other real time update subs, like gates or diverters
    FlipperLSh.Rotz = LeftFlipper.CurrentAngle
    FlipperRSh.Rotz = RightFlipper.CurrentAngle
	FlipperULSh.RotZ = LeftFlipper001.CurrentAngle
	FlipperURSh.RotZ = RightFlipper001.CurrentAngle
	LFLogo.RotZ = LeftFlipper.CurrentAngle
	LFLogo001.RotZ = LeftFlipper001.CurrentAngle
	RFlogo.RotZ = RightFlipper.CurrentAngle
	RFlogo001.RotZ = RightFlipper001.CurrentAngle
End Sub

'******
' Keys
'******

Sub Table1_KeyDown(ByVal Keycode)
    If Keycode = AddCreditKey Then
'		DOF 202, DOFPulse
        Credits = Credits + 1
		PlaySound "Coin_In_1"
		pDMDStartGame
		If B2SOn Then Controller.B2SSetscore 5, Credits
        if bFreePlay = False Then
'            DOF 125, DOFOn
            If(Tilted = False) Then
            End If
        End If
    End If

    If keycode = PlungerKey Then
        Plunger.Pullback
        PlaySoundAt "fx_plungerpull", plunger
        PlaySoundAt "fx_reload", plunger
		pDMDStartGame
    End If

    If hsbModeActive Then
        EnterHighScoreKey(keycode)
        Exit Sub
    End If

    ' Normal flipper action

    If bGameInPlay AND NOT Tilted Then

        If keycode = LeftTiltKey Then Nudge 90, 8:PlaySound "fx_nudge", 0, 1, -0.1, 0.25:CheckTilt
        If keycode = RightTiltKey Then Nudge 270, 8:PlaySound "fx_nudge", 0, 1, 0.1, 0.25:CheckTilt
        If keycode = CenterTiltKey Then Nudge 0, 9:PlaySound "fx_nudge", 0, 1, 1, 0.25:CheckTilt
	
'	If keycode = LeftMagnaSave Then
'	If keycode = RightMagnaSave Then
	
	If keycode = LeftFlipperKey Then
		SolLFlipper True	'This would be called by the solenoid callbacks if using a ROM
'		If bModeCastelActive = True Then
'		SolU2LFlipper True
		SolULFlipper True
'		End If
'		SolULFlipper False
	End If
	
	If keycode = RightFlipperKey Then
		SolRFlipper True	'This would be called by the solenoid callbacks if using a ROM
'		SolURFlipper False
		SolURFlipper True
'		if PuPGameRunning Then PuPGameInfo= PuPlayer.GameUpdate("PupMiniGame", 1 , 87 , "")  'w
	End If

        If keycode = StartGameKey Then
            If((PlayersPlayingGame <MaxPlayers) AND(bOnTheFirstBall = True) ) Then

                If(bFreePlay = True) Then
                    PlayersPlayingGame = PlayersPlayingGame + 1
'					If B2SOn Then Controller.B2SSetScorePlayer PlayersPlayingGame, 0
                    TotalGamesPlayed = TotalGamesPlayed + 1
                Else
                    If(Credits> 0) then
                        PlayersPlayingGame = PlayersPlayingGame + 1
'						If B2SOn Then Controller.B2SSetScorePlayer PlayersPlayingGame, 0
                        TotalGamesPlayed = TotalGamesPlayed + 1
						If B2SOn Then Controller.B2SSetscore 5, Credits
						PlaySound "fx_kit"
						resetbackglass
                        Credits = Credits - 1
						If B2SOn Then Controller.B2SSetscore 5, Credits
                        If Credits <1 And bFreePlay = False Then DOF 125, DOFOff
                        Else
                            ' Not Enough Credits to start a game.
                    End If
                End If
            End If
        End If
        Else ' If (GameInPlay)

            If keycode = StartGameKey Then
                If(bFreePlay = True) Then
                    If(BallsOnPlayfield = 0) Then
                        ResetForNewGame()
						UpdateMusicNow
                    End If
                Else
                    If(Credits> 0) Then
                        If(BallsOnPlayfield = 0) Then
                            Credits = Credits - 1
							If B2SOn Then Controller.B2SSetscore 5, Credits
                            If Credits <1 And bFreePlay = False Then DOF 125, DOFOff
                            ResetForNewGame()
							UpdateMusicNow
                        End If
                    Else
                        ' Not Enough Credits to start a game.
                    End If
                End If
            End If
    End If ' If (GameInPlay)

'table keys
'If keycode = RightMagnaSave or keycode = LeftMagnasave Then ShowPost 
End Sub

Sub Table1_KeyUp(ByVal keycode)

    If keycode = PlungerKey Then
        Plunger.Fire
        PlaySoundAt "fx_plunger", plunger
        If bBallInPlungerLane Then PlaySoundAt "fx_fire", plunger
    End If

    If hsbModeActive Then
        Exit Sub
    End If

    ' Table specific
'	If keycode = LeftMagnaSave Then 
'	If keycode = RightMagnaSave Then 

    If bGameInPLay AND NOT Tilted Then
	pDMDStartGame
		If keycode = LeftFlipperKey Then
			SolLFlipper False   'This would be called by the solenoid callbacks if using a ROM
			SolULFlipper False
		End If
	
		If keycode = RightFlipperKey Then
			SolRFlipper False   'This would be called by the solenoid callbacks if using a ROM
			SolURFlipper False
		End If
    End If
End Sub

'*************
' Pause Table
'*************

Sub table1_Paused
End Sub

Sub table1_unPaused
End Sub

Sub Table1_Exit
    Savehs
    If B2SOn Then Controller.Stop
	If UseUltraDMD > 0 Then UltraDMD.CancelRendering
End Sub

'*******************************************
'	ZFLP: Flippers
'*******************************************

Const ReflipAngle = 20

' Flipper Solenoid Callbacks (these subs mimics how you would handle flippers in ROM based tables)
Sub SolLFlipper(Enabled) 'Left flipper solenoid callback
	If Enabled Then
		PlaySoundAt SoundFXDOF("fx_flipperup", 101, DOFOn, DOFFlippers), LeftFlipper
		FlipperActivate LeftFlipper, LFPress
		LF.Fire  'leftflipper.rotatetoend
'		RotateLaneLightsLeftUp
		
		If leftflipper.currentangle < leftflipper.endangle + ReflipAngle Then
			RandomSoundReflipUpLeft LeftFlipper
		Else
			SoundFlipperUpAttackLeft LeftFlipper
			RandomSoundFlipperUpLeft LeftFlipper
		End If
	Else
		PlaySoundAt SoundFXDOF("fx_flipperdown", 101, DOFOff, DOFFlippers), LeftFlipper
		FlipperDeActivate LeftFlipper, LFPress
		LeftFlipper.RotateToStart
		If LeftFlipper.currentangle < LeftFlipper.startAngle - 5 Then
			RandomSoundFlipperDownLeft LeftFlipper
		End If
		FlipperLeftHitParm = FlipperUpSoundLevel
	End If
End Sub


Sub SolRFlipper(Enabled) 'Right flipper solenoid callback
	If Enabled Then
		PlaySoundAt SoundFXDOF("fx_flipperup", 102, DOFOn, DOFFlippers), RightFlipper
		FlipperActivate RightFlipper, RFPress
		RF.Fire 'rightflipper.rotatetoend
'		RotateLaneLightsRightUp
		
		If rightflipper.currentangle > rightflipper.endangle - ReflipAngle Then
			RandomSoundReflipUpRight RightFlipper
		Else
			SoundFlipperUpAttackRight RightFlipper
			RandomSoundFlipperUpRight RightFlipper
		End If
	Else
		PlaySoundAt SoundFXDOF("fx_flipperdown", 102, DOFOff, DOFFlippers), RightFlipper
		FlipperDeActivate RightFlipper, RFPress
		RightFlipper.RotateToStart
		If RightFlipper.currentangle > RightFlipper.startAngle + 5 Then
			RandomSoundFlipperDownRight RightFlipper
		End If
		FlipperRightHitParm = FlipperUpSoundLevel
	End If
End Sub

Sub SolURFlipper(Enabled)
	If Enabled Then
		PlaySoundAt SoundFXDOF("fx_flipperup", 102, DOFOn, DOFFlippers), RightFlipper
		RightFlipper001.rotatetoend

		If RightFlipper001.currentangle > RightFlipper001.endangle - ReflipAngle Then
			RandomSoundReflipUpRight RightFlipper001
		Else 
			SoundFlipperUpAttackRight RightFlipper001
			RandomSoundFlipperUpRight RightFlipper001
		End If
	Else
		PlaySoundAt SoundFXDOF("fx_flipperdown", 102, DOFOff, DOFFlippers), RightFlipper
		RightFlipper001.RotateToStart
		If RightFlipper001.currentangle > RightFlipper001.startAngle + 5 Then
			RandomSoundFlipperDownRight RightFlipper001
		End If	
		FlipperRightHitParm = FlipperUpSoundLevel
	End If
End Sub

Sub SolULFlipper(Enabled)
	If Enabled Then
		PlaySoundAt SoundFXDOF("fx_flipperup", 101, DOFOn, DOFFlippers), LeftFlipper
		LeftFlipper001.rotatetoend

		If LeftFlipper001.currentangle > LeftFlipper001.endangle - ReflipAngle Then
			RandomSoundReflipUpRight LeftFlipper001
		Else 
			SoundFlipperUpAttackRight LeftFlipper001
			RandomSoundFlipperUpRight LeftFlipper001
		End If
	Else
		PlaySoundAt SoundFXDOF("fx_flipperdown", 101, DOFOff, DOFFlippers), LeftFlipper
		LeftFlipper001.RotateToStart
		If LeftFlipper001.currentangle > LeftFlipper001.startAngle + 5 Then
			RandomSoundFlipperDownRight LeftFlipper001
		End If	
		FlipperRightHitParm = FlipperUpSoundLevel
	End If
End Sub

' Flipper collide subs
Sub LeftFlipper_Collide(parm)
	CheckLiveCatch ActiveBall, LeftFlipper, LFCount, parm
	LF.ReProcessBalls ActiveBall
	LeftFlipperCollide parm
End Sub

Sub RightFlipper_Collide(parm)
	CheckLiveCatch ActiveBall, RightFlipper, RFCount, parm
	RF.ReProcessBalls ActiveBall
	RightFlipperCollide parm
End Sub


'******************************************************
'	ZNFF:  FLIPPER CORRECTIONS by nFozzy
'******************************************************
'
' There are several steps for taking advantage of nFozzy's flipper solution.  At a high level we'll need the following:
'	1. flippers with specific physics settings
'	2. custom triggers for each flipper (TriggerLF, TriggerRF)
'	3. and, special scripting
'
' TriggerLF and RF should now be 27 vp units from the flippers. In addition, 3 degrees should be added to the end angle
' when creating these triggers.
'
' RF.ReProcessBalls Activeball and LF.ReProcessBalls Activeball must be added the flipper_collide subs.
'
' A common mistake is incorrect flipper length.  A 3-inch flipper with rubbers will be about 3.125 inches long.
' This translates to about 147 vp units.  Therefore, the flipper start radius + the flipper length + the flipper end
' radius should  equal approximately 147 vp units. Another common mistake is is that sometimes the right flipper
' angle was set with a large postive value (like 238 or something). It should be using negative value (like -122).
'
' The following settings are a solid starting point for various eras of pinballs.
' |                    | EM's           | late 70's to mid 80's | mid 80's to early 90's | mid 90's and later |
' | ------------------ | -------------- | --------------------- | ---------------------- | ------------------ |
' | Mass               | 1              | 1                     | 1                      | 1                  |
' | Strength           | 500-1000 (750) | 1400-1600 (1500)      | 2000-2600              | 3200-3300 (3250)   |
' | Elasticity         | 0.88           | 0.88                  | 0.88                   | 0.88               |
' | Elasticity Falloff | 0.15           | 0.15                  | 0.15                   | 0.15               |
' | Fricition          | 0.8-0.9        | 0.9                   | 0.9                    | 0.9                |
' | Return Strength    | 0.11           | 0.09                  | 0.07                   | 0.055              |
' | Coil Ramp Up       | 2.5            | 2.5                   | 2.5                    | 2.5                |
' | Scatter Angle      | 0              | 0                     | 0                      | 0                  |
' | EOS Torque         | 0.4            | 0.4                   | 0.375                  | 0.375              |
' | EOS Torque Angle   | 4              | 4                     | 6                      | 6                  |
'

'******************************************************
' Flippers Polarity (Select appropriate sub based on era)
'******************************************************

Dim LF : Set LF = New FlipperPolarity
Dim RF : Set RF = New FlipperPolarity

InitPolarity

'*******************************************
' Early 90's and after

Sub InitPolarity()
	Dim x, a
	a = Array(LF, RF)
	For Each x In a
		x.AddPt "Ycoef", 0, RightFlipper.Y-65, 1 'disabled
		x.AddPt "Ycoef", 1, RightFlipper.Y-11, 1
		x.enabled = True
		x.TimeDelay = 60
		x.DebugOn=False ' prints some info in debugger

		x.AddPt "Polarity", 0, 0, 0
		x.AddPt "Polarity", 1, 0.05, - 5.5
		x.AddPt "Polarity", 2, 0.16, - 5.5
		x.AddPt "Polarity", 3, 0.20, - 0.75
		x.AddPt "Polarity", 4, 0.25, - 1.25
		x.AddPt "Polarity", 5, 0.3, - 1.75
		x.AddPt "Polarity", 6, 0.4, - 3.5
		x.AddPt "Polarity", 7, 0.5, - 5.25
		x.AddPt "Polarity", 8, 0.7, - 4.0
		x.AddPt "Polarity", 9, 0.75, - 3.5
		x.AddPt "Polarity", 10, 0.8, - 3.0
		x.AddPt "Polarity", 11, 0.85, - 2.5
		x.AddPt "Polarity", 12, 0.9, - 2.0
		x.AddPt "Polarity", 13, 0.95, - 1.5
		x.AddPt "Polarity", 14, 1, - 1.0
		x.AddPt "Polarity", 15, 1.05, -0.5
		x.AddPt "Polarity", 16, 1.1, 0
		x.AddPt "Polarity", 17, 1.3, 0

		x.AddPt "Velocity", 0, 0, 0.85
		x.AddPt "Velocity", 1, 0.23, 0.85
		x.AddPt "Velocity", 2, 0.27, 1
		x.AddPt "Velocity", 3, 0.3, 1
		x.AddPt "Velocity", 4, 0.35, 1
		x.AddPt "Velocity", 5, 0.6, 1 '0.982
		x.AddPt "Velocity", 6, 0.62, 1.0
		x.AddPt "Velocity", 7, 0.702, 0.968
		x.AddPt "Velocity", 8, 0.95,  0.968
		x.AddPt "Velocity", 9, 1.03,  0.945
		x.AddPt "Velocity", 10, 1.5,  0.945

	Next
	
	' SetObjects arguments: 1: name of object 2: flipper object: 3: Trigger object around flipper
	LF.SetObjects "LF", LeftFlipper, TriggerLF
	RF.SetObjects "RF", RightFlipper, TriggerRF
End Sub

'******************************************************
'  FLIPPER CORRECTION FUNCTIONS
'******************************************************

' modified 2023 by nFozzy
' Removed need for 'endpoint' objects
' Added 'createvents' type thing for TriggerLF / TriggerRF triggers.
' Removed AddPt function which complicated setup imo
' made DebugOn do something (prints some stuff in debugger)
'   Otherwise it should function exactly the same as before\
' modified 2024 by rothbauerw
' Added Reprocessballs for flipper collisions (LF.Reprocessballs Activeball and RF.Reprocessballs Activeball must be added to the flipper collide subs
' Improved handling to remove correction for backhand shots when the flipper is raised

Class FlipperPolarity
	Public DebugOn, Enabled
	Private FlipAt		'Timer variable (IE 'flip at 723,530ms...)
	Public TimeDelay		'delay before trigger turns off and polarity is disabled
	Private Flipper, FlipperStart, FlipperEnd, FlipperEndY, LR, PartialFlipCoef, FlipStartAngle
	Private Balls(20), balldata(20)
	Private Name
	
	Dim PolarityIn, PolarityOut
	Dim VelocityIn, VelocityOut
	Dim YcoefIn, YcoefOut
	Public Sub Class_Initialize
		ReDim PolarityIn(0)
		ReDim PolarityOut(0)
		ReDim VelocityIn(0)
		ReDim VelocityOut(0)
		ReDim YcoefIn(0)
		ReDim YcoefOut(0)
		Enabled = True
		TimeDelay = 50
		LR = 1
		Dim x
		For x = 0 To UBound(balls)
			balls(x) = Empty
			Set Balldata(x) = new SpoofBall
		Next
	End Sub
	
	Public Sub SetObjects(aName, aFlipper, aTrigger)
		
		If TypeName(aName) <> "String" Then MsgBox "FlipperPolarity: .SetObjects error: first argument must be a String (And name of Object). Found:" & TypeName(aName) End If
		If TypeName(aFlipper) <> "Flipper" Then MsgBox "FlipperPolarity: .SetObjects error: Second argument must be a flipper. Found:" & TypeName(aFlipper) End If
		If TypeName(aTrigger) <> "Trigger" Then MsgBox "FlipperPolarity: .SetObjects error: third argument must be a trigger. Found:" & TypeName(aTrigger) End If
		If aFlipper.EndAngle > aFlipper.StartAngle Then LR = -1 Else LR = 1 End If
		Name = aName
		Set Flipper = aFlipper
		FlipperStart = aFlipper.x
		FlipperEnd = Flipper.Length * Sin((Flipper.StartAngle / 57.295779513082320876798154814105)) + Flipper.X ' big floats for degree to rad conversion
		FlipperEndY = Flipper.Length * Cos(Flipper.StartAngle / 57.295779513082320876798154814105)*-1 + Flipper.Y
		
		Dim str
		str = "Sub " & aTrigger.name & "_Hit() : " & aName & ".AddBall ActiveBall : End Sub'"
		ExecuteGlobal(str)
		str = "Sub " & aTrigger.name & "_UnHit() : " & aName & ".PolarityCorrect ActiveBall : End Sub'"
		ExecuteGlobal(str)
		
	End Sub
	
	' Legacy: just no op
	Public Property Let EndPoint(aInput)
		
	End Property
	
	Public Sub AddPt(aChooseArray, aIDX, aX, aY) 'Index #, X position, (in) y Position (out)
		Select Case aChooseArray
			Case "Polarity"
				ShuffleArrays PolarityIn, PolarityOut, 1
				PolarityIn(aIDX) = aX
				PolarityOut(aIDX) = aY
				ShuffleArrays PolarityIn, PolarityOut, 0
			Case "Velocity"
				ShuffleArrays VelocityIn, VelocityOut, 1
				VelocityIn(aIDX) = aX
				VelocityOut(aIDX) = aY
				ShuffleArrays VelocityIn, VelocityOut, 0
			Case "Ycoef"
				ShuffleArrays YcoefIn, YcoefOut, 1
				YcoefIn(aIDX) = aX
				YcoefOut(aIDX) = aY
				ShuffleArrays YcoefIn, YcoefOut, 0
		End Select
	End Sub
	
	Public Sub AddBall(aBall)
		Dim x
		For x = 0 To UBound(balls)
			If IsEmpty(balls(x)) Then
				Set balls(x) = aBall
				Exit Sub
			End If
		Next
	End Sub
	
	Private Sub RemoveBall(aBall)
		Dim x
		For x = 0 To UBound(balls)
			If TypeName(balls(x) ) = "IBall" Then
				If aBall.ID = Balls(x).ID Then
					balls(x) = Empty
					Balldata(x).Reset
				End If
			End If
		Next
	End Sub
	
	Public Sub Fire()
		Flipper.RotateToEnd
		processballs
	End Sub
	
	Public Property Get Pos 'returns % position a ball. For debug stuff.
		Dim x
		For x = 0 To UBound(balls)
			If Not IsEmpty(balls(x)) Then
				pos = pSlope(Balls(x).x, FlipperStart, 0, FlipperEnd, 1)
			End If
		Next
	End Property
	
	Public Sub ProcessBalls() 'save data of balls in flipper range
		FlipAt = GameTime
		Dim x
		For x = 0 To UBound(balls)
			If Not IsEmpty(balls(x)) Then
				balldata(x).Data = balls(x)
			End If
		Next
		FlipStartAngle = Flipper.currentangle
		PartialFlipCoef = ((Flipper.StartAngle - Flipper.CurrentAngle) / (Flipper.StartAngle - Flipper.EndAngle))
		PartialFlipCoef = abs(PartialFlipCoef-1)
	End Sub

	Public Sub ReProcessBalls(aBall) 'save data of balls in flipper range
		If FlipperOn() Then
			Dim x
			For x = 0 To UBound(balls)
				If Not IsEmpty(balls(x)) Then
					if balls(x).ID = aBall.ID Then
						If isempty(balldata(x).ID) Then
							balldata(x).Data = balls(x)
						End If
					End If
				End If
			Next
		End If
	End Sub

	'Timer shutoff for polaritycorrect
	Private Function FlipperOn()
		If GameTime < FlipAt+TimeDelay Then
			FlipperOn = True
		End If
	End Function
	
	Public Sub PolarityCorrect(aBall)
		If FlipperOn() Then
			Dim tmp, BallPos, x, IDX, Ycoef, BalltoFlip, BalltoBase, NoCorrection, checkHit
			Ycoef = 1
			
			'y safety Exit
			If aBall.VelY > -8 Then 'ball going down
				RemoveBall aBall
				Exit Sub
			End If
			
			'Find balldata. BallPos = % on Flipper
			For x = 0 To UBound(Balls)
				If aBall.id = BallData(x).id And Not IsEmpty(BallData(x).id) Then
					idx = x
					BallPos = PSlope(BallData(x).x, FlipperStart, 0, FlipperEnd, 1)
					BalltoFlip = DistanceFromFlipperAngle(BallData(x).x, BallData(x).y, Flipper, FlipStartAngle)
					If ballpos > 0.65 Then  Ycoef = LinearEnvelope(BallData(x).Y, YcoefIn, YcoefOut)								'find safety coefficient 'ycoef' data
				End If
			Next
			
			If BallPos = 0 Then 'no ball data meaning the ball is entering and exiting pretty close to the same position, use current values.
				BallPos = PSlope(aBall.x, FlipperStart, 0, FlipperEnd, 1)
				If ballpos > 0.65 Then  Ycoef = LinearEnvelope(aBall.Y, YcoefIn, YcoefOut)												'find safety coefficient 'ycoef' data
				NoCorrection = 1
			Else
				checkHit = 50 + (20 * BallPos) 

				If BalltoFlip > checkHit or (PartialFlipCoef < 0.5 and BallPos > 0.22) Then
					NoCorrection = 1
				Else
					NoCorrection = 0
				End If
			End If
			
			'Velocity correction
			If Not IsEmpty(VelocityIn(0) ) Then
				Dim VelCoef
				VelCoef = LinearEnvelope(BallPos, VelocityIn, VelocityOut)
				
				'If partialflipcoef < 1 Then VelCoef = PSlope(partialflipcoef, 0, 1, 1, VelCoef)
				
				If Enabled Then aBall.Velx = aBall.Velx*VelCoef
				If Enabled Then aBall.Vely = aBall.Vely*VelCoef
			End If
			
			'Polarity Correction (optional now)
			If Not IsEmpty(PolarityIn(0) ) Then
				Dim AddX
				AddX = LinearEnvelope(BallPos, PolarityIn, PolarityOut) * LR
				
				If Enabled and NoCorrection = 0 Then aBall.VelX = aBall.VelX + 1 * (AddX*ycoef*PartialFlipcoef*VelCoef)
			End If
			If DebugOn Then debug.print "PolarityCorrect" & " " & Name & " @ " & GameTime & " " & Round(BallPos*100) & "%" & " AddX:" & Round(AddX,2) & " Vel%:" & Round(VelCoef*100)
		End If
		RemoveBall aBall
	End Sub
End Class

'******************************************************
'  FLIPPER POLARITY AND RUBBER DAMPENER SUPPORTING FUNCTIONS
'******************************************************

' Used for flipper correction and rubber dampeners
Sub ShuffleArray(ByRef aArray, byVal offset) 'shuffle 1d array
	Dim x, aCount
	aCount = 0
	ReDim a(UBound(aArray) )
	For x = 0 To UBound(aArray)		'Shuffle objects in a temp array
		If Not IsEmpty(aArray(x) ) Then
			If IsObject(aArray(x)) Then
				Set a(aCount) = aArray(x)
			Else
				a(aCount) = aArray(x)
			End If
			aCount = aCount + 1
		End If
	Next
	If offset < 0 Then offset = 0
	ReDim aArray(aCount-1+offset)		'Resize original array
	For x = 0 To aCount-1				'set objects back into original array
		If IsObject(a(x)) Then
			Set aArray(x) = a(x)
		Else
			aArray(x) = a(x)
		End If
	Next
End Sub

' Used for flipper correction and rubber dampeners
Sub ShuffleArrays(aArray1, aArray2, offset)
	ShuffleArray aArray1, offset
	ShuffleArray aArray2, offset
End Sub

' Used for flipper correction, rubber dampeners, and drop targets
Function BallSpeed(ball) 'Calculates the ball speed
	BallSpeed = Sqr(ball.VelX^2 + ball.VelY^2 + ball.VelZ^2)
End Function

' Used for flipper correction and rubber dampeners
Function PSlope(Input, X1, Y1, X2, Y2)		'Set up line via two points, no clamping. Input X, output Y
	Dim x, y, b, m
	x = input
	m = (Y2 - Y1) / (X2 - X1)
	b = Y2 - m*X2
	Y = M*x+b
	PSlope = Y
End Function

' Used for flipper correction
Class spoofball
	Public X, Y, Z, VelX, VelY, VelZ, ID, Mass, Radius
	Public Property Let Data(aBall)
		With aBall
			x = .x
			y = .y
			z = .z
			velx = .velx
			vely = .vely
			velz = .velz
			id = .ID
			mass = .mass
			radius = .radius
		End With
	End Property
	Public Sub Reset()
		x = Empty
		y = Empty
		z = Empty
		velx = Empty
		vely = Empty
		velz = Empty
		id = Empty
		mass = Empty
		radius = Empty
	End Sub
End Class

' Used for flipper correction and rubber dampeners
Function LinearEnvelope(xInput, xKeyFrame, yLvl)
	Dim y 'Y output
	Dim L 'Line
	'find active line
	Dim ii
	For ii = 1 To UBound(xKeyFrame)
		If xInput <= xKeyFrame(ii) Then
			L = ii
			Exit For
		End If
	Next
	If xInput > xKeyFrame(UBound(xKeyFrame) ) Then L = UBound(xKeyFrame)		'catch line overrun
	Y = pSlope(xInput, xKeyFrame(L-1), yLvl(L-1), xKeyFrame(L), yLvl(L) )
	
	If xInput <= xKeyFrame(LBound(xKeyFrame) ) Then Y = yLvl(LBound(xKeyFrame) )		 'Clamp lower
	If xInput >= xKeyFrame(UBound(xKeyFrame) ) Then Y = yLvl(UBound(xKeyFrame) )		'Clamp upper
	
	LinearEnvelope = Y
End Function

'******************************************************
'  FLIPPER TRICKS
'******************************************************
' To add the flipper tricks you must
'	 - Include a call to FlipperCradleCollision from within OnBallBallCollision subroutine
'	 - Include a call the CheckLiveCatch from the LeftFlipper_Collide and RightFlipper_Collide subroutines
'	 - Include FlipperActivate and FlipperDeactivate in the Flipper solenoid subs

RightFlipper.timerinterval = 1
Rightflipper.timerenabled = True

Sub RightFlipper_timer()
	FlipperTricks LeftFlipper, LFPress, LFCount, LFEndAngle, LFState
	FlipperTricks RightFlipper, RFPress, RFCount, RFEndAngle, RFState
	FlipperNudge RightFlipper, RFEndAngle, RFEOSNudge, LeftFlipper, LFEndAngle
	FlipperNudge LeftFlipper, LFEndAngle, LFEOSNudge,  RightFlipper, RFEndAngle
End Sub

Dim LFEOSNudge, RFEOSNudge

Sub FlipperNudge(Flipper1, Endangle1, EOSNudge1, Flipper2, EndAngle2)
	Dim b
	Dim BOT
	BOT = GetBalls
	
	If Flipper1.currentangle = Endangle1 And EOSNudge1 <> 1 Then
		EOSNudge1 = 1
		'   debug.print Flipper1.currentangle &" = "& Endangle1 &"--"& Flipper2.currentangle &" = "& EndAngle2
		If Flipper2.currentangle = EndAngle2 Then
			For b = 0 To UBound(BOT)
				If FlipperTrigger(BOT(b).x, BOT(b).y, Flipper1) Then
					'Debug.Print "ball in flip1. exit"
					Exit Sub
				End If
			Next
			For b = 0 To UBound(BOT)
				If FlipperTrigger(BOT(b).x, BOT(b).y, Flipper2) Then
					BOT(b).velx = BOT(b).velx / 1.3
					BOT(b).vely = BOT(b).vely - 0.5
				End If
			Next
		End If
	Else
		If Abs(Flipper1.currentangle) > Abs(EndAngle1) + 30 Then EOSNudge1 = 0
	End If
End Sub


Dim FCCDamping: FCCDamping = 0.4

Sub FlipperCradleCollision(ball1, ball2, velocity)
	if velocity < 0.7 then exit sub		'filter out gentle collisions
    Dim DoDamping, coef
    DoDamping = false
    'Check left flipper
    If LeftFlipper.currentangle = LFEndAngle Then
		If FlipperTrigger(ball1.x, ball1.y, LeftFlipper) OR FlipperTrigger(ball2.x, ball2.y, LeftFlipper) Then DoDamping = true
    End If
    'Check right flipper
    If RightFlipper.currentangle = RFEndAngle Then
		If FlipperTrigger(ball1.x, ball1.y, RightFlipper) OR FlipperTrigger(ball2.x, ball2.y, RightFlipper) Then DoDamping = true
    End If
    If DoDamping Then
		coef = FCCDamping
        ball1.velx = ball1.velx * coef: ball1.vely = ball1.vely * coef: ball1.velz = ball1.velz * coef
        ball2.velx = ball2.velx * coef: ball2.vely = ball2.vely * coef: ball2.velz = ball2.velz * coef
    End If
End Sub

'*************************************************
'  Check ball distance from Flipper for Rem
'*************************************************

Function Distance(ax,ay,bx,by)
	Distance = Sqr((ax - bx) ^ 2 + (ay - by) ^ 2)
End Function

Function DistancePL(px,py,ax,ay,bx,by) 'Distance between a point and a line where point Is px,py
	DistancePL = Abs((by - ay) * px - (bx - ax) * py + bx * ay - by * ax) / Distance(ax,ay,bx,by)
End Function

Function Radians(Degrees)
	Radians = Degrees * PI / 180
End Function

Function AnglePP(ax,ay,bx,by)
	AnglePP = Atn2((by - ay),(bx - ax)) * 180 / PI
End Function

Function DistanceFromFlipper(ballx, bally, Flipper)
	DistanceFromFlipper = DistancePL(ballx, bally, Flipper.x, Flipper.y, Cos(Radians(Flipper.currentangle + 90)) + Flipper.x, Sin(Radians(Flipper.currentangle + 90)) + Flipper.y)
End Function

Function DistanceFromFlipperAngle(ballx, bally, Flipper, Angle)
	DistanceFromFlipperAngle = DistancePL(ballx, bally, Flipper.x, Flipper.y, Cos(Radians(Angle + 90)) + Flipper.x, Sin(Radians(angle + 90)) + Flipper.y)
End Function

Function FlipperTrigger(ballx, bally, Flipper)
	Dim DiffAngle
	DiffAngle = Abs(Flipper.currentangle - AnglePP(Flipper.x, Flipper.y, ballx, bally) - 90)
	If DiffAngle > 180 Then DiffAngle = DiffAngle - 360
	
	If DistanceFromFlipper(ballx,bally,Flipper) < 48 And DiffAngle <= 90 And Distance(ballx,bally,Flipper.x,Flipper.y) < Flipper.Length Then
		FlipperTrigger = True
	Else
		FlipperTrigger = False
	End If
End Function

'*************************************************
'  End - Check ball distance from Flipper for Rem
'*************************************************

Dim LFPress, RFPress, LFCount, RFCount
Dim LFState, RFState
Dim EOST, EOSA,Frampup, FElasticity,FReturn
Dim RFEndAngle, LFEndAngle

Const FlipperCoilRampupMode = 0 '0 = fast, 1 = medium, 2 = slow (tap passes should work)

LFState = 1
RFState = 1
EOST = leftflipper.eostorque
EOSA = leftflipper.eostorqueangle
Frampup = LeftFlipper.rampup
FElasticity = LeftFlipper.elasticity
FReturn = LeftFlipper.return
'Const EOSTnew = 1.5 'EM's to late 80's - new recommendation by rothbauerw (previously 1)
Const EOSTnew = 1.2 '90's and later - new recommendation by rothbauerw (previously 0.8)
Const EOSAnew = 1
Const EOSRampup = 0
Dim SOSRampup
Select Case FlipperCoilRampupMode
	Case 0
		SOSRampup = 2.5
	Case 1
		SOSRampup = 6
	Case 2
		SOSRampup = 8.5
End Select

Const LiveCatch = 16
Const LiveElasticity = 0.45
Const SOSEM = 0.815
'   Const EOSReturn = 0.055  'EM's
'   Const EOSReturn = 0.045  'late 70's to mid 80's
Const EOSReturn = 0.035  'mid 80's to early 90's
'   Const EOSReturn = 0.025  'mid 90's and later

LFEndAngle = Leftflipper.endangle
RFEndAngle = RightFlipper.endangle

Sub FlipperActivate(Flipper, FlipperPress)
	FlipperPress = 1
	Flipper.Elasticity = FElasticity
	
	Flipper.eostorque = EOST
	Flipper.eostorqueangle = EOSA
End Sub

Sub FlipperDeactivate(Flipper, FlipperPress)
	FlipperPress = 0
	Flipper.eostorqueangle = EOSA
	Flipper.eostorque = EOST * EOSReturn / FReturn
	
	If Abs(Flipper.currentangle) <= Abs(Flipper.endangle) + 0.1 Then
		Dim b, BOT
		BOT = GetBalls
		
		For b = 0 To UBound(BOT)
			If Distance(BOT(b).x, BOT(b).y, Flipper.x, Flipper.y) < 55 Then 'check for cradle
				If BOT(b).vely >= - 0.4 Then BOT(b).vely =  - 0.4
			End If
		Next
	End If
End Sub

Sub FlipperTricks (Flipper, FlipperPress, FCount, FEndAngle, FState)
	Dim Dir
	Dir = Flipper.startangle / Abs(Flipper.startangle) '-1 for Right Flipper
	
	If Abs(Flipper.currentangle) > Abs(Flipper.startangle) - 0.05 Then
		If FState <> 1 Then
			Flipper.rampup = SOSRampup
			Flipper.endangle = FEndAngle - 3 * Dir
			Flipper.Elasticity = FElasticity * SOSEM
			FCount = 0
			FState = 1
		End If
	ElseIf Abs(Flipper.currentangle) <= Abs(Flipper.endangle) And FlipperPress = 1 Then
		If FCount = 0 Then FCount = GameTime
		
		If FState <> 2 Then
			Flipper.eostorqueangle = EOSAnew
			Flipper.eostorque = EOSTnew
			Flipper.rampup = EOSRampup
			Flipper.endangle = FEndAngle
			FState = 2
		End If
	ElseIf Abs(Flipper.currentangle) > Abs(Flipper.endangle) + 0.01 And FlipperPress = 1 Then
		If FState <> 3 Then
			Flipper.eostorque = EOST
			Flipper.eostorqueangle = EOSA
			Flipper.rampup = Frampup
			Flipper.Elasticity = FElasticity
			FState = 3
		End If
	End If
End Sub

Const LiveDistanceMin = 5  'minimum distance In vp units from flipper base live catch dampening will occur
Const LiveDistanceMax = 114 'maximum distance in vp units from flipper base live catch dampening will occur (tip protection)
Const BaseDampen = 0.55

Sub CheckLiveCatch(ball, Flipper, FCount, parm) 'Experimental new live catch
    Dim Dir, LiveDist
    Dir = Flipper.startangle / Abs(Flipper.startangle)    '-1 for Right Flipper
    Dim LiveCatchBounce   'If live catch is not perfect, it won't freeze ball totally
    Dim CatchTime
    CatchTime = GameTime - FCount
    LiveDist = Abs(Flipper.x - ball.x)

    If CatchTime <= LiveCatch And parm > 3 And LiveDist > LiveDistanceMin And LiveDist < LiveDistanceMax Then
        If CatchTime <= LiveCatch * 0.5 Then   'Perfect catch only when catch time happens in the beginning of the window
            LiveCatchBounce = 0
        Else
            LiveCatchBounce = Abs((LiveCatch / 2) - CatchTime)  'Partial catch when catch happens a bit late
        End If
        
        If LiveCatchBounce = 0 And ball.velx * Dir > 0 And LiveDist > 30 Then ball.velx = 0

        If ball.velx * Dir > 0 And LiveDist < 30 Then
            ball.velx = BaseDampen * ball.velx
            ball.vely = BaseDampen * ball.vely
            ball.angmomx = BaseDampen * ball.angmomx
            ball.angmomy = BaseDampen * ball.angmomy
            ball.angmomz = BaseDampen * ball.angmomz
        Elseif LiveDist > 30 Then
            ball.vely = LiveCatchBounce * (32 / LiveCatch) ' Multiplier for inaccuracy bounce
            ball.angmomx = 0
            ball.angmomy = 0
            ball.angmomz = 0
        End If
    Else
        If Abs(Flipper.currentangle) <= Abs(Flipper.endangle) + 1 Then FlippersD.Dampenf ActiveBall, parm
    End If
End Sub

'******************************************************
'****  END FLIPPER CORRECTIONS
'******************************************************
Sub leftInlaneSpeedLimit
	'Wylte's implementation
'    debug.print "Spin in: "& activeball.AngMomZ
'    debug.print "Speed in: "& activeball.vely
	if activeball.vely < 0 then exit sub 							'don't affect upwards movement
    activeball.AngMomZ = -abs(activeball.AngMomZ) * RndNum(3,6)
    If abs(activeball.AngMomZ) > 60 Then activeball.AngMomZ = 0.8 * activeball.AngMomZ
    If abs(activeball.AngMomZ) > 80 Then activeball.AngMomZ = 0.8 * activeball.AngMomZ
    If activeball.AngMomZ > 100 Then activeball.AngMomZ = RndNum(80,100)
    If activeball.AngMomZ < -100 Then activeball.AngMomZ = RndNum(-80,-100)

    if abs(activeball.vely) > 5 then activeball.vely = 0.8 * activeball.vely
    if abs(activeball.vely) > 10 then activeball.vely = 0.8 * activeball.vely
    if abs(activeball.vely) > 15 then activeball.vely = 0.8 * activeball.vely
    if activeball.vely > 16 then activeball.vely = RndNum(14,16)
    if activeball.vely < -16 then activeball.vely = RndNum(-14,-16)
'    debug.print "Spin out: "& activeball.AngMomZ
'    debug.print "Speed out: "& activeball.vely
End Sub


Sub rightInlaneSpeedLimit
	'Wylte's implementation
'    debug.print "Spin in: "& activeball.AngMomZ
'    debug.print "Speed in: "& activeball.vely
	if activeball.vely < 0 then exit sub 							'don't affect upwards movement
    activeball.AngMomZ = abs(activeball.AngMomZ) * RndNum(2,4)
    If abs(activeball.AngMomZ) > 60 Then activeball.AngMomZ = 0.8 * activeball.AngMomZ
    If abs(activeball.AngMomZ) > 80 Then activeball.AngMomZ = 0.8 * activeball.AngMomZ
    If activeball.AngMomZ > 100 Then activeball.AngMomZ = RndNum(80,100)
    If activeball.AngMomZ < -100 Then activeball.AngMomZ = RndNum(-80,-100)

	if abs(activeball.vely) > 5 then activeball.vely = 0.8 * activeball.vely
    if abs(activeball.vely) > 10 then activeball.vely = 0.8 * activeball.vely
    if abs(activeball.vely) > 15 then activeball.vely = 0.8 * activeball.vely
    if activeball.vely > 16 then activeball.vely = RndNum(14,16)
    if activeball.vely < -16 then activeball.vely = RndNum(-14,-16)
'    debug.print "Spin out: "& activeball.AngMomZ
'    debug.print "Speed out: "& activeball.vely
End Sub
'******************************************************
' 	ZDMP:  RUBBER  DAMPENERS
'******************************************************
' These are data mined bounce curves,
' dialed in with the in-game elasticity as much as possible to prevent angle / spin issues.
' Requires tracking ballspeed to calculate COR

Sub dPosts_Hit(idx)
	RubbersD.dampen ActiveBall
	TargetBouncer ActiveBall, 1
End Sub

Sub dSleeves_Hit(idx)
	SleevesD.Dampen ActiveBall
	TargetBouncer ActiveBall, 0.7
End Sub

Dim RubbersD				'frubber
Set RubbersD = New Dampener
RubbersD.name = "Rubbers"
RubbersD.debugOn = False	'shows info in textbox "TBPout"
RubbersD.Print = False	  'debug, reports In debugger (In vel, out cor); cor bounce curve (linear)

'for best results, try to match in-game velocity as closely as possible to the desired curve
'   RubbersD.addpoint 0, 0, 0.935   'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 0, 0, 1.1		 'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 1, 3.77, 0.97
RubbersD.addpoint 2, 5.76, 0.967	'dont take this as gospel. if you can data mine rubber elasticitiy, please help!
RubbersD.addpoint 3, 15.84, 0.874
RubbersD.addpoint 4, 56, 0.64	   'there's clamping so interpolate up to 56 at least

Dim SleevesD	'this is just rubber but cut down to 85%...
Set SleevesD = New Dampener
SleevesD.name = "Sleeves"
SleevesD.debugOn = False	'shows info in textbox "TBPout"
SleevesD.Print = False	  'debug, reports In debugger (In vel, out cor)
SleevesD.CopyCoef RubbersD, 0.85

'######################### Add new FlippersD Profile
'######################### Adjust these values to increase or lessen the elasticity

Dim FlippersD
Set FlippersD = New Dampener
FlippersD.name = "Flippers"
FlippersD.debugOn = False
FlippersD.Print = False
FlippersD.addpoint 0, 0, 1.1
FlippersD.addpoint 1, 3.77, 0.99
FlippersD.addpoint 2, 6, 0.99

Class Dampener
	Public Print, debugOn   'tbpOut.text
	Public name, Threshold  'Minimum threshold. Useful for Flippers, which don't have a hit threshold.
	Public ModIn, ModOut
	Private Sub Class_Initialize
		ReDim ModIn(0)
		ReDim Modout(0)
	End Sub
	
	Public Sub AddPoint(aIdx, aX, aY)
		ShuffleArrays ModIn, ModOut, 1
		ModIn(aIDX) = aX
		ModOut(aIDX) = aY
		ShuffleArrays ModIn, ModOut, 0
		If GameTime > 100 Then Report
	End Sub
	
	Public Sub Dampen(aBall)
		If threshold Then
			If BallSpeed(aBall) < threshold Then Exit Sub
		End If
		Dim RealCOR, DesiredCOR, str, coef
		DesiredCor = LinearEnvelope(cor.ballvel(aBall.id), ModIn, ModOut )
		RealCOR = BallSpeed(aBall) / (cor.ballvel(aBall.id) + 0.0001)
		coef = desiredcor / realcor
		If debugOn Then str = name & " In vel:" & Round(cor.ballvel(aBall.id),2 ) & vbNewLine & "desired cor: " & Round(desiredcor,4) & vbNewLine & _
		"actual cor: " & Round(realCOR,4) & vbNewLine & "ballspeed coef: " & Round(coef, 3) & vbNewLine
		If Print Then Debug.print Round(cor.ballvel(aBall.id),2) & ", " & Round(desiredcor,3)
		
		aBall.velx = aBall.velx * coef
		aBall.vely = aBall.vely * coef
		aBall.velz = aBall.velz * coef
		If debugOn Then TBPout.text = str
	End Sub
	
	Public Sub Dampenf(aBall, parm) 'Rubberizer is handle here
		Dim RealCOR, DesiredCOR, str, coef
		DesiredCor = LinearEnvelope(cor.ballvel(aBall.id), ModIn, ModOut )
		RealCOR = BallSpeed(aBall) / (cor.ballvel(aBall.id) + 0.0001)
		coef = desiredcor / realcor
		If Abs(aball.velx) < 2 And aball.vely < 0 And aball.vely >  - 3.75 Then
			aBall.velx = aBall.velx * coef
			aBall.vely = aBall.vely * coef
			aBall.velz = aBall.velz * coef
		End If
	End Sub
	
	Public Sub CopyCoef(aObj, aCoef) 'alternative addpoints, copy with coef
		Dim x
		For x = 0 To UBound(aObj.ModIn)
			addpoint x, aObj.ModIn(x), aObj.ModOut(x) * aCoef
		Next
	End Sub
	
	Public Sub Report() 'debug, reports all coords in tbPL.text
		If Not debugOn Then Exit Sub
		Dim a1, a2
		a1 = ModIn
		a2 = ModOut
		Dim str, x
		For x = 0 To UBound(a1)
			str = str & x & ": " & Round(a1(x),4) & ", " & Round(a2(x),4) & vbNewLine
		Next
		TBPout.text = str
	End Sub
End Class

'******************************************************
'  TRACK ALL BALL VELOCITIES
'  FOR RUBBER DAMPENER AND DROP TARGETS
'******************************************************

Dim cor
Set cor = New CoRTracker

Class CoRTracker
	Public ballvel, ballvelx, ballvely
	
	Private Sub Class_Initialize
		ReDim ballvel(0)
		ReDim ballvelx(0)
		ReDim ballvely(0)
	End Sub
	
	Public Sub Update()	'tracks in-ball-velocity
		Dim str, b, AllBalls, highestID
		allBalls = GetBalls
		
		For Each b In allballs
			If b.id >= HighestID Then highestID = b.id
		Next
		
		If UBound(ballvel) < highestID Then ReDim ballvel(highestID)	'set bounds
		If UBound(ballvelx) < highestID Then ReDim ballvelx(highestID)	'set bounds
		If UBound(ballvely) < highestID Then ReDim ballvely(highestID)	'set bounds
		
		For Each b In allballs
			ballvel(b.id) = BallSpeed(b)
			ballvelx(b.id) = b.velx
			ballvely(b.id) = b.vely
		Next
	End Sub
End Class

' Note, cor.update must be called in a 10 ms timer. The example table uses the GameTimer for this purpose, but sometimes a dedicated timer call RDampen is used.
'
'Sub RDampen_Timer
'	Cor.Update
'End Sub

Sub CorTimer_Timer()
	Cor.Update
End Sub

'******************************************************
'****  END PHYSICS DAMPENERS
'******************************************************

'******************************************************
' 	ZBOU: VPW TargetBouncer for targets and posts by Iaakki, Wrd1972, Apophis
'******************************************************

Const TargetBouncerEnabled = 1	  '0 = normal standup targets, 1 = bouncy targets
Const TargetBouncerFactor = 0.9	 'Level of bounces. Recommmended value of 0.7-1

Sub TargetBouncer(aBall,defvalue)
	Dim zMultiplier, vel, vratio
	If TargetBouncerEnabled = 1 And aball.z < 30 Then
		'   debug.print "velx: " & aball.velx & " vely: " & aball.vely & " velz: " & aball.velz
		vel = BallSpeed(aBall)
		If aBall.velx = 0 Then vratio = 1 Else vratio = aBall.vely / aBall.velx
		Select Case Int(Rnd * 6) + 1
			Case 1
				zMultiplier = 0.2 * defvalue
			Case 2
				zMultiplier = 0.25 * defvalue
			Case 3
				zMultiplier = 0.3 * defvalue
			Case 4
				zMultiplier = 0.4 * defvalue
			Case 5
				zMultiplier = 0.45 * defvalue
			Case 6
				zMultiplier = 0.5 * defvalue
		End Select
		aBall.velz = Abs(vel * zMultiplier * TargetBouncerFactor)
		aBall.velx = Sgn(aBall.velx) * Sqr(Abs((vel ^ 2 - aBall.velz ^ 2) / (1 + vratio ^ 2)))
		aBall.vely = aBall.velx * vratio
		'   debug.print "---> velx: " & aball.velx & " vely: " & aball.vely & " velz: " & aball.velz
		'   debug.print "conservation check: " & BallSpeed(aBall)/vel
	End If
End Sub

'Add targets or posts to the TargetBounce collection if you want to activate the targetbouncer code from them
Sub TargetBounce_Hit(idx)
	TargetBouncer ActiveBall, 1
End Sub

'******************************************************
'	ZSSC: SLINGSHOT CORRECTION FUNCTIONS by apophis
'******************************************************
' To add these slingshot corrections:
'	 - On the table, add the endpoint primitives that define the two ends of the Slingshot
'	 - Initialize the SlingshotCorrection objects in InitSlingCorrection
'	 - Call the .VelocityCorrect methods from the respective _Slingshot event sub

Dim LS
Set LS = New SlingshotCorrection
Dim RS
Set RS = New SlingshotCorrection

InitSlingCorrection

Sub InitSlingCorrection
	LS.Object = LeftSlingshot
	LS.EndPoint1 = EndPoint1LS
	LS.EndPoint2 = EndPoint2LS
	
	RS.Object = RightSlingshot
	RS.EndPoint1 = EndPoint1RS
	RS.EndPoint2 = EndPoint2RS
	
	'Slingshot angle corrections (pt, BallPos in %, Angle in deg)
	' These values are best guesses. Retune them if needed based on specific table research.
	AddSlingsPt 0, 0.00, - 4
	AddSlingsPt 1, 0.45, - 7
	AddSlingsPt 2, 0.48,	0
	AddSlingsPt 3, 0.52,	0
	AddSlingsPt 4, 0.55,	7
	AddSlingsPt 5, 1.00,	4
End Sub

Sub AddSlingsPt(idx, aX, aY)		'debugger wrapper for adjusting flipper script In-game
	Dim a
	a = Array(LS, RS)
	Dim x
	For Each x In a
		x.addpoint idx, aX, aY
	Next
End Sub

Class SlingshotCorrection
	Public DebugOn, Enabled
	Private Slingshot, SlingX1, SlingX2, SlingY1, SlingY2
	
	Public ModIn, ModOut
	
	Private Sub Class_Initialize
		ReDim ModIn(0)
		ReDim Modout(0)
		Enabled = True
	End Sub
	
	Public Property Let Object(aInput)
		Set Slingshot = aInput
	End Property
	
	Public Property Let EndPoint1(aInput)
		SlingX1 = aInput.x
		SlingY1 = aInput.y
	End Property
	
	Public Property Let EndPoint2(aInput)
		SlingX2 = aInput.x
		SlingY2 = aInput.y
	End Property
	
	Public Sub AddPoint(aIdx, aX, aY)
		ShuffleArrays ModIn, ModOut, 1
		ModIn(aIDX) = aX
		ModOut(aIDX) = aY
		ShuffleArrays ModIn, ModOut, 0
		If GameTime > 100 Then Report
	End Sub
	
	Public Sub Report() 'debug, reports all coords in tbPL.text
		If Not debugOn Then Exit Sub
		Dim a1, a2
		a1 = ModIn
		a2 = ModOut
		Dim str, x
		For x = 0 To UBound(a1)
			str = str & x & ": " & Round(a1(x),4) & ", " & Round(a2(x),4) & vbNewLine
		Next
		TBPout.text = str
	End Sub
	
	
	Public Sub VelocityCorrect(aBall)
		Dim BallPos, XL, XR, YL, YR
		
		'Assign right and left end points
		If SlingX1 < SlingX2 Then
			XL = SlingX1
			YL = SlingY1
			XR = SlingX2
			YR = SlingY2
		Else
			XL = SlingX2
			YL = SlingY2
			XR = SlingX1
			YR = SlingY1
		End If
		
		'Find BallPos = % on Slingshot
		If Not IsEmpty(aBall.id) Then
			If Abs(XR - XL) > Abs(YR - YL) Then
				BallPos = PSlope(aBall.x, XL, 0, XR, 1)
			Else
				BallPos = PSlope(aBall.y, YL, 0, YR, 1)
			End If
			If BallPos < 0 Then BallPos = 0
			If BallPos > 1 Then BallPos = 1
		End If
		
		'Velocity angle correction
		If Not IsEmpty(ModIn(0) ) Then
			Dim Angle, RotVxVy
			Angle = LinearEnvelope(BallPos, ModIn, ModOut)
			'   debug.print " BallPos=" & BallPos &" Angle=" & Angle
			'   debug.print " BEFORE: aBall.Velx=" & aBall.Velx &" aBall.Vely" & aBall.Vely
			RotVxVy = RotPoint(aBall.Velx,aBall.Vely,Angle)
			If Enabled Then aBall.Velx = RotVxVy(0)
			If Enabled Then aBall.Vely = RotVxVy(1)
			'   debug.print " AFTER: aBall.Velx=" & aBall.Velx &" aBall.Vely" & aBall.Vely
			'   debug.print " "
		End If
	End Sub
End Class


'*********
' TILT
'*********

'NOTE: The TiltDecreaseTimer Subtracts .01 from the "Tilt" variable every round

Sub CheckTilt                                    'Called when table is nudged
    Tilt = Tilt + TiltSensitivity                'Add to tilt count
    TiltDecreaseTimer.Enabled = True
    If(Tilt> TiltSensitivity) AND(Tilt <15) Then 'show a warning
        'DMD "_", CL(1, "CAREFUL!"), "", eNone, eBlinkFast, eNone, 500, True, ""
    End if
    If Tilt> 15 Then 'If more that 15 then TILT the table
        Tilted = True
        'display Tilt
        'DMDFlush
		DOF 400, DOFPulse
        pupDMDDisplay "Splash","TILT","",3,0,20
        DisableTable True
        TiltRecoveryTimer.Enabled = True 'start the Tilt delay to check for all the balls to be drained
    End If
End Sub

Sub TiltDecreaseTimer_Timer
    ' DecreaseTilt
    If Tilt> 0 Then
        Tilt = Tilt - 0.1
    Else
        TiltDecreaseTimer.Enabled = False
    End If
End Sub

Sub DisableTable(Enabled)
    If Enabled Then
        'turn off GI and turn off all the lights
        GiOff
		B2SGIOff
        LightSeqTilt.Play SeqAllOff
        'Disable slings, bumpers etc
        LeftFlipper.RotateToStart
        RightFlipper.RotateToStart
        LeftSlingshot.Disabled = 1
        RightSlingshot.Disabled = 1
    Else
        'turn back on GI and the lights
        GiOn
		B2SGIOn
        LightSeqTilt.StopPlay
        LeftSlingshot.Disabled = 0
        RightSlingshot.Disabled = 0
        'clean up the buffer display
        'DMDFlush
    End If
End Sub

Sub TiltRecoveryTimer_Timer()
    ' if all the balls have been drained then..
    If(BallsOnPlayfield = 0) Then
        ' do the normal end of ball thing (this doesn't give a bonus if the table is tilted)
        EndOfBall()
        TiltRecoveryTimer.Enabled = False
    End If
' else retry (checks again in another second or so)
End Sub

'********************
' Music as wav sounds
'********************

Dim Song, UpdateMusic
Song = ""

Sub PlaySong(name)
    If bMusicOn Then
        If Song <> name Then
            StopSound Song
            Song = name
            PlaySound Song, -1, SongVolume
        End If
    End If
End Sub

Sub StopSong
    If bMusicOn Then
        StopSound Song
        Song = ""
    End If
End Sub

Sub ChangeSong
    If(BallsOnPlayfield = 0)Then
        PlaySong ""'"Mu_end"
        Exit Sub
    End If

    If bAttractMode Then
        PlaySong ""'"Mu_end"
        Exit Sub
    End If
    If bMultiBallMode Then
        PlaySong "" '"Mu_MB"
    Else
        UpdateMusicNow
    end if
End Sub

'if you add more balls to the game use changesong then if bMultiBallMode = true, your multiball song will be played.

Sub UpdateMusicNow
    Select Case UpdateMusic
        Case 0:PlaySong "Mu_1"
        Case 1:PlaySong "Mu_1"
        Case 2:PlaySong "Mu_1"
        Case 3:PlaySong "Mu_1"
        Case 4:PlaySong "Mu_1"
    End Select
end sub

'********************
' Play random quotes
'********************

Sub PlayQuote
    Dim tmp
    tmp = INT(RND * 123) + 1
    PlaySound "HIT_" &tmp
End Sub

'******************************************
' Change light color - simulate color leds
' changes the light color and state
' 10 colors: red, orange, amber, yellow...
'******************************************
' in this table this colors are use to keep track of the progress during the acts and battles

'colors
Dim red, orange, amber, yellow, darkgreen, green, blue, darkblue, purple, white, base, baseLB, baseLH

red = 10
orange = 9
amber = 8
yellow = 7
darkgreen = 6
green = 5
blue = 4
darkblue = 3
purple = 2
white = 1
base = 11
baseLB = 12
baseLH = 13

Sub SetLightColor(n, col, stat)
	Select Case col
		Case red
			n.color = RGB(255, 0, 0)
			n.colorfull = RGB(255, 0, 0)
'			n.color = RGB(18, 0, 0)
'			n.colorfull = RGB(255, 0, 0)
		Case orange
			n.color = RGB(255, 64, 0)
			n.colorfull = RGB(255, 64, 0)
'			n.color = RGB(18, 3, 0)
'			n.colorfull = RGB(255, 64, 0)
		Case amber
			n.color = RGB(193, 49, 0)
			n.colorfull = RGB(255, 153, 0)
		Case yellow
			n.color = RGB(18, 18, 0)
			n.colorfull = RGB(255, 255, 0)
		Case darkgreen
			n.color = RGB(0, 8, 0)
			n.colorfull = RGB(0, 64, 0)
		Case green
			n.color = RGB(0, 255, 0)
'			n.color = RGB(0, 18, 0)
			n.colorfull = RGB(0, 255, 0)
		Case blue
			n.color = RGB(0, 18, 18)
			n.colorfull = RGB(0, 255, 255)
		Case darkblue
			n.color = RGB(0, 8, 8)
			n.colorfull = RGB(0, 64, 64)
		Case purple
			n.color = RGB(128, 0, 128)
			n.colorfull = RGB(255, 0, 255)
		Case white
			n.color = RGB(255, 252, 224)
			n.colorfull = RGB(193, 91, 0)
'		Case white
'			n.color = RGB(255, 252, 224)
'			n.colorfull = RGB(193, 91, 0)
		Case base
			n.color = RGB(255, 197, 143)
			n.colorfull = RGB(255, 255, 236)
		Case baseLB
			n.color = RGB(0, 0, 160)
			n.colorfull = RGB(0, 0, 160)
		Case baseLH
			n.color = RGB(34, 100, 255)
			n.colorfull = RGB(34, 100, 255)
	End Select
	If stat <> -1 Then
		n.State = 0
		n.State = stat
	End If
End Sub
'**********************
'     GI effects
' independent routine
' it turns on the gi
' when there is a ball
' in play
'**********************
'B2S GI On and Off support
Sub B2SGIOn
	If B2SOn Then Controller.B2SSetData 1,1
End Sub
Sub B2SGIOff
	If B2SOn Then Controller.B2SSetData 1,0
End Sub

Dim OldGiState
OldGiState = -1   'start witht the Gi off

Sub ChangeGi(col) 'changes the gi color
    Dim bulb
    For each bulb in aGILights
        SetLightColor bulb, col, -1
    Next
End Sub

Sub GIUpdateTimer_Timer
    Dim tmp, obj
    tmp = Getballs
    If UBound(tmp) <> OldGiState Then
        OldGiState = Ubound(tmp)
        If UBound(tmp) = -1 Then 'we have 2 captive balls on the table (-1 means no balls, 0 is the first ball, 1 is the second..)
            GiOff               ' turn off the gi if no active balls on the table, we could also have used the variable ballsonplayfield.
        Else
            Gion
        End If
    End If
End Sub

Sub GiOn
    DOF 127, DOFOn
    Dim bulb
    For each bulb in aGiLights
        bulb.State = 1
    Next
    For each bulb in aBumperLights
        bulb.State = 1
    Next
	table1.ColorGradeImage = "ColorGradeLUT256x16_1to2"
End Sub

Sub GiOff
    DOF 127, DOFOff
    Dim bulb
    For each bulb in aGiLights
        bulb.State = 0
    Next
    For each bulb in aBumperLights
        bulb.State = 0
    Next
	table1.ColorGradeImage = "ColorGradeLUT256x16_1to3"
End Sub

' GI, light & flashers sequence effects

Sub GiEffect(n)
    Dim ii
    Select Case n
        Case 0 'all off
            LightSeqGi.Play SeqAlloff
        Case 1 'all blink
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqBlinking, , 15, 10
        Case 2 'random
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqRandom, 50, , 1000
        Case 3 'all blink fast
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqBlinking, , 10, 10
        Case 4 'all blink once
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqBlinking, , 4, 1
    End Select
End Sub

Sub LightEffect(n)
    Select Case n
        Case 0 ' all off
            LightSeqInserts.Play SeqAlloff
        Case 1 'all blink
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqBlinking, , 15, 10
        Case 2 'random
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqRandom, 50, , 1000
        Case 3 'all blink fast
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqBlinking, , 10, 10
        Case 4 'up 1 time
            LightSeqInserts.UpdateInterval = 4
            LightSeqInserts.Play SeqUpOn, 8, 1
        Case 5 'up 2 times
            LightSeqInserts.UpdateInterval = 4
            LightSeqInserts.Play SeqUpOn, 8, 2
        Case 6 'down 1 time
            LightSeqInserts.UpdateInterval = 4
            LightSeqInserts.Play SeqDownOn, 8, 1
        Case 7 'down 2 times
            LightSeqInserts.UpdateInterval = 4
            LightSeqInserts.Play SeqDownOn, 8, 2
    End Select
End Sub

' *********************************************************************
'                      Supporting Ball & Sound Functions
' *********************************************************************

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
    Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function Pan(ball) ' Calculates the pan for a ball based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = ball.x * 2 / table1.width-1
    If tmp > 0 Then
        Pan = Csng(tmp ^10)
    Else
        Pan = Csng(-((- tmp) ^10))
    End If
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
    Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
    BallVel = (SQR((ball.VelX ^2) + (ball.VelY ^2)))
End Function

Sub PlaySoundAt(soundname, tableobj) 'play sound at X and Y position of an object, mostly bumpers, flippers and other fast objects
    PlaySound soundname, 0, 1, Pan(tableobj), 0.06, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname) ' play a sound at the ball position, like rubbers, targets, metals, plastics
    PlaySound soundname, 0, Vol(ActiveBall), pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Function RndNbr(n) 'returns a random number between 1 and n
    Randomize timer
    RndNbr = Int((n * Rnd) + 1)
End Function
'********************************************
'   JP's VP10 Rolling Sounds
'********************************************

Const tnob = 11 ' total number of balls
Const lob = 0   'number of locked balls
ReDim rolling(tnob)
InitRolling

Sub InitRolling
    Dim i
    For i = 0 to tnob
        rolling(i) = False
    Next
End Sub

Sub RollingUpdate()
    Dim BOT, b, ballpitch, ballvol
    BOT = GetBalls

    ' stop the sound of deleted balls
    For b = UBound(BOT) + 1 to tnob
        rolling(b) = False
        StopSound("fx_ballrolling" & b)
    Next

    ' exit the sub if no balls on the table
    If UBound(BOT) = lob - 1 Then Exit Sub 'there no extra balls on this table

    ' play the rolling sound for each ball
    For b = lob to UBound(BOT)

        If BallVel(BOT(b) )> 1 Then
            If BOT(b).z <30 Then
                ballpitch = Pitch(BOT(b) )
                ballvol = Vol(BOT(b) )
            Else
                ballpitch = Pitch(BOT(b) ) + 25000 'increase the pitch on a ramp
                ballvol = Vol(BOT(b) ) * 10
            End If
            rolling(b) = True
            PlaySound("fx_ballrolling" & b), -1, ballvol, Pan(BOT(b) ), 0, ballpitch, 1, 0, AudioFade(BOT(b) )
        Else
            If rolling(b) = True Then
                StopSound("fx_ballrolling" & b)
                rolling(b) = False
            End If
        End If
        ' rothbauerw's Dropping Sounds
        If BOT(b).VelZ <-1 and BOT(b).z <55 and BOT(b).z> 27 Then 'height adjust for ball drop sounds
            PlaySound "fx_balldrop", 0, ABS(BOT(b).velz) / 17, Pan(BOT(b) ), 0, Pitch(BOT(b) ), 1, 0, AudioFade(BOT(b) )
        End If
    Next
End Sub

'**********************
' Ball Collision Sound
'**********************

Sub OnBallBallCollision(ball1, ball2, velocity)
    PlaySound "fx_collide", 0, Csng(velocity) ^2 / 2000, Pan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub

'******************************
' Diverse Collection Hit Sounds
'******************************

'Sub aMetals_Hit(idx):PlaySoundAtBall "fx_MetalHit":End Sub
'Sub aRubber_Bands_Hit(idx):PlaySoundAtBall "fx_rubber_band":End Sub
'Sub aRubber_Posts_Hit(idx):PlaySoundAtBall "fx_rubber_post":End Sub
'Sub aRubber_Pins_Hit(idx):PlaySoundAtBall "fx_rubber_pin":End Sub
'Sub aPlastics_Hit(idx):PlaySoundAtBall "fx_PlasticHit":End Sub
'Sub aGates_Hit(idx):PlaySoundAtBall "fx_Gate":End Sub
'Sub aWoods_Hit(idx):PlaySoundAtBall "fx_Woodhit":End Sub

Sub RHelp1_Hit()
    StopSound "fx_metalrolling"
    PlaySoundAtBall "fx_ballrampdrop"
End Sub

Sub RHelp2_Hit()
    StopSound "fx_metalrolling"
    PlaySoundAtBall"fx_ballrampdrop"
End Sub



' *********************************************************************
'                        User Defined Script Events
' *********************************************************************

' Initialise the Table for a new Game
'
Sub ResetForNewGame()
    Dim i

    bGameInPLay = True

    'resets the score display, and turn off attract mode
    StopAttractMode
	ResetEvents
    GiOn
	B2SGIOn

    TotalGamesPlayed = TotalGamesPlayed + 1
    CurrentPlayer = 1
    PlayersPlayingGame = 1
    bOnTheFirstBall = True
	'Multiball=false	
    For i = 1 To MaxPlayers
        PlayerScore(i) = 0
        BonusPoints(i) = 0
		'BonusHeldPoints(i) = 0
        BonusMultiplier(i) = 1
        BallsRemaining(i) = BallsPerGame
		BallinGame(i) = 1
        ExtraBallsAwards(i) = 0
        Special1Awarded(i) = False
        Special2Awarded(i) = False
        Special3Awarded(i) = False
    Next
	If B2SOn Then Controller.B2SSetScorePlayer 1, 0

    ' initialise any other flags
    Tilt = 0

	'reset variables
	bumperHits = 100

    UpdateMusic = 0
    'UpdateMusic = UpdateMusic + 6
    UpdateMusicNow

    ' initialise Game variables
    Game_Init()
	
    ' you may wish to start some music, play a sound, do whatever at this point
StopSong
PlaySound ""


    vpmtimer.addtimer 1500, "FirstBall '"
End Sub

' This is used to delay the start of a game to allow any attract sequence to

' complete.  When it expires it creates a ball for the player to start playing with

Sub FirstBall
	ResetEvents
'	PlaySound "Vo_Start"
    ' reset the table for a new ball
    ResetForNewPlayerBall()
    ' create a new ball in the shooters lane
    CreateNewBall()
End Sub

' (Re-)Initialise the Table for a new ball (either a new ball after the player has
' lost one or we have moved onto the next player (if multiple are playing))

Sub ResetForNewPlayerBall()
    ' make sure the correct display is upto date
    AddScore 0

    ' set the current players bonus multiplier back down to 1X
    BonusMultiplier(CurrentPlayer) = 1
    'UpdateBonusXLights
	
' reset any drop targets, lights, game Mode etc..
	CheckEventPlayer
    
   'This is a new ball, so activate the ballsaver
    bBallSaverReady = True

    'Reset any table specific
'	BumperBonus = 0
'	HoleBonus = 0
'	ALLRampBonus = 0
'	RampBonus1 = 0
'	RampBonus2 = 0
'	RampBonus3 = 0
	JackpotsBonus = 0
'	MulitballBonus = 0
    ResetNewBallVariables
    ResetNewBallLights()
	'Multiball=false	
End Sub

' Create a new ball on the Playfield

Sub CreateNewBall()
    
	LightSeqAttract.StopPlay

	' create a ball in the plunger lane kicker.
    BallRelease.CreateSizedBallWithMass BallSize / 2, BallMass

    ' There is a (or another) ball on the playfield
    BallsOnPlayfield = BallsOnPlayfield + 1

    ' kick it out..
    PlaySoundAt SoundFXDOF("fx_Ballrel", 123, DOFPulse, DOFContactors), BallRelease
    BallRelease.Kick 90, 4

	'only this tableDrain / Plunger Functions
	'ChangeBallImage

 '   If BallsOnPlayfield> 2 Then
 '       bMultiBallMode = True
 '       bAutoPlunger = True
 '       'ChangeSong
 '   End If

End Sub


' Add extra balls to the table with autoplunger
' Use it as AddMultiball 4 to add 4 extra balls to the table

Sub AddMultiball(nballs)
	Plunger.Pullback
	vpmtimer.addtimer 400, "Plunger.Fire '"
    mBalls2Eject = mBalls2Eject + nballs
    CreateMultiballTimer.Enabled = True
    'and eject the first ball
    CreateMultiballTimer_Timer
End Sub

' Eject the ball after the delay, AddMultiballDelay
Sub CreateMultiballTimer_Timer()
    ' wait if there is a ball in the plunger lane
    If bBallInPlungerLane Then
        Exit Sub
    Else
        If BallsOnPlayfield < MaxMultiballs Then
            CreateNewBall()
            mBalls2Eject = mBalls2Eject -1
            If mBalls2Eject = 0 Then 'if there are no more balls to eject then stop the timer
                CreateMultiballTimer.Enabled = False
            End If
        Else 'the max number of multiballs is reached, so stop the timer
            mBalls2Eject = 0
            CreateMultiballTimer.Enabled = False
        End If
    End If
End Sub


' The Player has lost his ball (there are no more balls on the playfield).
' Handle any bonus points awarded

Sub EndOfBall()
	Dim BonusDelayTime
	' the first ball has been lost. From this point on no new players can join in
    bOnTheFirstBall = False

    ' only process any of this if the table is not tilted.  (the tilt recovery
    ' mechanism will handle any extra balls or end of game)

	'LightSeqAttract.Play SeqBlinking, , 5, 150

StopSong
'bonuscheckie

    Dim AwardPoints, TotalBonus, ii
	AwardPoints = 0
    TotalBonus = 0

    'If NOT Tilted Then
	If(Tilted = False) Then
		
        'Bonus
'		PuPlayer.LabelShowPage pBackglass,1,0,""
	
'		PuPlayer.LabelSet pBackglass,"Bonus1", FormatNumber(JackpotsBonus,0),1,"{'mt':2,'color':13264128, 'size': 4 }"
'		AwardPoints = JackpotsBonus * 5000
'       TotalBonus = TotalBonus + AwardPoints

'		PuPlayer.LabelSet pBackglass,"Bonus2", FormatNumber(RaiderBonus,0),1,"{'mt':2,'color':55660, 'size': 4 }"
'		AwardPoints = RaiderBonus * 2000
'       TotalBonus = TotalBonus + AwardPoints

'		PuPlayer.LabelSet pBackglass,"Bonus3", FormatNumber(CroftBonus,0),1,"{'mt':2,'color':3739322, 'size': 4 }"
'		AwardPoints = CroftBonus * 2000
'       TotalBonus = TotalBonus + AwardPoints

'		PuPlayer.LabelSet pBackglass,"Bonus4", FormatNumber(RelicsBonus,0),1,"{'mt':2,'color':25542, 'size': 4 }"
'		AwardPoints = RelicsBonus * 15000
'       TotalBonus = TotalBonus + AwardPoints

'		PuPlayer.LabelSet pBackglass,"Bonus5", FormatNumber(ArtefactsBonus,0),1,"{'mt':2,'color':5602052, 'size': 4 }"
'		AwardPoints = ArtefactsBonus * 10000
       TotalBonus = TotalBonus + AwardPoints
        
'		PuPlayer.LabelSet pBackglass,"BonusTotal", FormatNumber(TotalBonus,0),1,"{'mt':2,'color':16777215, 'size': 4 }"	
        TotalBonus = TotalBonus * BonusMultiplier(CurrentPlayer)
       
'		SeqBonus
'		vpmtimer.addtimer 2500, "AddScore TotalBonus '"
'		AddScore TotalBonus

		' add a bit of a delay to allow for the bonus points to be shown & added up
		vpmtimer.addtimer 6000, "resetbackglassOFFScore '"
		vpmtimer.addtimer 6000, "EndOfBall2 '"
    Else 'Si hay falta simplemente espera un momento y va directo a la segunta parte después de perder la bola
		BonusDelayTime = 100
		EndOfBall2
    End If
	'vpmtimer.addtimer BonusDelayTime, "EndOfBall2 '"
End Sub

' The Timer which delays the machine to allow any bonus points to be added up
' has expired.  Check to see if there are any extra balls for this player.
' if not, then check to see if this was the last ball (of the CurrentPlayer)
'
Sub EndOfBall2()
    ' if were tilted, reset the internal tilted flag (this will also
    ' set TiltWarnings back to zero) which is useful if we are changing player LOL
    UpdateMusic = UpdateMusic + 1
	UpdateMusicNow	
    Tilted = False
    Tilt = 0
    DisableTable False 'enable again bumpers and slingshots

    ' has the player won an extra-ball ? (might be multiple outstanding)
    If(ExtraBallsAwards(CurrentPlayer) <> 0) Then
        'debug.print "Extra Ball"

        ' yep got to give it to them
        ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer) - 1

        ' if no more EB's then turn off any shoot again light
        If(ExtraBallsAwards(CurrentPlayer) = 0) Then
           LiMi004.State = 0
        End If

        ' You may wish to do a bit of a song AND dance at this point
        'DMD CL(0, "EXTRA BALL"), CL(1, "SHOOT AGAIN"), "", eNone, eNone, eBlink, 1000, True, "vo_extraball"

		UpdateMusic = UpdateMusic - 1
		UpdateMusicNow

        ' reset the playfield for the new ball
        ResetForNewPlayerBall()
		
		' set the dropped wall for bonus

		
        ' Create a new ball in the shooters lane
        CreateNewBall()
    Else ' no extra balls

        BallsRemaining(CurrentPlayer) = BallsRemaining(CurrentPlayer) - 1
		BallinGame(CurrentPlayer) = BallinGame(CurrentPlayer) + 1

        ' was that the last ball ?
        If(BallsRemaining(CurrentPlayer) <= 0) Then
			BallinGame(CurrentPlayer) = BallsPerGame
            'debug.print "No More Balls, High Score Entry"

            ' Submit the CurrentPlayers score to the High Score system
            CheckHighScore()
        ' you may wish to play some music at this point

        Else

            ' not the last ball (for that player)
            ' if multiple players are playing then move onto the next one
            EndOfBallComplete()
        End If
    End If
End Sub

' This function is called when the end of bonus display
' (or high score entry finished) AND it either end the game or
' move onto the next player (or the next ball of the same player)
'
Sub EndOfBallComplete()
    Dim NextPlayer

    'debug.print "EndOfBall - Complete"

    ' are there multiple players playing this game ?
    If(PlayersPlayingGame> 1) Then
        ' then move to the next player
        NextPlayer = CurrentPlayer + 1
        ' are we going from the last player back to the first
        ' (ie say from player 4 back to player 1)
        If(NextPlayer> PlayersPlayingGame) Then
            NextPlayer = 1
        End If
    Else
        NextPlayer = CurrentPlayer
    End If

    'debug.print "Next Player = " & NextPlayer

    ' is it the end of the game ? (all balls been lost for all players)
    If((BallsRemaining(CurrentPlayer) <= 0) AND(BallsRemaining(NextPlayer) <= 0) ) Then
        ' you may wish to do some sort of Point Match free game award here
        ' generally only done when not in free play mode
		StopSong
		'DMD CL(0, "GAME OVER") "", eNone, 13000, True, ""
		'DMD "", CL(1, "GAME OVER"), "", eNone, eNone, eNone, 13000, False, ""
'		PuPEvent 118
        ' set the machine into game over mode
'		vpmtimer.addtimer 3000, "Wall037.Collidable = False '"
'		If MIGreenActive(CurrentPlayer) = True Then SolKittRampToy 1
		If KittDown = False Then SolKittRampToy 1
		If DoorOpen=True Then SolTruckRamp 1
		vpmtimer.addtimer 3000, "DrainBallLock '"
        vpmtimer.addtimer 4000, "EndOfGame() '"
		vpmtimer.addtimer 6800, "pDMDGameOver '"
		
    ' you may wish to put a Game Over message on the desktop/backglass

    Else
        ' set the next player
        CurrentPlayer = NextPlayer

        ' make sure the correct display is up to date
        'DMDScoreNow

        ' reset the playfield for the new player (or new ball)
        ResetForNewPlayerBall()

        ' AND create a new ball
        CreateNewBall()

        ' play a sound if more than 1 player
        If PlayersPlayingGame> 1 Then
            PlaySound "vo_player" &CurrentPlayer
            'DMD "_", CL(1, "PLAYER " &CurrentPlayer), "", eNone, eNone, eNone, 800, True, ""
        End If
    End If
End Sub

' This function is called at the End of the Game, it should reset all
' Drop targets, AND eject any 'held' balls, start any attract sequences etc..

Sub EndOfGame()
    LightSeqAttract.StopPlay
	'debug.print "End Of Game"
    bGameInPLay = False
    ' just ended your game then play the end of game tune
    If NOT bJustStarted Then
        ChangeSong
    End If

    bJustStarted = False
    ' ensure that the flippers are down
    SolLFlipper 0
    SolRFlipper 0
	SolURFlipper 0
	SolULFlipper 0
	

    ' terminate all Mode - eject locked balls
    ' most of the Mode/timers terminate at the end of the ball

    ' set any lights for the attract mode
    GiOff
	B2SGIOff
    StartAttractMode
	ResetEvents
' you may wish to light any Game Over Light you may have
End Sub

Function BallsFunc
    Dim tmp
    tmp = BallsPerGame - BallsRemaining(CurrentPlayer) + 1
    If tmp> BallsPerGame Then
        BallsFunc = BallsPerGame
    Else
        BallsFunc = tmp
    End If
End Function

' *********************************************************************
'                      Drain / Plunger Functions
' *********************************************************************

' lost a ball ;-( check to see how many balls are on the playfield.
' if only one then decrement the remaining count AND test for End of game
' if more than 1 ball (multi-ball) then kill of the ball but don't create
' a new one
'
Sub Drain_Hit()
    ' Destroy the ball
    Drain.DestroyBall
    BallsOnPlayfield = BallsOnPlayfield - 1 
	'If BallsOnPlayfield<2 Then
	'Multiball=false
	'end if
	
    ' pretend to knock the ball into the ball storage mech
    PlaySoundAt "fx_drain", Drain
    'if Tilted then end Ball Mode
    If Tilted Then
        StopEndOfBallMode
    End If

    ' if there is a game in progress AND it is not Tilted
    If(bGameInPLay = True) AND(Tilted = False) Then

        ' is the ball saver active,
        If(bBallSaverActive = True) Then
	AddMultiball 1
	DOF 132, DOFPulse
	pupDMDDisplay "Splash4","Ball^SAVED","",3,1,10
	PlaySoundBsave
	bAutoPlunger = True
            ' yep, create a new ball in the shooters lane
            ' we use the Addmultiball in case the multiballs are being ejected
    'vpmtimer.addtimer 1250, "CreateNewBall() '"

           ' you may wish to put something on a display or play a sound at this point

            
        Else

			If(BallsOnPlayfield = 1)Then
                ' AND in a multi-ball??
                If(bMultiBallMode = True)then
                    ' not in multiball mode any more
					Mode_Multiball_End
                    bMultiBallMode = False		
                    ' you may wish to change any music over at this point and
                    ' turn off any multiball specific lights
					StopSong
					ChangeSong
                End If
            End If
            ' was that the last ball on the playfield
            If(BallsOnPlayfield = 0) Then
                ' End Mode and timers
				RampMCount = 0
				RampLCount = 0
				RampRCount = 0
				StopSong
				PlaySoundEND
                StopEndOfBallMode
                vpmtimer.addtimer 200, "EndOfBall '" 'the delay is depending of the animation of the end of ball, since there is no animation then move to the end of ball
            End If
        End If
    End If
End Sub



' The Ball has rolled out of the Plunger Lane and it is pressing down the trigger in the shooters lane
' Check to see if a ball saver mechanism is needed and if so fire it up.

Sub Trigger1_Hit()
If bAutoPlunger Then
        'debug.print "autofire the ball"
        PlungerIM.AutoFire
        DOF 117, DOFPulse
        PlaySoundAt "fx_fire", Trigger1
        bAutoPlunger = False
    End If	
'StopSong

    bBallInPlungerLane = True
    If(bBallSaverReady = True) AND(BallSaverTime <> 0) And(bBallSaverActive = False) Then
'        EnableBallSaver BallSaverTime
		 DOF 310, DOFon
'        Else
'        ' show the message to shoot the ball in case the player has fallen sleep
'        Trigger1.TimerEnabled = 1
    End If
End Sub

Sub Gate001_Hit()
	AddScore 2550
	DOF 310, DOFoff
	FlashForMs F1A003, 1000, 50, 0
	If(bBallSaverReady = True) AND(BallSaverTime <> 0) And(bBallSaverActive = False) Then 
        EnableBallSaver BallSaverTime
        Else
        ' show the message to shoot the ball in case the player has fallen sleep
        Trigger1.TimerEnabled = 1
    End If
End Sub
' The ball is released from the plunger

Sub Trigger1_UnHit()
    bBallInPlungerLane = False
    'LightEffect 4
	'ChangeSong
End Sub


Sub Trigger1_Timer
    trigger1.TimerEnabled = 0
End Sub

Sub EnableBallSaver(seconds)
    'debug.print "Ballsaver started"
    ' set our game flag
    bBallSaverActive = True
    bBallSaverReady = False
    ' start the timer
    BallSaverTimer.Interval = 1000 * seconds
    BallSaverTimer.Enabled = True
    BallSaverSpeedUpTimer.Interval = 1000 * seconds -(1000 * seconds) / 3
    BallSaverSpeedUpTimer.Enabled = True
    ' if you have a ball saver light you might want to turn it on at this point (or make it flash)
    LightShootAgain.BlinkInterval = 160
    LightShootAgain.State = 2
End Sub

' The ball saver timer has expired.  Turn it off AND reset the game flag
'
Sub BallSaverTimer_Timer()
    'debug.print "Ballsaver ended"
    BallSaverTimer.Enabled = False
    ' clear the flag
    bBallSaverActive = False
    ' if you have a ball saver light then turn it off at this point
   LightShootAgain.State = 0
End Sub
Sub BallSaverEnd
	BallSaverTimer.Enabled = False
    bBallSaverActive = False
    LightShootAgain.State = 0
End Sub

Sub BallSaverSpeedUpTimer_Timer()
    'debug.print "Ballsaver Speed Up Light"
    BallSaverSpeedUpTimer.Enabled = False
    ' Speed up the blinking
    LightShootAgain.BlinkInterval = 80
    LightShootAgain.State = 2
End Sub

' *********************************************************************
'                      Supporting Score Functions
' *********************************************************************

' Add points to the score AND update the score board
Sub AddScore(points)
    If Tilted Then Exit Sub

    ' add the points to the current players score variable
    PlayerScore(CurrentPlayer) = PlayerScore(CurrentPlayer) + points

    ' you may wish to check to see if the player has gotten an extra ball by a high score
    If PlayerScore(CurrentPlayer) >= Special1 AND Special1Awarded(CurrentPlayer) = False Then
        AwardExtraBall
        Special1Awarded(CurrentPlayer) = True
    End If
    If PlayerScore(CurrentPlayer) >= Special2 AND Special2Awarded(CurrentPlayer) = False Then
        AwardExtraBall
        Special2Awarded(CurrentPlayer) = True
    End If
    If PlayerScore(CurrentPlayer) >= Special3 AND Special3Awarded(CurrentPlayer) = False Then
        AwardExtraBall
        Special3Awarded(CurrentPlayer) = True
    End If
End Sub

' Add bonus to the bonuspoints AND update the score board
Sub AddBonus(points) 'not used in this table, since there are many different bonus items.
    If(Tilted = False) Then
        ' add the bonus to the current players bonus variable
        BonusPoints(CurrentPlayer) = BonusPoints(CurrentPlayer) + points
    End if
End Sub

Sub AwardExtraBall()
    ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer) + 1
	PlaySound SoundFXDOF("fx_Knocker", 122, DOFPulse, DOFKnocker)
	DOF 121, DOFPulse
	DOF 451, DOFPulse
	LiMi004.state = 1 
'    LightShootAgain.State = 1
    LightEffect 2
End Sub


'********************************************************************************************
' Only for VPX 10.2 and higher.
' FlashForMs will blink light or a flasher for TotalPeriod(ms) at rate of BlinkPeriod(ms)
' When TotalPeriod done, light or flasher will be set to FinalState value where
' Final State values are:   0=Off, 1=On, 2=Return to previous State
'********************************************************************************************

Sub FlashForMs(MyLight, TotalPeriod, BlinkPeriod, FinalState) 'thanks gtxjoe for the first version

    If TypeName(MyLight) = "Light" Then

        If FinalState = 2 Then
            FinalState = MyLight.State 'Keep the current light state
        End If
        MyLight.BlinkInterval = BlinkPeriod
        MyLight.Duration 2, TotalPeriod, FinalState
    ElseIf TypeName(MyLight) = "Flasher" Then

        Dim steps

        ' Store all blink information
        steps = Int(TotalPeriod / BlinkPeriod + .5) 'Number of ON/OFF steps to perform
        If FinalState = 2 Then                      'Keep the current flasher state
            FinalState = ABS(MyLight.Visible)
        End If
        MyLight.UserValue = steps * 10 + FinalState 'Store # of blinks, and final state

        ' Start blink timer and create timer subroutine
        MyLight.TimerInterval = BlinkPeriod
        MyLight.TimerEnabled = 0
        MyLight.TimerEnabled = 1
        ExecuteGlobal "Sub " & MyLight.Name & "_Timer:" & "Dim tmp, steps, fstate:tmp=me.UserValue:fstate = tmp MOD 10:steps= tmp\10 -1:Me.Visible = steps MOD 2:me.UserValue = steps *10 + fstate:If Steps = 0 then Me.Visible = fstate:Me.TimerEnabled=0:End if:End Sub"
    End If
End Sub


' ********************************
'   Table info & Attract Mode
' ********************************

Sub StartLightSeq()
    'lights sequences
    LightSeqAttract.UpdateInterval = 25
    LightSeqAttract.Play SeqBlinking, , 5, 150
    LightSeqAttract.Play SeqRandom, 40, , 4000
    LightSeqAttract.Play SeqAllOff
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqCircleOutOn, 15, 3
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqRightOn, 50, 1
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqLeftOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 40, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 40, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqRightOn, 30, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqLeftOn, 30, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqCircleOutOn, 15, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqStripe1VertOn, 50, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe1VertOn, 50, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe2VertOn, 50, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe1VertOn, 25, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe2VertOn, 25, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
End Sub

Sub LightSeqAttract_PlayDone()
    StartLightSeq()
End Sub

Sub LightSeqTilt_PlayDone()
    LightSeqTilt.Play SeqAllOff
End Sub

'***********************************************************************
' *********************************************************************
'                     Table Specific Script Starts Here
' *********************************************************************
'***********************************************************************

' droptargets, animations, etc
Sub VPObjects_Init
End Sub

' tables variables and Mode init
'Dim HoleBonus, BumperBonus, ALLRampBonus, RampBonus1, RampBonus2, RampBonus3, MulitballBonus, TargetBonus    
Dim JackpotsBonus, RaiderBonus, CroftBonus, RelicsBonus, ArtefactsBonus

Sub Game_Init() 'called at the start of a new game
	playclear pBackglass
    Dim i, j
    ChangeSong
	ResetEvents
'	TargetBonus = 0
	'bumperHits = 100
'	BumperBonus = 0
'	ALLRampBonus = 0
'	RampBonus1 = 0
'	RampBonus2 = 0
'	RampBonus3 =0
'	MulitballBonus = 0
	'BallInHole = 0
    TurnOffPlayfieldLights()
End Sub

Sub StopEndOfBallMode()     'this sub is called after the last ball is drained
End Sub

Sub ResetNewBallVariables() 'reset variables for a new ball or player
Dim i

bBallSaverReady = True
End Sub

Sub ResetNewBallLights()    'turn on or off the needed lights before a new ball is released
	gi1.state = 1
	gi2.state = 1
	gi3.state = 1
	gi4.state = 1
End Sub

Sub TurnOffPlayfieldLights()
    Dim a
    For each a in aLights
        a.State = 0
    Next
End Sub

' *********************************************************************
'                        Table Object Hit Events
'
' Any target hit Sub should do something like this:
' - play a sound
' - do some physical movement
' - add a score, bonus
' - check some variables/Mode this trigger is a member of
' - set the "LastSwitchHit" variable in case it is needed later
' *********************************************************************


'****************************************************************
'	ZSLG: Slingshots
'****************************************************************

' RStep and LStep are the variables that increment the animation
Dim RStep, LStep

Sub RightSlingShot_Slingshot
	PlaySoundAt SoundFXDOF("Sling_L", 104, DOFPulse, DOFcontactors), Sling1
    DOF 111, DOFPulse
	RS.VelocityCorrect(ActiveBall)
	Addscore 5105
	FlashForMs F1A004, 500, 250, 0
	RSling1.Visible = 1
	Sling1.TransY =  - 20   'Sling Metal Bracket
	RStep = 0
	RightSlingShot.TimerEnabled = 1
	RightSlingShot.TimerInterval = 10
	'   vpmTimer.PulseSw 52	'Slingshot Rom Switch
	RandomSoundSlingshotRight Sling1
End Sub

Sub RightSlingShot_Timer
	Select Case RStep
		Case 3
			RSLing1.Visible = 0
			RSLing2.Visible = 1
			Sling1.TransY =  - 10
		Case 4
			RSLing2.Visible = 0
			Sling1.TransY = 0
			RightSlingShot.TimerEnabled = 0
	End Select
	RStep = RStep + 1
End Sub

Sub LeftSlingShot_Slingshot
	PlaySoundAt SoundFXDOF("Sling_R", 103, DOFPulse, DOFcontactors), Sling2
    DOF 110, DOFPulse
	LS.VelocityCorrect(ActiveBall)
	Addscore 5105
'	FlashForMs F1A001, 1000, 50, 0
	FlashForMs F1A001, 500, 250, 0
	LSling1.Visible = 1
	Sling2.TransY =  - 20   'Sling Metal Bracket
	LStep = 0
	LeftSlingShot.TimerEnabled = 1
	LeftSlingShot.TimerInterval = 10
	'   vpmTimer.PulseSw 51	'Slingshot Rom Switch
	RandomSoundSlingshotLeft Sling2
End Sub

Sub LeftSlingShot_Timer
	Select Case LStep
		Case 3
			LSLing1.Visible = 0
			LSLing2.Visible = 1
			Sling2.TransY =  - 10
		Case 4
			LSLing2.Visible = 0
			Sling2.TransY = 0
			LeftSlingShot.TimerEnabled = 0
	End Select
	LStep = LStep + 1
End Sub

Sub TestSlingShot_Slingshot
	TS.VelocityCorrect(ActiveBall)
End Sub

'**************************
'Flupper bumpers
'**************************

Dim DayNightAdjust , DNA30, DNA45, DNA90
If NightDay < 10 Then
	DNA30 = 0 : DNA45 = (NightDay-10)/20 : DNA90 = 0 : DayNightAdjust = 0.4
Else
	DNA30 = (NightDay-10)/30 : DNA45 = (NightDay-10)/45 : DNA90 = (NightDay-10)/90 : DayNightAdjust = NightDay/25
End If

Dim FlBumperFadeActual(6), FlBumperFadeTarget(6), FlBumperColor(6), FlBumperTop(6), FlBumperSmallLight(6), Flbumperbiglight(6)
Dim FlBumperDisk(6), FlBumperBase(6), FlBumperBulb(6), FlBumperscrews(6), FlBumperActive(6), FlBumperHighlight(6)
Dim cnt : For cnt = 1 to 6 : FlBumperActive(cnt) = False : Next

' colors available are red, white, blue, orange, yellow, green, purple and blacklight

FlInitBumper 1, "red"
FlInitBumper 2, "red"
FlInitBumper 3, "red"

' ### uncomment the statement below to change the color for all bumpers ###
' Dim ind : For ind = 1 to 5 : FlInitBumper ind, "green" : next

Sub FlInitBumper(nr, col)
	FlBumperActive(nr) = True
	' store all objects in an array for use in FlFadeBumper subroutine
	FlBumperFadeActual(nr) = 1 : FlBumperFadeTarget(nr) = 1.1: FlBumperColor(nr) = col
	Set FlBumperTop(nr) = Eval("bumpertop" & nr) : FlBumperTop(nr).material = "bumpertopmat" & nr
	Set FlBumperSmallLight(nr) = Eval("bumpersmalllight" & nr) : Set Flbumperbiglight(nr) = Eval("bumperbiglight" & nr)
	Set FlBumperDisk(nr) = Eval("bumperdisk" & nr) : Set FlBumperBase(nr) = Eval("bumperbase" & nr)
	Set FlBumperBulb(nr) = Eval("bumperbulb" & nr) : FlBumperBulb(nr).material = "bumperbulbmat" & nr
	Set FlBumperscrews(nr) = Eval("bumperscrews" & nr): FlBumperscrews(nr).material = "bumperscrew" & col
	Set FlBumperHighlight(nr) = Eval("bumperhighlight" & nr)
	' set the color for the two VPX lights
	select case col
		Case "red"
			FlBumperSmallLight(nr).color = RGB(255,4,0) : FlBumperSmallLight(nr).colorfull = RGB(255,24,0)
			FlBumperBigLight(nr).color = RGB(255,32,0) : FlBumperBigLight(nr).colorfull = RGB(255,32,0)
			FlBumperHighlight(nr).color = RGB(64,255,0)
			FlBumperSmallLight(nr).BulbModulateVsAdd = 0.98
			FlBumperSmallLight(nr).TransmissionScale = 0
		Case "blue"
			FlBumperBigLight(nr).color = RGB(32,80,255) : FlBumperBigLight(nr).colorfull = RGB(32,80,255)
			FlBumperSmallLight(nr).color = RGB(0,80,255) : FlBumperSmallLight(nr).colorfull = RGB(0,80,255)
			FlBumperSmallLight(nr).TransmissionScale = 0 : MaterialColor "bumpertopmat" & nr, RGB(8,120,255)
			FlBumperHighlight(nr).color = RGB(255,16,8)
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1
		Case "green"
			FlBumperSmallLight(nr).color = RGB(8,255,8) : FlBumperSmallLight(nr).colorfull = RGB(8,255,8)
			FlBumperBigLight(nr).color = RGB(32,255,32) : FlBumperBigLight(nr).colorfull = RGB(32,255,32)
			FlBumperHighlight(nr).color = RGB(255,32,255) : MaterialColor "bumpertopmat" & nr, RGB(16,255,16) 
			FlBumperSmallLight(nr).TransmissionScale = 0.005
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1
		Case "orange"
			FlBumperHighlight(nr).color = RGB(255,130,255)
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1 
			FlBumperSmallLight(nr).TransmissionScale = 0
			FlBumperSmallLight(nr).color = RGB(255,130,0) : FlBumperSmallLight(nr).colorfull = RGB (255,90,0)
			FlBumperBigLight(nr).color = RGB(255,190,8) : FlBumperBigLight(nr).colorfull = RGB(255,190,8)
		Case "white"
			FlBumperBigLight(nr).color = RGB(255,230,190) : FlBumperBigLight(nr).colorfull = RGB(255,230,190)
			FlBumperHighlight(nr).color = RGB(255,180,100) : 
			FlBumperSmallLight(nr).TransmissionScale = 0
			FlBumperSmallLight(nr).BulbModulateVsAdd = 0.99
		Case "blacklight"
			FlBumperBigLight(nr).color = RGB(32,32,255) : FlBumperBigLight(nr).colorfull = RGB(32,32,255)
			FlBumperHighlight(nr).color = RGB(48,8,255) : 
			FlBumperSmallLight(nr).TransmissionScale = 0
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1
		Case "yellow"
			FlBumperSmallLight(nr).color = RGB(255,230,4) : FlBumperSmallLight(nr).colorfull = RGB(255,230,4)
			FlBumperBigLight(nr).color = RGB(255,240,50) : FlBumperBigLight(nr).colorfull = RGB(255,240,50)
			FlBumperHighlight(nr).color = RGB(255,255,220)
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1 
			FlBumperSmallLight(nr).TransmissionScale = 0
		Case "purple"
			FlBumperBigLight(nr).color = RGB(80,32,255) : FlBumperBigLight(nr).colorfull = RGB(80,32,255)
			FlBumperSmallLight(nr).color = RGB(80,32,255) : FlBumperSmallLight(nr).colorfull = RGB(80,32,255)
			FlBumperSmallLight(nr).TransmissionScale = 0 : 
			FlBumperHighlight(nr).color = RGB(32,64,255)
			FlBumperSmallLight(nr).BulbModulateVsAdd = 1
	end select
End Sub

Sub FlFadeBumper(nr, Z)
	FlBumperBase(nr).BlendDisableLighting = 0.5 * DayNightAdjust
'	UpdateMaterial(string, float wrapLighting, float roughness, float glossyImageLerp, float thickness, float edge, float edgeAlpha, float opacity,
'               OLE_COLOR base, OLE_COLOR glossy, OLE_COLOR clearcoat, VARIANT_BOOL isMetal, VARIANT_BOOL opacityActive,
'               float elasticity, float elasticityFalloff, float friction, float scatterAngle) - updates all parameters of a material
	FlBumperDisk(nr).BlendDisableLighting = (0.5 - Z * 0.3 )* DayNightAdjust	

	select case FlBumperColor(nr)

		Case "blue" :
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(38-24*Z,130 - 98*Z,255), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 20  + 500 * Z / (0.5 + DNA30)
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 50 * Z
			FlBumperBulb(nr).BlendDisableLighting = 12 * DayNightAdjust + 5000 * (0.03 * Z +0.97 * Z^3)
			Flbumperbiglight(nr).intensity = 45 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 10000 * (Z^3) / (0.5 + DNA90)

		Case "green"	
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(16 + 16 * sin(Z*3.14),255,16 + 16 * sin(Z*3.14)), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 10 + 150 * Z / (1 + DNA30)
			FlBumperTop(nr).BlendDisableLighting = 2 * DayNightAdjust + 20 * Z
			FlBumperBulb(nr).BlendDisableLighting = 7 * DayNightAdjust + 6000 * (0.03 * Z +0.97 * Z^10)
			Flbumperbiglight(nr).intensity = 20 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 6000 * (Z^3) / (1 + DNA90)
		
		Case "red" 
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(255, 16 - 11*Z + 16 * sin(Z*3.14),0), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 17 + 100 * Z / (1 + DNA30^2)
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 18 * Z / (1 + DNA90)
			FlBumperBulb(nr).BlendDisableLighting = 20 * DayNightAdjust + 9000 * (0.03 * Z +0.97 * Z^10)
			Flbumperbiglight(nr).intensity = 20 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 2000 * (Z^3) / (1 + DNA90)
			MaterialColor "bumpertopmat" & nr, RGB(255,20 + Z*4,8-Z*8)
		
		Case "orange"
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(255, 100 - 22*z  + 16 * sin(Z*3.14),Z*32), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 17 + 250 * Z / (1 + DNA30^2)
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 50 * Z / (1 + DNA90)
			FlBumperBulb(nr).BlendDisableLighting = 15 * DayNightAdjust + 2500 * (0.03 * Z +0.97 * Z^10)
			Flbumperbiglight(nr).intensity = 20 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 4000 * (Z^3) / (1 + DNA90)
			MaterialColor "bumpertopmat" & nr, RGB(255,100 + Z*50, 0)

		Case "white"
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(255,230 - 100 * Z, 200 - 150 * Z), RGB(255,255,255), RGB(32,32,32), false, true, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 20 + 180 * Z / (1 + DNA30)
			FlBumperTop(nr).BlendDisableLighting = 5 * DayNightAdjust + 30 * Z
			FlBumperBulb(nr).BlendDisableLighting = 18 * DayNightAdjust + 3000 * (0.03 * Z +0.97 * Z^10)
			Flbumperbiglight(nr).intensity = 14 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 1000 * (Z^3) / (1 + DNA90)
			FlBumperSmallLight(nr).color = RGB(255,255 - 20*Z,255-65*Z) : FlBumperSmallLight(nr).colorfull = RGB(255,255 - 20*Z,255-65*Z)
			MaterialColor "bumpertopmat" & nr, RGB(255,235 - z*36,220 - Z*90)

		Case "blacklight"
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 1, RGB(30-27*Z^0.03,30-28*Z^0.01, 255), RGB(255,255,255), RGB(32,32,32), false, true, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 20 + 900 * Z / (1 + DNA30)
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 60 * Z
			FlBumperBulb(nr).BlendDisableLighting = 15 * DayNightAdjust + 30000 * Z^3
			Flbumperbiglight(nr).intensity = 40 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 2000 * (Z^3) / (1 + DNA90)
			FlBumperSmallLight(nr).color = RGB(255-240*(Z^0.1),255 - 240*(Z^0.1),255) : FlBumperSmallLight(nr).colorfull = RGB(255-200*z,255 - 200*Z,255)
			MaterialColor "bumpertopmat" & nr, RGB(255-190*Z,235 - z*180,220 + 35*Z)

		Case "yellow"
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(255, 180 + 40*z, 48* Z), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 17 + 200 * Z / (1 + DNA30^2)
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 40 * Z / (1 + DNA90)
			FlBumperBulb(nr).BlendDisableLighting = 12 * DayNightAdjust + 2000 * (0.03 * Z +0.97 * Z^10)
			Flbumperbiglight(nr).intensity = 20 * Z / (1 + DNA45)
			FlBumperHighlight(nr).opacity = 1000 * (Z^3) / (1 + DNA90)
			MaterialColor "bumpertopmat" & nr, RGB(255,200, 24 - 24 * z)

		Case "purple" :
			UpdateMaterial "bumperbulbmat" & nr, 0, 0.75 , 0, 1-Z, 1-Z, 1-Z, 0.9999, RGB(128-118*Z - 32 * sin(Z*3.14), 32-26*Z ,255), RGB(255,255,255), RGB(32,32,32), false, True, 0, 0, 0, 0
			FlBumperSmallLight(nr).intensity = 15  + 200 * Z / (0.5 + DNA30) 
			FlBumperTop(nr).BlendDisableLighting = 3 * DayNightAdjust + 50 * Z
			FlBumperBulb(nr).BlendDisableLighting = 15 * DayNightAdjust + 10000 * (0.03 * Z +0.97 * Z^3)
			Flbumperbiglight(nr).intensity = 50 * Z / (1 + DNA45) 
			FlBumperHighlight(nr).opacity = 4000 * (Z^3) / (0.5 + DNA90)
			MaterialColor "bumpertopmat" & nr, RGB(128-60*Z,32,255)


	end select
End Sub

Sub BumperTimer_Timer
	dim nr
	For nr = 1 to 6
		If FlBumperFadeActual(nr) < FlBumperFadeTarget(nr) and FlBumperActive(nr)  Then
			FlBumperFadeActual(nr) = FlBumperFadeActual(nr) + (FlBumperFadeTarget(nr) - FlBumperFadeActual(nr)) * 0.8
			If FlBumperFadeActual(nr) > 0.99 Then FlBumperFadeActual(nr) = 1 : End If
			FlFadeBumper nr, FlBumperFadeActual(nr)
		End If
		If FlBumperFadeActual(nr) > FlBumperFadeTarget(nr) and FlBumperActive(nr)  Then
			FlBumperFadeActual(nr) = FlBumperFadeActual(nr) + (FlBumperFadeTarget(nr) - FlBumperFadeActual(nr)) * 0.4 / (FlBumperFadeActual(nr) + 0.1)
			If FlBumperFadeActual(nr) < 0.01 Then FlBumperFadeActual(nr) = 0 : End If
			FlFadeBumper nr, FlBumperFadeActual(nr)
		End If
	next
End Sub

'************************** 
'Bumpers 
'************************** 
Dim bumperHits

Sub Bumper1_Hit()
'	CheckBumpers
	If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 109, DOFPulse, DOFContactors), Bumper1
        DOF 138, DOFPulse
		GiEffect 4
		AddScore 9150
		FlBumperFadeTarget(1) = 0
		bumper1.timerinterval = 100
		Bumper1.timerenabled = True
	End If
End Sub

Sub Bumper2_Hit()
'	CheckBumpers
	If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 107, DOFPulse, DOFContactors), Bumper2
        DOF 139, DOFPulse
		GiEffect 4
		AddScore 9150
		FlBumperFadeTarget(2) = 0
		bumper2.timerinterval = 100
		Bumper2.timerenabled = True
	End If
End Sub

Sub Bumper3_Hit()
'	CheckBumpers
	If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 108, DOFPulse, DOFContactors), Bumper3
        DOF 140, DOFPulse
		GiEffect 4
		AddScore 9150
		FlBumperFadeTarget(3) = 0
		bumper3.timerinterval = 100
		Bumper3.timerenabled = True
	End If
End Sub

Sub Bumper1_Timer()
	FlBumperFadeTarget(1) = 1
End Sub

Sub Bumper2_Timer()
	FlBumperFadeTarget(2) = 1
End Sub

Sub Bumper3_Timer()
	FlBumperFadeTarget(3) = 1
End Sub
' Bumper Bonus
' 100000 i bonus after each 100 hits

Sub CheckBumpers()
	If bumperHits <= 0 Then
	BumperBonus = BumperBonus + 1
	DMD "_", CL(1, "BUMPERS BONUS " & BumperBonus), "_", eNone, eBlink, eNone, 500, True, ""
	bumperHits = 100
	End If
End Sub

Sub ResetBumpers()
    bumperHits = 100
End Sub


'' ###################################
'' ###### copy script until here #####
'' ###################################

'*****************
'Gates
'*****************
sub Gate_Hit()
End Sub

'*****************
'Kickers
'*****************

sub kicker001_hit()
	LightKittON
	FlashForMs F1A006, 500, 250, 0
	FlashForMs F1A007, 500, 250, 0
	FlashForMs Flasher003, 500, 50, 1
	Kicker001.timerinterval = 2000
	kicker001.timerenabled = True
	If LiStart.state = 2 Then AwardExtraBall : LiStart.state = 0
end Sub
Sub Kicker001_Timer()
	kicker001.kick 125, 45, 1.4
	PlaySound "KRfxScoop"
	kicker001.timerenabled = False
    DOF 112, DOFPulse
End Sub

sub kicker002_hit()
	LightKittON
	If MIRedActive(CurrentPlayer) = True Then MBLockActive(CurrentPlayer) = True : SolTruckRamp 1 : pupDMDDisplay "Splash4","Lock is Lit^Enter Truck","",3,1,10
	Kicker002.timerinterval = 2000
	kicker002.timerenabled = True
end Sub
Sub Kicker002_Timer()
	kicker002.kick 90, 35
	PlaySound "KRfxScoop"
	kicker002.timerenabled = False
    DOF 113, DOFPulse
End Sub

sub kicker003_hit()
	If LiKARR004.State = 2 Then PlaySound "KARR03" : AddScore 100000
	If MIYellActive(CurrentPlayer) = True Then LiKARR004.State = 1 : CheckAwardMIYell
	kicker003.kick 20, 35, 1.4
	kicker003.timerenabled = False
    DOF 114, DOFPulse
end Sub

Sub Kicker004_Hit() 'kickBackLeft
	kicker004.kick 0, 30
	Playsound "explosion01"
	pupDMDDisplay "Splash4","SHIELD^USED","",3,0,10
	LiTarget001.state = 0
	LiTarget002.state = 0
	LiTarget003.state = 0
	LeftOutlane.state = 0
	RightOutlane.state = 0
	KickBackActive(CurrentPlayer) = False
	kicker004.Enabled = False 
    DOF 115, DOFPulse
End Sub

Sub Kicker005_Hit() 'kickBackRight
	kicker005.kick 0, 30
	Playsound "explosion01"
	pupDMDDisplay "Splash4","SHIELD^USED","",3,0,10
	LiTarget001.state = 0
	LiTarget002.state = 0
	LiTarget003.state = 0
	LeftOutlane.state = 0
	RightOutlane.state = 0
	KickBackActive(CurrentPlayer) = False
	kicker005.Enabled = False 
    DOF 116, DOFPulse
End Sub
'***********
' Target
'***********

Sub Target001_Hit()
	AddScore 25625
	PlaySoundGUN
	LiTarget002.state = 1
	CheckKickBack
End Sub
Sub Target002_Hit()
	AddScore 25625
	PlaySoundGUN
	LiTarget003.state = 1
	CheckKickBack
End Sub
Sub Target003_Hit()
	AddScore 25625
	PlaySoundGUN
	LiTarget001.state = 1
	CheckKickBack
End Sub
Sub Target004_Hit()
	AddScore 25600
	LightKittON
	TruckDivertWall.Collidable = 1
End Sub
Sub CheckKickBack
	If LiTarget001.state = 1 And LiTarget002.state = 1 And LiTarget003.state = 1 And LeftOutlane.state = 0 And RightOutlane.state = 0 Then KickBackActive(CurrentPlayer) = True : LeftOutlane.state = 2 : RightOutlane.state = 2 : Playsound "KRfxmusicloop" : pupDMDDisplay "Splash4","Outline SHIELD^ACTIVATED","",3,0,10
End Sub

Sub Target005_Hit() 'Green
	AddScore 25600
	PlaySoundTargetsColor
	If MIGreenActive(CurrentPlayer) = False Then
	GreenCount(CurrentPlayer) = GreenCount(CurrentPlayer) + 1 
	CheckColorMISS
	End If
End Sub
Sub Target006_Hit() 'YELL
	AddScore 25600
	PlaySoundTargetsColor
	If MIYellActive(CurrentPlayer) = False Then
	YellCount(CurrentPlayer) = YellCount(CurrentPlayer) + 1 
	CheckColorMISS
	End If
End Sub
Sub Target007_Hit() 'RED
	AddScore 25600
	PlaySoundTargetsColor
	If MIRedActive(CurrentPlayer) = False Then
	RedCount(CurrentPlayer) = RedCount(CurrentPlayer) + 1
	CheckColorMISS
	End If
End Sub
Sub CheckColorMISS
	If GreenCount(CurrentPlayer) = 0 Then LiGreen002.state = 2 : LiGreen003.state = 2 : LiGreen004.state = 2
	If GreenCount(CurrentPlayer) = 1 Then LiGreen002.state = 1 : LiGreen003.state = 2 : LiGreen004.state = 2
	If GreenCount(CurrentPlayer) = 2 Then LiGreen002.state = 1 : LiGreen003.state = 1 : LiGreen004.state = 2
	If GreenCount(CurrentPlayer) = 3 And MIGreenActive(CurrentPlayer) = False Then LiGreen001.state = 0 : LiGreen002.state = 1 : LiGreen003.state = 1 : LiGreen004.state = 1 : StartMIGreen
	If GreenCount(CurrentPlayer) = 4 And MIGreenActive(CurrentPlayer) = True Then LiMi001.State = 2 : LiGreen001.state = 0 : LiGreen002.state = 1 : LiGreen003.state = 1 : LiGreen004.state = 1
	If YellCount(CurrentPlayer) = 0 Then LiYell002.state = 2 : LiYell003.state = 2 : LiYell004.state = 2
	If YellCount(CurrentPlayer) = 1 Then LiYell002.state = 1 : LiYell003.state = 2 : LiYell004.state = 2
	If YellCount(CurrentPlayer) = 2 Then LiYell002.state = 1 : LiYell003.state = 1 : LiYell004.state = 2
	If YellCount(CurrentPlayer) = 3 And MIYellActive(CurrentPlayer) = False Then LiYell001.state = 0 : LiYell002.state = 1 : LiYell003.state = 1 : LiYell004.state = 1 : StartMIYell
	If RedCount(CurrentPlayer) = 0 Then LiMi003.State = 0 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2
	If RedCount(CurrentPlayer) = 1 Then LiMi003.State = 0 : LiRed002.state = 1 : LiRed003.state = 2 : LiRed004.state = 2
	If RedCount(CurrentPlayer) = 2 Then LiMi003.State = 0 : LiRed002.state = 1 : LiRed003.state = 1 : LiRed004.state = 2
	If RedCount(CurrentPlayer) = 3 And MIRedActive(CurrentPlayer) = False Then LiMi003.State = 0 : LiRed001.state = 0 : LiRed002.state = 1 : LiRed003.state = 1 : LiRed004.state = 1 : StartMIRed
	If RedCount(CurrentPlayer) = 4 And MIRedActive(CurrentPlayer) = True Then LiMi003.State = 2 : LiRed001.state = 0 : LiRed002.state = 1 : LiRed003.state = 1 : LiRed004.state = 1
End Sub
Sub ResetLightPFhaut
	LiGreen001.state = 2
	LiGreen002.state = 2
	LiGreen003.state = 2
	LiGreen004.state = 2
	LiYell001.state = 2
	LiYell002.state = 2
	LiYell003.state = 2
	LiYell004.state = 2
	LiRed001.state = 2
	LiRed002.state = 2
	LiRed003.state = 2
	LiRed004.state = 2
	GreenCount(CurrentPlayer) = 0
	YellCount(CurrentPlayer) = 0
	MiYellEndTimer.Enabled = False
End Sub
Sub OFFLightPFhaut
	LiGreen001.state = 0
	LiGreen002.state = 0
	LiGreen003.state = 0
	LiGreen004.state = 0
	LiYell001.state = 0
	LiYell002.state = 0
	LiYell003.state = 0
	LiYell004.state = 0
	LiRed001.state = 0
	LiRed002.state = 0
	LiRed003.state = 0
	LiRed004.state = 0
End Sub
'*****************
'Triggers
'*****************
Sub Trigger001_Hit()
	FlashForMs F1A002, 1000, 50, 0
	AddScore 9550
	If LiKARR001.State = 0 Then PlaySoundTriggerCourt
	If LiKARR001.State = 2 Then PlaySound "KARR01" : AddScore 100000
	If MIYellActive(CurrentPlayer) = True Then LiKARR001.State = 1 : CheckAwardMIYell
End Sub
Sub Trigger002_Hit()
	FlashForMs F1A005, 500, 250, 0
	AddScore 9550
	If LiKARR005.State = 2 Then PlaySound "KARR04" : AddScore 100000
	If MIYellActive(CurrentPlayer) = True Then LiKARR005.State = 1 : CheckAwardMIYell
End Sub
Sub Trigger003_Hit()
	FlashForMs F1A008, 500, 250, 0	
	AddScore 9550
	If LiKARR002.State = 0 And LightShootAgain.state = 0 Then PlaySoundTriggerLong
	If LiKARR002.State = 2 Then PlaySound "KARR02" : AddScore 100000
	If MIYellActive(CurrentPlayer) = True Then LiKARR002.State = 1 : CheckAwardMIYell
End Sub
Sub Trigger004_Hit()
	AddScore 9550
	If LiKARR003.State = 0 And LightShootAgain.state = 0 Then PlaySoundTriggerCourt
	If LiKARR003.State = 2 Then PlaySound "KARR03" : AddScore 100000
	If MIYellActive(CurrentPlayer) = True Then LiKARR003.State = 1 : CheckAwardMIYell
End Sub
Sub Trigger008_Hit()
	AddScore 25000
	If MIRedActive(CurrentPlayer) = True Then MBLockActive(CurrentPlayer) = False : CheckLockMB : SolTruckRamp 1
End Sub
Sub Trigger009_Hit()
    DOF 120, DOFOff
    DOF 124, DOFOff
	AddScore 25000
	FlashForMs F1A002, 1000, 50, 0
	If Li10M.state = 2 or Li15M.state = 2 or Li20M.state = 2 or Li100M.state = 2 Then SolKittShakerToy 1 : EndKittTimer.Enabled = True : BonusGreenCount(CurrentPlayer) = BonusGreenCount(CurrentPlayer) + 1 : AwardMIGreen
End Sub
Sub Trigger010_Hit()
    DOF 120, DOFOn
    DOF 124, DOFOn
	AddScore 15000
	FlashForMs F1A008, 1000, 50, 0
	If Li10M.state = 2 or Li15M.state = 2 or Li20M.state = 2 or Li100M.state = 2 Then 
	SolKittShakerToy 1 
	PlaySound "TurboBoostShort"
	Else
	PlaySoundTriggerLong
	End If
End Sub

Sub Trigger011_Hit()
	AddScore 15000
	FlashForMs F1A005, 1000, 50, 0
	PlaySoundTriggerCourt
End Sub

Sub EndKittTimer_Timer()
	SolKittRampToy 1
	EndKittTimer.Enabled = False
End Sub

Sub TriggerDebug_Hit()
	If BallsOnPlayfield = 0 Then TriggerDebug.DestroyBall
End Sub

Sub TriggerTEST_Hit()
'	SolTruckRamp 1
'	SolKittRampToy 1
'	SolKittShakerToy 1
'	LightKittON
'	StartKitt
End Sub

Sub LightKittON
	PlaySound "fx_Kitt2"
	KittLightENDTimer.Enabled = True
	LiKIT001.state = 2
	LiKIT002.state = 2
	LiKIT003.state = 2
	LiKIT004.state = 2
	LiKIT005.state = 2
	LiKIT006.state = 2
End Sub
Sub KittLightENDTimer_Timer()
	LiKIT001.state = 0
	LiKIT002.state = 0
	LiKIT003.state = 0
	LiKIT004.state = 0
	LiKIT005.state = 0
	LiKIT006.state = 0
	KittLightENDTimer.Enabled = False
End Sub

Sub TLeftOutlane_Hit()
	AddScore 15300
	If LeftOutlane.State = 2 Then kicker004.Enabled = True : AddScore 5000 : FlashForMs F1A001, 1000, 50, 0 : FlashForMs F1A002, 1000, 50, 0
End Sub

Sub TLeftInlane_Hit()
	AddScore 15300
	leftInlaneSpeedLimit
End Sub
Sub TRightInlane_Hit()
	AddScore 15300
	rightInlaneSpeedLimit
End Sub

Sub TRightOutlane_Hit()
	AddScore 15300
	If RightOutlane.State = 2 Then kicker005.Enabled = True : AddScore 50000 : FlashForMs F1A003, 1000, 50, 0 : FlashForMs F1A004, 1000, 50, 0
End Sub
'*****************
'Flasher KITT
'*****************
Dim FondKittPos, FramesKitt
FramesKitt = Array("KittVoice006", "KittVoice005", "KittVoice004", "KittVoice003", "KittVoice002", "KittVoice001", "KittVoice000", "KittVoice001", _
"KittVoice002", "KittVoice003", "KittVoice004", "KittVoice005", "KittVoice006", "KittVoice005", "KittVoice004", "KittVoice003", "KittVoice004", "KittVoice005", "KittVoice006", "KittVoice005", "KittVoice004", "KittVoice003", _
"KittVoice004", "KittVoice005", "KittVoice006", "KittVoice005", "KittVoice004", "KittVoice003", "KittVoice004", "KittVoice005", "KittVoice004", "KittVoice005")

Sub StartKitt
	If StopKittTimer.Enabled = False Then
	Flasher004.visible = 0
	Flasher002.visible = 1
	FondKittPos = 0
    FondKittTimer.Enabled = 1
	StopKittTimer.Enabled = 1
	End If
End Sub
Sub FondKittTimer_Timer
    Flasher002.ImageA = FramesKitt (FondKittPos)
    FondKittPos = (FondKittPos + 1) MOD 32
End Sub
Sub StopKitt
	Flasher004.visible = 1
	Flasher002.visible = 0
	FondKittTimer.Enabled = 0
End Sub
Sub StopKittTimer_Timer
	StopKitt
Me.Enabled = 0
End Sub
'#################################
'FX SOUND
'#################################
Sub PlaySoundAwardGreen
	Select Case Int(Rnd * 3) + 1
		Case 1
			PlaySound "superpursuitmode1"
		Case 2
			PlaySound "superpursuitmode2"
		Case 3
			PlaySound "superpursuitmode3"
	End Select
End Sub

Sub PlaySoundGUN
	Select Case Int(Rnd * 3) + 1
		Case 1
			PlaySound "Gun01"
		Case 2
			PlaySound "Gun02"
		Case 3
			PlaySound "Gun03"
	End Select
End Sub

Sub PlaySoundEND
	StartKitt
	Select Case Int(Rnd * 7) + 1
		Case 1
			PlaySound "Kitt01"
		Case 2
			PlaySound "kitt02"
		Case 3
			PlaySound "kitt03"
		Case 4
			PlaySound "kitt04"
		Case 5
			PlaySound "kitt05"
		Case 6
			PlaySound "kitt06"
		Case 7
			PlaySound "kitt07"
	End Select
End Sub

Sub PlaySoundBsave
	Select Case Int(Rnd * 9) + 1
		Case 1
			PlaySound "Micheal01"
		Case 2
			PlaySound "Micheal02"
		Case 3
			PlaySound "Micheal03"
		Case 4
			PlaySound "Micheal04"
		Case 5
			PlaySound "Micheal05"
		Case 6
			PlaySound "Micheal06"
		Case 7
			PlaySound "Micheal07"
		Case 8
			PlaySound "Micheal08"
		Case 9
			PlaySound "Micheal09"
	End Select
End Sub

Sub PlaySoundTargetsColor
	Select Case Int(Rnd * 3) + 1
		Case 1
			PlaySound "Beep"
		Case 2
			PlaySound "Beep01"
		Case 3
			PlaySound "Beep02"
	End Select
End Sub

Sub PlaySoundTriggerCourt
	Select Case Int(Rnd * 6) + 1
		Case 1
			PlaySound "KRfx01"
		Case 2
			PlaySound "KRfx02"
		Case 3
			PlaySound "KRfx03"
		Case 4
			PlaySound "KRfx04"
		Case 5
			PlaySound "KRfx05"
		Case 6
			PlaySound "KRfx06"
	End Select
End Sub
Sub PlaySoundTriggerLong
	Select Case Int(Rnd * 4) + 1
		Case 1
			PlaySound "KRfx20"
		Case 2
			PlaySound "KRfx21"
		Case 3
			PlaySound "KRfx22"
		Case 4
			PlaySound "KRfx23"
	End Select
End Sub
'#################################
'MissionTargets
'#################################
Sub StartMIGreen
	AddScore 50000
	FlashForMs F1A006, 500, 250, 0
	FlashForMs F1A007, 500, 250, 0
	FlashForMs Flasher001, 3000, 200, 0
	pupDMDDisplay "Splash4","Turbo Boost Ready^Active by Ramp","",3,1,10
	LightKittON
	GreenCount(CurrentPlayer) = 4
	BonusGreenCount(CurrentPlayer) = BonusGreenCount(CurrentPlayer) + 1
	MIGreenActive(CurrentPlayer) = True
	CheckLiGreen
	LiMi001.State = 2
	LiGreen001.state = 0
'	OFFLightPFhaut
	SolKittRampToy 1
End Sub
Sub CheckLiGreen
'	If GreenCount = 4 Then 
		If BonusGreenCount(CurrentPlayer) = 0 Then Li10M.State = 0
		If BonusGreenCount(CurrentPlayer) = 1 Then Li10M.State = 2
		If BonusGreenCount(CurrentPlayer) = 2 Then Li10M.State = 1
		If BonusGreenCount(CurrentPlayer) = 3 Then Li10M.State = 1 : Li15M.State = 2
		If BonusGreenCount(CurrentPlayer) = 4 Then Li10M.State = 1 : Li15M.State = 1
		If BonusGreenCount(CurrentPlayer) = 5 Then Li10M.State = 1 : Li15M.State = 1 : Li20M.State = 2
		If BonusGreenCount(CurrentPlayer) = 6 Then Li10M.State = 1 : Li15M.State = 1 : Li20M.State = 1
		If BonusGreenCount(CurrentPlayer) = 7 Then Li10M.State = 1 : Li15M.State = 1 : Li20M.State = 1 : Li100M.State = 2
		If BonusGreenCount(CurrentPlayer) >= 8 Then Li10M.State = 1 : Li15M.State = 1 : Li20M.State = 1 : Li100M.State = 1
'	End If
End Sub
Sub AwardMIGreen 
	If BonusGreenCount(CurrentPlayer) = 2 Then DOF 441, DOFPulse : AddScore 10000000 : pupDMDDisplay "Splash4","TURBO BOOST^10 Million","",3,0,10
	If BonusGreenCount(CurrentPlayer) = 4 Then DOF 441, DOFPulse : AddScore 15000000 : pupDMDDisplay "Splash4","TURBO BOOST^15 Million","",3,0,10
	If BonusGreenCount(CurrentPlayer) = 6 Then DOF 441, DOFPulse : AddScore 20000000 : pupDMDDisplay "Splash4","TURBO BOOST^20 Million","",3,0,10
	If BonusGreenCount(CurrentPlayer) = 8 Then DOF 441, DOFPulse : AddScore 100000000 : pupDMDDisplay "Splash4","TURBO BOOST^100 Million","",3,0,10
	MIGreenActive(CurrentPlayer) = False
	GreenCount(CurrentPlayer) = 0
	CheckLiGreen
'	ResetLightPFhaut
	PlaySoundAwardGreen
	LiMi001.State = 1
	LiGreen001.state = 2
	LiGreen002.state = 2
	LiGreen003.state = 2
	LiGreen004.state = 2
End Sub

Sub StartMIYell
	FlashForMs F1A006, 500, 250, 0
	FlashForMs F1A007, 500, 250, 0
	FlashForMs Flasher001, 3000, 200, 0
	AddScore 50000
	LightKittON
	PlaySong "Mu_2"
	DOF 338, DOFPulse
	YellCount(CurrentPlayer) = 4
	MIYellActive(CurrentPlayer) = True
	pupDMDDisplay "Splash4","Mission START^Collect all KARR","",3,1,10
	MiYellEndTimer.Enabled = True
	LiMi002.State = 2
	LiKARR001.State = 2
	LiKARR002.State = 2
	LiKARR003.State = 2
	LiKARR004.State = 2
	LiKARR005.State = 2
	LiYell001.state = 0
'	OFFLightPFhaut
End Sub
Sub CheckAwardMIYell
	If YellCount(CurrentPlayer) = 4 And LiKARR001.State = 1 And LiKARR002.State = 1 And LiKARR003.State = 1 And LiKARR004.State = 1 And LiKARR005.State = 1 Then
		MIYellActive(CurrentPlayer) = False
		YellCount(CurrentPlayer) = 0
		pupDMDDisplay "Splash4","Mission KARR^SUCCESSFUL 250 Million ","",3,0,10
		AddScore 25000000
		PlaySong "Mu_1"
		DOF 338, DOFPulse
		LiStart.state = 2
		LiMi002.State = 1
		LiKARR001.State = 0
		LiKARR002.State = 0
		LiKARR003.State = 0
		LiKARR004.State = 0
		LiKARR005.State = 0
'		ResetLightPFhaut
		LiYell001.state = 2
		LiYell002.state = 2
		LiYell003.state = 2
		LiYell004.state = 2
		MiYellEndTimer.Enabled = False
	End If
End Sub

Sub MiYellEndTimer_Timer()
	MIYellActive(CurrentPlayer) = False
	pupDMDDisplay "Splash4","Mission KARR^FAILED","",3,0,10
	YellCount(CurrentPlayer) = 0
	AddScore 2000
	PlaySong "Mu_1"
	LiMi002.State = 0
	LiKARR001.State = 0
	LiKARR002.State = 0
	LiKARR003.State = 0
	LiKARR004.State = 0
	LiKARR005.State = 0
	LiYell001.state = 2
	LiYell002.state = 2
	LiYell003.state = 2
	LiYell004.state = 2
	MiYellEndTimer.Enabled = False
End Sub

Sub StartMIRed
	FlashForMs F1A006, 500, 250, 0
	FlashForMs F1A007, 500, 250, 0
	AddScore 50000
	pupDMDDisplay "Splash4","Shoot Scoop^Open Truck Door","",3,1,10
	RedCount(CurrentPlayer) = 4
	MIRedActive(CurrentPlayer) = True
	MBLock_Sav(CurrentPlayer) = MBLock_Sav(CurrentPlayer) + 1
	CheckLightMB
End Sub
Sub CheckLockMB
	RedCount(CurrentPlayer) = 0
	AddScore 50000
	MIRedActive(CurrentPlayer) = False
	MBLock_Sav(CurrentPlayer) = MBLock_Sav(CurrentPlayer) + 1
	If TotalGamesPlayed = 1 Then
		If MBLock_Sav(CurrentPlayer) = 2 Then BallsInHole = 1 : Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 1^LOCKED","",3,1,10
		If MBLock_Sav(CurrentPlayer) = 4 Then BallsInHole = 2 : Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 2^LOCKED","",3,1,10
		If MBLock_Sav(CurrentPlayer) = 6 Then BallsInHole = 3 : Playsound "MichealLaughs" : Mode_Multiball_Start 
	Elseif TotalGamesPlayed >= 2 Then
	CheckLockMBalt
	End If
	CheckLightMB
End Sub
Sub CheckLockMBalt
	If MBLock_Sav(CurrentPlayer) = 2 And BallsInHole = 0 Then Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 1^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 2 And BallsInHole = 1 Then Trigger008.DestroyBall : Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 1^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 2 And BallsInHole = 2 Then Trigger008.DestroyBall : Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 1^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 4 And BallsInHole = 0 Then Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 2^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 4 And BallsInHole = 1 Then Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 2^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 4 And BallsInHole = 2 Then Trigger008.DestroyBall : Playsound "MichealLaughs" : AddMultiball 1 : bAutoPlunger = True : BallsOnPlayfield = 1 : LiRed001.state = 2 : LiRed002.state = 2 : LiRed003.state = 2 : LiRed004.state = 2 : pupDMDDisplay "Splash4","BALL 2^LOCKED","",3,1,10
	If MBLock_Sav(CurrentPlayer) = 6 Then Playsound "MichealLaughs" : Mode_Multiball_Start 
End Sub
Sub Trigger012_Hit()
	BallsInHole = BallsInHole + 1
End Sub
Sub CheckLightMB
	If MBLock_Sav(CurrentPlayer) = 0 Then LiLOCK.State = 0 : LiLOCK2.State = 0 : LiMB.State = 0 : LiRed001.state = 2
	If MBLock_Sav(CurrentPlayer) = 1 Then LiLOCK.State = 2 : LiLOCK2.State = 0 : LiMB.State = 0 : LiRed001.state = 0
	If MBLock_Sav(CurrentPlayer) = 2 Then LiLOCK.State = 1 : LiLOCK2.State = 0 : LiMB.State = 0 : LiRed001.state = 2
	If MBLock_Sav(CurrentPlayer) = 3 Then LiLOCK.State = 1 : LiLOCK2.State = 2 : LiMB.State = 0 : LiRed001.state = 0
	If MBLock_Sav(CurrentPlayer) = 4 Then LiLOCK.State = 1 : LiLOCK2.State = 1 : LiMB.State = 0 : LiRed001.state = 2
	If MBLock_Sav(CurrentPlayer) = 5 Then LiLOCK.State = 1 : LiLOCK2.State = 1 : LiMB.State = 2 : LiRed001.state = 0
	If MBLock_Sav(CurrentPlayer) >= 6 Then LiLOCK.State = 1 : LiLOCK2.State = 1 : LiMB.State = 1
End Sub
Sub Mode_Multiball_Start
	pupDMDDisplay "Splash4","MULTIBALL^START","",3,0,10
	FlashForMs Flasher001, 3000, 200, 0
	AddScore 100000
	PlaySong "Mu_3"
	DOF 482, DOFOn
	bMultiBallMode = True
	Wall037.Collidable = False
	If TotalGamesPlayed >= 2 Then
		If BallsInHole = 0 Then 
			AddMultiball 1 
			vpmtimer.addtimer 3000, "AddBall2 '"
			BallsOnPlayfield = 3
		Elseif BallsInHole = 1 Then 
			AddMultiball 1
			BallsOnPlayfield = 3
		Elseif BallsInHole = 2 Then 
			BallsOnPlayfield = 3
		End If
	End If
	LiMi003.State = 2
	LiHorse001.State = 2
	LiHorse002.State = 2
	LiHorse003.State = 2
	LiHorse004.State = 2
	EnableBallSaver BallSaverTime
	LiRed001.state = 0
	BallsOnPlayfield = 3
End Sub
Sub AddBall2
	kicker002.CreateSizedBallWithMass BallSize / 2, BallMass 
	kicker002.kick 90, 35
End Sub 
Sub DrainBallLock
	Wall037.Collidable = False
	BallsOnPlayfield = 0
End Sub
Sub Mode_Multiball_End 
	AddScore 35000
	PlaySong "Mu_1"
	DOF 482, DOFOff
	bMultiBallMode = False
	RedCount(CurrentPlayer) = 0
	MIRedActive(CurrentPlayer) = False
	MBLock_Sav(CurrentPlayer) = 0
	BallsInHole = 0
	CheckLightMB
	Wall037.Collidable = True
	LiMi003.State = 1
	LiHorse001.State = 0
	LiHorse002.State = 0
	LiHorse003.State = 0
	LiHorse004.State = 0
	LiRed001.state = 2
	LiRed002.state = 2
	LiRed003.state = 2
	LiRed004.state = 2
'	If MIYellActive = False And MIGreenActive = False Then ResetLightPFhaut
End Sub
'#################################
'TRUCK
'#################################

Dim DoorOpen
DoorOpen = False

Sub ResetTruckRamp
	Ramp008.Collidable=False
	TruckDivertWall.Collidable=False
End Sub

Sub SolTruckRamp(enabled)
 If enabled Then
	PlaySound "fx_TruckOpen"
	TruckTimer.enabled=True
 Else
	TruckTimer.enabled=True
End If
End Sub

Sub TruckTimer_TImer()
	
If not DoorOpen Then
	TruckDoor.RotZ = TruckDoor.RotZ -1
	If TruckDoor.RotZ = 0 Then
		TruckTimer.enabled=False
		DoorOpen=True		
		Ramp008.Collidable=True
		TruckDivertWall.Collidable = False
	End IF
Else	
	If TruckDoor.RotZ = 115 Then
		TruckTimer.enabled=False
		DoorOpen=False
		ResetTruckRamp
	Else
		TruckDoor.RotZ = TruckDoor.RotZ +1
	End IF
End If

End Sub

'#################################
'KITT
'#################################

Sub SolKittRampToy(enabled)
 If enabled Then
	PlaySound "superpursuitStart"
	KittUpDownTimer.enabled=True
End If
End Sub

Dim KittDown
KittDown = True

Sub KittUpDownTimer_TImer()
	
If not KittDown Then
	KitSpoilerAv.TransY = KitSpoilerAv.TransY +1
	KitSpoilerAR.TransY = kitSpoilerAR.TransY -1
	KitLeft.TransX = KitLeft.TransX +1
	KitRight.TransX = KitRight.TransX -1

	If KitSpoilerAv.TransY = 0 Then		
		KittUpDownTimer.enabled=False		
		KittDown=True						
	End IF
Else	
	If KitSpoilerAv.TransY = -15 Then
		KittUpDownTimer.enabled=False
		KittDown=False	
	Else 
		KitSpoilerAv.TransY = KitSpoilerAv.TransY -1
		KitSpoilerAR.TransY = kitSpoilerAR.TransY +1
		KitLeft.TransX = KitLeft.TransX -1
		KitRight.TransX = KitRight.TransX +1
	End IF
End If
End Sub

Sub SolKittShakerToy(enabled)
 If enabled Then
	'PlaySound "Rampopens"
	KittShakerTimer.enabled=True
End If
End Sub

Dim KittShaker
KittShaker = True

Sub KittShakerTimer_TImer()
	
If not KittShaker Then
	KitCadre.TransY = KitCadre.TransY -15
	KitGlass.TransY = KitGlass.TransY -15
	kitRoueDessus.TransY = kitRoueDessus.TransY -15
	KitSiege.TransY = KitSiege.TransY -15
	Kitroues.TransY = Kitroues.TransY -15
	Kitporte.TransY = Kitporte.TransY -15
	Kitecranhaut.TransY = Kitecranhaut.TransY -15
	Kitecranred.TransY = Kitecranred.TransY -15
	KitGlass2.TransY = KitGlass2.TransY -15
	KitSpoilerAv.TransY = KitSpoilerAv.TransY -15
	KitSpoilerAR.TransY = kitSpoilerAR.TransY -15
	KitLeft.TransY = KitLeft.TransY -15
	KitRight.TransY = KitRight.TransY -15

	KitCadre.ObjRotX = KitCadre.ObjRotX -5
	KitGlass.ObjRotX = KitGlass.ObjRotX -5
	kitRoueDessus.ObjRotX = kitRoueDessus.ObjRotX -5
	KitSiege.ObjRotX = KitSiege.ObjRotX -5
	Kitroues.ObjRotX = Kitroues.ObjRotX -5
	Kitporte.ObjRotX = Kitporte.ObjRotX -5
	Kitecranhaut.ObjRotX = Kitecranhaut.ObjRotX -5
	Kitecranred.ObjRotX = Kitecranred.ObjRotX -5
	KitGlass2.ObjRotX = KitGlass2.ObjRotX -5
	KitSpoilerAv.ObjRotX = KitSpoilerAv.ObjRotX -5
	KitSpoilerAR.ObjRotX = kitSpoilerAR.ObjRotX -5
	KitLeft.ObjRotX = KitLeft.ObjRotX -5
	KitRight.ObjRotX = KitRight.ObjRotX -5

	If KitCadre.TransY = 0 Then		
		KittShakerTimer.enabled=False		
		KittShaker=True						
	End IF
Else	
	If KitCadre.TransY = 60 Then
		KittShakerTimer.enabled=False
		KittShaker=False	
	Else 
	KitCadre.TransY = KitCadre.TransY +6
	KitGlass.TransY = KitGlass.TransY +6
	kitRoueDessus.TransY = kitRoueDessus.TransY +6
	KitSiege.TransY = KitSiege.TransY +6
	Kitroues.TransY = Kitroues.TransY +6
	Kitporte.TransY = Kitporte.TransY +6
	Kitecranhaut.TransY = Kitecranhaut.TransY +6
	Kitecranred.TransY = Kitecranred.TransY +6
	KitGlass2.TransY = KitGlass2.TransY +6
	KitSpoilerAv.TransY = KitSpoilerAv.TransY +6
	KitSpoilerAR.TransY = kitSpoilerAR.TransY +6
	KitLeft.TransY = KitLeft.TransY +6
	KitRight.TransY = KitRight.TransY +6

	KitCadre.ObjRotX = KitCadre.ObjRotX +2
	KitGlass.ObjRotX = KitGlass.ObjRotX +2
	kitRoueDessus.ObjRotX = kitRoueDessus.ObjRotX +2
	KitSiege.ObjRotX = KitSiege.ObjRotX +2
	Kitroues.ObjRotX = Kitroues.ObjRotX +2
	Kitporte.ObjRotX = Kitporte.ObjRotX +2
	Kitecranhaut.ObjRotX = Kitecranhaut.ObjRotX +2
	Kitecranred.ObjRotX = Kitecranred.ObjRotX +2
	KitGlass2.ObjRotX = KitGlass2.ObjRotX +2
	KitSpoilerAv.ObjRotX = KitSpoilerAv.ObjRotX +2
	KitSpoilerAR.ObjRotX = kitSpoilerAR.ObjRotX +2
	KitLeft.ObjRotX = KitLeft.ObjRotX +2
	KitRight.ObjRotX = KitRight.ObjRotX +2

	End IF
End If
End Sub
'*************
' Save CurrentPlayer
'*************
Sub ResetEvents
	table1.ColorGradeImage = "ColorGradeLUT256x16_1to2"
	Wall037.Collidable = True
	Flasher003.visible = 0
	ChangeBall(0)
	SolURFlipper 0
	SolULFlipper 0
'	FlInitBumper 1, "blacklight"
	FlInitBumper 1, "red"
	FlInitBumper 2, "red"
	FlInitBumper 3, "red"
	GreenCount(CurrentPlayer) = 0
	BonusGreenCount(CurrentPlayer) = 0
	YellCount(CurrentPlayer) = 0
	RedCount(CurrentPlayer) = 0
	MIGreenActive(CurrentPlayer) = False
	MIYellActive(CurrentPlayer) = False
	MIRedActive(CurrentPlayer) = False
	MBLockActive(CurrentPlayer) = False
	ResetLightPFhaut
	MBLock_Sav(CurrentPlayer) = 0
	BallsInHole = 0
	KickBackActive(CurrentPlayer) = False
End Sub
	
Sub CheckEventPlayer
	If TotalGamesPlayed >= 2 Then
		MIYellActive(CurrentPlayer) = False
		YellCount(CurrentPlayer) = 0
		LiMi002.State = 0
		LiKARR001.State = 0
		LiKARR002.State = 0
		LiKARR003.State = 0
		LiKARR004.State = 0
		LiKARR005.State = 0
		LiYell001.state = 2
		MiYellEndTimer.Enabled = False
		If MIGreenActive(CurrentPlayer) = True And GreenCount(CurrentPlayer) = 4 Then
			LiMi001.State = 2
			LiGreen001.state = 0
'			If KittDown = False Then SolKittRampToy 1
		End If
		If MIGreenActive(CurrentPlayer) = True And KittDown = True Then SolKittRampToy 1
		If MIGreenActive(CurrentPlayer) = False And KittDown = False Then SolKittRampToy 1
		If MBLockActive(CurrentPlayer) = True And DoorOpen = False Then SolTruckRamp 1 : LiRed001.state = 0
		If MBLockActive(CurrentPlayer) = False And DoorOpen = True Then SolTruckRamp 1 : LiRed001.state = 2
		If KickBackActive(CurrentPlayer) = True Then LiTarget001.state = 1 : LiTarget002.state = 1 : LiTarget003.state = 1 : LeftOutlane.state = 2 : RightOutlane.state = 2
		If KickBackActive(CurrentPlayer) = False Then LiTarget001.state = 0 : LiTarget002.state = 0 : LiTarget003.state = 0 : LeftOutlane.state = 0 : RightOutlane.state = 0
	CheckLightMB 
	CheckLiGreen
	CheckColorMISS
	LiStart.state = 0
	End If
End Sub

'***********************
' Glowball Section 
'***********************
Dim GlowBall, CustomBulbIntensity(4)
Dim  GBred(4)
Dim GBgreen(4)
Dim GBblue(4)
Dim CustomBallImage(4), CustomBallLogoMode(4), CustomBallDecal(4), CustomBallGlow(4)
Dim GlowAura,GlowIntensity,ChooseBall

GlowAura=230 'GlowBlob Auroa radius
GlowIntensity=25'Glowblob intensity

' blue GlowBall
CustomBallGlow(1) = 		True
GBred(1) = 1 : GBgreen(1)	= 33 : GBblue(1) = 105
' Vert GlowBall
CustomBallGlow(2) = 		True
GBred(2) = 1 : GBgreen(2)	= 33 : GBblue(2) = 5
' Rouge GlowBall
CustomBallGlow(3) = 		True
GBred(3) = 130 : GBgreen(3)	= 1 : GBblue(3) = 1
' Orange GlowBall
CustomBallGlow(4) = 		True
GBred(4) = 250 : GBgreen(4)	= 130 : GBblue(4) = 1

Dim Glowing(10)
Set Glowing(0) = Glowball1 : Set Glowing(1) = Glowball2 : Set Glowing(2) = Glowball3 : Set Glowing(3) = Glowball4 : Set Glowing(4) = Glowball4

'*** change ball appearance ***

Sub ChangeBall(ballnr)
	If ModeChangeBallActive = 0 Then
	Dim BOT, ii, col
	GlowBall = CustomBallGlow(ballnr)
	For ii = 0 to 4
		col = RGB(GBred(ballnr), GBgreen(ballnr), GBblue(ballnr))
		Glowing(ii).color = col : Glowing(ii).colorfull = col 
	Next
	End If
End Sub

' *** Ball Shadow code / Glow Ball code / Primitive Flipper Update ***

Dim BallShadowArray
BallShadowArray = Array (BallShadow1, BallShadow2, BallShadow3,BallShadow4,BallShadow5)

Sub GraphicsTimer_Timer()
	Dim BOT, b
    BOT = GetBalls

	' switch off glowlight for removed Balls
	IF GlowBall Then
		For b = UBound(BOT) + 1 to 3
			If GlowBall and Glowing(b).state = 1 Then Glowing(b).state = 0 End If
		Next
	End If

    For b = 0 to UBound(BOT)
		If GlowBall and b < 4 Then
			If Glowing(b).state = 0 Then Glowing(b).state = 1 end if
			Glowing(b).BulbHaloHeight = BOT(b).z + 32
			Glowing(b).x = BOT(b).x
			Glowing(b).y = BOT(b).Y+10
			Glowing(b).falloff=GlowAura 'GlowBlob Auroa radius
			Glowing(b).intensity=GlowIntensity 'Glowblob intensity
		End If
	Next
End Sub
'************
' Rotation Light Bonus
'************
Sub RotateLaneLightsLeftUp
'    Dim TempState
'    TempState = LeftInlane.State
'    LeftInlane.State = LeftInlane2.State
'    LeftInlane2.State = LeftOutlane.State
'    LeftOutlane.State = TempState
End Sub

Sub RotateLaneLightsRightUp
'    Dim TempState
'	TempState = RightInlane.State
'    RightInlane.State = RightInlane2.State
'    RightInlane2.State = RightOutlane.State
'    RightOutlane.State = TempState
End Sub


Sub UDMD (toptext, bottomtext, utime)
	If UseUltraDMD > 0 Then UltraDMD.DisplayScene00Ex "", toptext, 8, 14, bottomtext, 8,14, 14, utime, 14
End Sub
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'   Pinup Active Backglass
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  

'**************************
'   PinUp Player Config
'   Change HasPuP = True if using PinUp Player Videos
'**************************

	Dim HasPup:HasPuP = True

	Dim PuPlayer

	Const pTopper=0
	Const pDMD=1
	Const pBackglass=2
	Const pPlayfield=3
	Const pMusic=4
	Const pMusic2=5
	Const pCallouts=6
	Const pBackglass2=7
	Const pTopper2=8
	Const pPopUP=9
	Const pGame=10


	if HasPuP Then
	on error resume next
	Set PuPlayer = CreateObject("PinUpPlayer.PinDisplay") 
	PuPlayer.B2SInit "", pGameName   'use new method to startup pup with dmd via puppack
	on error goto 0
	if not IsObject(PuPlayer) then HasPuP = False
	end If

	PuPlayer.LabelInit pBackglass

Sub resetbackglassOFFScore
	PuPlayer.LabelSet pDMD,"Bonus1", FormatNumber(JackpotsBonus,0),0,""
	PuPlayer.LabelSet pDMD,"Bonus2", FormatNumber(RaiderBonus,0),0,""
	PuPlayer.LabelSet pDMD,"Bonus3", FormatNumber(CroftBonus,0),0,""
	PuPlayer.LabelSet pDMD,"Bonus4", FormatNumber(RelicsBonus,0),0,""
	PuPlayer.LabelSet pDMD,"Bonus5", FormatNumber(ArtefactsBonus,0),0,""
	PuPlayer.LabelSet pDMD,"BonusTotal", FormatNumber(TotalBonus,0),0,""
End Sub

Function BonusScoreTotal()
	BonusScoreTotal = BonusMultiplier(CurrentPlayer) * ((JackpotsBonus * 5000) + (RaiderBonus * 2000) + (CroftBonus * 2000) + (RelicsBonus * 15000) + (ArtefactsBonus *10000) )
End Function 
Sub SeqBonus
	vpmtimer.addtimer 200, "SeqBonus1 '"
'	vpmtimer.addtimer 650, "SeqBonus2 '"
'	vpmtimer.addtimer 1120, "SeqBonus3 '"
'	vpmtimer.addtimer 1570, "SeqBonus4 '"
'	vpmtimer.addtimer 2120, "SeqBonus5 '"
End Sub
Sub SeqBonus1
	PuPlayer.LabelSet pDMD,"Bonus1", FormatNumber(JackpotsBonus,0),1,""
'	PlaySound "Bat"
End Sub
Sub SeqBonus2
'	PuPlayer.LabelSet pDMD,"Bonus2", FormatNumber(RaiderBonus,0),1,""
End Sub
Sub SeqBonus3
'	PuPlayer.LabelSet pDMD,"Bonus3", FormatNumber(CroftBonus,0),1,""
End Sub
Sub SeqBonus4
'	PuPlayer.LabelSet pDMD,"Bonus4", FormatNumber(RelicsBonus,0),1,""
End Sub
Sub SeqBonus5
'	PuPlayer.LabelSet pDMD,"Bonus5", FormatNumber(ArtefactsBonus,0),1,""
'	PlaySound "Bat2"
	PlayerScore(CurrentPlayer) = PlayerScore(CurrentPlayer) + BonusScoreTotal
End Sub

	'called on table load
Sub resetbackglass
'	PuPlayer.LabelSet pBackglass,"titleimg","",1,"{'mt':2,'color':111111, 'width': 0, 'height': 0, 'yalign': 0}"
	PuPlayer.LabelShowPage pBackglass,1,0,""
End Sub


'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'   Pupdmd Settings
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
	'PUPDMD Layout for each Table1
	'Setup Pages.  Note if you use fonts they must be in FONTS folder of the pupVideos\tablename\FONTS  "case sensitive exact naming fonts!"
	'*****************************************************************
	dim dmdnote:dmdnote="2-shortnote.mp4"

	Sub pSetPageLayouts

	DIM dmddef
	DIM dmdtomb
	DIM dmdalt
	DIM dmdscr
	DIM dmdfixed

	'labelNew <screen#>, <Labelname>, <fontName>,<size%>,<colour>,<rotation>,<xalign>,<yalign>,<xpos>,<ypos>,<PageNum>,<visible>
	'***********************************************************************'
	'<screen#>, in standard wed set this to pDMD ( or 1)
	'<Labelname>, your name of the label. keep it short no spaces (like 8 chars) although you can call it anything really. When setting the label you will use this labelname to access the label.
	'<fontName> Windows font name, this must be exact match of OS front name. if you are using custom TTF fonts then double check the name of font names.
	'<size%>, Height as a percent of display height. 20=20% of screen height.
	'<colour>, integer value of windows color.
	'<rotation>, degrees in tenths   (900=90 degrees)
	'<xAlign>, 0= horizontal left align, 1 = center horizontal, 2= right horizontal
	'<yAlign>, 0 = top, 1 = center, 2=bottom vertical alignment
	'<xpos>, this should be 0, but if you want to force a position you can set this. it is a % of horizontal width. 20=20% of screen width.
	'<ypos> same as xpos.
	'<PageNum> IMPORTANT this will assign this label to this page or group.
	'<visible> initial state of label. visible=1 show, 0 = off.


	if PuPDMDDriverType=pDMDTypeReal Then 'using RealDMD Mirroring.  **********  128x32 Real Color DMD  
		dmdalt="PKMN Pinball"
		dmdfixed="Instruction"
		dmdscr="Impact"    'main scorefont
		dmddef="Zig"
		dmdtomb="Ruben"

		'Page 1 (default score display)
			PuPlayer.LabelNew pDMD,"Play1"   ,dmddef,15,10013642   ,1,0,2,2,0,1,0
			PuPlayer.LabelNew pDMD,"Ball"    ,dmddef,15,10013642   ,1,2,2,96,0,1,0 '
			PuPlayer.LabelNew pDMD,"CurScore",dmdscr,60,33023   ,0,1,1, 0,0,1,0

		'Page 2 (default Text Splash 1 Big Line)
			PuPlayer.LabelNew pDMD,"Splash",dmdscr,60,16744448,0,1,1,0,0,2,0

		'Page 3 (default Text Splash 2 and 3 Lines)
			 PuPlayer.LabelNew pDMD,"Splash3a",dmddef,25,33023,0,1,0,0,2,3,0
			 PuPlayer.LabelNew pDMD,"Splash3b",dmdalt,25,10013642,0,1,0,0,30,3,0
			 PuPlayer.LabelNew pDMD,"Splash3c",dmdalt,25,10013642,0,1,0,0,55,3,0

		'Page 4 (2 Line Gameplay DMD)
'			 PuPlayer.LabelNew pDMD,"Splash4a",dmddef,13,2697513,0,1,0,0,30,4,0
'			 PuPlayer.LabelNew pDMD,"Splash4b",dmddef,10,2697513,0,1,2,0,55,4,0
			PuPlayer.LabelNew pDMD,"Splash4a",dmddef,25,8454143,0,1,0,0,10,4,0
			PuPlayer.LabelNew pDMD,"Splash4b",dmddef,25,157,0,1,2,0,80,4,0

		'Page 5 (3 layer large text for overlay targets function,  must you fixed width font!
			PuPlayer.LabelNew pDMD,"Back5"    ,dmdfixed,80,8421504,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Middle5"  ,dmdfixed,80,65535  ,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Flash5"   ,dmdfixed,80,65535  ,0,1,1,0,0,5,0

		'Page 6 (3 Lines for big # with two lines,  "19^Orbits^Count")
			PuPlayer.LabelNew pDMD,"Splash6a",dmddef,90,65280,0,0,0,15,1,6,0
			PuPlayer.LabelNew pDMD,"Splash6b",dmddef,50,33023,0,1,0,60,0,6,0
			PuPlayer.LabelNew pDMD,"Splash6c",dmddef,40,33023,0,1,0,60,50,6,0

		'Page 7 (Show High Scores Fixed Fonts)
'			PuPlayer.LabelNew pDMD,"Splash7a",dmddef,20,8454143,0,1,0,0,2,7,0
'			PuPlayer.LabelNew pDMD,"Splash7b",dmdfixed,40,33023,0,1,0,0,20,7,0
'			PuPlayer.LabelNew pDMD,"Splash7c",dmdfixed,40,33023,0,1,0,0,50,7,0
			PuPlayer.LabelNew pDMD,"Splash7a",dmddef,25,157,0,1,0,0,5,7,0
			PuPlayer.LabelNew pDMD,"Splash7b",dmddef,20,10013642,0,1,0,0,40,7,0
			PuPlayer.LabelNew pDMD,"Splash7c",dmddef,20,10013642,0,1,0,0,70,7,0

			pDMDStartBackLoop "Videoscenes","MainBack.mp4"
'			pDMDStartBackLoop "DMDSplash","intro1.mp4"
'			dmdnote="1-shortnote.mp4"

	END IF  ' use PuPDMDDriver

	if PuPDMDDriverType=pDMDTypeLCD THEN  'Using 4:1 Standard ratio LCD PuPDMD  ************ lcd **************

		'dmddef="Impact"
		dmdalt="PKMN Pinball"
		dmdfixed="Instruction"
		dmdscr="Impact"    'main scorefont
		dmddef="Zig"
		dmdtomb="Ruben"
		
		'Page 1 (default score display)
		PuPlayer.LabelNew pDMD,"Credits" ,dmdscr,20,16744448   ,1,0,0,3,0,1,0 '
		PuPlayer.LabelNew pDMD,"Play1"   ,dmdscr,25,16744448   ,1,0,2,2,0,1,0
		PuPlayer.LabelNew pDMD,"Ball"    ,dmdscr,25,16744448   ,1,2,2,96,0,1,0 '
		PuPlayer.LabelNew pDMD,"MsgScore",dmdscr,45,33023   ,0,1,0, 0,40,1,0
		PuPlayer.LabelNew pDMD,"CurScore",dmdscr,60,33023   ,0,1,1, 0,0,1,0

		'Page 2 (default Text Splash 1 Big Line)
		PuPlayer.LabelNew pDMD,"Splash",dmdtomb,60,16744448,0,1,1,0,0,2,0
		PuPlayer.LabelNew pBackglass, "InfoGame",dmdtomb,60,159	,0,1,1, 0,0,2,1

		'Page 3 (default Text 3 Lines)
			PuPlayer.LabelNew pDMD,"Splash3a",dmdscr,35,33023	,0,1,0,0,2,3,0
			PuPlayer.LabelNew pDMD,"Splash3b",dmdscr,25,159	,0,1,0,0,30,3,0
			PuPlayer.LabelNew pDMD,"Splash3c",dmdtomb,35,16744448	,0,1,0,0,57,3,0


		'Page 4 (default Text 2 Line)
		PuPlayer.LabelNew pDMD,"Splash4a",dmdtomb,40,8454143,0,1,0,0,0,4,0
		PuPlayer.LabelNew pDMD,"Splash4b",dmdtomb,30,157,0,1,2,0,75,4,0

		'Page 5 (3 layer large text for overlay targets function,  must you fixed width font!
			PuPlayer.LabelNew pDMD,"Back5"    ,dmdfixed,80,2697513,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Middle5"  ,dmdfixed,80,2697513  ,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Flash5"   ,dmdfixed,80,2697513  ,0,1,1,0,0,5,0

		'Page 6 (3 Lines for big # with two lines,  "19^Orbits^Count")
			PuPlayer.LabelNew pDMD,"Splash6a",dmddef,90,2697513,0,0,0,15,1,6,0
			PuPlayer.LabelNew pDMD,"Splash6b",dmddef,50,2697513,0,1,0,60,0,6,0
			PuPlayer.LabelNew pDMD,"Splash6c",dmddef,40,2697513,0,1,0,60,50,6,0

		'Page 7 (Show High Scores Fixed Fonts)
			PuPlayer.LabelNew pDMD,"Splash7a",dmdtomb,40,157,0,1,0,0,1,7,0
			PuPlayer.LabelNew pDMD,"Splash7b",dmdscr,34,8454143,0,1,0,0,36,7,0
			PuPlayer.LabelNew pDMD,"Splash7c",dmdscr,30,8454143,0,1,0,0,66,7,0
 
			pDMDStartBackLoop "Videoscenes","MainBack.mp4"
'			dmdnote="1-shortnote.mp4"

	END IF  ' use PuPDMDDriver

	if PuPDMDDriverType=pDMDTypeFULL THEN  'Using FULL BIG LCD PuPDMD  ************ lcd **************

		'dmddef="Impact"
		dmdalt="PKMN Pinball"
		dmdfixed="Instruction"
		dmdscr="Impact"    'main scorefont
		dmddef="Zig"
		dmdtomb="Ruben"

		'Page 1 (default score display)		
			PuPlayer.LabelNew pDMD,"Credits" ,dmdscr,6,128   ,0,1,1,12,73,1,0 '
			PuPlayer.LabelNew pDMD,"PlayersNumber" ,dmdscr,6,32896   ,0,1,1,18,73,1,0 'OK
			PuPlayer.LabelNew pDMD,"Ball"    ,dmdscr,6,12870144   ,0,1,1,24,73,1,0 'OK
			PuPlayer.LabelNew pDMD,"Play1"   ,dmdscr,8,128   ,0,1,1,85,85,1,0 'OK
			PuPlayer.LabelNew pDMD,"CurScore",dmdscr,12,32896   ,0,1,1,30,92,1,0 'OK
'			PuPlayer.LabelNew pDMD,"Bonus1"	,dmdscr,		    6,16777215  ,0,1,1,52,30,1,0 'JackpotsBonus
'			PuPlayer.LabelNew pDMD,"Bonus2"	,dmdscr,		    6,16777215  ,0,1,1,52,36,1,0 'RaiderBonus
'			PuPlayer.LabelNew pDMD,"Bonus3",dmdscr,			    6,16777215  ,0,1,1,52,42,1,0 'CroftBonus
'			PuPlayer.LabelNew pDMD,"Bonus4",dmdscr,			    6,16777215  ,0,1,1,52,48,1,0 'RelicsBonus
'			PuPlayer.LabelNew pDMD,"Bonus5",dmdscr,			    6,16777215  ,0,1,1,52,54,1,0 'ArtefactsBonus
'			PuPlayer.LabelNew pDMD,"BonusTotal",dmdscr,			8,16777215  ,0,1,1,78,42,1,0
			PuPlayer.LabelNew pDMD,"CScoreP1",dmdscr,6,1992703   ,0,1,1,10,80,1,0 
			PuPlayer.LabelNew pDMD,"CScoreP2",dmdscr,6,5548032     ,0,1,1,30,80,1,0 
			PuPlayer.LabelNew pDMD,"CScoreP3",dmdscr,6,128   ,0,1,1,50,80,1,0
			PuPlayer.LabelNew pDMD,"CScoreP4",dmdscr,6,12870144   ,0,1,1,70,80,1,0 

		'Page 2 (default Text Splash 1 Big Line)
			PuPlayer.LabelNew pDMD,"Splash",dmdtomb,28,157,0,1,1,0,0,2,0

		'Page 3 (default Text 3 Lines)
			PuPlayer.LabelNew pDMD,"Splash3a",dmdscr,18,33023	,0,1,0,0,20,3,0
			PuPlayer.LabelNew pDMD,"Splash3b",dmdscr,14,159	,0,1,0,0,35,3,0
			PuPlayer.LabelNew pDMD,"Splash3c",dmdtomb,18,16744448	,0,1,0,0,50,3,0


		'Page 4 (default Text 2 Line)
			PuPlayer.LabelNew pDMD,"Splash4a",dmdtomb,24,8454143,0,1,0,0,20,4,0
			PuPlayer.LabelNew pDMD,"Splash4b",dmdtomb,20,157,0,1,2,0,65,4,0

		'Page 5 (3 layer large text for overlay targets function,  must you fixed width font!
			PuPlayer.LabelNew pDMD,"Back5"    ,dmdfixed,80,2697513,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Middle5"  ,dmdfixed,80,2697513  ,0,1,1,0,0,5,0
			PuPlayer.LabelNew pDMD,"Flash5"   ,dmdfixed,80,2697513  ,0,1,1,0,0,5,0

		'Page 6 (3 Lines for big # with two lines,  "19^Orbits^Count")
			PuPlayer.LabelNew pDMD,"Splash6a",dmddef,90,2697513,0,0,0,15,1,6,0
			PuPlayer.LabelNew pDMD,"Splash6b",dmddef,50,2697513,0,1,0,60,0,6,0
			PuPlayer.LabelNew pDMD,"Splash6c",dmddef,40,2697513,0,1,0,60,50,6,0

		'Page 7 (Show High Scores Fixed Fonts)
'			PuPlayer.LabelNew pDMD,"Splash7a",dmdtomb,20,157,0,1,0,0,18,7,0
			PuPlayer.LabelNew pDMD,"Splash7a",dmdscr,18,8454143,0,1,0,0,18,7,0
			PuPlayer.LabelNew pDMD,"Splash7b",dmdscr,16,8454143,0,1,0,0,40,7,0
			PuPlayer.LabelNew pDMD,"Splash7c",dmdscr,16,8454143,0,1,0,0,60,7,0

		'Page 8 (HighScore)
		PuPlayer.LabelNew pDMD,"HighScore",dmdtomb,			22,157,0,1,0,0,18,7,0
		PuPlayer.LabelNew pDMD,"HighScoreL1",dmdscr,		14,16744448	,0,0,1,20,40,1,1
		PuPlayer.LabelNew pDMD,"HighScoreL2",dmdscr,		14,16744448	,0,0,1,25,40,1,1
		PuPlayer.LabelNew pDMD,"HighScoreL3",dmdscr,		14,16744448	,0,0,1,30,40,1,1
		PuPlayer.LabelNew pDMD,"HighScoreL4",dmdscr,		10,33023	,0,0,1,20,55,1,1
		
		pDMDStartBackLoop "Videoscenes","MainBack.mp4"
'		dmdnote="1-shortnote.mp4"

	END IF  ' use PuPDMDDriver

	end Sub 'page Layouts


	'*****************************************************************
	'        PUPDMD Custom SUBS/Events for each Table1
	'     **********    MODIFY THIS SECTION!!!  ***************
	'*****************************************************************
	'

	Sub pDMDStartBall
	end Sub

	Sub pDMDGameOver
	playclear pDMD
	pAttractStart
	end Sub

	Sub pAttractStart
	pDMDSetPage(pDMDBlank)   'set blank text overlay page.
	pCurAttractPos=0
	pInAttract=True 'Startup in AttractMode
	pAttractNext
	end Sub


	Sub pDMDStartUP
'	PuPEvent 118
	pInAttract=true
	end Sub

	Sub pDMDStartGame
	pInAttract=false
	pDMDSetPage(pScores)   'set blank text overlay page.
'	PuPEvent 119
'	PuPEvent 1
	end Sub

	DIM pCurAttractPos: pCurAttractPos=0


	'********************** gets called auto each page next and timed already in DMD_Timer.  make sure you use pupDMDDisplay or it wont advance auto.
	Sub pAttractNext
	pCurAttractPos=pCurAttractPos+1

	  Select Case pCurAttractPos

	  Case 1 pupDMDDisplay "Splash4","Game^Over", "",3, 1,10
			PlaySong "Mu_Intro"
'	  Case 2 pupDMDDisplay "highscore", "High Score^AAA   2451654^BBB   2342342", "", 5, 0, 10
	  Case 2 pupDMDDisplay "Splash","High Score", "",2, 0,10
	  Case 3 pupDMDDisplay "highscore", "High Score^AAA   2451654^BBB   2342342^CCC   2342342", "", 5, 0, 10
      Case 4 If(Credits> 0) then
			pupDMDDisplay "Splash4","Press^Start","",3,1,10
			Else
			pupDMDDisplay "Splash4","INSERT^Coins","",3,1,10
			End If
      Case 5 pupDMDDisplay "Splash4","EXTRABALL ^50M - 100M - 200M","",3,0,10
      Case 6 pupDMDDisplay "Splash4","KNIGHT RIDER^By Tombg","",3,0,10
	  Case 7 If(Credits> 0) then
			pupDMDDisplay "Splash4","Press^Start","",3,1,10
			Else
			pupDMDDisplay "Splash4","INSERT^Coins","",3,1,10
			End If
	  Case Else
		pCurAttractPos=0
		pAttractNext 'reset to beginning
	  end Select

	end Sub

'************************ called during gameplay to update Scores ***************************
Dim CurTestScore:CurTestScore=0
Sub pDMDUpdateScores  'call this ONLY on timer 300ms is good enough
if pDMDCurPage <> pScores then Exit Sub

puPlayer.LabelSet pDMD,"CurScore","" & FormatNumber(PlayerScore(CurrentPlayer), 0),1,""
puPlayer.LabelSet pDMD,"Play1","Player  " & FormatNumber(CurrentPlayer, 0),1,""
puPlayer.LabelSet pDMD,"Ball","" & FormatNumber(BallinGame(CurrentPlayer), 0) & "/" & FormatNumber(BallsPerGame, 0),1,""

PuPlayer.LabelSet pDMD,"PlayersNumber",""& FormatNumber(PlayersPlayingGame, 0),1,""
PuPlayer.LabelSet pDMD,"Credits",""& Credits,1,""

If PlayersPlayingGame <= 1 or UseBGB2S = 1 Then 
	PuPlayer.LabelSet pDMD,"CScoreP1","" & FormatNumber(PlayerScore(1),0),0,""
	PuPlayer.LabelSet pDMD,"CScoreP2","" & FormatNumber(PlayerScore(2),0),0,""
	PuPlayer.LabelSet pDMD,"CScoreP3","" & FormatNumber(PlayerScore(3),0),0,""
	PuPlayer.LabelSet pDMD,"CScoreP4","" & FormatNumber(PlayerScore(4),0),0,""
End If 
'If B2SOff Then
If UseBGB2S = 0 Then
	If PlayersPlayingGame > 1 Then PuPlayer.LabelSet pDMD,"CScoreP1","" & FormatNumber(PlayerScore(1),0),1,""
	If PlayersPlayingGame >= 2 Then PuPlayer.LabelSet pDMD,"CScoreP2","" & FormatNumber(PlayerScore(2),0),1,""
	If PlayersPlayingGame >= 3 Then PuPlayer.LabelSet pDMD,"CScoreP3","" & FormatNumber(PlayerScore(3),0),1,""
	If PlayersPlayingGame >= 4 Then PuPlayer.LabelSet pDMD,"CScoreP4","" & FormatNumber(PlayerScore(4),0),1,""
End If
end Sub

	'********************  pretty much only use pupDMDDisplay all over ************************   
	' Sub pupDMDDisplay(pEventID, pText, VideoName,TimeSec, pAni,pPriority)
	' pEventID = reference if application,  
	' pText = "text to show" separate lines by ^ in same string
	' VideoName "gameover.mp4" will play in background  "@gameover.mp4" will play and disable text during gameplay.
	' also global variable useDMDVideos=true/false if user wishes only TEXT
	' TimeSec how long to display msg in Seconds
	' animation if any 0=none 1=Flasher
	' also,  now can specify color of each line (when no animation).  "sometext|12345"  will set label to "sometext" and set color to 12345
	'Samples
	'pupDMDDisplay "shoot", "SHOOT AGAIN!", ", 3, 1, 10 
	'pupDMDDisplay "default", "DATA GADGET LIT", "@DataGadgetLit.mp4", 3, 1, 10
	'pupDMDDisplay "shoot", "SHOOT AGAIN!", "@shootagain.mp4", 3, 1, 10   
	'pupDMDDisplay "balllock", "Ball^Locked|16744448", "", 5, 1, 10             '  5 seconds,  1=flash, 10=priority, ball is first line, locked on second and locked has custom color |
	'pupDMDDisplay "balllock","Ball 2^is^Locked", "balllocked2.mp4",3, 1,10     '  3 seconds,  1=flash, play balllocked2.mp4 from dmdsplash folder, 
	'pupDMDDisplay "balllock","Ball^is^Locked", "@balllocked.mp4",3, 1,10       '  3 seconds,  1=flash, play @balllocked.mp4 from dmdsplash folder, because @ text by default is hidden unless useDmDvideos is disabled.


	'pupDMDDisplay "shownum", "3^More To|616744448^GOOOO", "", 5, 1, 10         ' "shownum" is special.  layout is line1=BIG NUMBER and line2,line3 are side two lines.  "4^Ramps^Left"

	'pupDMDDisplay "target", "POTTER^110120", "blank.mp4", 10, 0, 10            ' 'target'...  first string is line,  second is 0=off,1=already on, 2=flash on for each character in line (count must match)

	'pupDMDDisplay "highscore", "High Score^AAA   2451654^BBB   2342342", "", 5, 0, 10            ' highscore is special  line1=text title like highscore, line2, line3 are fixed fonts to show AAA 123,123,123
	'pupDMDDisplay "highscore", "High Score^AAA   2451654|616744448^BBB   2342342", "", 5, 0, 10  ' sames as above but notice how we use a custom color for text |



'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'  High Scores
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  

	' load em up


	Dim hschecker:hschecker = 0

	Sub Loadhs
		Dim x
		x = LoadValue(TableName, "HighScore1")
		If(x <> "") Then HighScore(0) = CDbl(x) Else HighScore(0) = 50000000 End If

		x = LoadValue(TableName, "HighScore1Name")
		If(x <> "") Then HighScoreName(0) = x Else HighScoreName(0) = "TOM" End If

		x = LoadValue(TableName, "HighScore2")
		If(x <> "") then HighScore(1) = CDbl(x) Else HighScore(1) = 25000000 End If

		x = LoadValue(TableName, "HighScore2Name")
		If(x <> "") then HighScoreName(1) = x Else HighScoreName(1) = "AMA" End If

		x = LoadValue(TableName, "HighScore3")
		If(x <> "") then HighScore(2) = CDbl(x) Else HighScore(2) = 15000000 End If

		x = LoadValue(TableName, "HighScore3Name")
		If(x <> "") then HighScoreName(2) = x Else HighScoreName(2) = "LIA" End If

		x = LoadValue(TableName, "HighScore4")
		If(x <> "") then HighScore(3) = CDbl(x) Else HighScore(3) = 10000000 End If

		x = LoadValue(TableName, "HighScore4Name")
		If(x <> "") then HighScoreName(3) = x Else HighScoreName(3) = "EMI" End If

		x = LoadValue(TableName, "Credits")
		If(x <> "") then Credits = CInt(x) Else Credits = 0 End If

		x = LoadValue(TableName, "TotalGamesPlayed")
		If(x <> "") then TotalGamesPlayed = CInt(x) Else TotalGamesPlayed = 0 End If

	'	If hschecker = 0 Then
	'	checkorder
	'	End If
	End Sub

	Dim hs3,hs2,hs1,hs0,hsn3,hsn2,hsn1,hsn0


	Sub checkorder
		hschecker = 1
		hs3 = HighScore(3)
		hs2 = HighScore(2)
		hs1 = HighScore(1)
		hs0 = HighScore(0)
		hsn3 = HighScoreName(3)
		hsn2 = HighScoreName(2)
		hsn1 = HighScoreName(1)
		hsn0 = HighScoreName(0)
		If hs3 > hs0 Then
			HighScore(0) = hs3
			HighScoreName(0) = hsn3	
			HighScore(1) = hs0
			HighScoreName(1) = hsn0	
			HighScore(2) = hs1
			HighScoreName(2) = hsn1	
			HighScore(3) = hs2
			HighScoreName(3) = hsn2

		ElseIf hs3 > hs1 Then
			HighScore(0) = hs0
			HighScoreName(0) = hsn0	
			HighScore(1) = hs3
			HighScoreName(1) = hsn3	
			HighScore(2) = hs1
			HighScoreName(2) = hsn1	
			HighScore(3) = hs2
			HighScoreName(3) = hsn2
		ElseIf hs3 > hs2 Then
			HighScore(0) = hs0
			HighScoreName(0) = hsn0	
			HighScore(1) = hs1
			HighScoreName(1) = hsn1	
			HighScore(2) = hs3
			HighScoreName(2) = hsn3	
			HighScore(3) = hs2
			HighScoreName(3) = hsn2
		ElseIf hs3 < hs2 Then
			HighScore(0) = hs0
			HighScoreName(0) = hsn0	
			HighScore(1) = hs1
			HighScoreName(1) = hsn1	
			HighScore(2) = hs2
			HighScoreName(2) = hsn2	
			HighScore(3) = hs3
			HighScoreName(3) = hsn3
		End If

		savehs
	End Sub


	Sub Savehs
		SaveValue TableName, "HighScore1", HighScore(0)
		SaveValue TableName, "HighScore1Name", HighScoreName(0)
		SaveValue TableName, "HighScore2", HighScore(1)
		SaveValue TableName, "HighScore2Name", HighScoreName(1)
		SaveValue TableName, "HighScore3", HighScore(2)
		SaveValue TableName, "HighScore3Name", HighScoreName(2)
		SaveValue TableName, "HighScore4", HighScore(3)
		SaveValue TableName, "HighScore4Name", HighScoreName(3)
		SaveValue TableName, "Credits", Credits
	End Sub

Sub Reseths
    HighScoreName(0) = "AAA"
    HighScoreName(1) = "BBB"
    HighScoreName(2) = "CCC"
    HighScoreName(3) = "DDD"
    HighScore(0) = 90000000
    HighScore(1) = 50000000
    HighScore(2) = 20000000
    HighScore(3) = 15000000
    Savehs
End Sub

	Sub Savegp
		SaveValue TableName, "TotalGamesPlayed", TotalGamesPlayed
		vpmtimer.addtimer 1000, "Loadhs'"
	End Sub


	' Initials

	Dim hsbModeActive:hsbModeActive = False
	Dim hsEnteredName
	Dim hsEnteredDigits(3)
	Dim hsCurrentDigit
	Dim hsValidLetters
	Dim hsCurrentLetter
	Dim hsLetterFlash

	' Check the scores to see if you got one

	Sub CheckHighscore()
		Dim tmp
		tmp = PlayerScore(CurrentPlayer)
'		osbtempscore = Score(CurrentPlayer)

		If tmp > HighScore(0)Then 'add 1 credit for beating the highscore
			Credits = Credits + 1
'			DOF 125, DOFOn
		End If

		If tmp > HighScore(3) Then
			PlaySound SoundFXDOF("fx_Knocker", 122, DOFPulse, DOFKnocker)
			DOF 121, DOFPulse
			vpmtimer.addtimer 2000, "PlaySound ""vo_contratulationsgreatscore"" '"
			HighScore(3) = tmp
			'enter player's name
			HighScoreEntryInit()
		Else

			EndOfBallComplete()
		End If
	End Sub





	Sub HighScoreEntryInit()
		hsbModeActive = True
		PlaySound "vo_enteryourinitials"

		hsEnteredDigits(1) = "A"
		hsEnteredDigits(2) = " "
		hsEnteredDigits(3) = " "

		hsCurrentDigit = 1
'		pupDMDDisplay "-","You Got a^High Score",dmdnote,3,0,10
		pupDMDDisplay "-","You Got a^High Score","",3,0,10
		Playsound "knocker"
		HighScoreDisplayName()
		HighScorelabels	
	End Sub

	' flipper moving around the letters

	Sub EnterHighScoreKey(keycode)
		If keycode = LeftFlipperKey Then
			Playsound "fx_Previous"
				If hsletter = 0 Then
					hsletter = 26
				Else
					hsLetter = hsLetter - 1
				End If
				HighScoreDisplayName()
		End If

		If keycode = RightFlipperKey Then
			Playsound "fx_Next"
				If hsletter = 26 Then
					hsletter = 0
				Else
					hsLetter = hsLetter + 1
				End If
				HighScoreDisplayName()
		End If

		If keycode = StartGameKey or keycode = PlungerKey Then
			PlaySound "success"
				If hsCurrentDigit = 3 Then
					If hsletter = 0 Then
						hsCurrentDigit = hsCurrentDigit -1
					Else
						assignletter
						vpmtimer.addtimer 700, "HighScoreCommitName()'"
						playclear pDMD
					End If
				End If
				If hsCurrentDigit < 3 Then
					If hsletter = 0 Then
						If hsCurrentDigit = 1 Then
						Else
							hsCurrentDigit = hsCurrentDigit -1
						End If
					Else
						assignletter
						hsCurrentDigit = hsCurrentDigit + 1
						HighScoreDisplayName()

					End If
				End If
		End if
	End Sub

	Dim hsletter
	hsletter = 1

	dim hsdigit:hsdigit = 1

	Sub assignletter
		if hscurrentdigit = 1 Then
			hsdigit = 1
		End If
		if hscurrentdigit = 2 Then
			hsdigit = 2
		End If
		if hscurrentdigit = 3 Then
			hsdigit = 3
		End If
		If hsletter = 1 Then 
			hsEnteredDigits(hsdigit) = "A"
		End If
		If hsletter = 2 Then 
			hsEnteredDigits(hsdigit) = "B"
		End If
		If hsletter = 3 Then 
			hsEnteredDigits(hsdigit) = "C"
		End If
		If hsletter = 4 Then 
			hsEnteredDigits(hsdigit) = "D"
		End If
		If hsletter = 5 Then 
			hsEnteredDigits(hsdigit) = "E"
		End If
		If hsletter = 6 Then 
			hsEnteredDigits(hsdigit) = "F"
		End If
		If hsletter = 7 Then 
			hsEnteredDigits(hsdigit) = "G"
		End If
		If hsletter = 8 Then 
			hsEnteredDigits(hsdigit) = "H"
		End If
		If hsletter = 9 Then 
			hsEnteredDigits(hsdigit) = "I"
		End If
		If hsletter = 10 Then 
			hsEnteredDigits(hsdigit) = "J"
		End If
		If hsletter = 11 Then 
			hsEnteredDigits(hsdigit) = "K"
		End If
		If hsletter = 12 Then 
			hsEnteredDigits(hsdigit) = "L"
		End If
		If hsletter = 13 Then 
			hsEnteredDigits(hsdigit) = "M"
		End If
		If hsletter = 14 Then 
			hsEnteredDigits(hsdigit) = "N"
		End If
		If hsletter = 15 Then 
			hsEnteredDigits(hsdigit) = "O"
		End If
		If hsletter = 16 Then 
			hsEnteredDigits(hsdigit) = "P"
		End If
		If hsletter = 17 Then 
			hsEnteredDigits(hsdigit) = "Q"
		End If
		If hsletter = 18 Then 
			hsEnteredDigits(hsdigit) = "R"
		End If
		If hsletter = 19 Then 
			hsEnteredDigits(hsdigit) = "S"
		End If
		If hsletter = 20 Then 
			hsEnteredDigits(hsdigit) = "T"
		End If
		If hsletter = 21 Then 
			hsEnteredDigits(hsdigit) = "U"
		End If
		If hsletter = 22 Then 
			hsEnteredDigits(hsdigit) = "V"
		End If
		If hsletter = 23 Then 
			hsEnteredDigits(hsdigit) = "W"
		End If
		If hsletter = 24 Then 
			hsEnteredDigits(hsdigit) = "X"
		End If
		If hsletter = 25 Then 
			hsEnteredDigits(hsdigit) = "Y"
		End If
		If hsletter = 26 Then 
			hsEnteredDigits(hsdigit) = "Z"
		End If

	End Sub

	Sub HighScorelabels
		PuPlayer.LabelSet pDMD,"HighScore","Your Name",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL1","A",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL2","",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL3","",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL4",PlayerScore(CurrentPlayer),1,""
		hsletter = 1
	End Sub

	Sub HighScoreDisplayName()

		Select case hsLetter
		Case 0
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","<",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","<",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","<",1,""
		Case 1
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","A",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","A",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","A",1,""
		Case 2
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","B",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","B",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","B",1,""
		Case 3
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","C",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","C",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","C",1,""
		Case 4
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","D",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","D",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","D",1,""
		Case 5
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","E",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","E",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","E",1,""
		Case 6
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","F",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","F",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","F",1,""
		Case 7
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","G",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","G",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","G",1,""
		Case 8
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","H",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","H",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","H",1,""
		Case 9
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","I",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","I",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","I",1,""
		Case 10
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","J",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","J",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","J",1,""
		Case 11
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","K",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","K",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","K",1,""
		Case 12
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","L",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","L",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","L",1,""
		Case 13
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","M",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","M",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","M",1,""
		Case 14
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","N",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","N",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","N",1,""
		Case 15
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","O",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","O",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","O",1,""
		Case 16
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","P",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","P",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","P",1,""
		Case 17
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","Q",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","Q",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","Q",1,""
		Case 18
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","R",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","R",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","R",1,""
		Case 19
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","S",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","S",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","S",1,""
		Case 20
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","T",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","T",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","T",1,""
		Case 21
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","U",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","U",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","U",1,""
		Case 22
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","V",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","V",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","V",1,""
		Case 23
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","W",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","W",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","W",1,""
		Case 24
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","X",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","X",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","X",1,""
		Case 25
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","Y",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","Y",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","Y",1,""
		Case 26
			if(hsCurrentDigit = 1) then PuPlayer.LabelSet pDMD,"HighScoreL1","Z",1,""
			if(hsCurrentDigit = 2) then PuPlayer.LabelSet pDMD,"HighScoreL2","Z",1,""
			if(hsCurrentDigit = 3) then PuPlayer.LabelSet pDMD,"HighScoreL3","Z",1,""
		End Select
	End Sub

	' post the high score letters


	Sub HighScoreCommitName()
		playclear pDMD
		PuPlayer.SetLoop 2,0
		PuPlayer.SetLoop 7,0
		hsEnteredName = hsEnteredDigits(1) & hsEnteredDigits(2) & hsEnteredDigits(3)
		HighScoreName(3) = hsEnteredName
		checkorder
		osbtemp = hsEnteredName
		if osbkey="" Then
		Else
		SubmitOSBScore
		end If
		EndOfBallComplete()
		PuPlayer.LabelSet pDMD,"HighScore","",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL1","",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL2"," ",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL3"," ",1,""
		PuPlayer.LabelSet pDMD,"HighScoreL4"," ",1,""
		hsbModeActive = False
	End Sub

sub playclear(chan)
		debug.print "play clear'd " & chan

		if chan = pMusic Then
			PuPlayer.SendMSG "{ ""mt"":301, ""SN"": 4, ""FN"":11, ""VL"":0 }"
		End If

		if chan = pBackglass Then
			PuPlayer.playstop pDMD
		End If
	end Sub


'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'  ATTRACT MODE
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
'/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
'\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
' X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  
' 

	Sub StartAttractMode()
		DOF 323, DOFOn   'DOF MX - Attract Mode ON
		bAttractMode = True
		ChangeSong
		StartLightSeq
	End Sub

	Sub StopAttractMode()
		pDMDStartGame
		DOF 323, DOFOff   'DOF MX - Attract Mode Off
		bAttractMode = False
		LightSeqAttract.StopPlay		
	'StopSong
	End Sub


'********************* START OF PUPDMD FRAMEWORK v1.0 *************************XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'******************** DO NOT MODIFY STUFF BELOW   THIS LINE!!!! ***************XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'******************************************************************************XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'*****   Create a PUPPack within PUPPackEditor for layout config!!!  **********XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'******************************************************************************XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	'
	'
	'  Quick Steps:
	'      1>  create a folder in PUPVideos with Starter_PuPPack.zip and call the folder "yourgame"
	'      2>  above set global variable pGameName="yourgame"
	'      3>  copy paste the settings section above to top of table script for user changes.
	'      4>  on Table you need to create ONE timer only called pupDMDUpdate and set it to 250 ms enabled on startup.
	'      5>  go to your table1_init or table first startup function and call PUPINIT function
	'      6>  Go to bottom on framework here and setup game to call the appropriate events like pStartGame (call that in your game code where needed)...etc
	'      7>  attractmodenext at bottom is setup for you already,  just go to each case and add/remove as many as you want and setup the messages to show.  
	'      8>  Have fun and use pDMDDisplay(xxxx)  sub all over where needed.  remember its best to make a bunch of mp4 with text animations... looks the best for sure!
	'

	'Const HasDMD = True   'dont set to false as it will break pup

	'pages
	Const pDMDBlank=0
	Const pScores=1
	Const pBigLine=2
	Const pThreeLines=3
	Const pTwoLines=4
	Const pTargerLetters=5

	'dmdType
	Const pDMDTypeLCD=0
	Const pDMDTypeReal=1
	Const pDMDTypeFULL=2


	dim PUPDMDObject  'for realtime mirroring.
	Dim pDMDlastchk: pDMDLastchk= -1    'performance of updates
	Dim pDMDCurPage: pDMDCurPage= 0     'default page is empty.
	Dim PBackglassCurPage: PBackglassCurPage= 0     'default page is empty.
	Dim pInAttract : pInAttract=false   'pAttract mode


	'*************  starts PUP system,  must be called AFTER b2s/controller running so put in last line of table1_init
	Sub PuPInit

	if (PuPDMDDriverType=pDMDTypeReal) and (useRealDMDScale=1) Then 
		   PuPlayer.setScreenEx pDMD,0,0,128,32,0  'if hardware set the dmd to 128,32
	End if

	PuPlayer.LabelInit pDMD


	if PuPDMDDriverType=pDMDTypeReal then
	Set PUPDMDObject = CreateObject("PUPDMDControl.DMD") 
	PUPDMDObject.DMDOpen
	PUPDMDObject.DMDPuPMirror
	PUPDMDObject.DMDPuPTextMirror
	PuPlayer.SendMSG "{ ""mt"":301, ""SN"": 1, ""FN"":33 }"             'set pupdmd for mirror and hide behind other pups
	PuPlayer.SendMSG "{ ""mt"":301, ""SN"": 1, ""FN"":32, ""FQ"":3 }"   'set no antialias on font render if real
	END IF


	pSetPageLayouts

	pDMDSetPage(pDMDBlank)   'set blank text overlay page.
	pDMDStartUP    ' firsttime running for like an startup video...
	End Sub 'end PUPINIT



	'PinUP Player DMD Helper Functions

	Sub pDMDLabelHide(labName)
	PuPlayer.LabelSet pDMD,labName,"",0,""   
	end sub

	Sub pDMDScrollBig(msgText,timeSec,mColor)
	PuPlayer.LabelShowPage pDMD,2,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash",msgText,0,"{'mt':1,'at':2,'xps':1,'xpe':-1,'len':" & (timeSec*1000000) & ",'mlen':" & (timeSec*1000) & ",'tt':0,'fc':" & mColor & "}"
	end sub

	Sub pDMDScrollBigV(msgText,timeSec,mColor)
	PuPlayer.LabelShowPage pDMD,2,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash",msgText,0,"{'mt':1,'at':2,'yps':1,'ype':-1,'len':" & (timeSec*1000000) & ",'mlen':" & (timeSec*1000) & ",'tt':0,'fc':" & mColor & "}"
	end sub

	Sub pDMDSplashScore(msgText,timeSec,mColor)
	PuPlayer.LabelSet pDMD,"MsgScore",msgText,0,"{'mt':1,'at':1,'fq':250,'len':"& (timeSec*1000) &",'fc':" & mColor & "}"
	end Sub

	Sub pDMDSplashScoreScroll(msgText,timeSec,mColor)
	PuPlayer.LabelSet pDMD,"MsgScore",msgText,0,"{'mt':1,'at':2,'xps':1,'xpe':-1,'len':"& (timeSec*1000) &", 'mlen':"& (timeSec*1000) &",'tt':0, 'fc':" & mColor & "}"
	end Sub

	Sub pDMDZoomBig(msgText,timeSec,mColor)  'new Zoom
	PuPlayer.LabelShowPage pDMD,2,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash",msgText,0,"{'mt':1,'at':3,'hstart':5,'hend':80,'len':" & (timeSec*1000) & ",'mlen':" & (timeSec*500) & ",'tt':5,'fc':" & mColor & "}"
	end sub

	Sub pDMDTargetLettersInfo(msgText,msgInfo, timeSec)  'msgInfo = '0211'  0= layer 1, 1=layer 2, 2=top layer3.
	'this function is when you want to hilite spelled words.  Like B O N U S but have O S hilited as already hit markers... see example.
	PuPlayer.LabelShowPage pDMD,5,timeSec,""  'show page 5
	Dim backText
	Dim middleText
	Dim flashText
	Dim curChar
	Dim i
	Dim offchars:offchars=0
	Dim spaces:spaces=" "  'set this to 1 or more depends on font space width.  only works with certain fonts
							  'if using a fixed font width then set spaces to just one space.

	For i=1 To Len(msgInfo)
		curChar="" & Mid(msgInfo,i,1)
		if curChar="0" Then
				backText=backText & Mid(msgText,i,1)
				middleText=middleText & spaces
				flashText=flashText & spaces          
				offchars=offchars+1
		End If
		if curChar="1" Then
				backText=backText & spaces
				middleText=middleText & Mid(msgText,i,1)
				flashText=flashText & spaces
		End If
		if curChar="2" Then
				backText=backText & spaces
				middleText=middleText & spaces
				flashText=flashText & Mid(msgText,i,1)
		End If   
	Next 

	if offchars=0 Then 'all litup!... flash entire string
	   backText=""
	   middleText=""
	   FlashText=msgText
	end if  

	PuPlayer.LabelSet pDMD,"Back5"  ,backText  ,1,""
	PuPlayer.LabelSet pDMD,"Middle5",middleText,1,""
	PuPlayer.LabelSet pDMD,"Flash5" ,flashText ,0,"{'mt':1,'at':1,'fq':150,'len':" & (timeSec*1000) & "}"   
	end Sub


	Sub pDMDSetPage(pagenum)    
		PuPlayer.LabelShowPage pDMD,pagenum,0,""   'set page to blank 0 page if want off
		PDMDCurPage=pagenum
	end Sub

	Sub pBackglassSetPage(pagenum)    
		PuPlayer.LabelShowPage pBackglass,pagenum,0,""   'set page to blank 0 page if want off
		PBackglassCurPage=pagenum
	end Sub

	Sub pHideOverlayText(pDisp)
		PuPlayer.SendMSG "{ ""mt"":301, ""SN"": "& pDisp &", ""FN"": 34 }"             'hideoverlay text during next videoplay on DMD auto return
	end Sub



	Sub pDMDShowLines3(msgText,msgText2,msgText3,timeSec)
	Dim vis:vis=1
	if pLine1Ani<>"" Then vis=0
	PuPlayer.LabelShowPage pDMD,3,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash3a",msgText,vis,pLine1Ani
	PuPlayer.LabelSet pDMD,"Splash3b",msgText2,vis,pLine2Ani
	PuPlayer.LabelSet pDMD,"Splash3c",msgText3,vis,pLine3Ani
	end Sub

	dim msg1
	dim msg2

	Sub pDMDShowLines2(msgText,msgText2,timeSec)
	Dim vis:vis=1
	'msg1=msgText
	'msg2=msgText2
	if pLine1Ani<>"" Then vis=0
	PuPlayer.LabelShowPage pDMD,4,timeSec,""
	'vpmtimer.addtimer 500, "showtext '"
	'dim endtime:endtime=(timesec*1000)-400
	'vpmtimer.addtimer endtime, "hidetext '"
	PuPlayer.LabelSet pDMD,"Splash4a",msgText,vis,pLine1Ani
	PuPlayer.LabelSet pDMD,"Splash4b",msgText2,vis,pLine2Ani
	end Sub

	'need to make a timer and add and remove to it instead of showtext and hide text

	sub showtext
		PuPlayer.LabelSet pDMD,"Splash4a",msg1,1,0
		PuPlayer.LabelSet pDMD,"Splash4b",msg2,1,0
	end Sub

	sub hidetext
		PuPlayer.LabelSet pDMD,"Splash4a","",1,0
		PuPlayer.LabelSet pDMD,"Splash4b","",1,0
	end Sub

	Sub pDMDShowCounter(msgText,msgText2,msgText3,timeSec)
	Dim vis:vis=1
	if pLine1Ani<>"" Then vis=0
	PuPlayer.LabelShowPage pDMD,6,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash6a",msgText,vis, pLine1Ani
	PuPlayer.LabelSet pDMD,"Splash6b",msgText2,vis,pLine2Ani
	PuPlayer.LabelSet pDMD,"Splash6c",msgText3,vis,pLine3Ani
	end Sub


	Sub pDMDShowBig(msgText,timeSec, mColor)
	Dim vis:vis=1
	if pLine1Ani<>"" Then vis=0
	PuPlayer.LabelShowPage pDMD,2,timeSec,""
	PuPlayer.LabelSet pDMD,"Splash",msgText,vis,pLine1Ani
	end sub


	Sub pDMDShowHS(msgText,msgText2,msgText3,timeSec) 'High Score
	Dim vis:vis=1
	if pLine1Ani<>"" Then vis=0
	PuPlayer.LabelShowPage pDMD,7,timeSec,""
'	PuPlayer.LabelSet pDMD,"Splash7a",msgText,vis,pLine1Ani
	PuPlayer.LabelSet pDMD,"Splash7a","1st. " & HighScoreName(0) &" - "& HighScore(0),vis,pLine1Ani
'	PuPlayer.LabelSet pDMD,"Splash7b",msgText2,vis,pLine2Ani
'	PuPlayer.LabelSet pDMD,"Splash7c",msgText3,vis,pLine3Ani
	PuPlayer.LabelSet pDMD,"Splash7b","2nd. " & HighScoreName(1) &" - "& HighScore(1),vis,pLine2Ani
	PuPlayer.LabelSet pDMD,"Splash7c","3nd. " & HighScoreName(2) &" - "& HighScore(2),vis,pLine3Ani
'	PuPlayer.LabelSet pDMD,"Splash7b","1- " & hsn0 &"->"& hs0,vis,pLine2Ani
'	PuPlayer.LabelSet pDMD,"Splash7c","2- " & hsn1 &"->"& hs1,vis,pLine3Ani
	end Sub


	Sub pDMDSetBackFrame(fname)
	  PuPlayer.playlistplayex pDMD,"PUPFrames",fname,0,1    
	end Sub

	Sub pDMDStartBackLoop(fPlayList,fname)
	  PuPlayer.playlistplayex pDMD,fPlayList,fname,0,1
	  PuPlayer.SetBackGround pDMD,1
	end Sub

	Sub pDMDStopBackLoop
	  PuPlayer.SetBackGround pDMD,0
	  PuPlayer.playstop pDMD
	end Sub


	Dim pNumLines

	'Theme Colors for Text (not used currenlty,  use the |<colornum> in text labels for colouring.
	Dim SpecialInfo
	Dim pLine1Color : pLine1Color=8454143  
	Dim pLine2Color : pLine2Color=8454143
	Dim pLine3Color :  pLine3Color=8454143
	Dim curLine1Color: curLine1Color=pLine1Color  'can change later
	Dim curLine2Color: curLine2Color=pLine2Color  'can change later
	Dim curLine3Color: curLine3Color=pLine3Color  'can change later


	Dim pDMDCurPriority: pDMDCurPriority =-1
	Dim pDMDDefVolume: pDMDDefVolume = 0   'default no audio on pDMD

	Dim pLine1
	Dim pLine2
	Dim pLine3
	Dim pLine1Ani
	Dim pLine2Ani
	Dim pLine3Ani

	Dim PriorityReset:PriorityReset=-1
	DIM pAttractReset:pAttractReset=-1
	DIM pAttractBetween: pAttractBetween=2000 '1 second between calls to next attract page
	DIM pDMDVideoPlaying: pDMDVideoPlaying=false


	'************************ where all the MAGIC goes,  pretty much call this everywhere  ****************************************
	'*************************                see docs for examples                ************************************************
	'****************************************   DONT TOUCH THIS CODE   ************************************************************
	'dim notenow:notenow = dmdnote
	Sub pupDMDDisplay(pEventID, pText, VideoName,TimeSec, pAni,pPriority)
	' pEventID = reference if application,  
	' pText = "text to show" separate lines by ^ in same string
	' VideoName "gameover.mp4" will play in background  "@gameover.mp4" will play and disable text during gameplay.
	' also global variable useDMDVideos=true/false if user wishes only TEXT
	' TimeSec how long to display msg in Seconds
	' animation if any 0=none 1=Flasher
	' also,  now can specify color of each line (when no animation).  "sometext|12345"  will set label to "sometext" and set color to 12345

	'if dmdnote = notenow Then
	'	VideoName = dmdver &"-shortnote2.mp4"
	'end if
	
	'notenow = VideoName	

	DIM curPos
	if pDMDCurPriority>=pPriority then Exit Sub  'if something is being displayed that we don't want interrupted.  same level will interrupt.
	pDMDCurPriority=pPriority
	if timeSec=0 then timeSec=1 'don't allow page default page by accident


	pLine1=""
	pLine2=""
	pLine3=""
	pLine1Ani=""
	pLine2Ani=""
	pLine3Ani=""


	if pAni=1 Then  'we flashy now aren't we
	pLine1Ani="{'mt':1,'at':1,'fq':150,'len':" & (timeSec*1000) &  "}"  
	pLine2Ani="{'mt':1,'at':1,'fq':150,'len':" & (timeSec*1000) &  "}"  
	pLine3Ani="{'mt':1,'at':1,'fq':150,'len':" & (timeSec*1000) &  "}"  
	end If

	curPos=InStr(pText,"^")   'Lets break apart the string if needed
	if curPos>0 Then 
	   pLine1=Left(pText,curPos-1) 
	   pText=Right(pText,Len(pText) - curPos)
	   
	   curPos=InStr(pText,"^")   'Lets break apart the string
	   if curPOS>0 Then
		  pLine2=Left(pText,curPos-1) 
		  pText=Right(pText,Len(pText) - curPos)

		  curPos=InStr("^",pText)   'Lets break apart the string   
		  if curPos>0 Then
			 pline3=Left(pText,curPos-1) 
		  Else 
			if pText<>"" Then pline3=pText 
		  End if 
	   Else 
		  if pText<>"" Then pLine2=pText
	   End if    
	Else 
	  pLine1=pText  'just one line with no break 
	End if


	'lets see how many lines to Show
	pNumLines=0
	if pLine1<>"" then pNumLines=pNumlines+1
	if pLine2<>"" then pNumLines=pNumlines+1
	if pLine3<>"" then pNumLines=pNumlines+1

	if pDMDVideoPlaying and (VideoName="") Then 
				PuPlayer.playstop pDMD
				pDMDVideoPlaying=False
	End if


	if (VideoName<>"") and (useDMDVideos) Then  'we are showing a splash video instead of the text.
		
		PuPlayer.playlistplayex pDMD,"DMDSplash",VideoName,pDMDDefVolume,pPriority  'should be an attract background (no text is displayed)
		pDMDVideoPlaying=true
	end if 'if showing a splash video with no text


	if StrComp(pEventID,"shownum",1)=0 Then              'check eventIDs
		pDMDShowCounter pLine1,pLine2,pLine3,timeSec
	Elseif StrComp(pEventID,"target",1)=0 Then              'check eventIDs
		pDMDTargetLettersInfo pLine1,pLine2,timeSec
	Elseif StrComp(pEventID,"highscore",1)=0 Then              'check eventIDs
		pDMDShowHS pLine1,pLine2,pline3,timeSec
	Elseif (pNumLines=3) Then                'depends on # of lines which one to use.  pAni=1 will flash.
		pDMDShowLines3 pLine1,pLine2,pLine3,TimeSec
	Elseif (pNumLines=2) Then
		pDMDShowLines2 pLine1,pLine2,TimeSec
	Elseif (pNumLines=1) Then
		pDMDShowBig pLine1,timeSec, curLine1Color
	Else
		pDMDShowBig pLine1,timeSec, curLine1Color
	End if

	PriorityReset=TimeSec*1000
	End Sub 'pupDMDDisplay message

	Sub pupDMDupdate_Timer()
		If B2SOn Then
			For i = 1 to PlayersPlayingGame
				Controller.B2SSetScorePlayer i, PlayerScore(i)
			Next
		End If
		pDMDUpdateScores 
		uDMDScoreUpdate
		
		if PriorityReset>0 Then  'for splashes we need to reset current prioirty on timer
		   PriorityReset=PriorityReset-pupDMDUpdate.interval
		   if PriorityReset<=0 Then 
				pDMDCurPriority=-1            
				if pInAttract then pAttractReset=pAttractBetween ' pAttractNext  call attract next after 1 second HP no attractmode
				pDMDVideoPlaying=false
				End if
		End if

		if pAttractReset>0 Then  'for splashes we need to reset current prioirty on timer
		   pAttractReset=pAttractReset-pupDMDUpdate.interval
		   if pAttractReset<=0 Then 
				pAttractReset=-1            
				if pInAttract then pAttractNext
				End if
		end if 
	End Sub

	Sub PuPEvent(EventNum)
	if hasPUP=false then Exit Sub
	PuPlayer.B2SData "E"&EventNum,1  'send event to puppack driver  
	End Sub