#property copyright "Michael Gallagher (c) 2014"
#property version   "1.00"

#include <Arrays/ArrayDouble.mqh>

class CustomStdDev
{
   private:
      int period;
      CArrayDouble * prices;
   public:
      CustomStdDev(int bars);
      ~CustomStdDev();
      void add(double price);
      double get_stdDev();
      double get_mean();
};

CustomStdDev::CustomStdDev(int bars){
   prices = new CArrayDouble;
   period = bars;
}

void CustomStdDev::add(double price){
   if (prices.Total() < period){
      prices.Add(price);
   }
   else {
      for (int i=0; i< period; i++){
         prices.Insert(prices[i], i+1);
      }
      prices.Insert(price,0);
   }
}

double CustomStdDev::get_stdDev(){
   double mean = get_mean();
   double sum = 0;
   for (int i=0; i< period; i++){
      sum = sum + (prices[i] - mean)*(prices[i] - mean);
   }
   double stdDev_sq = sum/period;
   return MathSqrt(stdDev_sq);
}

double CustomStdDev::get_mean(){
   if (prices.Total() < period) return NULL;
   double sum = 0;
   for (int i=0; i< period; i++){
      sum = sum + prices[i];
   }
   return sum/period;
}

CustomStdDev::~CustomStdDev(void){
   delete (prices);
}