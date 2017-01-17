package com.borhan.upload.commands
{
	import com.borhan.upload.events.KUploadErrorEvent;
	import com.borhan.upload.vo.FileVO;
	import com.borhan.vo.importees.UploadStatusTypes;

	public class ValidateUploadCommand extends BaseUploadCommand
	{
		override public function execute():void
		{
			var uploadErrorIndices:Array = [];
			for (var i:int = 0; i < model.files.length; i++)
			{
				var fileVo:FileVO = model.files[i];
				if (fileVo.uploadStatus == UploadStatusTypes.UPLOAD_FAILED)
				{
					uploadErrorIndices.push(i);
				}
			}
			var anyUploadErrors:Boolean = uploadErrorIndices.length > 0;

			if (anyUploadErrors)
			{
				model.error = KUploadErrorEvent.UPLOAD_ERROR;
				model.uploadedErrorIndices = uploadErrorIndices;
			}
			else
			{
				model.error = null;
				model.uploadedErrorIndices = [];

			}
		}
	}
}