package com.distriqt.extension.application
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getQualifiedClassName;
   
   internal class ObjectUtils
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
      
      public function ObjectUtils()
      {
         wlog("com.distriqt.extension.application.ObjectUtils.ObjectUtils");
         super();
      }
      
      internal static function valueWithProperties(param1:Object) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:String;
         switch(_loc6_ = getQualifiedClassName(param1))
         {
            case "Number":
            case "int":
            case "uint":
               _loc6_ = "Number";
               break;
            case "Boolean":
            case "String":
               break;
            case "Array":
               for each(var _loc2_ in param1)
               {
                  _loc5_.push(ObjectUtils.valueWithProperties(_loc2_));
               }
               break;
            case "Object":
               for(var _loc7_:String in param1)
               {
                  _loc4_.push(_loc7_);
                  _loc5_.push(ObjectUtils.valueWithProperties(param1[_loc7_]));
               }
               break;
            default:
               throw new Error("unknown type");
         }
         return {
            "value":param1,
            "type":_loc6_,
            "keys":_loc4_,
            "values":_loc5_
         };
      }
   }
}

