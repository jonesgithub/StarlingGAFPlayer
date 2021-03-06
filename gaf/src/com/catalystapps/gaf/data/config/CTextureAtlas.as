package com.catalystapps.gaf.data.config
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import com.catalystapps.gaf.core.GAFTextureMapingManager;
	import com.catalystapps.gaf.display.GAFTexture;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	/**
	 * @private
	 */
	public class CTextureAtlas
	{
		//--------------------------------------------------------------------------
		//
		//  PUBLIC VARIABLES
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  PRIVATE VARIABLES
		//
		//--------------------------------------------------------------------------
		
		private var _textureAtlasesDictionary: Object;
		private var _textureAtlasConfig: CTextureAtlasScale;
		
		/*
		 * Available only when GAFAsset.debug set to true. Used for debug purpose only
		 */
		private var _imgs: Object;
		
		//--------------------------------------------------------------------------
		//
		//  CONSTRUCTOR
		//
		//--------------------------------------------------------------------------
		
		public function CTextureAtlas(textureAtlasesDictionary: Object, textureAtlasConfig: CTextureAtlasScale)
		{
			this._textureAtlasesDictionary = textureAtlasesDictionary;
			this._textureAtlasConfig = textureAtlasConfig;
		}
		
		//--------------------------------------------------------------------------
		//
		//  PUBLIC METHODS
		//
		//--------------------------------------------------------------------------
		
		public static function textureFromImg(img: BitmapData, csf: Number): Texture
		{
			return Texture.fromBitmapData(img, false, false, csf);
		}
		
		public static function createFromTextures(texturesDictionary: Object, textureAtlasConfig: CTextureAtlasScale): CTextureAtlas
		{
			var atlasesDictionary: Object = new Object();
			
			var atlas: TextureAtlas;
			
			for each(var element: CTextureAtlasElement in textureAtlasConfig.elementsVector)
			{
				if(!atlasesDictionary[element.atlasID])
				{
					atlasesDictionary[element.atlasID] = new TextureAtlas(texturesDictionary[element.atlasID]);
				}
				
				atlas = atlasesDictionary[element.atlasID];
				
				atlas.addRegion(element.id, element.region);
			}
			
			var result: CTextureAtlas = new CTextureAtlas(atlasesDictionary, textureAtlasConfig);
			
			return result;
		}
		
		public function dispose(): void
		{
			for each(var textureAtlas: TextureAtlas in this._textureAtlasesDictionary)
			{
				textureAtlas.dispose();
			}
		}
		
		public function getTexture(id: String, mappedAssetID: String = "", ignoreMapping: Boolean = false): GAFTexture
		{
			var textureAtlasElement: CTextureAtlasElement = this._textureAtlasConfig.getElement(id);
			
			if(textureAtlasElement)
			{
				var texture: Texture = this.getTextureByIDandAtlasID(id, textureAtlasElement.atlasID);
			
				var pivotMatrix: Matrix;
			
				if(this._textureAtlasConfig.getElement(id))
				{
					pivotMatrix = this._textureAtlasConfig.getElement(id).pivotMatrix;
				}
				else
				{
					pivotMatrix = new Matrix();
				}
				
				return new GAFTexture(id, texture, pivotMatrix);
			}
			else
			{
				if(ignoreMapping)
				{
					return null;
				}
				else
				{
					return GAFTextureMapingManager.getMappedTexture(id, mappedAssetID);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  PRIVATE METHODS
		//
		//--------------------------------------------------------------------------
		
		private function getTextureByIDandAtlasID(id: String, atlasID: String): Texture
		{
			var textureAtlas: TextureAtlas = this._textureAtlasesDictionary[atlasID];
			
			return textureAtlas.getTexture(id);
		}
		
		//--------------------------------------------------------------------------
		//
		// OVERRIDDEN METHODS
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  EVENT HANDLERS
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  GETTERS AND SETTERS
		//
		//--------------------------------------------------------------------------
		
		/*
		 * Available only when GAFAsset.debug set to true. Used for debug purpose only
		 */
		public function get imgs(): Object
		{
			return _imgs;
		}
		
		/*
		 * Used only when GAFAsset.debug set to true. Used for debug purpose only
		 */
		public function set imgs(imgs: Object): void
		{
			_imgs = imgs;
		}
		
	}
}
