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
public:
   CArrayInt *pattern;
   int outcome;
   
   Pattern(CArrayInt *prices, int result);
   ~Pattern();
   
   virtual int Compare(const CObject *node,const int mode=0);
   // make outcome of the pattern a dynamic array
   // then I should be able to just search for a pattern in the list with the in built search function (which will us my compare), and if it's not find then add it
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::Pattern(CArrayInt *prices, int result)
  {
   pattern = prices;
   outcome = result;
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
   return pattern.CompareArray(nd.pattern);
}