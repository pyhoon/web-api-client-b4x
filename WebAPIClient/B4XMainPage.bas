B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private URL As String = "http://172.20.10.2:19800/v1/"
	Private lblTitle As B4XView
	Private lblBack As B4XView
	Private clvRecord As CustomListView
	Private btnEdit As B4XView
	Private btnDelete As B4XView
	Private btnNew As B4XView
	Private lblName As B4XView
	Private lblCategory As B4XView
	Private lblCode As B4XView
	Private lblPrice As B4XView
	Private lblStatus As B4XView
	Private PrefDialog As PreferencesDialog
	Dim Viewing As String
	Dim CategoryId As Long
	Dim Category() As Category
	Type Category (Id As Long, Name As String)
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	B4XPages.SetTitle(Me, "WebAPI Client")
	#if B4J
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", clvRecord, xui.Color_Transparent)
	#End If
End Sub

#If B4j
Private Sub SetScrollPaneBackgroundColor(View As CustomListView, Color As Int)
	Dim SP As JavaObject = View.GetBase.GetView(0)
	Dim V As B4XView = SP
	V.Color = Color
	Dim V As B4XView = SP.RunMethod("lookup", Array(".viewport"))
	V.Color = Color
End Sub
#End If

Private Sub B4XPage_Appear
	GetCategories
End Sub

#If B4J
Private Sub lblBack_MouseClicked (EventData As MouseEvent)
	GetCategories
End Sub
#Else
Private Sub lblBack_Click
	GetCategories
End Sub
#End If

Private Sub GetCategories
	Try
		Dim i As Long
		Dim sd As Object = SendData("GET", "category", Null)
		Wait For (sd) Complete (Data As Map)
		If Data.Get("s") = "ok" Then
			Dim Items As List = Data.Get("r")
			Dim Category(Items.Size) As Category
			For Each Item As Map In Items
				Category(i).Id = Item.Get("id")
				Category(i).Name = Item.Get("category_name")
				i = i + 1
			Next
			clvRecord.Clear
			For i = 0 To Category.Length - 1
				clvRecord.Add(CreateCategoryItems(Category(i).Name, clvRecord.AsView.Width), Category(i).Id)
			Next
			Viewing = "Category"
			lblTitle.Text = "Category"
			lblBack.Visible = False
		Else
			xui.MsgboxAsync(Data.Get("e"), "Error")
		End If
	Catch
		'Log(LastException)
		xui.MsgboxAsync(LastException.Message, "Error")
	End Try
End Sub

Private Sub GetProducts
	clvRecord.Clear
	Dim sd As Object = SendData("GET", $"category/${CategoryId}/product"$, Null)
	Wait For (sd) Complete (Data As Map)
	If Data.Get("s") = "ok" Then
		If 204 = Data.Get("a") Then
			xui.MsgboxAsync(Data.Get("m"), "No Product")
		Else			
			Dim Items As List = Data.Get("r")			
			For Each Item As Map In Items
				clvRecord.Add(CreateProductItems(Item.Get("product_code"), GetCategoryName(Item.Get("category_id")), Item.Get("product_name"), NumberFormat2(Item.Get("product_price"), 1, 2, 2, True), clvRecord.AsView.Width), Item.Get("id"))
			Next
		End If
	Else
		xui.MsgboxAsync(Data.Get("e"), "Error")
	End If
	Viewing = "Product"	
	lblTitle.Text = GetCategoryName(CategoryId)
	lblBack.Visible = True
End Sub

Private Sub GetCategoryName (Id As Long) As String
	For i = 0 To Category.Length - 1
		If Category(i).Id = Id Then
			Return Category(i).Name
		End If
	Next
	Return ""
End Sub

Private Sub GetCategoryId (Name As String) As Long
	For i = 0 To Category.Length - 1
		If Category(i).Name = Name Then
			Return Category(i).Id		
		End If
	Next
	Return 0
End Sub

Private Sub clvRecord_ItemClick (Index As Int, Value As Object)
	If Viewing = "Category" Then
		CategoryId = Value
		GetProducts
	End If
End Sub

Private Sub btnNew_Click
	If Viewing = "Product" Then
		Dim M1 As Map = CreateMap("Product Code": "", "Category": GetCategoryName(CategoryId), "Product Name": "", "Product Price": "", "id": 0)
		CreateProductDialog("Add")
		ShowDialog("Product", M1)
	Else
		Dim M1 As Map = CreateMap("Category Name": "", "id": 0)
		CreateCategoryDialog("Add")
		ShowDialog("Category", M1)
	End If
End Sub

Private Sub CreateCategoryItems (Name As String, Width As Double) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Width, 90dip)
	p.LoadLayout("CategoryItem")
	lblName.Text = Name
	Return p
End Sub

Private Sub CreateProductItems (ProductCode As String, CategoryName As String, ProductName As String, ProductPrice As String, Width As Double) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Width, 180dip)
	p.LoadLayout("ProductItem")
	lblCode.Text = ProductCode
	lblCategory.Text = CategoryName
	lblName.Text = ProductName
	lblPrice.Text = ProductPrice
	Return p
