package com.digitalstrawberry.ane.share
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.Rectangle;
   
   public class ShareOptions
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
      
      public static const ARROW_NONE:int = 0;
      
      public static const ARROW_UP:int = 1;
      
      public static const ARROW_DOWN:int = 2;
      
      public static const ARROW_LEFT:int = 4;
      
      public static const ARROW_RIGHT:int = 8;
      
      public static const ARROW_ANY:int = 15;
      
      private var mPosition:Rectangle;
      
      private var mArrowDirection:int = 15;
      
      private var mMimeType:String = null;
      
      public function ShareOptions()
      {
         wlog("com.digitalstrawberry.ane.share.ShareOptions.ShareOptions");
         super();
         mPosition = new Rectangle();
      }
      
      internal static function get defaults() : ShareOptions
      {
         return new ShareOptions();
      }
      
      public function get position() : Rectangle
      {
         return mPosition;
      }
      
      public function set position(value:Rectangle) : void
      {
         mPosition = value;
      }
      
      public function get arrowDirection() : int
      {
         return mArrowDirection;
      }
      
      public function set arrowDirection(value:int) : void
      {
         mArrowDirection = value;
      }
      
      public function get mimeType() : String
      {
         return mMimeType;
      }
      
      public function set mimeType(value:String) : void
      {
         mMimeType = value;
      }
   }
}

