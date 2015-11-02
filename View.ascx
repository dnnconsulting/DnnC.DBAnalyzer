<%@ Control Language="vb" AutoEventWireup="true" CodeBehind="View.ascx.vb" Inherits="DnnC.Modules.DBAnalyzer.View" %>
<%@ Register TagName="label" TagPrefix="dnn" Src="~/controls/labelcontrol.ascx" %>

<asp:Label ID="Label2" runat="server"></asp:Label>

<div id="dnncDBA">
    <!-- Start Database Info -->
    <div class="infoSize">
        <asp:GridView ID="grdInfo" runat="server" 
            AutoGenerateColumns="False" 
            CssClass="grd-dbdata"
            GridLines="None">
            <RowStyle CssClass="infoBox" />

            <Columns>
                <asp:TemplateField HeaderText="Database name">                
                    <HeaderStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="lblDBName" runat="server" Text='<%# Bind("DBName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Database Size" >                
                    <HeaderStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="lblDBName" runat="server" Text='<%# Bind("Size") %>'></asp:Label> Mb
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Used space">                
                    <HeaderStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="lblDBName" runat="server" Text='<%# Bind("UsedSpace") %>'></asp:Label> Mb
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Available space">                
                    <HeaderStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="lblDBName" runat="server" Text='<%# Bind("AvailableFreeSpace") %>'></asp:Label> Mb
                    </ItemTemplate>
                </asp:TemplateField>                      
            </Columns>
        </asp:GridView>

    </div><!--// End Database Info -->

    <!-- Start Database table Info -->
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="toolbar">
                <div class="left">
                    <dnn:Label ID="lblSort" runat="server" /> 
                    <asp:DropDownList ID="ddlColName" runat="server">
                        <asp:ListItem Value="TableName">Table name</asp:ListItem>
                        <asp:ListItem Value="TotalRows" Selected="true">Number of rows</asp:ListItem>
                        <asp:ListItem Value="SpaceUsed">Size of table</asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlDirection" runat="server">
                        <asp:ListItem Value="ASC">Ascending</asp:ListItem>
                        <asp:ListItem Value="DESC" Selected="true">Descending</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnSort" runat="server" Text="Go" class="btnGo" />
                </div>
                <div class="right">
                    <dnn:Label ID="lblZoom" runat="server" />
                    <asp:DropDownList ID="ddlzoom" runat="server" AutoPostBack="true">
                        <asp:ListItem Value="5000" Text="10 x"/>
                        <asp:ListItem Value="4000" Text="20 x"/>
                        <asp:ListItem Value="3000" Text="30 x"/>
                        <asp:ListItem Value="2000" Text="40 x"/>
                        <asp:ListItem Value="1000" Text="50 x"/>
                        <asp:ListItem Value="400" Text="60 x"/>
                        <asp:ListItem Value="200" Text="70 x"/>
                        <asp:ListItem Value="120" Text="80 x"/>
                        <asp:ListItem Value="60" Text="90 x"/>
                        <asp:ListItem Value="20" Text="100 x" Selected="True"/>
                    </asp:DropDownList> 
                </div>
            </div>
    
            <div class="graphbar">
                <asp:GridView ID="grdDBData" runat="server" 
                    AutoGenerateColumns="False" 
                    CssClass="grd-dbdata"
                    GridLines="None">
                    <RowStyle CssClass="itemStyle" />
                    <AlternatingRowStyle CssClass="altStyle" /> 
                    <Columns>

                        <asp:TemplateField HeaderText="Table name" ItemStyle-Width="220px" ItemStyle-CssClass="tableNameStyle">                
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblTableName" runat="server" Text='<%# Bind("TableName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Table data">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <div class="bar-holder">
                                    <div class="rowbar">
                                        <asp:Image ID="imgRowBar" runat="server" ImageUrl="~/desktopmodules/dnnc_db_analyzer/img/bar.png" />
                                        <asp:Label ID="lblRowCount" runat="server"></asp:Label>
                                    </div>
                                    <div class="sizebar">
                                        <asp:Image ID="imgSizeVal" runat="server" ImageUrl="~/desktopmodules/dnnc_db_analyzer/img/bar.png" />
                                        <asp:Label ID="lblSizeVal" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <div class="bar-holder">
                                    <div class="rowbar">
                                        <asp:Image ID="imgRowBar" runat="server" ImageUrl="~/desktopmodules/dnnc_db_analyzer/img/bar.png" />
                                        <asp:Label ID="lblRowCount" runat="server"></asp:Label>
                                    </div>
                                    <div class="sizebar">
                                        <asp:Image ID="imgSizeVal" runat="server" ImageUrl="~/desktopmodules/dnnc_db_analyzer/img/bar.png" />
                                        <asp:Label ID="lblSizeVal" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </AlternatingItemTemplate>
                        </asp:TemplateField>                        
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSort" />
            <asp:AsyncPostBackTrigger ControlID="ddlZoom" />
        </Triggers>
    </asp:UpdatePanel><!--// End Database table Info -->
</div>
