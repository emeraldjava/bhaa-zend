<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Description of GridController
 */
class GridController extends Zend_Controller_Action
{
        public function init()
        {
                $this->view->baseUrl = $this->_request->getBaseUrl();
               // $this->view->addScriptPath(Core::getBaseDir() . DIRECTORY_SEPARATOR . 'skins/scripts/datagrid/');

              // enable debug
            //Bvb_Grid_Deploy_JqGrid::$debug = true;
            // enable JQuery - should be part of bootstrap
            ZendX_JQuery::enableView($this->view);
            //Bvb_Grid_Deploy_JqGrid::$jqgridLibPath = '/public/js/jqgrid/3.6.4/';
            // set url to jqGrid library
            //if (@isset(Zend_Registry::get ( 'config' )->site->jqGridUrl)) {
                //Bvb_Grid_Deploy_JqGrid::$defaultJqGridLibPath = Zend_Registry::get ( 'config' )->site->jqGridUrl;
            //}
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
            //$config = new Zend_Config_Ini('./application/grids/grid.ini', 'production');
            $config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/grid.ini', 'production');

            $db = Zend_Registry::get("db");

            //$grid = Bvb_Grid::factory('Bvb_Grid_Deploy_JqGrid',array(),$id='');
            $grid = Bvb_Grid::factory('Table',$config,$id='');
            $grid->setImagesUrl('/public/images');

            $runnerTable = new Model_DbTable_Runner();
            $rowset = $runnerTable->exportRunners("2010-06-12","A","C");

            $grid->setSource(new Bvb_Grid_Source_Zend_Select($rowset));//new Bvb_Grid_Source_Zend_Table(new Model_DbTable_DayMembers()));
            //$grid->setGridColumns(array('firstname','surname'));
            //$grid->setDetailColumns();
            //$grid = new Bvb_Grid_Deploy_Table($db, 'Document Title', 'temp/dir', array('save','download'));

            //Grid Initialization
            //$grid = Bvb_Grid::factory('Bvb_Grid_Deploy_Table', $config, 'id');

            //Setting grid source
            //$grid->setSource(new Bvb_Grid_Source_Zend_Table(new Bugs()));
            //$grid->query($db->select()->from("event"));

            $left = new Bvb_Grid_Extra_Column();
            $left->position('left')->name('racenumber')->title('Number');//->decorator("<input  type='checkbox' name='number[]'>");
            $grid->addExtraColumns($left);

            //CRUD Configuration
            $form = new Bvb_Grid_Form();
            $form->setAdd(true)->setEdit(true)->setDelete(true);
            $grid->setForm($form);

            $grid->setExport(array('xml','pdf'));
            $grid->setPagination((int) 50);
            //$grid->setLibraryDir('/home/assure/bhaa/zend/trunk/library');

            $this->view->grid = $grid->deploy();

            //Pass it to the view
            //$this->view->pages = $grid;
            //$this->render('index');


        }
}
?>
