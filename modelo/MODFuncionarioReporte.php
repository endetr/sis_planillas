<?php
/***
 Nombre: 	MODFuncionarioPlanillaReporte.php
 Proposito: Clase de Modelo, que contiene la definicion y llamada a funciones especificas relacionadas 
 a la tabla tfuncionario del esquema RHUM
 Autor:		Kplian
 Fecha:		04/06/2011
 * 
 *  HISTORIAL DE MODIFICACIONES:
       
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
  
 */
class MODFuncionarioReporte extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
		
	}
	
	function listarFuncionarioReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.f_reporte_funcionario_sel';// nombre procedimiento almacenado
		$this->transaccion='PLA_TOTRANGO_SEL';//nombre de la transaccion
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('rango_inicio','rango_inicio','integer');
		$this->setParametro('rango_fin','rango_fin','integer');
		$this->setParametro('id_cargo','id_cargo','integer');
		$this->setParametro('id_centro_costo','id_centro_costo','integer');
		$this->setParametro('id_lugar','id_lugar','integer');
		$this->setParametro('genero','genero','varchar');
		$this->setParametro('tipo_agrupacion','tipo_agrupacion','varchar');
		
		
		
		$this->captura('nombre_uo_pre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('fecha_ingreso','date');
		$this->captura('antiguedad_ant','integer');
		 
		$this->captura('antiguedad_anos','integer');
		$this->captura('antiguedad','integer');
		$this->captura('rango','varchar');
		$this->captura('genero','varchar');
		
		 $this->captura('cargo','varchar');
		 $this->captura('fecha_nacimiento','date');
		 $this->captura('edad','integer');
		//Ejecuta la funcion
		$this->armarConsulta();		
		//echo $this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//var_dump('hola',$this->respuesta);exit;
		
		return $this->respuesta;

	}


	function listarDatosReporteDetalle(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATPLAEMP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('nombre_empleado','text');
		$this->captura('codigo_empleado','varchar');
		$this->captura('ci','varchar');
		$this->captura('fecha_ingreso','date');
		$this->captura('codigo_columna','varchar');
		$this->captura('valor','numeric');
				$this->captura('tipo_contrato','varchar');	
		$this->captura('cargo','text');			
		$this->captura('nombre_gerencia','varchar');
		$this->captura('nombre_unidad','varchar');
		$this->captura('orden_centro','numeric');
		$this->captura('periodo','varchar');
		$this->captura('gestion','integer');
		$this->captura('nivel','varchar');
		$this->captura('distrito','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('tc','numeric');
		$this->captura('fecha_quinquenio','date'); 
		$this->captura('anos_quinquenio','integer');
		$this->captura('mes_quinquenio','integer');
		$this->captura('dias_quinquenio','integer');
		
		$this->captura('basico_limite','numeric');
		$this->captura('nivel_limite','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	
	function listarDatosAportes(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATAPORTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_afp','id_afp','integer');	
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('primer_nombre','varchar');
		$this->captura('segundo_nombre','varchar');
		$this->captura('num_ci','varchar');
		$this->captura('ci','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('valor','numeric');	
		$this->captura('columna','varchar');			
		$this->captura('edad','integer');
		$this->captura('nro_afp','varchar');
		$this->captura('tipo_jubilado','varchar');
		$this->captura('departamento','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('fecha_ingreso','date');
		$this->captura('fecha_finalizacion','date');
		$this->captura('nombre_afp','varchar');
		$this->captura('id_afp','integer');
		$this->captura('periodo','varchar');
		$this->captura('dias_ingreso','integer');
		$this->captura('dias_retiro','integer');
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarDatosPersonal(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATPERSON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_gestion','id_gestion','integer');	
		
		//Datos del empleado
		$this->captura('desc_funcionario1','text');
		$this->captura('fecha','date');
		$this->captura('observaciones_finalizacion','varchar');
		$this->captura('id_funcionario','integer');
		$this->captura('cargo','varchar');
		$this->captura('centro','varchar');
		$this->captura('valor','numeric');	
		$this->captura('mes','varchar');
		$this->captura('gestion','integer');			
		
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


//planilla tributaria

	function listarDatosPlaniTrib(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_PLATRIB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('nombre','varchar');	
		$this->captura('num_ci','varchar');
		
		$this->captura('periodo','integer');
		$this->captura('gestion','integer');
		$this->captura('codigo_rciva','varchar');
		$this->captura('tipo_documento','varchar');	
		$this->captura('novedad','varchar');	
		$this->captura('valor','numeric');				
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



	function listarDatosReporteDep(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_INFDEP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		
		//Datos del empleado
		if($this->objParam->getParametro('tipo_reporte')=='dependientes'){
			
			$this->captura('id_persona','integer');
			$this->captura('matricula','varchar');
			$this->captura('historia_clinica','varchar');
			$this->captura('codigo','varchar');	
			$this->captura('fecha_nacimiento','date');
			$this->captura('fecha_ingreso','date');
			$this->captura('nombre_funcionario','text');
			$this->captura('relacion','varchar');
			$this->captura('nombre_dep','text');	
			$this->captura('fecha_nacimiento_dep','date');	
			$this->captura('matricula_dep','varchar');
			$this->captura('historia_clinica_dep','varchar');
			$this->captura('edad_dep','integer');
		}else{
			$this->setParametro('rango_inicio','rango_inicio','integer');
			$this->setParametro('rango_fin','rango_fin','integer');
			$this->captura('nombre_funcionario','text');
			$this->captura('fecha_nacimiento_dep','date');
			$this->captura('edad_dep','integer');
			$this->captura('nombre_dep','text');
			$this->captura('genero','varchar');
			$this->captura('distrito','varchar');
			$this->captura('rango','varchar');
			
		}
		 
                  
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



	function listarDatosCurva(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_CURVSAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		
		//Datos del empleado
		 $this->captura('codigo','varchar');
		 $this->captura('num_documento','varchar');
		 $this->captura('tipo_documento','varchar');
		 $this->captura('expedicion','varchar'); 
		 $this->captura('nro_afp','varchar'); 
		 $this->captura('apellido_paterno','varchar'); 
		 $this->captura('apellido_materno','varchar'); 
		 $this->captura('primer_nombre','varchar');
         $this->captura('segundo_nombre','varchar'); 
         $this->captura('fecha_nacimiento','date'); 
         $this->captura('direccion','varchar'); 
         $this->captura('telefono1','varchar');
         $this->captura('grupo_sanguineo','varchar');
         $this->captura('genero','varchar');
         $this->captura('estado_civil','varchar'); 
         $this->captura('profesion','varchar');
         $this->captura('cargo','varchar');
         $this->captura('fecha_ingreso','date');
         $this->captura('tiempo_contrato','varchar'); 
         $this->captura('nombre_lugar','varchar');
         $this->captura('codigo_centro','varchar');  
         $this->captura('numero_nivel','integer'); 
         $this->captura('nivel_salarial_cargo','varchar'); 
         $this->captura('lugar_pago','varchar');
         $this->captura('nivel_salarial_categoria','varchar');
         $this->captura('basico_limite','numeric');
         $this->captura('fecha_quinquenio','date');
         $this->captura('antiguedad_anterior','integer'); 
         $this->captura('fecha_planilla','date');
         $this->captura('fecha_retiro','date');
         $this->captura('motivo_retiro','varchar');
		 $this->captura('fecha_ingreso_ctto1','date');
		 $this->captura('fecha_retiro_ctto1','date');
		 $this->captura('fecha_ingreso_ctto2','date');
		 $this->captura('fecha_retiro_ctto2','date');
		 $this->captura('estado','varchar');
		 $this->captura('sueldo_mes','numeric');
		 $this->captura('cotizable','numeric');
		 $this->captura('liquido','numeric');
		 $this->captura('disponibilidad','numeric');
		 $this->captura('prenatal','numeric'); 
		 $this->captura('lactancia','numeric'); 
		 $this->captura('natalidad','numeric'); 
		 $this->captura('total_ganado','numeric');
		 $this->captura('total_descuentos','numeric'); 
		 $this->captura('total_gral','numeric');
         $this->captura('celular1','varchar'); 
         $this->captura('nro_cuenta','varchar'); 
         $this->captura('banco','varchar'); 
		 
		 $this->captura('bonofrontera','numeric'); 
		 $this->captura('horext','numeric'); 
		 $this->captura('extra','numeric'); 
		 $this->captura('hornoc','numeric'); 
		 $this->captura('nocturno','numeric'); 
		 $this->captura('suelmes','numeric'); 
		 $this->captura('asigtra','numeric'); 
		 $this->captura('asigtra_it','numeric'); 
		 $this->captura('asigesp','numeric'); 
		 $this->captura('asigesp_it','numeric'); 
		 $this->captura('asigcaja','numeric'); 
		 $this->captura('asigcaja_it','numeric');          
		 $this->captura('asignaciones','numeric');
		 $this->captura('nombre_afp','varchar'); 		 		  
				   
        //Ejecuta la instruccion
		$this->armarConsulta(); //echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
		
	}
}
?>