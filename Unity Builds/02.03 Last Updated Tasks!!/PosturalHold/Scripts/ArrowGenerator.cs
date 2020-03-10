
//using System.Collections.Generic;
//using System.Windows.Media;
//using UnityEngine;
//using System;

//public class Arrows
//{
//    public double Weight = 0;

//    public Arrows(double w)
//    {
//        this.Weight = w;
//    }
//}

//class Program
//{
//    private static System.Random rand = new System.Random();
//    private static System.Random _rnd = new System.Random();

//    public static Arrows GetArrow(List<Arrows> items, double totalWeight)
//    {
//        // totalWeight is the sum of all Arrows' weight

//        double randomNumber = _rnd.NextDouble() * (totalWeight - 0) + 0;

//        Arrows selectedArrow = null;
//        foreach (Arrows item in items)
//        {
//            if (randomNumber < item.Weight)
//            {
//                selectedArrow = item;
//                break;
//            }

//            randomNumber = randomNumber - item.Weight;
//        }

//        return selectedArrow;
//    }


//    static void Main()
//    {

//        List<double> items = new List<double>();
//        for (int i = 0; i < 8; i++)
//        {
//            double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
//            double u2 = 1.0 - rand.NextDouble();
//            double randStdNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
//                         Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
//            double randNormal =
//                         0.125 + 0.04 * randStdNormal; //random normal(mean,stdDev^2)
//            items.Add(Math.Abs(randNormal));
//        }

//        // total the weigth
//        double totalWeight = 0;
//        foreach (Arrows item in items)
//        {
//            totalWeight += item.Weight;
//        }

//        while (true)
//        {
//            double result = new double();
//            Arrows selectedArrow = null;

//            //for (int i = 0; i < 1000; i++)
//            //{
//                selectedArrow = GetArrow(items, totalWeight);
//                if (selectedArrow != null)
//                {
//                int i = items.FindIndex(x => x.selectedArrow);
//                    //{
//                    //    result[selectedArrow] = result[selectedArrow] + 1;
//                    //}
//                    //else
//                    //{
//                    //    result.Add(selectedArrow, 1);
//                    //}
//                }
//            }

//        }
//    }
//}