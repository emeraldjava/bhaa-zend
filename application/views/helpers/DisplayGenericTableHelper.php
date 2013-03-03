<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of DisplayGenericTable
 *
 * @author assure
 */
class Zend_View_Helper_DisplayGenericTableHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function displayGenericTableHelper(Zend_Db_Table_Rowset_Abstract $rowset,$border=0) {
        $table = "";
        if(count($rowset)>0) {
            $table .= '<table border="'.$border.'"><tr>';
            foreach(array_keys($rowset->current()->toArray()) as $column) {
                $table .= '<th>'.$column.'</th>';
            }
            foreach($rowset as $row) {
                $table .= '</tr><tr>';
                foreach($row->toArray() as $content) {
                    $table .= '<td>'.$content.'</td>';
                }
            }
            $table .='</tr></table>';
           }
           return $table;
    }
}
?>