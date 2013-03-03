<?php
require_once 'BhaaStoredProcedure.php';

class TeamraceresultsController extends Zend_Controller_Action
{
    var $logger;
    var $sp;
    
    function init()
    {
        parent::init();

        $this->logger = Zend_Registry::get('logger');
        $this->sp = new BhaaStoredProcedure($this->logger);

        ZendX_JQuery::enableView($this->view);
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();

        // Excel format context
        $excelConfig =
            array(
                'excel' => array(
                    'suffix'  => 'excel',
                    'headers' => array(
                        'Content-type' => 'application/vnd.ms-excel')),
            );
    }

    function preDispatch()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
    }

    public function indexAction()
    {
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getMostRecentEvent();
        $this->view->currentevent = $event;

        $leagueTable = new Model_DbTable_League();
        $this->view->teamleague = $leagueTable->getCurrentLeague("T");

        $config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/grid.ini', 'production');

        $db = Zend_Registry::get("db");

        $grid = Bvb_Grid::factory('Table',$config,$id='');

        $table = new Model_DbTable_TeamRaceResult();
        $sql = $table->getTeamDetailsSQL();
        //$this->logger->info($sql);
        $grid->setSource(new Bvb_Grid_Source_Zend_Select($sql));

        //CRUD Configuration
        $form = new Bvb_Grid_Form();
        $form->setAdd(false)->setEdit(true)->setDelete(false);

        $grid->setForm($form);
        //$grid->setNoOrder(true);
        $grid->setPagination(20);
        $grid->updateColumn('id',array('remove'=>true));
        $grid->updateColumn('team',array('remove'=>true));
        $grid->updateColumn('runnerfirst',array('remove'=>true));
        $grid->updateColumn('runnersecond',array('remove'=>true));
        $grid->updateColumn('runnerthird',array('remove'=>true));
        $grid->updateColumn('class',array('order'=>false));
        $grid->updateColumn('std',array('order'=>false));
        $grid->updateColumn('pos',array('order'=>false));
        $grid->setExport(array());//'xml','pdf'));
        $this->view->grid = $grid->deploy();
    }

    public function firstphaseAction()
    {
        $this->sp->processTeams(
            $this->_request->getParam('league'),
            $this->_request->getParam('race'),
            $this->_request->getParam('gender'));
        $this->_helper->redirector('index');
    }

    public function finalphaseAction()
    {
        $logger = Zend_Registry::get('logger');
        $this->sp->finaliseTeams($this->_request->getParam('gender'));
        $this->_helper->redirector('index');
    }

    public function clearteamsAction()
    {
        $logger = Zend_Registry::get('logger');
        $teamResultTable = new Model_DbTable_TeamRaceResult();
        $delete = $teamResultTable->getAdapter()->quoteInto('race = ?',$this->_request->getParam('race'));
        $teamResultTable->delete($delete);
        $logger->info("delete teamraceresults");
        $this->_helper->redirector('index');
    }

    public function updatestatusAction()
    {
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($this->_request->getParam('tag'));

        $teamResultTable = new Model_DbTable_TeamRaceResult();
        $teamResultTable->updateTeamResultsStatusForEvent();
        
        $this->_helper->redirector('index');
    }
}
?>