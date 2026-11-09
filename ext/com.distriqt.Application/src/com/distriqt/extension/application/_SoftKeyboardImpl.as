package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.application.keyboard.SoftKeyboard;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.events.SoftKeyboardEvent;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.geom.Rectangle;
   
   internal final class _SoftKeyboardImpl extends EventDispatcher implements SoftKeyboard
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
      
      private var _extContext:ExtensionContext = null;
      
      private var _stage:Stage = null;
      
      public function _SoftKeyboardImpl(param1:ExtensionContext, param2:Stage = null)
      {
         wlog("com.distriqt.extension.application._SoftKeyboardImpl._SoftKeyboardImpl");
         super();
         _extContext = param1;
         _extContext.addEventListener("status",extContext_statusHandler);
         setStage(param2);
      }
      
      public function dispose() : void
      {
         if(_extContext != null)
         {
            _extContext.removeEventListener("status",extContext_statusHandler);
            _extContext = null;
         }
      }
      
      public function setStage(param1:Stage) : void
      {
         _stage = param1;
      }
      
      public function init() : void
      {
         try
         {
            _safeCallStatic(_extContext, "softKeyboard_init");
         }
         catch(e:Error)
         {
         }
      }
      
      public function get x() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "softKeyboard_getX") as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get y() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "softKeyboard_getY") as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get height() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "softKeyboard_getHeight") as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get width() : int
      {
         try
         {
            return _safeCallStatic(_extContext, "softKeyboard_getWidth") as int;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get softKeyboardRect() : Rectangle
      {
         return new Rectangle(x,y,width,height);
      }
      
      public function setAdjustMode(param1:String) : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "softKeyboard_setAdjustMode",param1) as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function show() : void
      {
         try
         {
            _safeCallStatic(_extContext, "softKeyboard_show");
         }
         catch(e:Error)
         {
         }
      }
      
      private function extContext_statusHandler(param1:StatusEvent) : void
      {
         switch(param1.code)
         {
            case "softKeyboardActivate":
            case "softKeyboardActivating":
            case "softKeyboardDeactivate":
               dispatchEvent(new SoftKeyboardEvent(param1.code,false,false,null,""));
         }
      }
   }
}

