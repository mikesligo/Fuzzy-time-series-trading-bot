#property copyright "Michael Gallagher (c) 2014"
#property description "Fuzzy time series EA"
#property version   "1.00"

#include "Libraries/trendline.mq5"
#include "Libraries/CDynamicArray.mqh"
#include "Pattern.mqh"

#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

input int             Divisions    = 20;
input double          Top          = 1.4;
input double          Bottom       = 1.27;
input int             Pattern_size = 5;

double top[], bottom[];
CDynamicArray knowledge; // representing the jumps in fuzzy divisions per bar

static datetime old_time;

void OnInit()
  {
  
  }
  
void OnTick(){  
  
   datetime new_time[1];
   CopyTime(_Symbol,_Period,0,1,new_time);
   
   if (old_time != new_time[0]){ // if it's a new bar
      double close[];
      CopyClose(Symbol(),0,0,Pattern_size,close);
      ArraySetAsSeries(close,true);
      
      Print ("Close[0] - ", close[0]);
      Print ("Close[1] - ", close[1]);
      int division = get_fuzzy_section(close[0]);
      int prev_division = get_fuzzy_section(close[1]);
      knowledge.AddValue(division - prev_division);
   }
  
}

int get_fuzzy_section(double price){
   int i;
   double difference = Top - Bottom;
   double increment = difference/(double) Divisions;
   
   for (i=0; i< Divisions; i++){
      double division = (double)i*increment + lowest;
      if (price > division && price <= division + increment){
         return i+1;
      }
   }
   return Divisions;
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])

  {
   int i;
   
//+------------------------------------------------------------------+
//| Adjust bar at which we start from (start)                        |
//+------------------------------------------------------------------+   
   
   int start; // The bar at which we're starting from
   if (Bars_checked >= rates_total){
      start = 0;   
   }
   else {
     start = rates_total - Bars_checked;
   }
   
//+------------------------------------------------------------------+
//| Get highest and lowest points                                    |
//+------------------------------------------------------------------+

   double highest = Top;
   double lowest = Bottom;
   
//+------------------------------------------------------------------+
//| Divide high and low price into fuzzy sections                    |
//+------------------------------------------------------------------+

   double divisions[];
   ArrayResize(divisions, Divisions+1);
   
   double difference = highest - lowest;
   double increment = difference/(double) Divisions;
   
   for (i=0; i< Divisions; i++){
      divisions[i] = (double)i*increment + lowest;
   }
   divisions[Divisions] = highest;   // because the modulus probably won't go in evenly

//+------------------------------------------------------------------+
//| Draw trend lines                                                 |
//+------------------------------------------------------------------+

   datetime date[];
   ArrayResize(date,rates_total);
   CopyTime(Symbol(),Period(),0,rates_total,date);
   
   for (i=0; i< Divisions+1; i++){
      TrendCreate(0,IntegerToString(i),0,date[start],divisions[i],date[rates_total-1],divisions[i]);
   }
   ChartRedraw();
   
   
   return(rates_total);
  }

void OnDeinit(const int reason)
  {
   for (int i=0; i < Divisions +1; i++){
      TrendDelete(0, IntegerToString(i));
   }
   return;
  }
