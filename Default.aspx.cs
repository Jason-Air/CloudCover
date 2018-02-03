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

        form1.InnerHtml+="<script>" + FileToArray(new DateTime(2018, 01, 25, 13, 0, 0)) + "</script>";
    }

    string FileToArray(DateTime dt)
    {
        string[] title, value;

        string output = "", path = "\\data\\";
        string fileName = dt.ToString("yyyyMMddHH") + ".csv";
        string theFile = path + fileName;
        StreamReader sr = File.OpenText(theFile);
        title = sr.ReadLine().Split(';');
        output += "title=[";
        for (int i = 0; i < title.Length; i++)
            output += "'"+title[i] + "',";
        output = output.TrimEnd(',');
        output += "];";

        String line;
        int j;
        output += "value=[";
        for (line = sr.ReadLine(), j = 0; line != null; line = sr.ReadLine(), j++) //while ((line = sr.ReadLine()) != null)
        {
            value = line.Split(';');
            output += "[";
            for (int i = 0; i < title.Length; i++)
            {
                output += "'" + value[i] + "',";   //output += "value[" + j + "][" + i + "] = " + value[i];
            }
            output += "],";
        }

        output = output.TrimEnd(',');
        output += "]";

        return output;
    }
}