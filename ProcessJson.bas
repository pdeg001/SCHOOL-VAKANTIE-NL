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
	Private lstVakantie As List
End Sub

Public Sub Initialize
	
End Sub

Private Sub GetSchoolVakData (startYear As String, endYear As String)
	Dim jsonData As String
	lstVakantie.Initialize
	
	If ValidatePassed (startYear, endYear) = False Then
		'DO SOMETHING
	End If
	
	url = $"https://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/schoolholidays/schoolyear/${startYear}-${endYear}?output=json"$
	Job.Download(url)
	
	Wait For (Job) Complete (result As Boolean)
	
	If result Then
		jsonData = Job.GetString	
	Else
		'DO SOMTHING
	End If
	
	Job.Release
	
	ParseSchoolVakData(jsonData)
	
End Sub

Private Sub ParseSchoolVakData(data As String)
	jsonParser.Initialize(data)
	Dim root As Map = jsonParser.NextObject
'	Dim license As String = root.Get("license")
	Dim creators As List = root.Get("creators")
	For Each colcreators As String In creators
		
	Next
	Dim lastmodified As String = root.Get("lastmodified")
	Starter.lastModified = lastmodified
'	Dim language As String = root.Get("language")
'	Dim location As String = root.Get("location")
'	Dim id As String = root.Get("id")
'	Dim canonical As String = root.Get("canonical")
	Dim rightsholders As List = root.Get("rightsholders")
	For Each colrightsholders As String In rightsholders
	Next
'	Dim Type As String = root.Get("type")
	Dim content As List = root.Get("content")
	For Each colcontent As Map In content
'		Dim schoolyear As String = colcontent.Get("schoolyear")
		Dim vacations As List = colcontent.Get("vacations")
		For Each colvacations As Map In vacations
			Dim regions As List = colvacations.Get("regions")
			For Each colregions As Map In regions
				Dim enddate As String = colregions.Get("enddate")
				Dim region As String = colregions.Get("region")
				Dim startdate As String = colregions.Get("startdate")
			Next
			Dim compulsorydates As String = colvacations.Get("compulsorydates")
			Dim vacation_type As String = colvacations.Get("type")
		Next
'		Dim title As String = colcontent.Get("title")
		'CREATE VACATION MAP
		lstVakantie.Add(CreatevakantieMap(region, startdate, enddate, vacation_type, compulsorydates))
	Next
	Dim authorities As List = root.Get("authorities")
	For Each colauthorities As String In authorities
	Next
	Dim notice As String = root.Get("notice")
	
	
End Sub

Private Sub ValidatePassed (startYear As Int, endYear As Int) As Boolean
	If Not(startYear) Or Not(endYear) Then
		Return False
	End If
	
	If startYear < endYear Then
		Return False
	End If
	
	If startYear = endYear Then
		Return False
	End If
	
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