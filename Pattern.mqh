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
   CArrayInt *outcome;
   
   Pattern(CArrayInt *prices, int result);
   ~Pattern();
   
   virtual int Compare(const CObject *node,const int mode=0);
   string str();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::Pattern(CArrayInt *prices, int result)
  {
   outcome = new CArrayInt;
   
   pattern = prices;
   outcome.Add(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::~Pattern()
  {
  if(CheckPointer(pattern)==POINTER_DYNAMIC) {
      delete (pattern);
   }
   delete (outcome);
  }
//+------------------------------------------------------------------+

int Pattern::Compare(const CObject *node,const int mode=0){
   const Pattern* nd = node;
   return pattern.CompareArray(nd.pattern);
}

string Pattern::str(){
   int i;
   string ret = "";
   for (i=0; i<pattern.Total(); i++){
      if (i < pattern.Total() -1) ret = ret + IntegerToString(pattern[i]) + ",";
      else ret = ret + IntegerToString(pattern[i]);
   }
   ret = ret + " => ";
   for (i=0; i< outcome.Total(); i++){
      if (i < outcome.Total() -1) ret = ret + IntegerToString(outcome[i]) +  ",";
      else ret = ret + IntegerToString(outcome[i]);
   }
   return ret;
}