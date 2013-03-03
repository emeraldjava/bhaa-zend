<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
require_once 'Bhaa_Service_Flickr.php';

class FlickrController extends Zend_Controller_Action
{
	var $per_page = 100;
	var $page = 1;
    var $sp;
    var $logger;
	protected $apikey;

	
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
        $this->apikey = Zend_Registry::get('config')->flickr_api_key;
        $this->logger = Zend_Registry::get('logger');
    }

    function login()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
    }

    public function indexAction()
    {
    	//$this->login();
        //$tag = $this->_request->getParam('tag','kclubxx');
        
        $flickr = new BHAA_Service_Flickr($this->apikey);
        $this->view->sets = $flickr->photoSet();
        
//        $this->view->flickrPlugin = $this->loadFlickrPhotos(
  //      	$tag,
    //    	array($tag,"bhaa"),
      //  	array('per_page'=>$this->per_page,'page'=>$this->page,'tag_mode'=>'all'));
    }
    
    public function runnerphotosAction()
    {
    	$this->login();
        $id = $this->_request->getParam('id');
        $this->loadFlickrPhotos(
        	$id,
        	array("bhaa"),
        	array('per_page'=>$this->per_page,'page'=>$this->page,'tag_mode'=>'all','machine_tags'=>sprintf('bhaa:id=%d',$id)));
        $redirector = $this->_helper->getHelper('redirector');
	    $redirector->gotoSimpleAndExit('index','runner', 'default',array('id'=>$id));
    }
    
    public function eventphotosAction()
    {
    	$this->login();
    	$tag = $this->_request->getParam('tag');
        $this->view->flickrPlugin = $this->loadFlickrPhotos(
        	$tag,
        	array($tag,"bhaa"),
        	array('per_page'=>$this->per_page,'page'=>$this->page,'tag_mode'=>'all'));
    }
    
    public function clearcacheAction()
    {
    	$this->login();
        $cache = Zend_Registry::get('flickrcache');
        $cache->clean(Zend_Cache::CLEANING_MODE_ALL);
        $this->_helper->redirector('index', 'flickr');
    }

    private function loadFlickrPhotos($key,$flickrtags,$flickroptions)
    {

    	$this->logger->info("loadFlickrPhotos ".$key);
    	// http://www.tee-jay.de/en/article/show/New-Page-On-My-Website
        $flickr = new BHAA_Service_Flickr($this->apikey);
        $flickrResults = $flickr->tagSearch($flickrtags,$flickroptions);
        $this->logger->info("matched ".$flickrResults->totalResults()." flickr photos for tag ".(string)$key);
        if($flickrResults->totalResults() > 0) {
            foreach ($flickrResults as $k => $value) {
                $resultsArray[$k] = $value;
            }
        }

	    if(count($resultsArray) > 1)
	    {
		    // save to the cache regardless
		    $html = $this->createFlickrWidget($resultsArray);
            $flickrcache = Zend_Registry::get('flickrcache');
	        $flickrcache->save($html,(string)$key);
            $this->logger->info("saved flickr widget ".$key);
	    }
    }
    
    private function createFlickrWidget($resultsArray)
    {
    	$flickrPlugin .= '<div id="gallery"><ol id="flickrselectable">';
    	if (count($resultsArray) > 0){
    		foreach ($resultsArray as $flickr_result) {
    			if ($flickr_result->title == ""){
    				$title = $results->flickr;
    			}else{
    				$substring = strtolower(substr($flickr_result->title, -4));
    				if ($substring == ".jpg" or $substring == ".gif" or $substring == ".png"){
    					$title = $results->flickr;
    				}else{
    					$title = $flickr_result->title;
    				}
    			}
    			// title="'.$flickr_result->title.'"
    			$flickrPlugin .= '<li><a class="highslide" onclick="return hs.expand(this)" href="'.$flickr_result->Medium->uri.'" title="'.$flickr_result->owner.'/'.$flickr_result->id.'">';
    			$flickrPlugin .= '<img class="thumb" alt="'.$flickr_result->title.'" width="80" height="80" src="'.$flickr_result->Square->uri.'" /></a></li>';
    		}
    	}
    	$flickrPlugin .= '</ol></div>';
    	return $flickrPlugin;
    }
}
?>