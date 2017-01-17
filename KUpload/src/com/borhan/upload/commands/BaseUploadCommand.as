package com.borhan.upload.commands
{
	import com.borhan.upload.model.KUploadModelLocator;

	import flash.events.EventDispatcher;

	public class BaseUploadCommand extends EventDispatcher
	{
		protected var model:KUploadModelLocator = KUploadModelLocator.getInstance();
		public function execute():void
		{
		}

	}
}