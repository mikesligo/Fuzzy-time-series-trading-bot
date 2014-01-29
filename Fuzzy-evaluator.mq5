#property copyright "Michael Gallagher (c) 2014"
#property description "Fuzzy time series EA"
#property version   "1.00"

#include "libs/hline.mqh"
#include "Pattern.mqh"
#include <Arrays/ArrayInt.mqh>
#include <Arrays/List.mqh>

input int             Divisions    = 20;
input double          Top          = 1.4;
input double          Bottom       = 1.27;
input int             Pattern_size = 5;

double divisions[];
CArrayInt * movement_sequence; // representing the jumps in fuzzy divisions per bar
CList *patterns;

static datetime old_time;

void OnInit() {   
   movement_sequence = new CArrayInt;
   patterns = new CList;
   
   old_time = TimeCurrent();
   
   ArrayResize(divisions, Divisions+1);
   
   int i;
   double difference = Top - Bottom;
   double increment = difference/(double) Divisions;
   
   for (i=0; i< Divisions; i++){
      double division = (double)i*increment + Bottom;
      divisions[i] = HLineCreate(0,IntegerToString(i),0,division);
   }
   divisions[Divisions] = HLineCreate(0,IntegerToString(Divisions+1),0,Top);
  }
  
void OnTick(){  

   datetime new_time[1];
   CopyTime(_Symbol,_Period,0,1,new_time);
   
   if (old_time != new_time[0]){ // if it's a new bar
      double open[];
      CopyOpen(Symbol(),0,0,Pattern_size+1,open);
      ArraySetAsSeries(open,true);
      
      int division = get_fuzzy_section(open[0]);
      int prev_division = get_fuzzy_section(open[1]);
      int jump = division - prev_division;
      
      CArrayInt * latest = get_latest_pattern(movement_sequence);
      if (latest != NULL){
         Pattern * current = new Pattern(latest, jump); // remember to delete
         Pattern * search = patterns.Search(current);
         if (search == NULL){
            patterns.Add(current);
         }
         else {
            search.outcome.Add(jump);
            delete(current);
         }
         
         movement_sequence.Add(jump);
      }
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
   //patterns.Sort();
   for (i=0; i< patterns.Total(); i++){
      Pattern* p = patterns.GetNodeAtIndex(i);
      Print(p.str());
   }
   for (i=0; i < Divisions +1; i++){
      HLineDelete(0, IntegerToString(i));
   }
   delete (movement_sequence);
   delete (patterns);
  }
