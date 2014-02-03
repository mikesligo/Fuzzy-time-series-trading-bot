/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

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
   for (int i=0; i<pattern.Total(); i++){
      if (pattern[i] < nd.pattern[i]) return -1;
      if (pattern[i] > nd.pattern[i]) return 1;
   }
   return 0;
}

string Pattern::str(){
   int i;
   string ret = "";
   for (i=0; i<pattern.Total(); i++){
      if (i < pattern.Total() -1) ret = ret + IntegerToString(pattern[i]) + "->";
      else ret = ret + IntegerToString(pattern[i]);
   }
   ret = ret + " => ";
   int total=0;
   for (i=0; i< outcome.Total(); i++){
      total = total + outcome[i];
      if (i < outcome.Total() -1) ret = ret + IntegerToString(outcome[i]) +  ",";
      else ret = ret + IntegerToString(outcome[i]);
   }
   ret = ret + " - Total: " + IntegerToString(total);
   return ret;
}