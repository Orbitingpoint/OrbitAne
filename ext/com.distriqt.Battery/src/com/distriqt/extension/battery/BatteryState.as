package com.distriqt.extension.battery
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class BatteryState
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
      
      public static const NOT_SUPPORTED:int = -1;
      
      public static const UNKNOWN:int = 0;
      
      public static const NOT_CHARGING:int = 1;
      
      public static const CHARGING:int = 2;
      
      public static const FULL:int = 3;
      
      public function BatteryState()
      {
         wlog("com.distriqt.extension.battery.BatteryState.BatteryState");
         super();
      }
   }
}

