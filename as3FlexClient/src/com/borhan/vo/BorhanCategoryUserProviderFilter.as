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
	import com.borhan.vo.BorhanFilter;

	[Bindable]
	public dynamic class BorhanCategoryUserProviderFilter extends BorhanFilter
	{
		/**
		 **/
		public var userIdEqual : String = null;

		/**
		 **/
		public var userIdIn : String = null;

		/**
		 * @see com.borhan.types.BorhanCategoryUserStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 **/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.borhan.types.BorhanUpdateMethodType
		 **/
		public var updateMethodEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var updateMethodIn : String = null;

		/**
		 **/
		public var permissionNamesMatchAnd : String = null;

		/**
		 **/
		public var permissionNamesMatchOr : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userIdEqual');
			arr.push('userIdIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('updateMethodEqual');
			arr.push('updateMethodIn');
			arr.push('permissionNamesMatchAnd');
			arr.push('permissionNamesMatchOr');
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
