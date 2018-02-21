using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string message;
            DateTime dt = new DateTime(2000, 1, 1);
            string[] files = Directory.GetFiles("c:\\data", "*.csv");
            string file = null;
            FileInfo fi;
            foreach (var f in files)
            {
                fi = new FileInfo(f);
                if (fi.CreationTime > dt)
                {
                    dt = fi.CreationTime;
                    file = f;
                }
            }

            if (file == null) //dosya bulunamadı
            {
                message = "alert('Seçtiğiniz tarihe ait bilgi bulunamadı');";
            }
            else
            {
                message = FileToArray(file);
                message = message.Replace("-999", "---").Replace("-99", "---");
                Label1.Text = "<script>" + message + "</script>";
                file = file.Substring(file.IndexOf('\\', 5) + 1, 10);
                datetime.Value = file.Substring(6, 2) + "." + file.Substring(4, 2) + "." + file.Substring(0, 4);// dt.ToString("dd/MM/yyyy");
                DropDownList1.SelectedIndex = Convert.ToInt32(file.Substring(8, 2));
            }
        }

    }

    string FileToArray(DateTime dt)
    {
        string fileName = dt.ToString("yyyyMMddHH") + ".csv";
        return FileToArray(fileName);
    }

    string FileToArray(string fileName)
    {
        string output = "";
        string[] content;

        if (File.Exists(fileName))
        {
            content = File.ReadAllLines(fileName, Encoding.GetEncoding(1254));
            output += "title=['" + content[0].Replace(";", "','") + "'];";
            output = output.TrimEnd(',');
            output += "value=[";
            for (int i = 1; i < content.Length; i++)
            {
                output += "['" + content[i].Replace(";", "','") + "'],";
            }
            output = output.TrimEnd(',');
            output += "]";
        }

        return output;
    }

    protected void button_Click(object sender, EventArgs e)
    {
        string file = Convert.ToDateTime(datetime.Value).ToString("yyyyMMdd") + DropDownList1.SelectedValue + ".csv";
        string message = FileToArray("c:\\data\\" + file);
        if(message=="") message = "alert('Seçtiğiniz tarihe ait bilgi bulunamadı');";
        Label1.Text = "<script>" + message + "</script>";

    }
}