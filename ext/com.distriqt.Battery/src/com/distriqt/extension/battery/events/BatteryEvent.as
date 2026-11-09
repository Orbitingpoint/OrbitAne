package com.distriqt.extension.battery.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class BatteryEvent extends Event
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
      
      public static const BATTERY_INFO:String = "battery:info";
      
      public var batteryLevel:Number = 0;
      
      public var batteryState:int = 0;
      
      public function BatteryEvent(param1:String, param2:Number, param3:int, param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.battery.events.BatteryEvent.BatteryEvent");
         super(param1,param4,param5);
         this.batteryLevel = param2;
         this.batteryState = param3;
      }
      
      override public function clone() : Event
      {
         return new BatteryEvent(type,batteryLevel,batteryState,bubbles,cancelable);
      }
   }
}

