<?php
class Bhaa_Service_Flickr extends Zend_Service_Flickr {

	var $logger;
	
	public function photoSet()//$userName, array $options = null)
	{
		$this->logger = Zend_Registry::get('logger');
		
		static $method = 'flickr.photosets.getList';
		static $defaultOptions = array(
			'per_page' => 50,
	        'page'        => 1,
	        'tag_mode' => 'or',
	        'extras'   => 'license, date_upload, date_taken, owner_name, icon_server'
		);
		
		$options = array();
		$options['user_id'] = "34896940@N06";
		// merge the arrays
		$options = $this->_prepareOptions($method,$options,$defaultOptions);
		 
		// now search for photos
		$restClient = $this->getRestClient();
		$restClient->getHttpClient()->resetParameters();
		$response = $restClient->restGet('/services/rest/', $options);
		 
		//$this->logger->info($response);
		// check for errors
		if ($response->isError()) {
			require_once 'Zend/Service/Exception.php';
			throw new Zend_Service_Exception('An error occurred sending request. Status code: ' .
			$response->getStatus());
		}

		// return the xml plain text
		// return $response->getBody();
		
		// http://www.edvanbeinum.com/use-zend_service_flickr-to-retrieve-latitude-and-longitude-for-a-photo
		$dom = new DOMDocument();
		$dom->loadXML($response->getBody());
		$xpath = new DOMXPath($dom);
		self::_checkErrors($dom);
		$retval = array();
		
		// <photoset id="72157628047252802" primary="6310230047" secret="6f0c042c87" server="6113" farm="7" photos="63" videos="0" needs_interstitial="0" visibility_can_see_set="1" count_views="2" count_comments="0" can_comment="1" date_create="1320363298" date_update="1320364993">
		// <title>datasolutions2008</title>
		// <description />
		// </photoset>
		foreach($xpath->query('//rsp/photosets/photoset') as $set) {
			//http://www.php.net/manual/en/domxpath.query.php
			$retval[] = array(
				'title' => $set->getElementsByTagName('title')->item(0)->nodeValue,
				'id' => $set->getAttribute('id'),
				'primary' => $set->getAttribute('primary'),
				'secret' => $set->getAttribute('secret'),
				'server' => (string)  $set->getAttribute('server'),
				"farm" => $set->getAttribute('farm'),
				'photos' => (string)  $set->getAttribute('photos'),
				'count_views' => (string)  $set->getAttribute('count_views'),
				'date_create' => (string)  $set->getAttribute('date_create'),
				'date_update' => (string)  $set->getAttribute('date_update')
			);
		}
		return $this->createFlickrWidgetSet($retval);
	}
	
	private function createFlickrWidgetSet($resultsArray)
	{
		$flickrPlugin .= '<div id="flickrsets"><ol id="selectablefs">';
		if (count($resultsArray) > 0){
			foreach ($resultsArray as $flickr) {
				$photosetimage = sprintf('http://farm%s.static.flickr.com/%s/%s_%s_s.jpg',$flickr['farm'],$flickr['server'],$flickr['primary'],$flickr['secret']);
				// http://www.flickr.com/photos/34896940@N06/sets/72157628047252802/
				$photoset = sprintf('http://flickr.com/photos/34896940@N06/sets/%s',$flickr['id']);
				
				$flickrPlugin .= '<div><li><a href="'.$photoset.'" target="new" title="'.$flickr["title"].'">';
				$flickrPlugin .= '<img class="thumb" alt="'.$flickr['title'].'" width="100" height="100" src="'.$photosetimage.'" />
				</a><div><b>'.$flickr['title'].'</b><br/>Photos:'.$flickr['photos'].'<br/>Views:'.$flickr['count_views'].'</div></li></div>';
			}
		}
		$flickrPlugin .= '</ol></div>';
		return $flickrPlugin;
	}
	
	public function getCachedFlickrSetsData($apiKey,$userName,$tags = 'Fav'){
	
		// caching options
		$frontendOptions = array('lifetime' => 86400,'automatic_serialization' => true);
		$backendOptions = array('cache_dir' => $this->_config->framework->tmp_dir);
	
		// cache id of "what we want to cache"
		$id = 'SetsCache';
	
		// create a new Cache Instance
		$cache = Zend_Cache::factory('Core', 'File', $frontendOptions, $backendOptions);
	
		// check if we chached output
		if (!($outputarray = $cache->load($id))) {
			$data = '';
	
			// Instanciating our new Class
			$flickr = new Teejay_Service_Flickr($apiKey);
			$options = array();
			$options['user_id'] = $flickr->getIdByUsername($userName);
			$data = $flickr->photoSet($userName,$options);
	
			// load xml plain text //  here we need a error fall back
			$xml = simplexml_load_string($data);
			$results = $xml->xpath('//photoset');
	
			// build the output array
			$outputarray = array();
			foreach($results as $obj){
				$outputarray[] = array(
	                    'title'=>(string) $obj->title,
	                    'photos'=> (int) $obj->attributes()->photos,
	                    'id'=> (string) $obj->attributes()->id
				);
			}
	
			// save the output in a file
			$cache->save($outputarray);
		}
	
		// just return your newly created output
		return $outputarray;
	}
	
}
?>