package com.borhan.upload.commands
{
	import com.borhan.BorhanClient;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryAddFromUploadedFile;
	import com.borhan.commands.media.MediaAddFromUploadedFile;
	import com.borhan.commands.notification.NotificationGetClientNotification;
	import com.borhan.events.BorhanEvent;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.types.BorhanNotificationType;
	import com.borhan.upload.business.PartnerNotificationVO;
	import com.borhan.upload.errors.KsuError;
	import com.borhan.upload.events.KUploadErrorEvent;
	import com.borhan.upload.events.KUploadEvent;
	import com.borhan.upload.vo.FileVO;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanClientNotification;
	import com.borhan.vo.BorhanMediaEntry;
	
	import flash.events.Event;

	public class AddEntriesCommand extends BaseUploadCommand
	{

		public function AddEntriesCommand():void
		{
		}
		
		override public function execute():void
		{
			if (model.error)
			{
				throw new KsuError("Cannot add entries, some uploads failed. Either re-upload or remove the files", KsuError.CANNOT_ADD_ENTRIES);
				return;
			}
			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			for each (var fileVo:FileVO in model.files) {
				//media entry
				if (fileVo.mediaTypeCode && (
					(fileVo.mediaTypeCode == BorhanMediaType.AUDIO.toString()) 
					|| (fileVo.mediaTypeCode == BorhanMediaType.VIDEO.toString())
					|| (fileVo.mediaTypeCode == BorhanMediaType.IMAGE.toString()))) 
				{
					var mediaEntry:BorhanMediaEntry = new BorhanMediaEntry();
					mediaEntry.mediaType = parseInt(fileVo.mediaTypeCode);
					updateBorhanBaseEntry(fileVo, mediaEntry as BorhanBaseEntry);
					var addMediaEntry:MediaAddFromUploadedFile = new MediaAddFromUploadedFile(mediaEntry, fileVo.token);
					mr.addAction(addMediaEntry);
				}
				//base entry
				else
				{
					var borhanEntry:BorhanBaseEntry = new BorhanBaseEntry();
					updateBorhanBaseEntry(fileVo, borhanEntry);
					var addEntry:BaseEntryAddFromUploadedFile = new BaseEntryAddFromUploadedFile (borhanEntry, fileVo.token, fileVo.entryType);
					mr.addAction(addEntry);
				}
				requestIndex++;
				//get notifications for entry
				var getNotification:NotificationGetClientNotification = new NotificationGetClientNotification('entryId', BorhanNotificationType.ENTRY_ADD);
				mr.mapMultiRequestParam(requestIndex - 1, 'id', requestIndex, 'entryId')
				mr.addAction(getNotification);
				requestIndex++;
			}

			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			
			model.context.kc.post(mr);
		}
		
		/**
		 * updates the given  BorhanBaseEntry according to the given fileVO
		 * @param fileVo the given FileVO
		 * @param borhanBaseEntry the given baseEntry
		 * @return borhanBaseEntry
		 * 
		 */		
		private function updateBorhanBaseEntry(fileVo:FileVO, borhanBaseEntry:BorhanBaseEntry):void {
			borhanBaseEntry.name	= fileVo.title;
			borhanBaseEntry.creditUserName = model.screenName;
			borhanBaseEntry.creditUrl = model.siteUrl;
			
			// Ignoring letter capitalization in the file's extension.
			var lowered:String = fileVo.extension.toLowerCase();
			if (model.conversionMapping != null && model.conversionMapping[lowered] != null){
				borhanBaseEntry.conversionQuality = model.conversionMapping[lowered];
				borhanBaseEntry.conversionProfileId = parseInt(model.conversionMapping[lowered]);
			} 
			else if (model.conversionProfile) {
				borhanBaseEntry.conversionQuality = model.conversionProfile;
				borhanBaseEntry.conversionProfileId = parseInt(model.conversionProfile);
			}
			
			borhanBaseEntry.userId = model.context.userId;
			
			if (fileVo.tags.length > 0)
				borhanBaseEntry.tags	= fileVo.tags.join(",");
			
			if (model.context.partnerData)
				borhanBaseEntry.partnerData = model.context.partnerData;
			
			if (model.context.groupId)
				borhanBaseEntry.groupId = parseInt(model.context.groupId);
		}
		
		/**
		 * handle result for "addentries" multirequest
		 * */
		private function result (event:BorhanEvent) : void {
			var resultArray:Array = event.data as Array;
			var notificationsArray:Array = new Array();
			for (var i:int = 0; i< resultArray.length; i++) {
				if (resultArray[i] is BorhanBaseEntry) {
					var entry:BorhanBaseEntry = resultArray[i] as BorhanBaseEntry;
					//location in model.files is always /2 since we also count here the notification requests
					(model.files[i/2] as FileVO).entryId = entry.id;
					(model.files[i/2] as FileVO).thumbnailUrl = entry.thumbnailUrl;
				} 
				else {
					dispatchAddEntryError();
				}
				//following response is for the get notofication request
				i++;
				if (resultArray[i] is BorhanClientNotification) {
					var notification:BorhanClientNotification = (resultArray[i] as BorhanClientNotification);
					var partnerNot:PartnerNotificationVO = new PartnerNotificationVO(notification.url, notification.data );
					notificationsArray.push(partnerNot);
				}
			}
			//handle notifications
			if (notificationsArray.length > 0)
			{
				var sendNotifications:SendNotificationsCommand = new SendNotificationsCommand(notificationsArray);
				sendNotifications.execute();
			}
			else
			{
				var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadEvent.ENTRIES_ADDED, model.files);
				notifyShell.execute();
				//clear already added files
				model.files = [];
			}
			
			
		
		}
		
		private function fault (info:Object) : void {
			dispatchAddEntryError();
		}

	 	private function dispatchAddEntryError():void
		{
			var notifyShell:NotifyShellCommand = new NotifyShellCommand(KUploadErrorEvent.ADD_ENTRY_FAILED);
			notifyShell.execute();
		}
	}
}