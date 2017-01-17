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
	import com.borhan.vo.BorhanAssetFilter;

	[Bindable]
	public dynamic class BorhanCaptionAssetBaseFilter extends BorhanAssetFilter
	{
		/**
		 **/
		public var captionParamsIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var captionParamsIdIn : String = null;

		/**
		 * @see com.borhan.types.BorhanCaptionType
		 **/
		public var formatEqual : String = null;

		/**
		 **/
		public var formatIn : String = null;

		/**
		 * @see com.borhan.types.BorhanCaptionAssetStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 **/
		public var statusNotIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('captionParamsIdEqual');
			arr.push('captionParamsIdIn');
			arr.push('formatEqual');
			arr.push('formatIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
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
