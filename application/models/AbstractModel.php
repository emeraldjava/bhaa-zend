<?php

/**
 * http://havl.net/devnotes/2010/10/zendframework-model-orm
 * http://manual.phpdoc.org/HTMLSmartyConverter/HandS/phpDocumentor/tutorial_tags.property.pkg.html
 * @author assure
 *
 */
abstract class Model_AbstractModel
{
	const INVALID_PROPERTY = "Invalid property";

	// properties
	protected $_properties = null;
	var $logger;
	
	public function __construct()
	{
		$this->logger = Zend_Registry::get('logger');
	}

	/**
	 * Set property
	 * @param string $name
	 * @return itself
	 */
	public function __set($name, $value)
	{
		$method = 'set' . ucfirst($name);

		// if trying to set mapper, then throw exception
		if ('mapper' == $name) {
			throw new Exception(self::INVALID_PROPERTY);
		}

		// if setter method
		if(method_exists($this, $method)) {
			return $this->$method($value);
		} // else if array key with that name exists in object properties
		else if (array_key_exists($name, $this->_properties)){
			$this->_properties[$name] = $value;
			return $this;
		} else { // else throw exception
			throw new Exception(self::INVALID_PROPERTY);
		}
	}

	/**
	 * Get property
	 * @param string $name
	 * @return mixed
	 */
	public function __get($name)
	{
		$method = 'get' . ucfirst($name);
		$value = null;

		// if getter method exists
		if (method_exists($this, $method)) {
			$value = $this->$method();
		} // else if array key with that name exists in object properties
		else if (array_key_exists($name, $this->_properties)){
			$value = $this->_properties[$name];
		} else { // else throw exception
			throw new Exception(self::INVALID_PROPERTY);
		}
		return $value;
	}

	/**
	 * Add new property to object
	 * @param $name property name
	 * @return itself
	 */
	public function addProperty($name)
	{
		if (array_key_exists($name, $this->_properties) === false) {
			$this->_properties[$name] = null;
		}
		return $this;
	}

	public function __isset($name)
	{
		return isset($this->_properties[$name]);
	}

	public function __unset($name)
	{
		if (isset($this->_properties[$name])) {
			unset($this->_properties[$name]);
		}
	}

	protected function _preUpdate()
	{
		$datetime = date('Y-m-d H:i:s');
		$this->_properties["updated"] = $datetime;
	}

	protected function _preInsert()
	{
		$datetime = date('Y-m-d H:i:s');
		$this->_properties["created"] = $datetime;
	}

	/* utility methods */

	/**
	 * Get all accessible properties as array
	 * @return array of accessible properties
	 */
	public function toArray()
	{
		// return properties as array.
		return $this->_properties;
	}

	/**
	 * Clears (sets to null) all properties of the object
	 * @return void
	 */
	public function clear()
	{
		foreach ($this->_properties as $key => $value) {
			$this->_properties[$key] = null;
		}
	}
}
?>