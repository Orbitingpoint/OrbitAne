package com.distriqt.extension.application.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class ApplicationStateEvent extends Event
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
      
      public static const DEACTIVATE:String = "applicationstate:deactivate";
      
      public static const ACTIVATE:String = "applicationstate:activate";
      
      public static const BACKGROUND:String = "applicationstate:background";
      
      public static const FOREGROUND:String = "applicationstate:foreground";
      
      public static const CODE_HOME:String = "deactivate:home";
      
      public static const CODE_LOCK:String = "deactivate:lock";
      
      public var code:String;
      
      public var description:String;
      
      public function ApplicationStateEvent(param1:String, param2:String, param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         wlog("com.distriqt.extension.application.events.ApplicationStateEvent.ApplicationStateEvent");
         super(param1,param4,param5);
         this.code = param2;
         this.description = param3;
      }
      
      override public function clone() : Event
      {
         return new ApplicationStateEvent(type,code,description,bubbles,cancelable);
      }
   }
}

