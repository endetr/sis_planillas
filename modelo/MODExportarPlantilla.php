<?php
/**
*@package pXP
*@file MODExportarPlantilla.php
*@author  (egs)
*@date 
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
* 	ISSUE		FECHA    		AUTOR			DESCRIPCION
*	#9			23/05/2019		EGS				creacion 
*/

class MODExportarPlantilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
		function exportarDatosTipoPlanilla() {
		
		$this->procedimiento='plani.f_exportar_plantilla';
			$this->transaccion='PLA_EXPTIPL_SEL';
			$this->tipo_procedimiento='SEL';
			$this->setCount(false);
			
		    $this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');
			
			//Definicion de la lista del resultado del query
				
				$this->captura('tipo_reg','varchar');                    
                $this->captura('codigo','varchar');
                $this->captura('nombre','varchar');                       
                $this->captura('codigo_proceso_macro','varchar');
                $this->captura('funcion_obtener_empleados','varchar');
                $this->captura('tipo_presu_cc','varchar');
                $this->captura('funcion_validacion_nuevo_empleado','varchar');
                $this->captura('calculo_horas','varchar');
                $this->captura('periodicidad','varchar');
                $this->captura('funcion_calculo_horas','varchar');
                $this->captura('recalcular_desde','integer');
                $this->captura('estado_reg','varchar');
			
		
		$this->armarConsulta();	
		
        $this->ejecutarConsulta(); 
		 		
		////////////////////////////
				
		if($this->respuesta->getTipo() == 'ERROR'){
			return $this->respuesta;
		}
		else {
		    $this->procedimiento = 'plani.f_exportar_plantilla';
			$this->transaccion = 'PLA_EXPTIPLDE_SEL';
			$this->tipo_procedimiento = 'SEL';
			$this->setCount(false);
			$this->resetCaptura();
			$this->addConsulta();	


				
			$this->captura('tipo_reg','varchar');			
			$this->captura('codigo','varchar');
            $this->captura('codigo_tipo_pla','varchar');
            $this->captura('nombre','varchar');
            $this->captura('tipo_dato','varchar');
            $this->captura('descripcion','text');
            $this->captura('formula','varchar');
            $this->captura('compromete','varchar');
            $this->captura('tipo_descuento_bono','varchar');
            $this->captura('decimales_redondeo','integer');
            $this->captura('orden','integer');
            $this->captura('finiquito','varchar');
            $this->captura('tiene_detalle','varchar');
            $this->captura('recalcular','varchar');
            $this->captura('estado_reg','varchar');
			
		
			
			$this->armarConsulta();
			$consulta=$this->getConsulta();			
	  
			$this->ejecutarConsulta($this->respuesta);
		}

		
       return $this->respuesta;		
	
	}

	function exportarDatosTipoObligacion() {
		
		$this->procedimiento='plani.f_exportar_plantilla';
			$this->transaccion='PLA_EXPTIOB_SEL';
			$this->tipo_procedimiento='SEL';
			$this->setCount(false);
			
			//var_dump($this->objParam);
		    $this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');   
		    $this->setParametro('id_tipo_obligacion','id_tipo_obligacion','integer');

			//Definicion de la lista del resultado del query
				
				$this->captura('tipo_reg','varchar');
				$this->captura('codigo','varchar');
				$this->captura('codigo_tipo_planilla','varchar'); 
				$this->captura('nombre','varchar');                                        
                $this->captura('tipo_obligacion','varchar');
                $this->captura('dividir_por_lugar','varchar');                       
                $this->captura('es_pagable','varchar');
                $this->captura('codigo_tipo_obligacion_agrupador','varchar');
                $this->captura('descripcion','varchar');
                $this->captura('codigo_tipo_relacion_debe','varchar');
                $this->captura('codigo_tipo_relacion_haber','varchar');
                $this->captura('estado_reg','varchar');

		
		$this->armarConsulta();	
		
        $this->ejecutarConsulta(); 
		 		
		////////////////////////////
				
		if($this->respuesta->getTipo() == 'ERROR'){
			return $this->respuesta;
		}
		else {
		    $this->procedimiento = 'plani.f_exportar_plantilla';
			$this->transaccion = 'PLA_EXPTIOBCO_SEL';
			$this->tipo_procedimiento = 'SEL';
			$this->setCount(false);
			$this->resetCaptura();
			$this->addConsulta();	


				
			$this->captura('tipo_reg','varchar');			
			$this->captura('codigo','varchar');
            $this->captura('codigo_tipo_obligacion','varchar');
            $this->captura('codigo_tipo_planilla','varchar');
            $this->captura('pago','varchar');
            $this->captura('presupuesto','varchar');
            $this->captura('es_ultimo','varchar');
            $this->captura('estado_reg','varchar');
			
		
			
			$this->armarConsulta();
			$consulta=$this->getConsulta();			
	  
			$this->ejecutarConsulta($this->respuesta);
		}

	    //var_dump('res',$this->respuesta);exit;
       return $this->respuesta;		
	
	}

			
}
?>