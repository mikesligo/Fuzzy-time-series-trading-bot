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

#include <Arrays/ArrayDouble.mqh>

class Pattern : public CObject
  {
public:
   CArrayDouble *pattern;
   CArrayDouble *outcome;
   
   Pattern(CArrayDouble *prices, double result);
   ~Pattern();
   
   virtual int Compare(const CObject *node,const int mode=0);
   string str(bool surpress_lone=true);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Pattern::Pattern(CArrayDouble *prices, double result)
  {
   outcome = new CArrayDouble;
   
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

string Pattern::str(bool surpress_lone=true){
   if (surpress_lone == true){
      if (outcome.Total() == 1){
         return "";
      }
   }
   int i;
   string ret = "";
   string outcome_str = "";
   
   double total=0;
   for (i=0; i< outcome.Total(); i++){
      total = total + outcome[i];
      if (i < outcome.Total() -1) outcome_str = outcome_str + DoubleToString(outcome[i],1) +  ", ";
      else outcome_str = outcome_str + DoubleToString(outcome[i],1);
   }
   ret = ret + "Total: " + DoubleToString(total,1) + " :::\t";
   
   for (i=0; i<pattern.Total(); i++){
      if (i < pattern.Total() -1) ret = ret + DoubleToString(pattern[i],1) + " -> ";
      else ret = ret + DoubleToString(pattern[i],1);
   }
   ret = ret + " => " + outcome_str; 

   return ret;
}