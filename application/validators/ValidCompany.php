<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of CompanyValidator
 *
 * @author assure
 *
 * http://code.google.com/p/zepcms/source/browse/#svn/trunk
 */
class Validator_ValidCompany extends Zend_Validate_Abstract
{
    const NOT_PRESENT = 'notPresent';

    protected $_messageTemplates = array(
        self::NOT_PRESENT => 'Field %field% is not present'
    );

    protected $_messageVariables = array(
        'field' => '_field'
    );

    protected $_field;

    protected $_listOfFields;

    public function __construct( array $listOfFields )
    {
        $this->_listOfFields = $listOfFields;
    }

    public function isValid( $value, $context = null )
    {
        if( !array( $context ) )
        {
            $this->_error( self::NOT_PRESENT );

            return false;
        }

        foreach( $this->_listOfFields as $field )
        {
            if( isset( $context[ $field ] ) )
            {
                return true;
            }
        }

        $this->_field = $field;
        $this->_error( self::NOT_PRESENT );

        return false;
    }
}
?>
