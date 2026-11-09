package com.digitalstrawberry.ane.share.events
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.events.Event;
   
   public class ShareEvent extends Event
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
      
      public static const COMPLETE:String = "ShareEvent::complete";
      
      public static const CANCEL:String = "ShareEvent::cancel";
      
      public static const ERROR:String = "ShareEvent::error";
      
      private var mSharedActivity:String;
      
      private var mErrorMessage:String;
      
      public function ShareEvent(type:String, sharedActivity:String = null, errorMessage:String = null)
      {
         wlog("com.digitalstrawberry.ane.share.events.ShareEvent.ShareEvent");
         super(type,false,false);
         mSharedActivity = sharedActivity;
         mErrorMessage = errorMessage;
      }
      
      public function get sharedActivity() : String
      {
         return mSharedActivity;
      }
      
      public function get errorMessage() : String
      {
         return mErrorMessage;
      }
   }
}

