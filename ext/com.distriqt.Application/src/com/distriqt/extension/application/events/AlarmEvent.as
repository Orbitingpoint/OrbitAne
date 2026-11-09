package com.distriqt.extension.application.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class AlarmEvent extends Event
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
      
      public static const ALARM:String = "alarm";
      
      public var id:int = 0;
      
      public var data:String = "";
      
      public function AlarmEvent(param1:String, param2:int, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.application.events.AlarmEvent.AlarmEvent");
         super(param1,param4,param5);
         this.id = param2;
         this.data = param3;
      }
      
      override public function clone() : Event
      {
         return new AlarmEvent(type,id,data,bubbles,cancelable);
      }
   }
}

