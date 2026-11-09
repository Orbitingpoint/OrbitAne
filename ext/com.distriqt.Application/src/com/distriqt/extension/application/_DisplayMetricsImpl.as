package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.EventDispatcher;
   import flash.external.ExtensionContext;
   
   internal class _DisplayMetricsImpl extends EventDispatcher implements DisplayMetrics
   {

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
      
      private var _density:Number = 0;
      
      private var _densityDpi:int = 0;
      
      private var _screenHeight:int = 0;
      
      private var _screenWidth:int = 0;
      
      private var _xdpi:Number = 0;
      
      private var _ydpi:Number = 0;
      
      private var _nativeScale:Number = 1;
      
      public function _DisplayMetricsImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._DisplayMetricsImpl._DisplayMetricsImpl");
         var _loc2_:Object = null;
         super();
         try
         {
            _loc2_ = param1.call("displayMetrics") as Object;
            update(_loc2_);
         }
         catch(e:Error)
         {
         }
      }
      
      public function get density() : Number
      {
         return _density;
      }
      
      public function set density(param1:Number) : void
      {
         _density = param1;
      }
      
      public function get densityDpi() : int
      {
         return _densityDpi;
      }
      
      public function set densityDpi(param1:int) : void
      {
         _densityDpi = param1;
      }
      
      public function get screenHeight() : int
      {
         return _screenHeight;
      }
      
      public function set screenHeight(param1:int) : void
      {
         _screenHeight = param1;
      }
      
      public function get screenWidth() : int
      {
         return _screenWidth;
      }
      
      public function set screenWidth(param1:int) : void
      {
         _screenWidth = param1;
      }
      
      public function get xdpi() : Number
      {
         return _xdpi;
      }
      
      public function set xdpi(param1:Number) : void
      {
         _xdpi = param1;
      }
      
      public function get ydpi() : Number
      {
         return _ydpi;
      }
      
      public function set ydpi(param1:Number) : void
      {
         _ydpi = param1;
      }
      
      public function get nativeScale() : Number
      {
         return _nativeScale;
      }
      
      public function set nativeScale(param1:Number) : void
      {
         _nativeScale = param1;
      }
      
      public function dispose() : void
      {
      }
      
      internal function update(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         for(var _loc2_:String in param1)
         {
            switch(_loc2_)
            {
               case "density":
                  density = param1[_loc2_];
                  break;
               case "densityDpi":
                  densityDpi = param1[_loc2_];
                  break;
               case "screenHeight":
                  screenHeight = param1[_loc2_];
                  break;
               case "screenWidth":
                  screenWidth = param1[_loc2_];
                  break;
               case "xdpi":
                  xdpi = param1[_loc2_];
                  break;
               case "ydpi":
                  ydpi = param1[_loc2_];
                  break;
               case "nativeScale":
                  nativeScale = param1[_loc2_];
            }
         }
      }
      
      override public function toString() : String
      {
         return "[" + screenWidth + "x" + screenHeight + "]";
      }
   }
}

