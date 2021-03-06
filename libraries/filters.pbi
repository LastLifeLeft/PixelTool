﻿DeclareModule Filters
	;Public data structure
	
	;Public functions declaration
	Declare FixAlpha(Image, Threshold)
	Declare Outline(Image, Color)
	Declare TrimImage(List ImageList(), Margin)
EndDeclareModule

Module filters
	EnableExplicit
	;Private data structure
	Structure Pos
		X.i
		Y.i
	EndStructure
	
	Global FixAlpha_Threshold
	
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
	
	Procedure Outline(Image, Color)
		Protected _Width, _Height, X, Y
		Protected NewList _PlotList.Pos()
		
		Color = RGBA(Red(Color), Green(Color), Blue(Color), 255)
		
		StartDrawing(ImageOutput(Image))
		DrawingMode(#PB_2DDrawing_AllChannels)
		_Width = OutputWidth() - 1
		_Height = OutputHeight() - 1
		
		For Y = 0 To _Height
			For X = 0 To _Width
				If Alpha(Point(X, Y))
					
					If X
						If  Alpha(Point(X - 1, Y)) = 0
							AddElement(_PlotList())
							_PlotList()\X = X - 1
							_PlotList()\Y = Y
						EndIf
					EndIf
					
					If X < _Width
						If  Alpha(Point(X + 1, Y)) = 0
							AddElement(_PlotList())
							_PlotList()\X = X + 1
							_PlotList()\Y = Y
						EndIf
					EndIf
					
					If Y
						If  Alpha(Point(X, Y - 1)) = 0
							AddElement(_PlotList())
							_PlotList()\X = X
							_PlotList()\Y = Y - 1
						EndIf
					EndIf
					
					If Y < _Height
						If  Alpha(Point(X, Y + 1)) = 0
							AddElement(_PlotList())
							_PlotList()\X = X
							_PlotList()\Y = Y + 1
						EndIf
					EndIf
				EndIf
				
			Next
		Next
		
		ForEach _PlotList()
			Plot(_PlotList()\X, _PlotList()\Y, Color)
		Next
		
		StopDrawing()
		
		FreeList(_PlotList())
		
	EndProcedure
	
	Procedure TrimImage(List ImageList(), Margin)
		Protected _Top = ImageHeight(ImageList()) - 1, _Left = ImageWidth(ImageList()) - 1, _Right = 0, _Bottom = 0
		Protected _Width = _Left, _Height = _Top, X, Y
		Protected _TempImage
		
		ForEach ImageList()
			StartDrawing(ImageOutput(ImageList()))
			DrawingMode(#PB_2DDrawing_AllChannels)
			
			For Y = 0 To _Height
				For X = 0 To _Left
					If Alpha(Point(X,Y))
						_Left = X
						Break
					EndIf
				Next
				
				For X = _Width To _Right Step -1
					If Alpha(Point(X,Y))
						_Right = X
						Break
					EndIf
				Next
			Next
			
			For X = 0 To _Width
				For Y = 0 To _Top
					If Alpha(Point(X,Y))
						_Top = Y
						Break
					EndIf
				Next
				
				For Y = _Height To _Bottom Step -1
					If Alpha(Point(X,Y))
						_Bottom = Y
						Break
					EndIf
				Next
			Next
			
			StopDrawing()
		Next
		
		_Right + Margin
		_Left - Margin
		_Bottom + Margin
		_Top - Margin
		
		_Width = _Right - _Left + 1
		_Height = _Bottom - _Top + 1
		
		ForEach ImageList()
 			_TempImage = CopyImage(ImageList(), #PB_Any)
			ResizeImage(ImageList(), _Width, _Height, #PB_Image_Raw)
			
			StartDrawing(ImageOutput(ImageList()))
			DrawingMode(#PB_2DDrawing_AllChannels)
			DrawImage(ImageID(_TempImage), -_Left, -_Top)
			StopDrawing()
			FreeImage(_TempImage)
		Next
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
; CursorPosition = 101
; FirstLine = 75
; Folding = 8-
; EnableXP