using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;



namespace TEMA_Filme_lab4
{
    /// <summary>
    /// Summary description for WebService1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class WebService1 : System.Web.Services.WebService
    {
        SqlConnection myConn = new SqlConnection();
       
        DataSet dsMovies = new DataSet();

        public WebService1()
        {
            myConn.ConnectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=D:\UTCN\II\WindowsFormsApp2\Movies.mdf;Integrated Security=True";
            myConn.Open();
        }


        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public DataSet GetMovies()
        {

            SqlDataAdapter daFilme = new SqlDataAdapter("SELECT Title FROM MOVIES", myConn);
            daFilme.Fill(dsMovies, "Movies");
            return dsMovies;
        }

        [WebMethod]
        public void AddMovie(int MoviesId, string Title, string Director, int ReleaseYear)
        {
            try
            {
                SqlCommand command = new SqlCommand("INSERT INTO MOVIES (MoviesId,Title,Director,ReleaseYear) VALUES (@MoviesId,@Title,@Director,@ReleaseYear)", myConn);
                command.Parameters.Add("@MoviesId", SqlDbType.Int).Value = MoviesId;
                command.Parameters.Add("@Title", SqlDbType.Text).Value = Title;
                command.Parameters.Add("@Director", SqlDbType.Text).Value = Director;
                command.Parameters.Add("@ReleaseYear", SqlDbType.Int).Value = ReleaseYear;
                

                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            myConn.Close();
        }





        [WebMethod]
        public void ModifyMovie(int MoviesId, string Title, string Director, int ReleaseYear)
        {
            try
            {
                SqlCommand command = new SqlCommand("UPDATE MOVIES SET MoviesId = @MoviesId,Title = @Title, Director = @Director, ReleaseYear = @Releaseyear  WHERE MoviesId = @MoviesId", myConn);
                command.Parameters.Add("@MoviesId", SqlDbType.Int).Value = MoviesId;
                command.Parameters.Add("@Title", SqlDbType.Text).Value = Title;
                command.Parameters.Add("@Director", SqlDbType.Text).Value = Director;
                command.Parameters.Add("@ReleaseYear", SqlDbType.Int).Value = ReleaseYear;
                

                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            myConn.Close();
        }





        [WebMethod]
        public void DeleteMovie(int MoviesId)
        {
            try
            {
                SqlCommand command = new SqlCommand("DELETE FROM MOVIES WHERE MoviesId=@MoviesId", myConn);
                command.Parameters.Add("@MoviesId", SqlDbType.Int).Value = MoviesId;
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            myConn.Close();
        }
    }
}






