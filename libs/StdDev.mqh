#property copyright "Michael Gallagher (c) 2014"
#property version   "1.00"

#include <Arrays/ArrayDouble.mqh>

class CustomStdDev
{
   private:
      CArrayDouble * prices;
   public:
      CustomStdDev();
      ~CustomStdDev();
      void add(double price);
      double get_stdDev();
      double get_mean();
};

CustomStdDev::CustomStdDev(){
   prices = new CArrayDouble;
}

void CustomStdDev::add(double price){
   prices.Add(price);
}

double CustomStdDev::get_stdDev(){
   double mean = get_mean();
   double sum = 0;
   for (int i=0; i< prices.Total(); i++){
      sum = sum + (prices[i] - mean)*(prices[i] - mean);
   }
   double stdDev_sq = sum/prices.Total();
   return MathSqrt(stdDev_sq);
}

double CustomStdDev::get_mean(){
   double sum = 0;
   for (int i=0; i< prices.Total(); i++){
      sum = sum + prices[i];
   }
   return sum/prices.Total();
}

CustomStdDev::~CustomStdDev(void){
   delete (prices);
}