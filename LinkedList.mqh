//+------------------------------------------------------------------+
//|                                                   LinkedList.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

#include <Object.mqh>

class CLinkedNode: public CObject
{
public:
   CObject *object;
   CLinkedNode():
      object(NULL)
   {
   }
   CLinkedNode(CObject *obj):
      object(obj)
   {
   }
   CLinkedNode *insert(CObject *obj)
   {
      CLinkedNode *node = new CLinkedNode(obj);
      node.Next(GetPointer(this));
      node.Prev(Prev());
      if (Prev() != NULL) Prev().Next(node);
      Prev(node);
      return node;
   }
   CLinkedNode *append(CObject *obj)
   {
      if (Next() != NULL)
         return ((CLinkedNode*)Next()).insert(obj);
      return insert(obj);
   }
   virtual CObject *pop()
   {
      CObject *p = object;
      if (Prev() != NULL) ((CLinkedNode*)Prev()).Next(Next());
      if (Next() != NULL) ((CLinkedNode*)Next()).Prev(Prev());
      delete GetPointer(this);
      return p;
   }

};

class CLinkedList: public CLinkedNode
{
public:
   CLinkedList()
   {
      Next(GetPointer(this));
      Prev(GetPointer(this));
   }
   ~CLinkedList()
   {
      clear();
   }
   CLinkedNode *begin() { return (CLinkedNode*)Next(); }
   CLinkedNode *end() { return GetPointer(this); }
   void clear()
   {
      while (begin() != end()) ((CLinkedNode*)Next()).pop(); 
   }
   virtual CObject *pop()
   {
      if (begin() == end()) return NULL;
      return begin().pop();
   }
   bool empty() { return begin() == end(); }
};
