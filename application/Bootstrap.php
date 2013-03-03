<?php
require_once 'controllers/BhaaStoredProcedure.php';

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	protected function _initView()
    { 
        // Initialize view
        $view = new Zend_View();
        $view->setEncoding("UTF-8");
        $view->doctype('XHTML1_TRANSITIONAL');
   //     $view->doctype('HTML5');
        $view->headTitle('Business Houses Athletic Association');
        // http://zend-framework-community.634137.n4.nabble.com/Firefox-double-request-td2992431.html
        $view->headMeta()
        	->appendHttpEquiv('Content-Type','text/html;charset=utf-8')
            ->appendHttpEquiv('Content-Language','en-UK');

        
        $view->env = APPLICATION_ENV;

        $view->addHelperPath(APPLICATION_PATH .'/views/helpers', 'View_Helper');
        $view->addHelperPath('ZendX/JQuery/View/Helper/','ZendX_JQuery_View_Helper'); 
        $view->jQuery()->enable();
        $view->jQuery()->uiEnable();
		Zend_Controller_Action_HelperBroker::addHelper(
		    new ZendX_JQuery_Controller_Action_Helper_AutoComplete()
		);
		
		// Add it to the ViewRenderer
        $viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer();
        $viewRenderer->setView($view);
		Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);

		Zend_Controller_Action_HelperBroker::addHelper(new Zend_Controller_Action_Helper_FlashMessenger());
		
        // add paths to controller helpers
        Zend_Controller_Action_HelperBroker::addPath( APPLICATION_PATH .'/controllers/helpers');

        // navigation
		$navconfig = new Zend_Config_Xml(APPLICATION_PATH.'/configs/navigation.xml','nav');
	    $navigation = new Zend_Navigation($navconfig);
	    $view->navigation($navigation);

        // Return it, so that it can be stored by the bootstrap
        return $view;
    }

    protected function _initAutoload()
    {
        $moduleLoader = new Zend_Application_Module_Autoloader(array(
            'namespace' => '',
        	'basePath' => APPLICATION_PATH)
        );
    }

    protected function _initRegistry()
    {
        $this->bootstrap('db');
        $db = $this->getResource('db');
        $db->query("SET NAMES 'utf8'");
        Zend_Registry::set('db', $db);
    }

    protected function _initAutoLoader()
    {
    	$autoLoader = Zend_Loader_Autoloader::getInstance();
    	$autoLoader->registerNamespace('Bvb_');
    	$autoLoader->suppressNotFoundWarnings(false);
    	$autoLoader->setFallbackAutoloader(true);
    	
    	$resourceLoader = new Zend_Loader_Autoloader_Resource(
    		array(
    			'basePath' => APPLICATION_PATH,
    	    	'namespace' => '',));
    	       
        $resourceLoader->addResourceType('filter', 'filters', 'Filter_');
        $autoLoader->pushAutoloader($resourceLoader);
    }

    protected function _initConfig()
    {
    	$config = new Zend_Config($this->getOptions(), true);
    	Zend_Registry::set('config', $config);
    	return $config;
    }
    
    protected function _initLog()
    {
    	$writer = new Zend_Log_Writer_Stream(APPLICATION_PATH.'/../data/logs/bhaa.zend.log');
    	$logger = new Zend_Log($writer);

    	$config = Zend_Registry::get('config');
    	$filter = new Zend_Log_Filter_Priority((int)$config->loglevel);
    	$logger->addFilter($filter);
    	
    	Zend_Registry::set('logger',$logger);

        $sp = new BhaaStoredProcedure();
        Zend_Registry::set('sp',$sp);
    }

	
    protected function _initCache()
    {
        $frontendOptions = array(
            'lifetime' => 3600*24*5, // cache lifetime of 5 days
            'automatic_serialization' => true,
            'logging' => false,
            'caching' => true
        );

        $backendOptions = array(
            'cache_dir' => APPLICATION_PATH.'/../data/cache/', // Directory where to put the cache files
            'hashed_directory_level' => 2
        );
        
        $flickrFrontendOptions = array(
            'lifetime' => 3600*24*5, // cache lifetime of 5 days
            'automatic_serialization' => true,
            'logging' => false,
            'caching' => true
        );

        $flickrBackendOptions = array(
            'cache_dir' => APPLICATION_PATH.'/../data/flickr/', // Directory where to put the cache files
            'hashed_directory_level' => 2
        );

        // getting a Zend_Cache_Core object
        $cache = Zend_Cache::factory(
            'Core',
            'File',
            $frontendOptions,
            $backendOptions);
        Zend_Registry::set('cache', $cache);

        $flickrcache = Zend_Cache::factory(
            'Core',
            'File',
            $flickrFrontendOptions,
            $flickrBackendOptions);
        Zend_Registry::set('flickrcache', $flickrcache);
    }
    
//     protected function _initZFDebug()
//     {
//     	if ($this->hasOption('zfdebug'))
//     	{
// 	    	$autoloader = Zend_Loader_Autoloader::getInstance();
// 	    	$autoloader->registerNamespace('ZFDebug');
	    
// 	    	$options = array(
// 	            'plugins' => array('Variables', 
// 	                               'Database' => array('adapter' => $db), 
// 	                               'File' => array('basePath' => $this->hasOption('zfdebug.basePath')),
// 	                               'Cache' => array('backend' => Zend_Registry::get('cache')->getBackend()), 
// 	                               'Exception')
// 	    	);
// 	    	$debug = new ZFDebug_Controller_Plugin_Debug($options);
	    
// 	    	$this->bootstrap('frontController');
// 	    	$frontController = $this->getResource('frontController');
	    	
// 	    	$auth = Zend_Auth::getInstance();
// 	    	if ($auth->hasIdentity())
// 	    	{
// 	    		$frontController->registerPlugin($debug);
// 	    	}
//     	}
//     }
}