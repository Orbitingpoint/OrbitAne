package com.digitalstrawberry.ane.share
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.display.BitmapData;
   
   public class SharedData
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
      
      private var mData:* = null;
      
      private var mShareWithFacebook:Boolean = true;
      
      private var mIsLocalFileUrl:Boolean = false;
      
      public function SharedData(data:*)
      {
         wlog("com.digitalstrawberry.ane.share.SharedData.SharedData");
         super();
         if(!(data is String || data is BitmapData))
         {
            throw new ArgumentError("Parameter data must be either a String or BitmapData.");
         }
         mData = data;
      }
      
      public function get data() : *
      {
         return mData;
      }
      
      public function get shareWithFacebook() : Boolean
      {
         return mShareWithFacebook;
      }
      
      public function set shareWithFacebook(value:Boolean) : void
      {
         mShareWithFacebook = value;
      }
      
      public function get isLocalFileUrl() : Boolean
      {
         return mIsLocalFileUrl;
      }
      
      public function set isLocalFileUrl(value:Boolean) : void
      {
         mIsLocalFileUrl = value;
      }
   }
}

