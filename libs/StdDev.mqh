/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#property copyright "Michael Gallagher (c) 2014"
#property version   "1.00"

#include <Arrays/ArrayDouble.mqh>

class CustomStdDev
{
   private:
      int period;
      CArrayDouble * prices;
      bool mean_up_to_date;
      double mean;
   public:
      CustomStdDev(int bars);
      ~CustomStdDev();
      void add(double price);
      double get_stdDev();
      double get_mean();
};

CustomStdDev::CustomStdDev(int bars){
   prices = new CArrayDouble;
   mean_up_to_date = false;
   period = bars;
}

void CustomStdDev::add(double price){
   if (prices.Total() < period){
      prices.Add(price);
   }
   else {
      for (int i=period-1; i >0; i--){
         prices.Update(i, prices[i-1]);
      }
      prices.Update(0, price);
   }
   mean_up_to_date = false;
}

double CustomStdDev::get_stdDev(){
   if (prices.Total() == 0) return 0.0;
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
   if (prices.Total() == 0) return 0.0;
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