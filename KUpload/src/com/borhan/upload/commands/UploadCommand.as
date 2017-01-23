package com.borhan.upload.commands
{
	import com.borhan.commands.uploadToken.UploadTokenAdd;
	import com.borhan.commands.uploadToken.UploadTokenUpload;
	import com.borhan.events.BorhanEvent;
	import com.borhan.net.PolledFileReference;
	import com.borhan.net.TemplateURLVariables;
	import com.borhan.upload.errors.KsuError;
	import com.borhan.upload.events.KUploadErrorEvent;
	import com.borhan.upload.events.KUploadEvent;
	import com.borhan.upload.vo.FileVO;
	import com.borhan.vo.BorhanUploadToken;
	import com.borhan.vo.importees.UploadStatusTypes;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class UploadCommand extends BaseUploadCommand
	{
		private var _activeFile:FileVO;
		private var _call:UploadTokenUpload;
		private var _files:Array; /*of FileVO*/

		override public function execute():void
		{

			if (model.error == KUploadErrorEvent.FILE_SIZE_EXCEEDS ||
				model.error == KUploadErrorEvent.TOTAL_SIZE_EXCEEDS ||
				model.error == KUploadErrorEvent.NUM_FILES_EXCEEDS)
			{
				throw new KsuError("Cannot upload, limitations exceeded:" + model.error + ". Please check for errors", KsuError.LIMITATIONS_EXCEEDED);
				return;
			}
			trace('upload selected file(s)');
			_files = getNotUploadedFiles();
			uploadNextFile();
		}

		private function uploadNextFile():void
		{
			if (_files.length > 0)
			{
				_activeFile = _files.shift();
				model.currentlyUploadedFileVo = _activeFile;
				//if we recieved uploadUrl parameter, don't use the regular action
				if (model.uploadUrl) {
					setupFileListeners();
					var uploadUrl:String = model.uploadUrl;				
					var uploadRequest:URLRequest = new URLRequest(uploadUrl);
					uploadRequest.method = URLRequestMethod.POST;
					uploadRequest.data = getURLVariables(_activeFile);
					_activeFile.file.fileReference.upload(uploadRequest);
				}
				else {
					var fileToken:BorhanUploadToken = new BorhanUploadToken();
					fileToken.fileName = _activeFile.file.fileReference.name;
					fileToken.fileSize = _activeFile.file.bytesTotal;
					var uploadToken:UploadTokenAdd = new UploadTokenAdd(fileToken);
					uploadToken.addEventListener(BorhanEvent.COMPLETE, uploadTokenAddHandler);
					uploadToken.addEventListener(BorhanEvent.FAILED, onUploadTokenFailed);
					
					model.context.kc.post(uploadToken);
				}
				
			}
			else
			{
				allFilesComplete()
			}
		}
		
		/**
		 * file token was added, now upload the file
		 * */
		private function uploadTokenAddHandler(event:BorhanEvent):void {
			var tokenId:String = (event.data as BorhanUploadToken).id;
			_activeFile.token = tokenId;
			_call = new UploadTokenUpload(tokenId, _activeFile.file.fileReference);
			_call.useTimeout = false;
			setupFileListeners();
			
			model.context.kc.post(_call);
		}
		
		private function setupFileListeners():void
		{
			if (model.uploadUrl) {
				_activeFile.file.fileReference.addEventListener(Event.COMPLETE, 					fileCompleteHandler);
			}
			else {
				_call.addEventListener(BorhanEvent.COMPLETE, 										fileCompleteHandler);
				_call.addEventListener(BorhanEvent.FAILED, 										onFileFailed);
			}
			_activeFile.file.fileReference.addEventListener(IOErrorEvent.IO_ERROR, 					onFileFailed );
			_activeFile.file.fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 		onFileFailed);
			_activeFile.file.fileReference.addEventListener(ProgressEvent.PROGRESS, 				fileProgressHandler);
			_activeFile.file.fileReference.addEventListener(Event.OPEN, 							fileOpenHandler);
			_activeFile.file.fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, 			fileHttpStatusHandler);
			_activeFile.file.addEventListener(Event.CANCEL,											polledFileReferenceCancelHandler);
		}
		
		private function fileHttpStatusHandler(event:HTTPStatusEvent):void
		{
			trace(event.status);
		}
		
		private function removeFileListeners():void
		{
			if (model.uploadUrl) {
				_activeFile.file.fileReference.removeEventListener(Event.COMPLETE, 					fileCompleteHandler);
			}
			else {
				_call.removeEventListener(BorhanEvent.COMPLETE, 									fileCompleteHandler);
				_call.removeEventListener(BorhanEvent.FAILED, 										onFileFailed);
			}
			_activeFile.file.fileReference.removeEventListener(IOErrorEvent.IO_ERROR, 				onFileFailed );
			_activeFile.file.fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	onFileFailed);
			_activeFile.file.fileReference.removeEventListener(ProgressEvent.PROGRESS, 				fileProgressHandler);
			_activeFile.file.fileReference.removeEventListener(Event.OPEN, 							fileOpenHandler);
			_activeFile.file.removeEventListener(Event.CANCEL,										polledFileReferenceCancelHandler);
		}
		
		/**
		 * file finished uploading
		 * */
		private function fileCompleteHandler(event:Event):void
		{
			trace('finish uploading selected file(s)');
			_activeFile.uploadStatus = UploadStatusTypes.UPLOAD_COMPLETE;
			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.SINGLE_UPLOAD_COMPLETE, [_activeFile]);
			notifyShell.execute();
	
			removeFileListeners();
			uploadNextFile();
		}
		
		/**
		 * upload error
		 * */
		private function onFileFailed(event:Event):void {
			var str:String;
			var rfileName:String = 'unknownFileName';
			var fileName:String = _activeFile.file.fileReference.name;
			switch (event.type) {
				case BorhanEvent.FAILED:
					str = 'BorhanEvent.FAILED, ' + (event as BorhanEvent).error.errorMsg;
					rfileName = (event.target.fileData as FileReference).name;
					break;
				case IOErrorEvent.IO_ERROR:
					str = 'OErrorEvent.IO_ERROR, ' + (event as IOErrorEvent).toString();
					rfileName = (event.target as FileReference).name;
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					str = 'SecurityErrorEvent.SECURITY_ERROR, ' + (event as SecurityErrorEvent).toString();
					rfileName = (event.target as FileReference).name;
					break;
				default:
					str = event.toString();
					break;
			}
			trace('failed uploading selected file: ', rfileName, fileName, ' - ' , str);
			_activeFile.uploadStatus = UploadStatusTypes.UPLOAD_FAILED;
			removeFileListeners();
			
			uploadNextFile();
		}
		
		/**
		 * upload token error
		 * */
		private function onUploadTokenFailed(info:Object):void {
			
			_activeFile.uploadStatus = UploadStatusTypes.UPLOAD_FAILED;
			uploadNextFile();
		}

		private function onFileComplete(evtComplete:Event):void
		{
			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.SINGLE_UPLOAD_COMPLETE, [_activeFile]);
			notifyShell.execute();

			uploadNextFile();
		}

		private function polledFileReferenceCancelHandler(evtCancel:Event):void
		{
			removeFileListeners();
		}
	
		private function fileOpenHandler(openEvent:Event):void
		{
			//report the progress because if the upload is fast, the 0 bytes out of X progress event doesn't always dispatched
			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.PROGRESS, [0, _activeFile.bytesTotal, _activeFile]);
			notifyShell.execute();

		}
		private function fileProgressHandler(progressEvent:ProgressEvent):void
		{
			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.PROGRESS, [progressEvent.bytesLoaded, progressEvent.bytesTotal, _activeFile]);
			notifyShell.execute();
		}

		private function getURLVariables(fileVO:FileVO):URLVariables
		{
			var uploadURLVariables:TemplateURLVariables = new TemplateURLVariables(model.baseRequestData);
			uploadURLVariables["filename"] = fileVO.guid;
			return uploadURLVariables;
		}

		private function allFilesComplete():void
		{
			trace("all uploads complete" );

			var validateUploads:ValidateUploadCommand = new ValidateUploadCommand();
			validateUploads.execute();

			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.ALL_UPLOADS_COMPLETE);
			notifyShell.execute();
		}

		private function getNotUploadedFiles():Array
		{
			return model.files.filter(
				function(fileVo:FileVO, i:int, list:Array):Boolean
				{
					return fileVo.bytesLoaded < fileVo.bytesTotal;
				}
			)
		}
	}
}