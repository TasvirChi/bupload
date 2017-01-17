// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Borhan Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Borhan Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.borhan.vo
{
	import com.borhan.vo.BorhanJobData;

	[Bindable]
	public dynamic class BorhanMailJobData extends BorhanJobData
	{
		/**
		 * @see com.borhan.types.BorhanMailType
		 **/
		public var mailType : String = null;

		/**
		 **/
		public var mailPriority : int = int.MIN_VALUE;

		/**
		 * @see com.borhan.types.BorhanMailJobStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var recipientName : String = null;

		/**
		 **/
		public var recipientEmail : String = null;

		/**
		 * kuserId
		 * 
		 **/
		public var recipientId : int = int.MIN_VALUE;

		/**
		 **/
		public var fromName : String = null;

		/**
		 **/
		public var fromEmail : String = null;

		/**
		 **/
		public var bodyParams : String = null;

		/**
		 **/
		public var subjectParams : String = null;

		/**
		 **/
		public var templatePath : String = null;

		/**
		 * @see com.borhan.types.BorhanLanguageCode
		 **/
		public var language : String = null;

		/**
		 **/
		public var campaignId : int = int.MIN_VALUE;

		/**
		 **/
		public var minSendDate : int = int.MIN_VALUE;

		/**
		 * @see com.borhan.types.borhanBoolean
		 **/
		public var isHtml : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('mailType');
			arr.push('mailPriority');
			arr.push('status');
			arr.push('recipientName');
			arr.push('recipientEmail');
			arr.push('recipientId');
			arr.push('fromName');
			arr.push('fromEmail');
			arr.push('bodyParams');
			arr.push('subjectParams');
			arr.push('templatePath');
			arr.push('language');
			arr.push('campaignId');
			arr.push('minSendDate');
			arr.push('isHtml');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}
	}
}
