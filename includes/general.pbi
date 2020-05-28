DeclareModule General
	;Public data structure
	#AppName = "PixelTool"
	#Version = 1
	
	;Public functions declaration
	Declare Init()
EndDeclareModule

Module General
	EnableExplicit
	;Private data structure	
	Structure WorkList
		job.i
		List argument.i()
	EndStructure
	
	Global NewList FileList.s()
	Global NewList WorkList.WorkList()
	
	;Private functions declaration
	Declare ParseDirectory(Directory$, FileMask$, List ResultList.s())
	Declare FixAlpha(Threshold)
	Declare Trim_(Margin)
	Declare Outline(Color)
	Declare Flip(Direction)
	
	;Public functions
	Procedure Init()
		Protected _Index, _ParameterCount = CountProgramParameters() - 1, _Parameter.s
		OpenConsole(General::#AppName)
		
		If _ParameterCount >= 0
			While _Index <= _ParameterCount
				Select LCase(ProgramParameter(_Index))
					Case "_fixalpha" ;{
						AddElement(WorkList())
						AddElement(WorkList()\argument())
						WorkList()\job = @FixAlpha()
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(ProgramParameter(_Index + 1), 1) = "_" )
							WorkList()\argument() =  Round(255 * Val(_Parameter) / 100,#PB_Round_Nearest)
							_Index + 1
						Else
							WorkList()\argument() = 122
						EndIf
						;}
					Case "_trim" ;{
						AddElement(WorkList())
						AddElement(WorkList()\argument())
						WorkList()\job = @Trim_()
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(ProgramParameter(_Index + 1), 1) = "_" )
							WorkList()\argument() =  Val(_Parameter)
							_Index + 1
						Else
							WorkList()\argument() = 0
						EndIf
						;}
					Case "_outline" ;{
						AddElement(WorkList())
						AddElement(WorkList()\argument())
						WorkList()\job = @FixAlpha()
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(ProgramParameter(_Index + 1), 1) = "_" )
							WorkList()\argument() =  Val("$" + _Parameter)
							_Index + 1
						Else
							WorkList()\argument() = 0
						EndIf
						;}
					Case "_flip" ;{
						AddElement(WorkList())
						AddElement(WorkList()\argument())
						WorkList()\job = @Flip()
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(ProgramParameter(_Index + 1), 1) = "_" ) And LCase(_Parameter) = "vertical"
							WorkList()\argument() =  1
							_Index + 1
						Else
							WorkList()\argument() = 0
						EndIf
						;}
					Default ;{
						_Parameter = ProgramParameter(_Index)
						If FileSize(_Parameter) = -2
							
							ParseDirectory(Trim(_Parameter,~"\""),"png",FileList())
							Debug "ok!"
							
							ForEach FileList()
								Debug FileList()
							Next
							
						Else
							PrintN(#AppName + " unknown parameter: " + _Parameter)
							;End
						EndIf
						;}
				EndSelect
				
				_Index + 1
				
			Wend
		Else ;{ Display manual 
			ConsoleColor(7,0)

			Print(#AppName +" v"+#Version + " By ")
			ConsoleColor(4,0)
			Print("♥")
			ConsoleColor(7,0)
			PrintN("x1")
			PrintN("A collection of filters to process image batches in a simple CLI.")
			PrintN("")
			PrintN("Usage:")
			PrintN("Mandatory:")
			PrintN(~"  \"path\"				: path to process, inside quotation marks.")
			PrintN("")
			PrintN("Filters:")
			Print("  _fixalpha ")
			ConsoleColor(8,0)
			Print("[threshold = 50%]")
			ConsoleColor(7,0)
			PrintN("		: clean up a pixel under the alpha threshold, make it opaque above.")
			Print("  _trim ")
			ConsoleColor(8,0)
			Print("[margin = 0]")
			ConsoleColor(7,0)
			PrintN(~"			: trim all the images to fit in the smallest possible surface.")
			Print("  _outline ")
			ConsoleColor(8,0)
			Print("[color = 000000]")
			ConsoleColor(7,0)
			PrintN(~"		: add an outline around the non transparent pixel.")
			Print("  _flip ")
			ConsoleColor(8,0)
			Print("[direction = horizontal]")
			ConsoleColor(7,0)
			PrintN(~"	: flip the whole image on the desired axis.")
			PrintN("")
			PrintN("ie: "+#AppName+~".exe \"d:\\images\\to\\process\" _outline FF0000 _flip")
			;}
		EndIf
	EndProcedure
	
	;Private functions
	Procedure ParseDirectory(Directory$, FileMask$, List ResultList.s())
		Protected _DirectoryID, _EntryName.s
		
		If Not (Right(Directory$, 1) = "\" Or Right(Directory$, 1) = "/")
			Directory$ + "/"
		EndIf
		
		_DirectoryID = ExamineDirectory(#PB_Any, Directory$, "*")
		If _DirectoryID
			While NextDirectoryEntry(_DirectoryID)
				
				_EntryName = DirectoryEntryName(_DirectoryID)
				
				
				If _EntryName = "." Or _EntryName = ".."
					Continue
				EndIf
				
				_EntryName = Directory$ + _EntryName
				
				If FileSize(_EntryName) = -2
					ParseDirectory(_EntryName, FileMask$, ResultList())
				ElseIf FindString(FileMask$, GetExtensionPart(_EntryName))
					AddElement(ResultList())
					ResultList() = _EntryName
				EndIf
				
			Wend
			
			FinishDirectory(_DirectoryID)
		EndIf
		
	EndProcedure
	
	Procedure FixAlpha(Threshold)
		
	EndProcedure
	
	Procedure Trim_(Margin)
		
	EndProcedure
	
	Procedure Outline(Color)
		
	EndProcedure
	
	Procedure Flip(Direction)
		
	EndProcedure
	
EndModule
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 2
; Folding = Ho9
; EnableXP