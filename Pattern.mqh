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

#include <Arrays/ArrayInt.mqh>

class Pattern : public CObject
  {
private:

public:
   CArrayInt pattern;
   int outcome;
   Pattern(int &prices[], int size);
   ~Pattern();
   
   virtual int       Compare(const CObject *node,const int mode=0);
   // get compare working
   // then make list of patterns, sorted
   // make outcome of the pattern a dynamic array
   // then I should be able to just search for a pattern in the list with the in built search function (which will us my compare), and if it's not find then add it
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::Pattern(int &prices[], int size)
  {
   outcome = prices[0];
   for (int i=size; i > 0; i--){
      pattern.Add(prices[i]);
   }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::~Pattern()
  {
  }
//+------------------------------------------------------------------+

int Pattern::Compare(const CObject *node,const int mode=0){
   const Pattern* nd = node;
   return pattern.CompareArray(nd->pattern);
}