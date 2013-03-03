<?php

require_once 'facebook.php';

class FacebookController extends Zend_Controller_Action
{
    public $apiKey = "c65e9ef71b66c842a581ee2253f36abc";
    public $apiSecret = "45d2d0362b9f27f79e3fa0d876bdf701";

    public $simulateFb = false;
    public $useTestApplication = false;
    public $canvasUrl = "http://apps.facebook.com/bhaa_app";
    //public $testApiKey = '28c...b05';
    //public $testApiSecret = 'df6...3fb5';
    //public $testCanvasUrl = "http://apps.facebook.com/myfbapptest";
    //public $fbUserId = "1234567";

    protected $facebook;

    public function init() {
            if($this->simulateFb) {
                    Zend_Session::start();
                    parent::init();
            }
            else {
                    if($this->useTestApplication) {
                            $this->apiKey = $this->testApiKey;
                            $this->apiSecret = $this->testApiSecret;
                            $this->canvasUrl = $this->testCanvasUrl;
                    }
                    $this->facebook = new Facebook($this->apiKey, $this->apiSecret);
                    $session_key = md5($this->facebook->api_client->session_key);
                    if(!Zend_Session::isStarted())  {
                            Zend_Session::setId($session_key);
                            Zend_Session::start();
                    }
                    parent::init();
            }
    }
    protected function requireLogin() {
            if(!$this->simulateFb) {
                    $this->fbUserId = $this->facebook->require_login();
            }
    }
    protected function _redirect($url, array $options = array()) {
            if(!$this->simulateFb) {
               $this->facebook->redirect($this->canvasUrl . $url);
            }
            else {
               parent::_redirect($url, $options);
            }
    }

    public function indexAction()
    {
        $this->requireLogin();

        $user = $this->facebook->api_client->users_getLoggedInUser();

        //Zend_Debug::dump($user,"",true);

        $this->view->user=$user;
    }

    public function tabAction()
    {
        $user_id = $this->facebook->api_client->users_getLoggedInUser();
        $this->view->user_id=$user_id;
    }
}
?>