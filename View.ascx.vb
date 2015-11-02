' Copyright (c) 2015  DnnConsulting.nl
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
'Imports DotNetNuke
'Imports DotNetNuke.Entities.Modules.Actions
'Imports DotNetNuke.Entities.Modules
Imports DotNetNuke.Services.Localization
Imports DotNetNuke.Services.Exceptions
Imports DotNetNuke.Data
Imports System.Data.SqlClient

Partial Class View
    Inherits DnnC_DB_AnalyzerModuleBase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                GetDBInfo()
                BindData()
            End If
        Catch exc As Exception
            Exceptions.ProcessModuleLoadException(Me, exc)
        End Try
    End Sub

    Private Sub GetDBInfo()
        Dim strSQL As New StringBuilder()

        strSQL.Append("SELECT DBName, name, [filename], size as 'Size', usedspace as 'UsedSpace', (size - usedspace) as 'AvailableFreeSpace' FROM(")
        strSQL.Append("SELECT ")
        strSQL.Append("db_name(s.database_id) as DBName, ")
        strSQL.Append("s.name AS [Name], ")
        strSQL.Append("s.physical_name AS [FileName], ")
        strSQL.Append("(s.size * CONVERT(float,8))/1024 AS [Size], ")
        strSQL.Append("(CAST(CASE s.type WHEN 2 THEN 0 ELSE CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8) END AS float))/1024 AS [UsedSpace], ")
        strSQL.Append("s.file_id AS [ID] ")
        strSQL.Append("FROM ")
        strSQL.Append("sys.filegroups AS g ")
        strSQL.Append("INNER JOIN sys.master_files AS s ON ((s.type = 2 or s.type = 0) and s.database_id = db_id() and (s.drop_lsn IS NULL)) AND (s.data_space_id=g.data_space_id) ")
        strSQL.Append(")  DBFileSizeInfo")

        grdInfo.DataSource = CType(DataProvider.Instance().ExecuteSQL(strSQL.ToString()), IDataReader)
        grdInfo.DataBind()

    End Sub

    Private Sub BindData(Optional sortBy As String = "TotalRows", Optional sortDir As String = "DESC")
        Dim strSQL As New StringBuilder()

        strSQL.Append("SELECT TableName = obj.name, TotalRows = prt.rows, [SpaceUsed] = SUM(alloc.used_pages)*8 ")
        strSQL.Append("FROM sys.objects obj ")
        strSQL.Append("JOIN sys.indexes idx on obj.object_id = idx.object_id ")
        strSQL.Append("JOIN sys.partitions prt on obj.object_id = prt.object_id ")
        strSQL.Append("JOIN sys.allocation_units alloc on alloc.container_id = prt.partition_id ")
        strSQL.Append("WHERE obj.type = 'U' AND idx.index_id IN (0, 1) ")
        strSQL.Append("GROUP BY obj.name, prt.rows ")
        strSQL.Append("ORDER BY " & sortBy & " " & sortDir & "")

        grdDBData.DataSource = CType(DataProvider.Instance().ExecuteSQL(strSQL.ToString()), IDataReader)
        grdDBData.DataBind()
    End Sub

    Private Sub btnSort_Click(sender As Object, e As EventArgs) Handles btnSort.Click
        BindData(ddlColName.SelectedValue, ddlDirection.SelectedValue)
    End Sub

    Private Sub grdDBData_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles grdDBData.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim tRows As Integer = DataBinder.Eval(e.Row.DataItem, "TotalRows")
            Dim tSize As Integer = DataBinder.Eval(e.Row.DataItem, "SpaceUsed")

            Dim perRowVal As Integer = ((tRows / CInt(ddlzoom.SelectedValue)))
            Dim perSizeVal As Integer = ((tSize / CInt(ddlzoom.SelectedValue)))

            Dim lblRowCount As Label = TryCast(e.Row.FindControl("lblRowCount"), Label)
                Dim lblSizeVal As Label = TryCast(e.Row.FindControl("lblSizeVal"), Label)
                Dim imgRowBar As Image = TryCast(e.Row.FindControl("imgRowBar"), Image)
                Dim imgSizeVal As Image = TryCast(e.Row.FindControl("imgSizeVal"), Image)

                imgRowBar.Attributes("width") = perRowVal & "% "
                imgSizeVal.Attributes("width") = perSizeVal & "%"

                lblRowCount.Text = " " & DataBinder.Eval(e.Row.DataItem, "TotalRows") & " rows"
                lblSizeVal.Text = " " & DataBinder.Eval(e.Row.DataItem, "SpaceUsed") & " kb"
            End If
    End Sub

    Private Sub ddlzoom_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlzoom.SelectedIndexChanged
        BindData()
    End Sub
End Class