B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.6
@EndOfDesignText@
'#IgnoreWarnings: 12, 10, 9

Sub Class_Globals
	Private jsonParser As JSONParser
	Private Job As HttpJob
	Private url As String
	Public lstVakantie As List
End Sub

Public Sub Initialize
	
End Sub

public Sub GetVacationData() As ResumableSub
	Dim jsonData As String
	lstVakantie.Initialize
	
	url = $"https://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/schoolholidays/schoolyear/${Starter.urlCurrYear}-${Starter.urlNextYear}?output=json"$
	
	Job.Initialize("", Me)
	Job.Download(url)
		
	Wait For (Job) jobDone(jobDone As HttpJob)
	
	If jobDone.Success Then
		jsonData = Job.GetString	
	Else
		Job.Release
		Return False
	End If
	
	Job.Release
	
	If jsonData.IndexOf("<status-code>404") <> -1 Or jsonData = "" Then
		Return False
	End If
	
	Wait For (ParseSchoolVakData(jsonData)) Complete (result As Boolean)
	
	Return True
	
End Sub

Private Sub ParseSchoolVakData(data As String) As ResumableSub
	jsonParser.Initialize(data)
	Dim root As Map = jsonParser.NextObject

	Dim content As List = root.Get("content")
	For Each colcontent As Map In content
		Dim vacations As List = colcontent.Get("vacations")
		For Each colvacations As Map In vacations
			Dim compulsorydates As String = colvacations.Get("compulsorydates")
			Dim vacation_type As String = colvacations.Get("type")
			Dim regions As List = colvacations.Get("regions")
			For Each colregions As Map In regions
				Dim enddate As String = colregions.Get("enddate")
				Dim region As String = colregions.Get("region")
				Dim startdate As String = colregions.Get("startdate")
				lstVakantie.Add(CreatevakantieMap(region.Trim, startdate, enddate, vacation_type.Trim, compulsorydates))
			Next
		Next
	Next
	
	Return True
End Sub

Public Sub CreatevakantieMap (region As String, startDate As String, EndDate As String, vacation_type As String, compulsorydates As String) As vakantieMap
	Dim t1 As vakantieMap
	t1.Initialize
	t1.region = region
	t1.startDate = startDate
	t1.EndDate = EndDate
	t1.vacation_type = vacation_type
	t1.compulsorydates = compulsorydates
	Return t1
End Sub