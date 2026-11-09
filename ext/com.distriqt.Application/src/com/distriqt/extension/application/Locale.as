package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class Locale
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
      
      private static const TAG:String = "Locale";
      
      public var country:String = "";
      
      public var language:String = "";
      
      public function Locale()
      {
         wlog("com.distriqt.extension.application.Locale.Locale");
         super();
      }
      
      internal static function fromObject(param1:Object) : Locale
      {
         var _loc2_:Locale = null;
         if(param1 != null)
         {
            _loc2_ = new Locale();
            if(param1.hasOwnProperty("country"))
            {
               _loc2_.country = param1.country;
            }
            if(param1.hasOwnProperty("language"))
            {
               _loc2_.language = param1.language;
            }
            return _loc2_;
         }
         return null;
      }
   }
}

