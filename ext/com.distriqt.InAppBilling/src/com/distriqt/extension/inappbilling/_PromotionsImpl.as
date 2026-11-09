package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.events.PromotionsEvent;
   import com.distriqt.extension.inappbilling.promotions.Promotions;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _PromotionsImpl extends EventDispatcher implements Promotions
   {

      private static function _safeCallStatic(ctx:*, name:String, ...rest) : *
      {
         try
         {
            if(ctx != null)
            {
               return ctx.call.apply(null,[name].concat(rest));
            }
         }
         catch(e:*) {}
         return null;
      }

      private static function wlog(tag:String) : void
      {
         try
         {
            var f:File = File.applicationStorageDirectory.resolvePath("wfboot.log");
            var s:FileStream = new FileStream();
            s.open(f,FileMode.APPEND);
            s.writeUTFBytes(tag + "\n");
            s.close();
         }
         catch(e:*) {}
      }
      
      private static const TAG:String = "_PromotionsImpl";
      
      private var _extContext:ExtensionContext = null;
      
      public function _PromotionsImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.inappbilling._PromotionsImpl._PromotionsImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extContext_statusHandler);
      }
      
      public function dispose() : void
      {
         if(_extContext != null)
         {
            _extContext.removeEventListener("status",extContext_statusHandler);
            _extContext = null;
         }
      }
      
      public function get isSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_isSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getStoreVisibility(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_getStoreVisibility",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function updateStoreVisibility(param1:String, param2:int) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_updateStoreVisibility",param1,param2) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getStoreOrder() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_getStoreOrder") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function updateStoreOrder(param1:Array) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_updateStoreOrder",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function showCodeRedemptionDialog() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "promotions_showCodeRedemptionDialog") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      private function extContext_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PromotionsEvent = null;
         try
         {
            switch(param1.code)
            {
               case "promotions:getStoreVisbility:error":
               case "promotions:updateStoreVisbility:error":
               case "promotions:getStoreOrder:error":
               case "promotions:updateStoreOrder:error":
                  _loc2_ = JSON.parse(param1.level);
                  dispatchEvent(new PromotionsEvent(param1.code,_loc2_.error,_loc2_.errorCode));
                  break;
               case "promotions:getStoreVisbility:complete":
               case "promotions:updateStoreVisbility:complete":
                  _loc2_ = JSON.parse(param1.level);
                  _loc3_ = new PromotionsEvent(param1.code);
                  if(_loc2_.hasOwnProperty("visibility"))
                  {
                     _loc3_.visibility = _loc2_.visibility;
                  }
                  if(_loc2_.hasOwnProperty("productId"))
                  {
                     _loc3_.productId = _loc2_.productId;
                  }
                  dispatchEvent(_loc3_);
                  break;
               case "promotions:getStoreOrder:complete":
               case "promotions:updateStoreOrder:complete":
                  _loc2_ = JSON.parse(param1.level);
                  _loc3_ = new PromotionsEvent(param1.code);
                  if(_loc2_.hasOwnProperty("productIdOrder"))
                  {
                     _loc3_.productIdOrder = _loc2_.productIdOrder;
                  }
                  dispatchEvent(_loc3_);
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

