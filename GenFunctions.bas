B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=10.6
@EndOfDesignText@
Sub Process_Globals
	Dim yearLeft, yearRight As Int

End Sub

Sub SetSelectedYear(currSelection As String, changeYear As Int) As String
	Dim passedSelection() As String
	
	passedSelection = Regex.Split("-", currSelection)
	yearLeft = passedSelection(0)
	yearRight = passedSelection(1)
	
	
	If changeYear = 1 Then
		SetYear(1)
	Else
		SetYear(-1)
	End If
	
	Starter.urlCurrYear = yearLeft
	Starter.urlNextYear = yearRight
	Return ($"${yearLeft} - ${yearRight}"$)
	
End Sub

Private Sub SetYear(year As Int)
	yearLeft = yearLeft + year
	yearRight = yearRight + year
End Sub

Sub SetYearStart As String
	Dim currYear As Int = DateTime.GetYear(DateTime.Now)
	
	Starter.urlCurrYear = currYear
	Starter.urlNextYear = currYear + 1
	
	Return $"${Starter.urlCurrYear} - ${Starter.urlNextYear}"$
End Sub

Sub ParseVacationDate(vDate As String) As String
	Dim dDate As Long
	vDate = vDate.Replace(".000Z", "")
	DateTime.DateFormat = "yyyy-MM-dd"
	dDate = DateTime.DateParse(vDate)
	DateTime.DateFormat= "dd-MM-yyyy"
	Return DateTime.Date(dDate)
End Sub