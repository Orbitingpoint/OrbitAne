package com.distriqt.extension.application.display
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class DisplayMode
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
      
      public static const NORMAL:String = "normal";
      
      public static const FULLSCREEN:String = "fullscreen";
      
      public static const IMMERSIVE:String = "immersive";
      
      public function DisplayMode()
      {
         wlog("com.distriqt.extension.application.display.DisplayMode.DisplayMode");
         super();
      }
   }
}