End Sub

Private Sub CreateCategoryDialog (Action As String)
	PrefDialog.Initialize(Root, Action & " Category", 300dip, 60dip)
	PrefDialog.Dialog.OverlayColor = xui.Color_ARGB(128, 0, 10, 40)
	PrefDialog.Dialog.TitleBarHeight = 50dip
	If Action = "Add" Then
		PrefDialog.Dialog.TitleBarColor = xui.Color_RGB(50, 205, 50)
	Else
		PrefDialog.Dialog.TitleBarColor = xui.Color_RGB(65, 105, 225)
	End If	
	PrefDialog.LoadFromJson(File.ReadString(File.DirAssets, "template_category.json"))
End Sub

Private Sub CreateProductDialog (Action As String)
	Dim options As List
	options.Initialize
	For i = 0 To Category.Length - 1
		options.Add(Category(i).Name)
	Next
	PrefDialog.Initialize(Root, Action & " Product", 300dip, 240dip)
	PrefDialog.Dialog.TitleBarHeight = 50dip	
	If Action = "Add" Then
		PrefDialog.Dialog.TitleBarColor = xui.Color_RGB(50, 205, 50)
	Else
		PrefDialog.Dialog.TitleBarColor = xui.Color_RGB(65, 105, 225)
	End If
	PrefDialog.Dialog.OverlayColor = xui.Color_ARGB(128, 0, 10, 40)
	PrefDialog.LoadFromJson(File.ReadString(File.DirAssets, "template_product.json"))
	PrefDialog.SetOptions("Category", options)
End Sub

Private Sub ShowDialog (Tag As String, Item As Map)
	If Tag = "Product" Then
		Dim sf As Object = PrefDialog.ShowDialog(Item, "OK", "CANCEL")
		Wait For (sf) Complete (Result As Int)
		If Result = xui.DialogResponse_Positive Then			
			If 0 = Item.Get("id") Then ' New row
				CategoryId = GetCategoryId(Item.Get("Category"))
				Dim ProductMap As Map = CreateMap("code": Item.Get("Product Code"), "name": Item.Get("Product Name"), "price": Item.Get("Product Price"))
				Dim sd As Object = SendData("POST", $"category/${CategoryId}/product"$, ProductMap)
				Wait For (sd) Complete (Data As Map)
				'Log(Data)
				If Data.Get("s") = "ok" Then
					'Log(Data.Get("a")) ' 201 Created
					Dim l As List = Data.Get("r")
					Dim m As Map = l.Get(0)
					xui.MsgboxAsync("New Item created!", $"ID: ${m.Get("id")}"$)
				Else
					xui.MsgboxAsync(Data.Get("e"), "Error")
				End If
			Else
				Dim NewCategoryId As Long = GetCategoryId(Item.Get("Category"))
				Dim ProductMap As Map = CreateMap("cat_id": NewCategoryId, "code": Item.Get("Product Code"), "name": Item.Get("Product Name"), "price": Item.Get("Product Price"))
				Dim sd As Object = SendData("PUT", $"category/${CategoryId}/product/${Item.Get("id")}"$, ProductMap)
				Wait For (sd) Complete (Data As Map)
				'Log(Data)
				If Data.Get("s") = "ok" Then
					xui.MsgboxAsync("Product updated!", "Edit")
					CategoryId = NewCategoryId
				Else
					xui.MsgboxAsync(Data.Get("e"), "Error")
				End If
			End If			
			GetProducts
		End If
	Else	' Category
		Dim sf As Object = PrefDialog.ShowDialog(Item, "OK", "CANCEL")
		Wait For (sf) Complete (Result As Int)
		If Result = xui.DialogResponse_Positive Then
			If 0 = Item.Get("id") Then ' New row
				Dim CategoryMap As Map = CreateMap("name": Item.Get("Category Name"))
				Dim sd As Object = SendData("POST", "category", CategoryMap)
				Wait For (sd) Complete (Data As Map)
				'Log(Data)
				If Data.Get("s") = "ok" Then
					'Log(Data.Get("status_code")) ' 201 Created
					Dim l As List = Data.Get("r")
					Dim m As Map = l.Get(0)
					xui.MsgboxAsync("New category created!", $"ID: ${m.Get("id")}"$)
				Else
					xui.MsgboxAsync(Data.Get("e"), "Error")
					Return
				End If
			Else
				Dim CategoryMap As Map = CreateMap("name": Item.Get("Category Name"))
				Dim sd As Object = SendData("PUT", $"category/${Item.Get("id")}"$, CategoryMap)
				Wait For (sd) Complete (Data As Map)
				'Log(Data)
				If Data.Get("s") = "ok" Then
					xui.MsgboxAsync("Category updated!", "Edit")
				Else
					xui.MsgboxAsync(Data.Get("e"), "Error")
				End If
			End If
			GetCategories
		End If
	End If
