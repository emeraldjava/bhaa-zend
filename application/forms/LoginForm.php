<?php
class Form_LoginForm extends Zend_Form
{
    public function init()
    {
        $username = $this->addElement('text', 'username', array(
            'filters'    => array('StringTrim'),
//            'validators' => array(
//                'Alnum',
//                array('StringLength', false, array(1,50)),
//            ),
            'required'   => true,
            'label'      => 'Email:',
        ));

        $password = $this->addElement('text', 'password', array(
            'filters'    => array('StringTrim'),
            'validators' => array(
                'Alnum',
                array('StringLength', false, array(1,50)),
            ),
            'required'   => true,
            'label'      => 'Password:',
        ));

        $login = $this->addElement('submit', 'login', array(
            'required' => false,
            'ignore'   => true,
            'label'    => 'Login',
        ));

        // We want to display a 'failed authentication' message if necessary;
        // we'll do that with the form 'description', so we need to add that
        // decorator.
        $decors = array(
        array('ViewHelper'),
        array('HtmlTag'),
        array('Description', array('tag'=>'span','class'=>'description','placement'=>'APPEND')),
        array('Label', array('separator' => '')),                       // those unpredictable newlines
        array('Errors', array('separator' => '')),                      // in the render output
        );
        $this->setDecorators($decors);
        
//         $this->setDecorators(array(
//             'FormElements',
//             array('HtmlTag', array('tag' => 'dl', 'class' => 'zend_form')),
//             array('Description', array('placement' => 'prepend')),
//             'Form'
//         ));
    }
}
?>