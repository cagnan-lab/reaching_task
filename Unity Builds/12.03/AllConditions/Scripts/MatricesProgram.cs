using System;
using System.IO;
//       1         2         3         4         5         6         7         8
// 45678901234567890123456789012345678901234567890123456789012345678901234567890

namespace Matrices
{

  class MatricesProgram
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nBegin vectors and matrices using C# demo \n");

      Console.WriteLine("Creating and displaying a vector with 4 cells init to 3.5 \n");
      double[] v = Utils.VecCreate(4, 3.5);
      Utils.VecShow(v, 3, 6);

      Console.WriteLine("\nCreating and displaying a 3x4 matrix \n");
      double[][] m = Utils.MatCreate(3, 4);
      Utils.MatShow(m, 2, 6);

      Console.WriteLine("\nLoading a 4x3 matrix from file dummy_data.tsv \n");
      string fn = "..\\..\\..\\dummy_data.tsv";
      double[][] d = Utils.MatLoad(fn, 4, new int[] { 0, 1, 2 }, '\t');
      Utils.MatShow(d, 1, 6);

      Console.WriteLine("\nEnd demo ");
      Console.ReadLine();
    } // Main
  } // Program class

  public class Utils
  {
    public static double[] VecCreate(int n, double val = 0.0)
    {
      double[] result = new double[n];
      for (int i = 0; i < n; ++i)
        result[i] = val;
      return result;
    }

    public static void VecShow(double[] vec, int dec, int wid)
    {
      for (int i = 0; i < vec.Length; ++i)
        Console.Write(vec[i].ToString("F" + dec).PadLeft(wid));
      Console.WriteLine("");
    }

    public static double[][] MatCreate(int rows, int cols)
    {
      double[][] result = new double[rows][];
      for (int i = 0; i < rows; ++i)
        result[i] = new double[cols];
      return result;
    }

    public static void MatShow(double[][] mat, int dec, int wid)
    {
      int nRows = mat.Length;
      int nCols = mat[0].Length;
      for (int i = 0; i < nRows; ++i)
      {
        for (int j = 0; j < nCols; ++j)
        {
          double x = mat[i][j];
          Console.Write(x.ToString("F" + dec).PadLeft(wid));
        }
        Console.WriteLine("");
        // Utils.VecShow(mat[i], dec, wid);
      }
    }

    public static double[][] MatLoad(string fn, int nRows, int[] cols, char sep)
    {
      int nCols = cols.Length;
      double[][] result = MatCreate(nRows, nCols);
      string line = "";
      string[] tokens = null;
      FileStream ifs = new FileStream(fn, FileMode.Open);
      StreamReader sr = new StreamReader(ifs);

      int i = 0;
      while ((line = sr.ReadLine()) != null)
      {
        if (line.StartsWith("//") == true)
          continue;
        tokens = line.Split(sep);
        for (int j = 0; j < nCols; ++j)
        {
          int k = cols[j];  // into tokens
          result[i][j] = double.Parse(tokens[k]);
        }
        ++i;
      }
      sr.Close(); ifs.Close();
      return result;
    }

  } // Utils class


} // ns
