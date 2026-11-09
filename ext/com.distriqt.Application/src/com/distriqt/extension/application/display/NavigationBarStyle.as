package com.distriqt.extension.application.display
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class NavigationBarStyle
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
      
      public static const DEFAULT:int = 0;
      
      public static const LIGHT:int = 1;
      
      public static const DARK:int = 2;
      
      public function NavigationBarStyle()
      {
         wlog("com.distriqt.extension.application.display.NavigationBarStyle.NavigationBarStyle");
         super();
      }
   }
}

