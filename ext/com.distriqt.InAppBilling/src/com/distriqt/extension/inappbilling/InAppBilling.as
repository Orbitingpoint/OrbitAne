package com.distriqt.extension.inappbilling
{
   import com.distriqt.extension.inappbilling.events.InAppBillingEvent;
   import com.distriqt.extension.inappbilling.events.ProductOverlayEvent;
   import com.distriqt.extension.inappbilling.events.ProductViewEvent;
   import com.distriqt.extension.inappbilling.events.PurchaseEvent;
   import com.distriqt.extension.inappbilling.events.PurchaseRequestEvent;
   import com.distriqt.extension.inappbilling.events.UserDataEvent;
   import com.distriqt.extension.inappbilling.promotions.Promotions;
   import com.distriqt.extension.inappbilling.purchases.Downloads;
   import com.distriqt.extension.inappbilling.updates.InAppUpdates;
   import com.distriqt.extension.inappbilling.user.UserData;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.setTimeout;
   
   [Event(name="inappbilling:setup:success",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:setup:failure",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:products:loaded",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:products:failed",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:product:invalid",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:restore:purchases:success",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:restore:purchases:failed",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:consume:success",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="inappbilling:consume:failed",type="com.distriqt.extension.inappbilling.events.InAppBillingEvent")]
   [Event(name="purchases:updated",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:failed",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:success",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:cancelled",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:removed",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:notallowed",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:deferred",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:purchasing",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="purchase:restored",deprecatedReplacement="com.distriqt.extension.inappbilling.events.PurchaseEvent.PURCHASES_UPDATED",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="get:purchases:complete",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="get:purchases:failed",type="com.distriqt.extension.inappbilling.events.PurchaseEvent")]
   [Event(name="productview:loaded",type="com.distriqt.extension.inappbilling.events.ProductViewEvent")]
   [Event(name="productview:failed",type="com.distriqt.extension.inappbilling.events.ProductViewEvent")]
   [Event(name="productview:displayed",type="com.distriqt.extension.inappbilling.events.ProductViewEvent")]
   [Event(name="productview:dismissed",type="com.distriqt.extension.inappbilling.events.ProductViewEvent")]
   [Event(name="should:add:purchase",type="com.distriqt.extension.inappbilling.events.PurchaseRequestEvent")]
   [Event(name="userdata:get:success",type="com.distriqt.extension.inappbilling.events.UserDataEvent")]
   [Event(name="userdata:get:failed",type="com.distriqt.extension.inappbilling.events.UserDataEvent")]
   public class InAppBilling extends EventDispatcher
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

      private static var _wlogInit:Boolean = false;
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
      
      public static const EXT_CONTEXT_ID:String = "com.distriqt.InAppBilling";
      
      private static const EXT_ID_NUMBER:int = 15;
      
      public static const VERSION:String = "14.0.0";
      
      private static const VERSION_DEFAULT:String = "0";
      
      private static const IMPLEMENTATION_DEFAULT:String = "unknown";
      
      private static const ERROR_CREATION:String = "The native extension context could not be created";
      
      private static const ERROR_SINGLETON:String = "The singleton has already been created. Use InAppBilling.service to access the functionality";
      
      private static var _instance:InAppBilling;
      
      private static var _shouldCreateInstance:Boolean = false;
      
      private static var _extContext:ExtensionContext = null;
      
      private var _extensionId:String = "";
      
      private var _extensionIdNumber:int = -1;
      
      private var _serviceSetup:Boolean = false;
      
      private var _products:Array = [];
      
      private var _applicationReceipt:ApplicationReceipt = null;
      
      private var _downloads:Downloads = null;
      
      private var _promotions:Promotions = null;
      
      private var _inAppUpdates:InAppUpdates = null;
      
      public function InAppBilling()
      {
         wlog("com.distriqt.extension.inappbilling.InAppBilling.InAppBilling");
         super();
         if(_shouldCreateInstance)
         {
            try
            {
               _extensionId = "com.distriqt.InAppBilling";
               _extensionIdNumber = 15;
               _extContext = ExtensionContext.createExtensionContext("com.distriqt.InAppBilling",null);
               _extContext.addEventListener("status",extension_statusHandler);
            }
            catch(e:Error)
            {
               /* stub: no native context on Windows */
            }
            return;
         }
         throw new Error("The singleton has already been created. Use InAppBilling.service to access the functionality");
      }
      
      public static function get service() : InAppBilling
      {
         createInstance();
         return _instance;
      }
      
      private static function createInstance() : void
      {
         if(_instance == null)
         {
            _shouldCreateInstance = true;
            _instance = new InAppBilling();
            _shouldCreateInstance = false;
         }
      }
      
      [Deprecated(message="You no longer need to use an application key")]
      public static function init(param1:String = "") : void
      {
         wlog("com.distriqt.extension.inappbilling.InAppBilling.init");
         createInstance();
      }
      
      public static function get isSupported() : Boolean
      {
         createInstance();
         try
         {
            return _safeCallStatic(_extContext, "isSupported");
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get version() : String
      {
         return "14.0.0";
      }
      
      public function get nativeVersion() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "version") as String;
         }
         catch(e:Error)
         {
         }
         return "0";
      }
      
      public function get implementation() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "implementation") as String;
         }
         catch(e:Error)
         {
         }
         return "unknown";
      }
      
      public function dispose() : void
      {
         cleanup();
         if(_applicationReceipt != null)
         {
            _ApplicationReceiptImpl(_applicationReceipt).dispose();
            _applicationReceipt = null;
         }
         if(_downloads != null)
         {
            _DownloadsImpl(_downloads).dispose();
            _downloads = null;
         }
         if(_promotions != null)
         {
            _PromotionsImpl(_promotions).dispose();
            _promotions = null;
         }
         if(_extContext != null)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext.dispose();
            _extContext = null;
         }
         _instance = null;
      }
      
      public function get canMakePayments() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "canMakePayments") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      [Deprecated(message="You should pass the service type to the setup function in your BillingService")]
      public function setServiceType(param1:String) : String
      {
         return "";
      }
      
      public function setup(param1:* = "") : Boolean
      {
         var _loc2_:BillingService = null;
         try
         {
            if(param1 is BillingService)
            {
               _loc2_ = param1;
            }
            else if(param1 is String)
            {
               _loc2_ = new BillingService().setGooglePlayPublicKey(param1);
            }
            return _safeCallStatic(_extContext, "setup",_loc2_) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function isServiceSupported(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isServiceSupported",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function cleanup() : void
      {
         try
         {
            _safeCallStatic(_extContext, "cleanup");
         }
         catch(e:Error)
         {
         }
         _serviceSetup = false;
      }
      
      public function getProducts(param1:Array, param2:Array = null, param3:Boolean = false) : Boolean
      {
         try
         {
            if(_serviceSetup)
            {
               if(param1 == null)
               {
                  param1 = [];
               }
               if(param2 == null)
               {
                  param2 = [];
               }
               if(param1.length == 0 && param2.length == 0)
               {
                  return false;
               }
               return _safeCallStatic(_extContext, "getProducts",param1,param2,param3) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get activeProducts() : Array
      {
         var _loc1_:String = null;
         try
         {
            if(_serviceSetup)
            {
               try
               {
                  _loc1_ = _safeCallStatic(_extContext, "activeProducts") as String;
                  return processProductsResponse(_loc1_);
               }
               catch(e:Error)
               {
               }
            }
         }
         catch(e:Error)
         {
         }
         return [];
      }
      
      public function get activeProductIds() : Array
      {
         try
         {
            if(_serviceSetup)
            {
               try
               {
                  return _safeCallStatic(_extContext, "activeProductIds") as Array;
               }
               catch(e:Error)
               {
               }
            }
         }
         catch(e:Error)
         {
         }
         return [];
      }
      
      public function get isProductViewSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isProductViewSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function showProductView(param1:String) : Boolean
      {
         try
         {
            if(isProductViewSupported)
            {
               return _safeCallStatic(_extContext, "showProductView",param1) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get isProductOverlaySupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isProductOverlaySupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function showProductOverlay(param1:String, param2:String = "bottom") : Boolean
      {
         try
         {
            if(isProductOverlaySupported)
            {
               return _safeCallStatic(_extContext, "showProductOverlay",param1,param2) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function dismissProductOverlay() : void
      {
         try
         {
            _safeCallStatic(_extContext, "dismissProductOverlay");
         }
         catch(e:Error)
         {
         }
      }
      
      public function get applicationReceipt() : ApplicationReceipt
      {
         if(_applicationReceipt == null)
         {
            _applicationReceipt = new _ApplicationReceiptImpl(_extContext);
         }
         return _applicationReceipt;
      }
      
      public function makePurchase(param1:PurchaseRequest) : Boolean
      {
         try
         {
            if(_serviceSetup)
            {
               if(!checkPurchaseRequestValid(param1))
               {
                  return true;
               }
               return _safeCallStatic(_extContext, "makePurchase",param1) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get isChangePurchaseSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isChangePurchaseSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function changePurchase(param1:PurchaseChangeRequest) : Boolean
      {
         try
         {
            if(_serviceSetup)
            {
               return _safeCallStatic(_extContext, "changePurchase",param1) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function finishPurchase(param1:Purchase) : Boolean
      {
         if(_serviceSetup)
         {
            try
            {
               return _safeCallStatic(_extContext, "finishPurchase",param1) as Boolean;
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      public function consumePurchase(param1:Purchase) : Boolean
      {
         try
         {
            if(_serviceSetup)
            {
               return _safeCallStatic(_extContext, "consumePurchase",param1) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function consumePurchaseByProductId(param1:String) : Boolean
      {
         return consumePurchase(new Purchase(param1));
      }
      
      public function shouldAddPurchase(param1:PurchaseRequest, param2:Boolean) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "shouldAddPurchase",param1,param2) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function checkPurchaseRequestValid(param1:PurchaseRequest) : Boolean
      {
         var purchase:Purchase;
         var product:Product;
         var request:PurchaseRequest = param1;
         var purchases:Array = getPendingPurchases();
         for each(purchase in purchases)
         {
            if(purchase.productId == request.productId)
            {
               setTimeout(function():void
               {
                  dispatchPurchaseEvents([purchase]);
               },50);
               return false;
            }
         }
         for each(product in _products)
         {
            if(product.id == request.productId)
            {
               if(product.type == "subs")
               {
                  if(request.subscriptionOfferRequest == null || request.subscriptionOfferRequest.offer == null)
                  {
                     throw new Error("You must set a subscription offer to purchase a subscription");
                  }
               }
            }
         }
         return true;
      }
      
      public function get isGetPurchasesSupported() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "isGetPurchasesSupported") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getPurchases(param1:Boolean = true) : Boolean
      {
         try
         {
            if(_serviceSetup)
            {
               return _safeCallStatic(_extContext, "getPurchases",param1) as Boolean;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function restorePurchases(param1:String = "") : void
      {
         try
         {
            if(_serviceSetup)
            {
               _safeCallStatic(_extContext, "restorePurchases",param1);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function getPendingPurchases() : Array
      {
         try
         {
            if(_serviceSetup)
            {
               return processPurchaseResponse(_safeCallStatic(_extContext, "getPendingPurchases") as String);
            }
         }
         catch(e:Error)
         {
         }
         return [];
      }
      
      public function getUserData() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "getUserData") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get downloads() : Downloads
      {
         if(_downloads == null)
         {
            _downloads = new _DownloadsImpl(_extContext);
         }
         return _downloads;
      }
      
      public function get promotions() : Promotions
      {
         if(_promotions == null)
         {
            _promotions = new _PromotionsImpl(_extContext);
         }
         return _promotions;
      }
      
      public function get inAppUpdates() : InAppUpdates
      {
         if(_inAppUpdates == null)
         {
            _inAppUpdates = new _InAppUpdatesImpl(_extContext);
         }
         return _inAppUpdates;
      }
      
      private function processProductsResponse(param1:String) : Array
      {
         var _loc2_:Object = null;
         var _loc4_:Array = [];
         try
         {
            _loc2_ = JSON.parse(param1);
            for each(var _loc3_:Object in _loc2_.products)
            {
               _loc4_.push(Product.fromObject(_loc3_));
            }
         }
         catch(e:Error)
         {
         }
         return _loc4_;
      }
      
      private function processPurchaseResponse(param1:String) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Array = [];
         try
         {
            _loc2_ = JSON.parse(param1);
            _loc3_ = processPurchaseObjectArray(_loc2_.purchases);
         }
         catch(e:Error)
         {
         }
         return _loc3_;
      }
      
      private function processPurchaseObjectArray(param1:Array) : Array
      {
         var _loc2_:Array = [];
         if(param1 != null)
         {
            for each(var _loc3_:Object in param1)
            {
               try
               {
                  _loc2_.push(Purchase.fromObject(_loc3_));
               }
               catch(e:Error)
               {
               }
            }
         }
         return _loc2_;
      }
      
      private function removePurchasesFromPendingPurchases(param1:Array, param2:Array) : Array
      {
         var _loc5_:Boolean = false;
         var _loc4_:Array = [];
         for each(var _loc3_:Purchase in param2)
         {
            _loc5_ = false;
            for each(var _loc6_:Purchase in param1)
            {
               if(_loc3_.productId == _loc6_.productId)
               {
                  _loc5_ = true;
                  break;
               }
            }
            if(!_loc5_)
            {
               _loc4_.push(_loc3_);
            }
         }
         return _loc4_;
      }
      
      private function dispatchPurchaseEvents(param1:Array, param2:String = "purchases:updated", param3:String = "", param4:String = "") : void
      {
         var _loc7_:String = null;
         var _loc5_:String = null;
         for each(var _loc6_:Purchase in param1)
         {
            _loc7_ = param4 == null || param4 == "" ? _loc6_.error : param4;
            _loc5_ = param3 == null || param3 == "" ? _loc6_.errorCode : param3;
            switch(_loc6_.transactionState)
            {
               case "transaction:purchased":
                  dispatchEvent(new PurchaseEvent("purchase:success",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:deferred":
                  dispatchEvent(new PurchaseEvent("purchase:deferred",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:notallowed":
                  dispatchEvent(new PurchaseEvent("purchase:notallowed",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  dispatchEvent(new PurchaseEvent("purchase:failed",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:failed":
                  dispatchEvent(new PurchaseEvent("purchase:failed",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:cancelled":
                  dispatchEvent(new PurchaseEvent("purchase:cancelled",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:purchasing":
                  dispatchEvent(new PurchaseEvent("purchase:purchasing",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:restored":
                  dispatchEvent(new PurchaseEvent("purchase:restored",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:refunded":
                  dispatchEvent(new PurchaseEvent("purchase:refunded",new <Purchase>[_loc6_],_loc5_,_loc7_));
                  break;
               case "transaction:removed":
                  dispatchEvent(new PurchaseEvent("purchase:removed",new <Purchase>[_loc6_],_loc5_,_loc7_));
            }
         }
         if(param2 != "")
         {
            dispatchEvent(new PurchaseEvent(param2,Vector.<Purchase>(param1),param3,param4));
         }
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc5_:Object = null;
         var _loc3_:Array = null;
         var _loc7_:Purchase = null;
         var _loc6_:Array = null;
         var _loc2_:PurchaseRequest = null;
         var _loc4_:UserData = null;
         try
         {
            switch(param1.code)
            {
               case "extension:error":
                  dispatchEvent(new ErrorEvent("error",false,false,param1.level));
                  break;
               case "inappbilling:setup:success":
                  _serviceSetup = true;
                  dispatchEvent(new InAppBillingEvent("inappbilling:setup:success",null,"",param1.level));
                  break;
               case "inappbilling:setup:failure":
                  _serviceSetup = false;
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppBillingEvent("inappbilling:setup:failure",null,_loc5_.errorCode,_loc5_.error));
                  break;
               case "inappbilling:products:loaded":
                  _products = processProductsResponse(param1.level);
                  dispatchEvent(new InAppBillingEvent("inappbilling:products:loaded",_products));
                  break;
               case "inappbilling:products:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppBillingEvent("inappbilling:products:failed",null,_loc5_.errorCode,_loc5_.error));
                  break;
               case "inappbilling:product:invalid":
                  dispatchEvent(new InAppBillingEvent("inappbilling:product:invalid",null,param1.level,"Invalid product identifier"));
                  break;
               case "purchases:updated":
                  _loc5_ = JSON.parse(param1.level);
                  _loc3_ = processPurchaseObjectArray(_loc5_.purchases);
                  dispatchPurchaseEvents(_loc3_,"purchases:updated",_loc5_.errorCode ? _loc5_.errorCode : "",_loc5_.message ? _loc5_.message : "");
                  break;
               case "purchase:failed":
                  _loc5_ = JSON.parse(param1.level);
                  _loc7_ = Purchase.fromObject(_loc5_.purchase);
                  dispatchEvent(new PurchaseEvent("purchase:failed",_loc7_ != null ? new <Purchase>[_loc7_] : null,_loc5_.errorCode ? _loc5_.errorCode : "",_loc5_.message ? _loc5_.message : ""));
                  break;
               case "get:purchases:complete":
                  _loc5_ = JSON.parse(param1.level);
                  _loc6_ = processPurchaseObjectArray(_loc5_.purchases);
                  dispatchEvent(new PurchaseEvent("get:purchases:complete",Vector.<Purchase>(_loc6_),_loc5_.errorCode ? _loc5_.errorCode : "",_loc5_.message ? _loc5_.message : ""));
                  break;
               case "get:purchases:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new PurchaseEvent("get:purchases:failed",null,_loc5_.errorCode ? _loc5_.errorCode : "",_loc5_.message ? _loc5_.message : ""));
                  break;
               case "inappbilling:restore:purchases:success":
                  dispatchEvent(new InAppBillingEvent("inappbilling:restore:purchases:success"));
                  break;
               case "inappbilling:restore:purchases:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppBillingEvent("inappbilling:restore:purchases:failed",null,_loc5_.errorCode,_loc5_.error));
                  break;
               case "inappbilling:finish:success":
               case "inappbilling:consume:success":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppBillingEvent(param1.code,[Purchase.fromObject(_loc5_.purchase)],_loc5_.errorCode,_loc5_.message));
                  break;
               case "inappbilling:finish:failed":
               case "inappbilling:consume:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new InAppBillingEvent(param1.code,null,_loc5_.errorCode,_loc5_.message));
                  break;
               case "productview:dismissed":
               case "productview:displayed":
               case "productview:loaded":
                  dispatchEvent(new ProductViewEvent(param1.code));
                  break;
               case "productview:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new ProductViewEvent(param1.code,_loc5_.error,_loc5_.errorCode));
                  break;
               case "productoverlay:dismissed":
               case "productoverlay:displayed":
               case "productoverlay:loaded":
                  dispatchEvent(new ProductOverlayEvent(param1.code));
                  break;
               case "productoverlay:failed":
                  _loc5_ = JSON.parse(param1.level);
                  dispatchEvent(new ProductOverlayEvent(param1.code,_loc5_.error,_loc5_.errorCode));
                  break;
               case "should:add:purchase":
                  _loc5_ = JSON.parse(param1.level);
                  _loc2_ = PurchaseRequest.fromObject(_loc5_);
                  dispatchEvent(new PurchaseRequestEvent(param1.code,_loc2_));
                  break;
               case "userdata:get:success":
                  _loc5_ = JSON.parse(param1.level);
                  _loc4_ = UserData.fromObject(_loc5_.userData);
                  dispatchEvent(new UserDataEvent(param1.code,_loc4_));
                  break;
               case "userdata:get:failed":
                  dispatchEvent(new UserDataEvent(param1.code,null));
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent("error",false,false,e.message));
         }
      }
   }
}

