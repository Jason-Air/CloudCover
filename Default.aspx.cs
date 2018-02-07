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
        //int index = 0, len = 0; ;
        //StreamReader sr = File.OpenText(theFile);
        //title = sr.ReadLine().Split(';');
        content = File.ReadAllLines(theFile);
        //len = content.IndexOf('\n');
        title = content[0].Split(';');
        output += "title=[";
        for (int i = 0; i < title.Length; i++)
            output += "'" + title[i] + "',";
        output = output.TrimEnd(',');
        output += "];";
        //content = content.Substring(len);

        output += "value=[";
        //for (line = sr.ReadLine(), j = 0; line != null; line = sr.ReadLine(), j++) //while ((line = sr.ReadLine()) != null)
        
        //string[] line = content.Split(('\n'));
        //for (index += len, len = content.IndexOf('\n', index), line = content.Substring(index, len); line != null; index += len, len = content.IndexOf('\n', index), line = content.Substring(index, len))
        for (int i=1;i<content.Length;i++) //foreach(string l in line)
        {
            value = content[i].Split(';');
            output += "[";
            foreach (var v in value) //for (int i = 0; i < title.Length; i++)
            {
                output += "'" + v + "',";   //output += "value[" + j + "][" + i + "] = " + value[i];
            }
            output = output.TrimEnd(',');
            output += "],";
        }

        output = output.TrimEnd(',');
        output += "]";

        return output;
    }
}