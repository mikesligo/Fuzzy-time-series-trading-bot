#property copyright "Michael Gallagher (c) 2014"
#property version   "1.00"

#include <Arrays/ArrayDouble.mqh>

class CustomStdDev
{
   private:
      CArrayDouble * prices;
      bool mean_up_to_date;
      double mean;
   public:
      CustomStdDev();
      ~CustomStdDev();
      void add(double price);
      double get_stdDev();
      double get_mean();
};

CustomStdDev::CustomStdDev(){
   prices = new CArrayDouble;
   mean_up_to_date = false;
}

void CustomStdDev::add(double price){
   prices.Add(price);
   mean_up_to_date = false;
}

double CustomStdDev::get_stdDev(){
   get_mean();
   double sum = 0;
   for (int i=0; i< prices.Total(); i++){
      sum = sum + (prices[i] - mean)*(prices[i] - mean);
   }
   double stdDev_sq = sum/prices.Total();
   return MathSqrt(stdDev_sq);
}

double CustomStdDev::get_mean(){
   if (mean_up_to_date) return mean;
   double sum = 0;
   for (int i=0; i< prices.Total(); i++){
      sum = sum + prices[i];
   }
   mean = sum/prices.Total();
   mean_up_to_date = true;
   return mean;
}

CustomStdDev::~CustomStdDev(void){
   delete (prices);
}