package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class StatusBarStyle
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
      
      public static const DEFAULT:uint = 0;
      
      public static const LIGHT:uint = 3;
      
      public static const DARK:uint = 4;
      
      public function StatusBarStyle()
      {
         wlog("com.distriqt.extension.application.StatusBarStyle.StatusBarStyle");
         super();
      }
   }
}

