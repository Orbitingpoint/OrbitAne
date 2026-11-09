package com.distriqt.extension.inappbilling.user
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class UserData
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
      
      private static const TAG:String = "UserData";
      
      public var userId:String;
      
      public function UserData()
      {
         wlog("com.distriqt.extension.inappbilling.user.UserData.UserData");
         super();
      }
      
      public static function fromObject(param1:Object) : UserData
      {
         var _loc2_:UserData = null;
         if(param1 != null)
         {
            _loc2_ = new UserData();
            if(param1.hasOwnProperty("userId"))
            {
               _loc2_.userId = param1.userId;
            }
            return _loc2_;
         }
         return null;
      }
   }
}

