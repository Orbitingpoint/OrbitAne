package com.distriqt.extension.battery
{
   import com.distriqt.extension.battery.events.BatteryEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class Battery extends EventDispatcher
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
      
      public static const EXT_CONTEXT_ID:String = "com.distriqt.Battery";
      
      private static const EXT_ID_NUMBER:int = 7;
      
      public static const VERSION:String = "3.0.003";
      
      private static const VERSION_DEFAULT:String = "0";
      
      private static const IMPLEMENTATION_DEFAULT:String = "unknown";
      
      private static const ERROR_CREATION:String = "The native extension context could not be created";
      
      private static const ERROR_SINGLETON:String = "The singleton has already been created. Use Battery.instance to access the functionality";
      
      private static var _instance:Battery;
      
      private static var _shouldCreateInstance:Boolean = false;
      
      private static var _extContext:ExtensionContext = null;
      
      private var _extensionId:String = "";
      
      private var _extensionIdNumber:int = -1;
      
      public function Battery()
      {
         wlog("com.distriqt.extension.battery.Battery.Battery");
         super();
         if(_shouldCreateInstance)
         {
            try
            {
               _extensionId = "com.distriqt.Battery";
               _extensionIdNumber = 7;
               _extContext = ExtensionContext.createExtensionContext("com.distriqt.Battery",null);
               _extContext.addEventListener("status",extension_statusHandler,false,0,true);
            }
            catch(e:Error)
            {
               /* stub: no native context on Windows */
            }
            return;
         }
         throw new Error("The singleton has already been created. Use Battery.instance to access the functionality");
      }
      
      public static function get service() : Battery
      {
         createInstance();
         return _instance;
      }
      
      private static function createInstance() : void
      {
         if(_instance == null)
         {
            _shouldCreateInstance = true;
            _instance = new Battery();
            _shouldCreateInstance = false;
         }
      }
      
      [Deprecated(message="You no longer need to use an application key")]
      public static function init(param1:String = "") : void
      {
         wlog("com.distriqt.extension.battery.Battery.init");
         createInstance();
      }
      
      public static function get isSupported() : Boolean
      {
         createInstance();
         return _safeCallStatic(_extContext, "isSupported");
      }
      
      public function get version() : String
      {
         return "3.0.003";
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
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext.dispose();
            _extContext = null;
         }
         _instance = null;
      }
      
      public function getBatteryInfo() : void
      {
         try
         {
            _safeCallStatic(_extContext, "getBatteryInfo");
         }
         catch(e:Error)
         {
         }
      }
      
      public function cancel() : void
      {
         try
         {
            _safeCallStatic(_extContext, "cancel");
         }
         catch(e:Error)
         {
         }
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Array = param1.level.split("|");
         var _loc3_:String = param1.code;
         if("battery:info" === _loc3_)
         {
            dispatchEvent(new BatteryEvent("battery:info",Number(_loc2_[0]),int(_loc2_[1])));
         }
      }
   }
}

