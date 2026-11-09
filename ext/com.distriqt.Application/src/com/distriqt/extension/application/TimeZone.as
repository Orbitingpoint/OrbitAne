package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   public class TimeZone
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
      
      private static const TAG:String = "TimeZone";
      
      public var id:String;
      
      public var abbreviation:String;
      
      public var description:String;
      
      public var utcOffset:Number;
      
      public function TimeZone()
      {
         wlog("com.distriqt.extension.application.TimeZone.TimeZone");
         super();
      }
      
      internal static function fromObject(param1:Object) : com.distriqt.extension.application.TimeZone
      {
         var _loc2_:com.distriqt.extension.application.TimeZone = null;
         if(param1 != null)
         {
            _loc2_ = new com.distriqt.extension.application.TimeZone();
            if(param1.hasOwnProperty("id"))
            {
               _loc2_.id = param1.id;
            }
            if(param1.hasOwnProperty("abbreviation"))
            {
               _loc2_.abbreviation = param1.abbreviation;
            }
            if(param1.hasOwnProperty("description"))
            {
               _loc2_.description = param1.description;
            }
            if(param1.hasOwnProperty("utcOffset"))
            {
               _loc2_.utcOffset = param1.utcOffset;
            }
            return _loc2_;
         }
         return null;
      }
   }
}
