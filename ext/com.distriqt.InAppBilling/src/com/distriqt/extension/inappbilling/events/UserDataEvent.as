package com.distriqt.extension.inappbilling.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import com.distriqt.extension.inappbilling.user.UserData;
   import flash.events.Event;
   
   public class UserDataEvent extends Event
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
      
      private static const TAG:String = "UserDataEvent";
      
      public static const GET_SUCCESS:String = "userdata:get:success";
      
      public static const GET_FAILED:String = "userdata:get:failed";
      
      public var userData:UserData;
      
      public function UserDataEvent(param1:String, param2:UserData, param3:Boolean = false, param4:Boolean = false)
      {
         wlog("com.distriqt.extension.inappbilling.events.UserDataEvent.UserDataEvent");
         super(param1,param3,param4);
         this.userData = param2;
      }
      
      override public function clone() : Event
      {
         return new UserDataEvent(type,userData,bubbles,cancelable);
      }
   }
}

