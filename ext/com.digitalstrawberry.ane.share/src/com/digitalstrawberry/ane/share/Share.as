package com.digitalstrawberry.ane.share
{
   import com.digitalstrawberry.ane.share.events.ShareEvent;
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Capabilities;
   
   public class Share extends EventDispatcher
   {

      private static var _wlogInit:Boolean = false;
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
      
      private static const TAG:String = "[Share]";
      
      private static const EXTENSION_ID:String = "com.digitalstrawberry.ane.share";
      
      private static var mInstance:Share;
      
      private static var mCanInitialize:Boolean;
      
      private static var mContext:ExtensionContext;
      
      private static const iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") > -1;
      
      private static const ANDROID:Boolean = Capabilities.manufacturer.indexOf("Android") > -1;
      
      private var mLastSharedData:Vector.<SharedData>;
      
      public function Share()
      {
         wlog("com.digitalstrawberry.ane.share.Share.Share");
         super();
         if(!mCanInitialize)
         {
            throw new Error("Share is a singleton.");
         }
         mInstance = this;
      }
      
      public static function get instance() : Share
      {
         if(mInstance == null)
         {
            mCanInitialize = true;
            mInstance = new Share();
            mCanInitialize = false;
         }
         return mInstance;
      }
      
      public static function get version() : String
      {
         return "1.1.0";
      }
      
      public static function get isSupported() : Boolean
      {
         var result:Boolean = false;
         if(!isSupportedPlatform || !initExtensionContext())
         {
            return false;
         }
         return mContext.call("isSupported") as Boolean;
      }
      
      private static function get isSupportedPlatform() : Boolean
      {
         return iOS || ANDROID;
      }
      
      private static function initExtensionContext() : Boolean
      {
         if(mContext === null)
         {
            try
            {
               mContext = ExtensionContext.createExtensionContext("com.digitalstrawberry.ane.share",null);
            }
            catch(e:Error)
            {
               trace("[Share]","Error creating extension context for","com.digitalstrawberry.ane.share");
               return false;
            }
         }
         return mContext !== null;
      }
      
      public function share(data:Vector.<SharedData>, options:ShareOptions = null) : void
      {
         if(!isSupported)
         {
            return;
         }
         if(data == null)
         {
            throw new ArgumentError("Parameter data cannot be null.");
         }
         if(data.length == 0)
         {
            throw new IllegalOperationError("No data to be shared.");
         }
         if(options == null)
         {
            options = ShareOptions.defaults;
         }
         mLastSharedData = data;
         mContext.addEventListener("status",onStatus);
         mContext.call("share",data,options);
      }
      
      public function setTitle(title:String) : void
      {
         if(!isSupported)
         {
            return;
         }
         mContext.call("setTitle",title);
      }
      
      public function dispose() : void
      {
         if(!isSupported)
         {
            return;
         }
         mContext.removeEventListener("status",onStatus);
         mContext.dispose();
         mContext = null;
      }
      
      private function onStatus(event:StatusEvent) : void
      {
         switch(event.code)
         {
            case "ShareEvent::complete":
               mLastSharedData = null;
               dispatchEvent(new ShareEvent("ShareEvent::complete",event.level));
               return;
            case "ShareEvent::cancel":
               mLastSharedData = null;
               dispatchEvent(new ShareEvent("ShareEvent::cancel",event.level));
               return;
            case "ShareEvent::error":
               mLastSharedData = null;
               dispatchEvent(new ShareEvent("ShareEvent::error",null,event.level));
               return;
            default:
               return;
         }
      }
   }
}

