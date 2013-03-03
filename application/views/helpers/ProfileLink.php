<?php
class Bhaa_View_Helper_ProfileLink
{
	public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function profileLink()
    {
        $auth = Zend_Auth::getInstance();
        if ($auth->hasIdentity()) {
            $identity = $auth->getIdentity();
			$username = $identity['username'];
            return '<a href="/profile' . $username . '">Welcome, ' . $username .  '</a>';
        } 

        return '<a href="/login">Login</a>';
    }
}
?>