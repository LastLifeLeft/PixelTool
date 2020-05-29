DeclareModule Utilities
	;Public data structure
	
	;Public functions declaration
	Declare ParseDirectory(Directory$, FileMask$, List ResultList.s())
EndDeclareModule

Module Utilities
	EnableExplicit
	;Private data structure
	
	;Private functions declaration
	
	;Public functions
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
	
	;Private functions
	
EndModule
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP