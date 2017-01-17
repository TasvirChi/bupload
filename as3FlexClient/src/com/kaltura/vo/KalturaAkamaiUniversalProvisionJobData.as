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
	import com.borhan.vo.BorhanProvisionJobData;

	[Bindable]
	public dynamic class BorhanAkamaiUniversalProvisionJobData extends BorhanProvisionJobData
	{
		/**
		 **/
		public var streamId : int = int.MIN_VALUE;

		/**
		 **/
		public var systemUserName : String = null;

		/**
		 **/
		public var systemPassword : String = null;

		/**
		 **/
		public var domainName : String = null;

		/**
		 * @see com.borhan.types.BorhanDVRStatus
		 **/
		public var dvrEnabled : int = int.MIN_VALUE;

		/**
		 **/
		public var dvrWindow : int = int.MIN_VALUE;

		/**
		 **/
		public var primaryContact : String = null;

		/**
		 **/
		public var secondaryContact : String = null;

		/**
		 * @see com.borhan.types.BorhanAkamaiUniversalStreamType
		 **/
		public var streamType : String = null;

		/**
		 **/
		public var notificationEmail : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('streamId');
			arr.push('systemUserName');
			arr.push('systemPassword');
			arr.push('domainName');
			arr.push('dvrEnabled');
			arr.push('dvrWindow');
			arr.push('primaryContact');
			arr.push('secondaryContact');
			arr.push('streamType');
			arr.push('notificationEmail');
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
