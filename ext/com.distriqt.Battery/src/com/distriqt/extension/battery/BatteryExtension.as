package com.distriqt.extension.battery
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class BatteryExtension
   {

      private static var _wlogInit:Boolean = false;
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
      public function BatteryExtension()
      {
         wlog("com.distriqt.extension.battery.BatteryExtension.BatteryExtension");
         super();
      }
   }
}
