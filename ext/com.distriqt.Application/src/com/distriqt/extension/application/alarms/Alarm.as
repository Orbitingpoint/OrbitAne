package com.distriqt.extension.application.alarms
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class Alarm
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
      
      public var id:int = 0;
      
      public var interval:Number = 0;
      
      public var timestamp:Number = 0;
      
      public var data:String = "";
      
      public var isExact:Boolean = false;
      
      public var willLaunchApplication:Boolean = false;
      
      public var allowWhileIdle:Boolean = false;
      
      public function Alarm()
      {
         wlog("com.distriqt.extension.application.alarms.Alarm.Alarm");
         super();
      }
   }
}

