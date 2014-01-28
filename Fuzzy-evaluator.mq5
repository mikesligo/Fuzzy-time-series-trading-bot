#property copyright "Michael Gallagher (c) 2014"
#property description "Fuzzy time series indicator"
#property version   "1.00"

#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

input int             Divisions    = 7;
input int             Bars_checked = 275;

double top[], bottom[];

void OnInit()
  {

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

   double highest = high[rates_total-1];
   double lowest = low[rates_total-1];

   for (i=start; i < rates_total; i++){
      if (high[i] > highest){
         highest = high[i];
      }
      if (low[i] < lowest){
         lowest = low[i];
      }
   }
   
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

bool TrendCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="TrendLine",  // line name
                 const int             sub_window=0,      // subwindow index
                 datetime              time1=0,           // first point time
                 double                price1=0,          // first point price
                 datetime              time2=0,           // second point time
                 double                price2=0,          // second point price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=false,    // highlight to move
                 const bool            ray_left=false,    // line's continuation to the left
                 const bool            ray_right=false,   // line's continuation to the right
                 const bool            hidden=false,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a trend line by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the left
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| The function deletes the trend line from the chart.              |
//+------------------------------------------------------------------+
bool TrendDelete(const long   chart_ID=0,       // chart's ID
                 const string name="TrendLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete a trend line
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }