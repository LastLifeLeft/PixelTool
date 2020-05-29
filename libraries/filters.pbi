DeclareModule Filters
	;Public data structure
	
	;Public functions declaration
	Declare FixAlpha(Image, Threshold)
EndDeclareModule

Module filters
	EnableExplicit
	Global FixAlpha_Threshold
	;Private data structure
	
	;Private functions declaration
	Declare FixAlpha_Callback(x, y, SourceColor, TargetColor)
	
	;Public functions
	Procedure FixAlpha(Image, Threshold)
		Protected _TempImage = CopyImage(Image, #PB_Any)
		FixAlpha_Threshold = Threshold
		
		StartDrawing(ImageOutput(Image))
		DrawingMode(#PB_2DDrawing_AllChannels)
		Box(0, 0, OutputWidth(), OutputHeight(), RGBA(0, 0, 0, 0))
		CustomFilterCallback(@FixAlpha_Callback())
		DrawingMode(#PB_2DDrawing_AllChannels|#PB_2DDrawing_CustomFilter )
		DrawImage(ImageID(_TempImage),0,0)
		StopDrawing()
		
	EndProcedure
	
	;Private functions
	Procedure FixAlpha_Callback(x, y, SourceColor, TargetColor)
		
		If Alpha(SourceColor) >= FixAlpha_Threshold
			SourceColor = RGBA(Red(SourceColor), Green(SourceColor), Blue(SourceColor), 255)
		Else
			SourceColor = RGBA(0, 0, 0, 0)
		EndIf
		
		ProcedureReturn SourceColor
	EndProcedure
	
EndModule
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 25
; Folding = -
; EnableXP