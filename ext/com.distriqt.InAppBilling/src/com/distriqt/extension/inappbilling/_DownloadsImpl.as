package com.distriqt.extension.inappbilling
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.purchases.Downloads;
   import flash.events.EventDispatcher;
   import flash.external.ExtensionContext;
   
   internal final class _DownloadsImpl extends EventDispatcher implements Downloads
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
      
      private var _extContext:ExtensionContext;
      
      public function _DownloadsImpl(param1:ExtensionContext)
      {
         wlog("com.distriqt.extension.inappbilling._DownloadsImpl._DownloadsImpl");
         super();
         _extContext = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get isSupported() : Boolean
      {
         return false;
      }
      
      public function startDownloads(param1:Purchase) : Boolean
      {
         return false;
      }
      
      public function pauseDownloads() : Boolean
      {
         return false;
      }
   }
}

