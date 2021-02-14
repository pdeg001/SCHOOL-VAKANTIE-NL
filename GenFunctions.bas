B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=10.6
@EndOfDesignText@
Sub Process_Globals
	Dim yearLeft, yearRight As Int

End Sub

Sub SetSelectedYear(currSelection As String, changeYear As Int) as String
	Dim passedSelection() As String
	
	passedSelection = Regex.Split("-", currSelection)
	yearLeft = passedSelection(0)
	yearRight = passedSelection(1)
	
	
	If changeYear = 1 Then
		SetYear(1)
	Else
		SetYear(-1)
	End If
	
	Return ($"${yearLeft} - ${yearRight}"$)
	
End Sub

Private Sub SetYear(year As Int)
	yearLeft = yearLeft + year
	yearRight = yearRight + year
End Sub