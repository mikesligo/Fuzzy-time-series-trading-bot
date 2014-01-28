// Taken from http://www.mql5.com/en/articles/567
// Modified to use ints instead of doubles

class CDynamicArray
  {
private:
   int               m_ChunkSize;    // Chunk size
   int               m_ReservedSize; // Actual size of the array
   int               m_Size;         // Number of active elements in the array
public:
   int            Element[];      // The array proper. It is located in the public section, 
                                     // so that we can use it directly, if necessary
   //+------------------------------------------------------------------+
   //|   Constructor                                                    |
   //+------------------------------------------------------------------+
   void CDynamicArray(int ChunkSize=1024)
     {
      m_Size=0;                            // Number of active elements
      m_ChunkSize=ChunkSize;               // Chunk size
      m_ReservedSize=ChunkSize;            // Actual size of the array
      ArrayResize(Element,m_ReservedSize); // Prepare the array
     }
   //+------------------------------------------------------------------+
   //|   Function for adding an element at the end of array             |
   //+------------------------------------------------------------------+
   void AddValue(int Value)
     {
      m_Size++; // Increase the number of active elements
      if(m_Size>m_ReservedSize)
        { // The required number is bigger than the actual array size
         m_ReservedSize+=m_ChunkSize; // Calculate the new array size
         ArrayResize(Element,m_ReservedSize); // Increase the actual array size
        }
      Element[m_Size-1]=Value; // Add the value
     }
   //+------------------------------------------------------------------+
   //|   Function for getting the number of active elements in the array|
   //+------------------------------------------------------------------+
   int Size()
     {
      return(m_Size);
     }
  };