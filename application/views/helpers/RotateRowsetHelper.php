<?php

class Zend_View_Helper_RotateRowsetHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function rotateRowsetHelper(Zend_Db_Table_Rowset_Abstract $rowset,$header=true) {
        $table = "";
        $header = "";
        $values = "";
        //Zend_Debug::dump($rowset,"",true);
        if(count($rowset)>0) {
            $table .= '<table border="1" width="90%">';
            foreach($rowset as $row)
            {
                $header .= '<th>'.$row['id'].'</th>';
                $values .= '<td width="20px">'.$row['total'].'</td>';
            }
			$table .= '<tr><th>Standard</th>'.$header.'</tr>';
			$table .= '<tr><th>Runners</th>'.$values.'</tr>';
			$table .='</table>';
        }
        return $table;
    }
}
?>