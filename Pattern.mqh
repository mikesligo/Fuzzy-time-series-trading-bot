//+------------------------------------------------------------------+
//|                                                      Pattern.mqh |
//|                                                Michael Gallagher |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michael Gallagher"
#property link      ""
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Pattern
  {
private:
   int pattern[];
   int outcome;
public:
   
   string sig();
   Pattern(int &prices, int size);
   ~Pattern();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::Pattern(int &prices, int size)
  {
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::~Pattern()
  {
  }
//+------------------------------------------------------------------+
string Pattern::sig(void){
   return ("lol");
}