using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        form1.InnerHtml += "<script>" + FileToArray(new DateTime(2018, 01, 25, 13, 0, 0)) + "</script>";
    }

    string FileToArray(DateTime dt)
    {
        string[] title, value;

        string output = "", path = "\\data\\";
        string fileName = dt.ToString("yyyyMMddHH") + ".csv";
        string theFile = path + fileName;
        string[] content;

        content = File.ReadAllLines(theFile);
        
        title = content[0].Split(';');
        output += "title=[";
        for (int i = 0; i < title.Length; i++)
            output += "'" + title[i] + "',";
        output = output.TrimEnd(',');
        output += "];";
        output += "value=[";
        for (int i=1;i<content.Length;i++) 
        {
            value = content[i].Split(';');
            output += "[";
            foreach (var v in value) 
            {
                output += "'" + v + "',";   
            }
            output = output.TrimEnd(',');
            output += "],";
        }

        output = output.TrimEnd(',');
        output += "]";

        return output;
    }
}