End Sub

Private Sub btnEdit_Click
	Dim Index As Int = clvRecord.GetItemFromView(Sender)
	Dim lst As B4XView = clvRecord.GetPanel(Index)
	If Viewing = "Product" Then
		If CategoryId = 0 Then Return
		Dim ProductId As Long = clvRecord.GetValue(Index)
		Dim pnl As B4XView = lst.GetView(0)
		Dim v1 As B4XView = pnl.GetView(0)
		Dim v2 As B4XView = pnl.GetView(1)
		Dim v3 As B4XView = pnl.GetView(2)
		Dim v4 As B4XView = pnl.GetView(3)
		Dim M1 As Map = CreateMap("Product Code": v1.Text, "Category": v2.Text, "Product Name": v3.Text, "Product Price": v4.Text.Replace(",", ""), "id": ProductId)
		CreateProductDialog("Edit")
		ShowDialog("Product", M1)
	Else
		CategoryId = clvRecord.GetValue(Index)
		Dim pnl As B4XView = lst.GetView(0)
		Dim v1 As B4XView = pnl.GetView(0)
		Dim M1 As Map = CreateMap("Category Name": v1.Text, "id": CategoryId)
		CreateCategoryDialog("Edit")
		ShowDialog("Category", M1)
	End If
End Sub

Private Sub btnDelete_Click
	Dim Index As Int = clvRecord.GetItemFromView(Sender)
	Dim lst As B4XView = clvRecord.GetPanel(Index)
	Dim pnl As B4XView = lst.GetView(0)
	If Viewing = "Product" Then
		If CategoryId = 0 Then Return
		Dim ProductId As Long = clvRecord.GetValue(Index)
		Dim v1 As B4XView = pnl.GetView(2)
	Else
		CategoryId = clvRecord.GetValue(Index)
		Dim v1 As B4XView = pnl.GetView(0)
	End If
	Dim sf As Object = xui.Msgbox2Async(v1.Text, "Confirm Delete?", "Yes", "", "No", Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_Positive Then		
		If Viewing = "Product" Then
			Dim sd As Object = SendData("DELETE", $"category/${CategoryId}/product/${ProductId}"$, Null)
		Else
			Dim sd As Object = SendData("DELETE", $"category/${CategoryId}"$, Null)
		End If
		Wait For (sd) Complete (Data As Map)
		If Data.Get("s") = "ok" Then
			xui.MsgboxAsync(Viewing & " deleted!", "Delete")
		Else
			xui.MsgboxAsync(Data.Get("e"), "Error")
		End If
	End If
	If Viewing = "Product" Then
		GetProducts
	Else
		GetCategories
	End If
End Sub

Sub SendData (Method As String, EndPoint As String, Payload As Map) As ResumableSub
	Dim j As HttpJob
	Dim Data As Map
	Try
		Dim Link As String = $"${URL}${EndPoint}"$
		'Log("Link:" & Link)
		j.Initialize("", Me)
		Select Case Method.ToUpperCase
			Case "POST"
				#if b4i
				j.PostString(Link, Map2JSON(Payload))
				#else
				j.PostString(Link, Payload.As(JSON).ToString)
				#End If
			Case "PUT"
				#if b4i
				j.PutString(Link, Map2JSON(Payload))
				#else
				j.PutString(Link, Payload.As(JSON).ToString)
				#End If
			Case "DELETE"
				j.Delete(Link)
			Case Else ' GET
				j.Download(Link)
		End Select
		Wait For (j) JobDone(j As HttpJob)
		If j.Success Then
			#if b4i
			Data = JSON2Map(j.GetString)
			#else
				Data = j.GetString.As(JSON).ToMap 'ignore
			#End If
			#if B4J
			lblStatus.Text = "Connected to " & URL
			#Else
			lblStatus.Text = "Connected to " & CRLF & URL
			#End If
		Else
			If j.ErrorMessage.Contains($""s": "error""$) Then
				#if b4i
				Data = JSON2Map(j.ErrorMessage)
				#else
					Data = j.ErrorMessage.As(JSON).ToMap 'ignore
				#End If				
			Else
				Data = CreateMap("s": "error", "e": j.ErrorMessage, "m": "", "r": Null)
			End If
		End If
		Data.Put("a", j.Response.StatusCode)
	Catch
		Log(LastException.Message)
		Data = CreateMap("s": "error", "e": LastException.Message, "m": "", "r": Null)
		Data.Put("a", -1)
		'xui.MsgboxAsync(LastException.Message, "Error")
	End Try
	j.Release
	Return Data
End Sub

#if b4i
Private Sub Map2JSON (Map As Map) As String
	Dim gen As JSONGenerator
	gen.Initialize(Map)
	Return gen.ToString
End Sub
Private Sub JSON2Map (JSON As String) As Map
	Dim par As JSONParser
	par.Initialize(JSON)
	Return par.NextObject
End Sub
#End If