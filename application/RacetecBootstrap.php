<?php
require_once 'controllers/BhaaStoredProcedure.php';
require_once 'Racetec_Acl.php';
require_once 'Racetec_Plugin_Acl.php';

class RacetecBootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	private $_acl = null;
	private $_auth = null;
	
	protected function _initView()
    { 
        // Initialize view
        $view = new Zend_View();
        $view->setEncoding("UTF-8");
        $view->doctype('XHTML1_TRANSITIONAL');
        $view->headTitle('Business Houses Athletic Association');
        $view->headMeta()->appendHttpEquiv('Content-Type', 'text/html;charset=utf-8');
        $view->env = APPLICATION_ENV;

        $view->addHelperPath(APPLICATION_PATH .'/views/helpers', 'View_Helper');
        $view->addHelperPath('ZendX/JQuery/View/Helper/','ZendX_JQuery_View_Helper'); 
        $view->jQuery()->enable();
        $view->jQuery()->uiEnable();
		Zend_Controller_Action_HelperBroker::addHelper(
		    new ZendX_JQuery_Controller_Action_Helper_AutoComplete()
		);
		
		
		//$view->headLink(array('rel' => 'icon', 'href' => '/images/favicon.ico', 'type' => 'image/x-icon'))
		//	->prependStylesheet($view->baseUrl('/css/bootstrap.min.css'))
		//	->appendStylesheet($view->baseUrl('/css/bootstrap.min.responsive'));
		
		//$view->jQuery()
		//	->setVersion('1.5.2')
		//	->setUiVersion('1.8.12');
		
		//$view->headScript()->prependFile('/js/bootstrap.js');
			
		// Add it to the ViewRenderer
        $viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer();
        $viewRenderer->setView($view);
		Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);

        // add paths to controller helpers
        Zend_Controller_Action_HelperBroker::addPath( APPLICATION_PATH .'/controllers/helpers');

        $registry = Zend_Registry::getInstance();
        $acl = new Racetec_Acl();
        $registry->set('acl', $acl);
        
        $frontController = Zend_Controller_Front::getInstance();
        $frontController->registerPlugin(new Racetec_Plugin_Acl());
                
        // navigation
		$navconfig = new Zend_Config_Xml(APPLICATION_PATH.'/configs/racetec.xml','nav');
	    $navigation = new Zend_Navigation($navconfig);
	    
	     
	    //http://stackoverflow.com/questions/8158552/zend-navigation-and-zend-acl
	    //Zend_View_Helper_Navigation_HelperAbstract::setDefaultAcl(Zend_Registry::get('acl'));
	    //Zend_View_Helper_Navigation_HelperAbstract::setDefaultRole("guest");
	    
	    $view->navigation($navigation)->setAcl($this->_acl)
		  ->setRole(Zend_Auth::getInstance()->getStorage()->read()->role);
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
        return $moduleLoader;
    }

    protected function _initRegistry()
    {
        $this->bootstrap('db');
        $db = $this->getResource('db');
        $db->query("SET NAMES 'utf8'");
        Zend_Registry::set('db', $db);
    }

    protected function _initResource()
    {
        $resource = new Zend_Loader_Autoloader_Resource(array(
                'basePath'  => APPLICATION_PATH,
                'namespace' => '',
        ));
        $resource->addResourceType('filter', 'filters/', 'Filter_');
        $resource->addResourceTypes(array(
                'class' => array(
                        'path'      => 'validators/',
                        'namespace' => 'Validator',
                ),
        ));
        return $resource;
    }

    protected function _initLoader()
    {
        $autoloader = Zend_Loader_Autoloader::getInstance();
        $autoloader->registerNamespace('Bvb_');
        //$autoloader->registerNamespace('My_');
        $autoloader->suppressNotFoundWarnings(false);
        $autoloader->setFallbackAutoloader(true);
        return $autoloader;
    }
    
    protected function _initLog()
    {
    	$writer = new Zend_Log_Writer_Stream('./logs/racetec.zend.log');
    	$logger = new Zend_Log($writer);
		Zend_Registry::set('logger',$logger);

        $sp = new BhaaStoredProcedure($logger);
        Zend_Registry::set('sp',$sp);
    }

	protected function _initConfig()
	{
	    $config = new Zend_Config($this->getOptions(), true);
	    Zend_Registry::set('config', $config);
	    return $config;
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
            'cache_dir' => './../data/cache/', // Directory where to put the cache files
            'hashed_directory_level' => 2
        );
        
        $flickrFrontendOptions = array(
            'lifetime' => 3600*24*5, // cache lifetime of 5 days
            'automatic_serialization' => true,
            'logging' => false,
            'caching' => true
        );

        $flickrBackendOptions = array(
            'cache_dir' => './../data/flickr/', // Directory where to put the cache files
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
}