#property copyright "Michael Gallagher (c) 2014"
#property description "Fuzzy time series EA"
#property version   "1.00"

#include "Pattern.mqh"
#include <Arrays/ArrayInt.mqh>
#include <Arrays/List.mqh>
#include "libs/StdDev.mqh"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_type1   DRAW_LINE
#property indicator_color1  C'127,191,127'
#property indicator_style1  STYLE_SOLID
#property indicator_label1  "Plus 1"
#property indicator_width1  2
#property indicator_type2   DRAW_LINE
#property indicator_color2  C'191,127,127'
#property indicator_style2  STYLE_SOLID
#property indicator_label2  "Minus 1"
#property indicator_width2  2

input int             Divisions    = 20;
input double          Top          = 1.4;
input double          Bottom       = 1.27;
input int             Pattern_size = 5;
input int             StdDev_ma = 50;

double divisions[];
CArrayInt * movement_sequence; // representing the jumps in fuzzy divisions per bar
CList *patterns;
CustomStdDev * stdDev;
CustomStdDev * indicator_stdDev;
double plusOne[], minusOne[];

static datetime old_time;

void OnInit() {
   movement_sequence = new CArrayInt;
   patterns = new CList;
   stdDev = new CustomStdDev(StdDev_ma);
   indicator_stdDev = new CustomStdDev(StdDev_ma);
   
   old_time = TimeCurrent();
   
   SetIndexBuffer(0,plusOne,INDICATOR_DATA);
   SetIndexBuffer(1,minusOne,INDICATOR_DATA);
   
   ArrayResize(divisions, Divisions+1);
     
   double difference = Top - Bottom;
   double increment = difference/(double) Divisions;
  }
  
void OnTick(){  

   datetime new_time[1];
   CopyTime(_Symbol,_Period,0,1,new_time);
   
   if (old_time != new_time[0]){ // if it's a new bar
      double open[];
      CopyOpen(Symbol(),0,0,Pattern_size+1,open);
      ArraySetAsSeries(open,true);
      if (open[0] > Top || open[0] < Bottom){
         old_time = new_time[0];
         return;
      }
      Print("hi");
      int division = get_fuzzy_section(open[0]);
      int prev_division = get_fuzzy_section(open[1]);
      int jump = division - prev_division;
      
      //stdDev.add(open[0]);
      //double dev = stdDev.get_stdDev();
      
      // Get standard deviation with a moving average of EVERYTHING and fuzzily split...?
      CArrayInt * latest = get_latest_pattern(movement_sequence);
      if (latest != NULL){
         Pattern * current = new Pattern(latest, jump); // remember to delete
         patterns.Sort(0);
         Pattern * search = patterns.Search(current);
         if (search == NULL){
            patterns.Add(current);
         }
         else {
            search.outcome.Add(jump);
            delete(current);
         }
      }
      if (jump < Divisions *(3/4)) movement_sequence.Add(jump); // outliers
      old_time = new_time[0];
   }  
}

CArrayInt* get_latest_pattern(CArrayInt* seq){
   if (seq.Total() < Pattern_size+1) return NULL;
   CArrayInt *new_arr = new CArrayInt;
   for (int i=seq.Total()-Pattern_size-1; i < seq.Total()-1; i++){
      new_arr.Add(seq[i]);
   }
   return new_arr;
}

int get_fuzzy_section(double price){
   int i;
   double difference = Top - Bottom;
   double increment = difference/(double) Divisions;
   
   for (i=0; i< Divisions; i++){
      double division = (double)i*increment + Bottom;
      if (price > division && price <= division + increment){
         return i+1;
      }
   }
   if (price < Top) return Divisions+1;
   return Divisions;
}

void OnDeinit(const int reason)
  {
   int i;
   patterns.Sort(0);
   Print (IntegerToString(patterns.Total()));
   for (i=0; i< patterns.Total(); i++){
      Pattern* p = patterns.GetNodeAtIndex(i);
      Print(p.str());
   }
   delete (movement_sequence);
   delete (patterns);
   delete (stdDev);
   delete (indicator_stdDev); 
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
   if (rates_total-prev_calculated > StdDev_ma) return rates_total;
   for (int i=prev_calculated; i< rates_total; i++){
      indicator_stdDev.add(open[i]);
      double stddev = indicator_stdDev.get_stdDev();
      if (stddev){
         plusOne[i] = open[i] + stddev;
         
         minusOne[i] = open[i] - stddev;
      }
   }
   return rates_total;
}