package com.borhan.upload.commands
{
	import com.borhan.upload.vo.FileVO;

	public class StopUploadsCommand extends BaseUploadCommand
	{
		override public function execute():void
		{
			model.currentlyUploadedFileVo.file.cancel();
			model.currentlyUploadedFileVo = null;
		}
	}
}