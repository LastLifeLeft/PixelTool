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
	Structure JobList
		*job
		List argument.i()
	EndStructure
	
	Global NewList FileList.s()
	Global NewList JobList.JobList()
	
	;Private functions declaration
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
						AddElement(JobList())
						AddElement(JobList()\argument())
						JobList()\job = @FixAlpha()
						
						_Parameter = ProgramParameter(_Index + 1)
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(_Parameter, 1) = "_" )
							JobList()\argument() = Val(_Parameter)
							_Index + 1
						Else
							JobList()\argument() = 122
						EndIf
						
						;}
					Case "_trim" ;{
						AddElement(JobList())
						AddElement(JobList()\argument())
						JobList()\job = @Trim_()
						
						_Parameter = ProgramParameter(_Index + 1)
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(_Parameter, 1) = "_" )
							JobList()\argument() =  Val(_Parameter)
							_Index + 1
						Else
							JobList()\argument() = 0
						EndIf
						;}
					Case "_outline" ;{
						AddElement(JobList())
						AddElement(JobList()\argument())
						JobList()\job = @Outline()
						
						_Parameter = ProgramParameter(_Index + 1)
						
						If _Index < _ParameterCount And Not ( FileSize(_Parameter) = -2 Or Left(_Parameter, 1) = "_" )
							JobList()\argument() =  Val("$" + _Parameter)
							_Index + 1
						Else
							JobList()\argument() = 0
						EndIf
						;}
					Case "_flip" ;{
						AddElement(JobList())
						AddElement(JobList()\argument())
						JobList()\job = @Flip()
						
						_Parameter = ProgramParameter(_Index + 1)
						
						If LCase(_Parameter) = "vertical"
							JobList()\argument() =  1
							_Index + 1
						Else
							JobList()\argument() = 0
						EndIf
						;}
					Default ;{
						_Parameter = ProgramParameter(_Index)
						If FileSize(_Parameter) = -2
							
							Utilities::ParseDirectory(Trim(_Parameter,~"\""),"png",FileList())
							
						Else
							PrintN(#AppName + " unknown parameter: " + _Parameter)
							;End
						EndIf
						;}
				EndSelect
				
				_Index + 1
				
			Wend
			
			If ListSize(FileList())
				PrintN(Str(ListSize(JobList())) + " jobs to perform on " + Str(ListSize(FileList())) + " images.")
				
				ResetList(JobList())
				
				EnableGraphicalConsole(#True)
				
				While NextElement(JobList())
					ConsoleColor(8,0)
					Print("● Job #" + Str(1 + ListIndex(JobList())) + " : ")
					ConsoleColor(7,0)
					CallFunctionFast(JobList()\job, JobList()\argument())
				Wend
				
				EnableGraphicalConsole(#False)
				
			Else
				PrintN(#AppName + " couldn't find any image To process")
			EndIf
			
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
	Procedure FixAlpha(Threshold)
		Print("FixAlpha with " + Threshold + "% threshold ")
		Threshold = Round(255 * Threshold / 100,#PB_Round_Nearest)
		
		ForEach FileList()
			If LoadImage(0,FileList())
				Filters::FixAlpha(0,Threshold)
				;SaveImage(0, FileList(),#PB_ImagePlugin_PNG,0,32)
				FreeImage(0)
				Print(".")
			Else
				PrintN("")
				PrintN("Couldn't load "+FileList())
				DeleteElement(FileList())
			EndIf
		Next
		PrintN("")
	EndProcedure
	
	Procedure Trim_(Margin)
		
	EndProcedure
	
	Procedure Outline(Color)
		Print("Draw a #" + RSet(Hex(Color), 6, "0")  + " outline ")
		
		ForEach FileList()
			If LoadImage(0,FileList())
				Filters::Outline(0,Color)
				;SaveImage(0, FileList(),#PB_ImagePlugin_PNG,0,32)
				SaveImage(0, "D:\poshu\Documents\test.png",#PB_ImagePlugin_PNG,0,32)
				FreeImage(0)
				Print(".")
				End
			Else
				PrintN("")
				PrintN("Couldn't load "+FileList())
				DeleteElement(FileList())
			EndIf
		Next
		PrintN("")
	EndProcedure
	
	Procedure Flip(Direction)
		
	EndProcedure
	
EndModule
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 195
; FirstLine = 137
; Folding = --+
; EnableXP