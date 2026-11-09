package com.distriqt.extension.application.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class AuthorisationEvent extends Event
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
      
      public static const CHANGED:String = "authorisation:changed";
      
      public var status:String = "unknown";
      
      public function AuthorisationEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.application.events.AuthorisationEvent.AuthorisationEvent");
         super(param1,param3,param4);
         this.status = param2;
      }
      
      override public function clone() : Event
      {
         return new AuthorisationEvent(type,status,bubbles,cancelable);
      }
   }
}

