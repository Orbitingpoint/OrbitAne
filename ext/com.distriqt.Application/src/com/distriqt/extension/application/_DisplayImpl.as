package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.application.display.Display;
   import com.distriqt.extension.application.display.DisplayCutout;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   internal class _DisplayImpl extends EventDispatcher implements Display
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
      
      private static const TAG:String = "_DisplayImpl";
      
      private var _extContext:ExtensionContext;
      
      private var _stage:Stage = null;
      
      private var _displayMetrics:_DisplayMetricsImpl = null;
      
      public function _DisplayImpl(param1:ExtensionContext, param2:Stage = null)
      {
         wlog("com.distriqt.extension.application._DisplayImpl._DisplayImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extension_statusHandler);
         setStage(param2);
      }
      
      public function dispose() : void
      {
         if(_displayMetrics != null)
         {
            _displayMetrics.dispose();
            _displayMetrics = null;
         }
         if(_extContext)
         {
            _extContext.removeEventListener("status",extension_statusHandler);
            _extContext = null;
         }
      }
      
      public function setStage(param1:Stage) : void
      {
         _stage = param1;
      }
      
      public function setDisplayMode(param1:String, param2:String = "cutout_never") : Boolean
      {
         try
         {
            if(_stage != null)
            {
               _stage.displayState = "normal";
            }
            return _safeCallStatic(_extContext, "display_setDisplayMode",param1,param2) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setLayoutMode(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "display_setLayoutMode",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get willCutoutAffectView() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "display_willCutoutAffectView") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getDisplayCutout() : DisplayCutout
      {
         var _loc2_:String = null;
         var _loc1_:Object = null;
         try
         {
            _loc2_ = _safeCallStatic(_extContext, "display_getDisplayCutout") as String;
            _loc1_ = JSON.parse(_loc2_);
            return DisplayCutout.fromObject(_loc1_);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function setSystemUiVisibility(param1:int) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "display_setSystemUiVisibility",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function getSystemUiVisibility() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "display_getSystemUiVisibility") as int;
         }
         catch(e:Error)
         {
         }
         return 0;
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
      
      public function setNavigationBarColour(param1:uint) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setNavigationBarColour",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setNavigationBarStyle(param1:int) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setNavigationBarStyle",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setStatusBarStyle(param1:uint, param2:Boolean = false) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setStatusBarStyle",param1,param2);
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setStatusBarHidden(param1:Boolean = true, param2:String = "none") : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setStatusBarHidden",param1,param2) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setStatusBarColour(param1:uint, param2:Number = 1) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "setStatusBarColour",param1,param2) as Boolean;
         }
         catch(e:Error)
         {
            trace(e);
         }
         return false;
      }
      
      public function getStatusBarHeight() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "getStatusBarHeight") as int;
         }
         catch(e:Error)
         {
            trace(e);
         }
         return 0;
      }
      
      public function get userInterfaceStyle() : String
      {
         try
         {
            return _safeCallStatic(_extContext, "display_userInterfaceStyle") as String;
         }
         catch(e:Error)
         {
         }
         return "unspecified";
      }
      
      private function extension_statusHandler(param1:StatusEvent) : void
      {
      }
   }
}

