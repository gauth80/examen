<?php

defined('BASEPATH') or exit('No direct script access allowed');

class Produits extends CI_Controller {
	public function __construct() {
		parent::__construct();
		$this->load->model('Produits_model');
	}

	public function index() {
		//sub - option
		$produits = new Produits_model;

		$data['data']= $this->produits_model->get_produits();

    $this->templates->display('produits/index', $data);
  }

}