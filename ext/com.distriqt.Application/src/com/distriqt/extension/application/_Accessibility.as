package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.EventDispatcher;
   import flash.external.ExtensionContext;
   
   internal final class _Accessibility extends EventDispatcher implements Accessibility
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
      
      public function _Accessibility(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.application._Accessibility._Accessibility");
         super();
         _extContext = param1;
      }
      
      public function get voiceOverEnabled() : Boolean
      {
         try
         {
            return _safeCallStatic(_extContext, "accessibility_voiceOverEnabled") as Boolean;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

