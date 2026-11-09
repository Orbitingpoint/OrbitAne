package com.distriqt.extension.application.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class DefaultsEvent extends Event
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
      
      public static const CHANGED:String = "defaults:changed";
      
      public var key:String;
      
      public function DefaultsEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.application.events.DefaultsEvent.DefaultsEvent");
         super(param1,param3,param4);
         this.key = param2;
      }
      
      override public function clone() : Event
      {
         return new DefaultsEvent(type,key,bubbles,cancelable);
      }
   }
}

