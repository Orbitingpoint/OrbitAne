package com.distriqt.extension.application
{
   import flash.filesystem.FileStream;
   import flash.filesystem.FileMode;
   import com.distriqt.extension.application.events.DeviceOrientationEvent;
   import com.distriqt.extension.application.events.DeviceStateEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   
   internal class _DeviceImpl extends EventDispatcher implements Device
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
      
      private var _extContext:ExtensionContext;
      
      private var _name:String;
      
      private var _brand:String;
      
      private var _manufacturer:String;
      
      private var _device:String;
      
      private var _model:String;
      
      private var _product:String;
      
      private var _yearClass:int = -2147483648;
      
      private var _phone:String;
      
      private var _displayMetrics:_DisplayMetricsImpl = null;
      
      public function _DeviceImpl(param1:ExtensionContext = null)
      {
         wlog("com.distriqt.extension.application._DeviceImpl._DeviceImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extension_statusHandler);
      }
      
      public function dispose() : void
      {
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext = null;
         }
      }
      
      public function uniqueId(param1:String = "vendor", param2:Boolean = false) : String
      {
         try
         {
            return _safeCallStatic(_extContext, "device_uniqueId",param1,param2) as String;
         }
         catch(e:Error)
         {
         }
         return "";
      }
      
      public function get name() : String
      {
         if(_name == null)
         {
            update();
         }
         return _name;
      }
      
      public function get brand() : String
      {
         if(_brand == null)
         {
            update();
         }
         return _brand;
      }
      
      public function get manufacturer() : String
      {
         if(_manufacturer == null)
         {
            update();
         }
         return _manufacturer;
      }
      
      public function get device() : String
      {
         if(_device == null)
         {
            update();
         }
         return _device;
      }
      
      public function get model() : String
      {
         if(_model == null)
         {
            update();
         }
         return _model;
      }
      
      public function get product() : String
      {
         if(_product == null)
         {
            update();
         }
         return _product;
      }
      
      public function get yearClass() : int
      {
         if(_yearClass == -2147483648)
         {
            update();
         }
         return _yearClass;
      }
      
      public function get phone() : String
      {
         if(_phone == null)
         {
            update();
         }
         return _phone;
      }
      
      public function get os() : OperatingSystem
      {
         try
         {
            return new OperatingSystem(_safeCallStatic(_extContext, "device_os"));
         }
         catch(e:Error)
         {
         }
         return new OperatingSystem();
      }
      
      public function getFilesDir() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "device_getFilesDir") as String;
         }
         catch(e:Error)
         {
         }
         return File.applicationStorageDirectory.nativePath;
      }
      
      public function getExternalFilesDir() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "device_getExternalFilesDir") as String;
         }
         catch(e:Error)
         {
         }
         return File.applicationStorageDirectory.nativePath;
      }
      
      public function get displayMetrics() : DisplayMetrics
      {
         try
         {
            _displayMetrics = new _DisplayMetricsImpl(_extContext);
         }
         catch(e:Error)
         {
         }
         return _displayMetrics;
      }
      
      public function isDeviceIdleMode() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "device_isDeviceIdleMode") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function isPowerSaveMode() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "device_isPowerSaveMode") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function isAutoTimeEnabled() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "device_isAutoTimeEnabled") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function isAutoTimeZoneEnabled() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "device_isAutoTimeZoneEnabled") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get deviceOrientation() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "deviceOrientation") as String;
         }
         catch(e:Error)
         {
         }
         return "unknown";
      }
      
      public function startGeneratingDeviceOrientationEvents() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "startGeneratingDeviceOrientationEvents") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function stopGeneratingDeviceOrientationEvents() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "stopGeneratingDeviceOrientationEvents") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get locale() : Locale
      {
         try
         {
            return Locale.fromObject(_safeCallStatic(_extContext, "locale"));
         }
         catch(e:Error)
         {
         }
         return new Locale();
      }
      
      public function get localTimeZone() : com.distriqt.extension.application.TimeZone
      {
         try
         {
            return com.distriqt.extension.application.TimeZone.fromObject(_safeCallStatic(_extContext, "device_localTimeZone"));
         }
         catch(e:Error)
         {
         }
         return new com.distriqt.extension.application.TimeZone();
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         switch(param1)
         {
            case "application:device:powersavemode:changed":
            case "application:device:idlemode:changed":
               try
               {
                  _safeCallStatic(_extContext, "device_addEventListener",param1);
               }
               catch(e:Error)
               {
               }
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         switch(param1)
         {
            case "application:device:idlemode:changed":
            case "application:device:powersavemode:changed":
               try
               {
                  _safeCallStatic(_extContext, "device_removeEventListener",param1);
               }
               catch(e:Error)
               {
               }
         }
      }
      
      private function update(param1:Object = null) : void
      {
         if(param1 == null)
         {
            try
            {
               param1 = _safeCallStatic(_extContext, "device_properties");
            }
            catch(e:Error)
            {
               trace(e);
            }
         }
         if(param1 != null)
         {
            if(param1.hasOwnProperty("name"))
            {
               this._name = param1.name;
            }
            if(param1.hasOwnProperty("brand"))
            {
               this._brand = param1.brand;
            }
            if(param1.hasOwnProperty("manufacturer"))
            {
               this._manufacturer = param1.manufacturer;
            }
            if(param1.hasOwnProperty("device"))
            {
               this._device = param1.device;
            }
            if(param1.hasOwnProperty("model"))
            {
               this._model = param1.model;
            }
            if(param1.hasOwnProperty("product"))
            {
               this._product = param1.product;
            }
            if(param1.hasOwnProperty("yearClass"))
            {
               this._yearClass = param1.yearClass;
            }
            if(param1.hasOwnProperty("phone"))
            {
               this._phone = param1.phone;
            }
         }
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.code)
         {
            case "orientation:changed":
               _loc2_ = JSON.parse(param1.level);
               dispatchEvent(new DeviceOrientationEvent("orientation:changed",_loc2_.orientation));
               break;
            case "application:device:powersavemode:changed":
            case "application:device:idlemode:changed":
               dispatchEvent(new DeviceStateEvent(param1.code));
         }
      }
   }
}
