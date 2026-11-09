package com.distriqt.extension.application.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class DeviceOrientationEvent extends Event
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
      
      public static const CHANGED:String = "orientation:changed";
      
      public var orientation:String = "unknown";
      
      public function DeviceOrientationEvent(param1:String, param2:String = "unknown", param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.application.events.DeviceOrientationEvent.DeviceOrientationEvent");
         super(param1,param3,param4);
         this.orientation = param2;
      }
      
      override public function clone() : Event
      {
         return new DeviceOrientationEvent(type,orientation,bubbles,cancelable);
      }
   }
}

