package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class DeviceOrientation
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
      
      public static const UNKNOWN:String = "unknown";
      
      public static const DEFAULT:String = "default";
      
      public static const ROTATED_LEFT:String = "rotatedLeft";
      
      public static const ROTATED_RIGHT:String = "rotatedRight";
      
      public static const UPSIDE_DOWN:String = "upsideDown";
      
      public function DeviceOrientation()
      {
         wlog("com.distriqt.extension.application.DeviceOrientation.DeviceOrientation");
         super();
      }
   }
}

