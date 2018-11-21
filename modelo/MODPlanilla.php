<?php
/**
*@package pXP
*@file gen-MODPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:04
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlanilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlanilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_PLANI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');

		//Definicion de la lista del resultado del query
		$this->captura('id_planilla','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_uo','int4');
		$this->captura('id_tipo_planilla','int4');
		$this->captura('id_proceso_macro','int4');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('observaciones','text');
		$this->captura('nro_planilla','varchar');
		$this->captura('estado','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('periodo','int4');
		$this->captura('nombre_planilla','varchar');
		$this->captura('desc_uo','varchar');
		$this->captura('id_depto','int4');
		$this->captura('nombre_depto','varchar');
		$this->captura('calculo_horas','varchar');
		$this->captura('plani_tiene_presupuestos','varchar');
		$this->captura('plani_tiene_costos','varchar');	
		$this->captura('fecha_planilla','date');		
		$this->captura('codigo_poa','varchar');
		$this->captura('obs_poa','text');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function listarReportePlanillaMinisterioNuevo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_planilla_sel';
        $this->transaccion='PLA_R_MINTRASUE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_gestion','id_gestion','int4');

        //Definicion de la lista del resultado del query
        $this->captura('fila','int4');
        $this->captura('tipo_documento','varchar');
        $this->captura('ci','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('fecha_nacimiento','text');

        $this->captura('apellido_paterno','varchar');
        $this->captura('apellido_materno','varchar');
        $this->captura('nombres','varchar');
        $this->captura('nacionalidad','varchar');
        $this->captura('sexo','varchar');
        $this->captura('jubilado','int4');
        $this->captura('aporta_afp','int4');
        $this->captura('discapacitado','int4');
        $this->captura('tutor_discapacidad','int4');
        $this->captura('fecha_ingreso','text');
        $this->captura('fecha_finalizacion','text');
        $this->captura('motivo_retiro','varchar');
        $this->captura('caja_salud','varchar');
        $this->captura('afp','integer');
        $this->captura('nro_afp','varchar');
        $this->captura('oficina','int4');
        $this->captura('clasificacion_laboral','varchar');
        $this->captura('cargo','varchar');
        $this->captura('modalidad_contrato','int4');
        $this->captura('tipo_contrato','int4');
        $this->captura('valor','numeric');
        $this->captura('horas_dia','int4');

        $this->captura('codigo_columna','varchar');
        $this->captura('contrato_periodo','varchar');
        $this->captura('retiro_periodo','varchar');
        $this->captura('edad','integer');
        $this->captura('lugar','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	function listarReportePlanillaMinisterio(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPMINTRASUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('fila','int4');
		$this->captura('tipo_documento','int4');
		$this->captura('ci','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('afp','varchar');
		$this->captura('nro_afp','varchar');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('apellido_casada','varchar');
		$this->captura('primer_nombre','varchar');
		$this->captura('otros_nombres','varchar');
		$this->captura('nacionalidad','varchar');
		$this->captura('fecha_nacimiento','text');
		$this->captura('sexo','int4');
		$this->captura('jubilado','int4');
		$this->captura('clasificacion_laboral','varchar');
		$this->captura('cargo','varchar');
		$this->captura('fecha_ingreso','text');
		$this->captura('modalidad_contrato','int4');
		$this->captura('fecha_finalizacion','text');
		$this->captura('horas_dia','int4');
		$this->captura('codigo_columna','varchar');
		$this->captura('valor','numeric');
		$this->captura('oficina','varchar');
		$this->captura('discapacitado','varchar');
		$this->captura('contrato_periodo','varchar');
		$this->captura('retiro_periodo','varchar');	
		$this->captura('edad','integer');	
		$this->captura('lugar','varchar');			
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarReportePrimaMinisterio(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPMINPRIMA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		$this->setParametro('id_gestion','id_gestion','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('fila','int4');
		$this->captura('tipo_documento','int4');
		$this->captura('ci','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('afp','varchar');
		$this->captura('nro_afp','varchar');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('apellido_casada','varchar');
		$this->captura('primer_nombre','varchar');
		$this->captura('otros_nombres','varchar');
		$this->captura('nacionalidad','varchar');
		$this->captura('fecha_nacimiento','text');
		$this->captura('sexo','int4');
		$this->captura('jubilado','int4');
		$this->captura('clasificacion_laboral','varchar');
		$this->captura('cargo','varchar');
		$this->captura('fecha_ingreso','text');
		$this->captura('modalidad_contrato','int4');
		$this->captura('fecha_finalizacion','text');
		$this->captura('horas_dia','int4');
		$this->captura('codigo_columna','varchar');
		$this->captura('valor','numeric');
		$this->captura('oficina','varchar');
		$this->captura('discapacitado','varchar');
		
		$this->captura('edad','integer');	
		$this->captura('lugar','varchar');		
		
					
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarReporteAguinaldoMinisterio(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPMINAGUI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		$this->setParametro('id_gestion','id_gestion','int4');
				
		//Definicion de la lista del resultado del query
        $this->captura('fila','int4');
        $this->captura('tipo_documento','int4');
        $this->captura('ci','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('afp','varchar');
        $this->captura('nro_afp','varchar');
        $this->captura('apellido_paterno','varchar');
        $this->captura('apellido_materno','varchar');
        $this->captura('apellido_casada','varchar');
        $this->captura('primer_nombre','varchar');
        $this->captura('otros_nombres','varchar');
        $this->captura('nacionalidad','varchar');
        $this->captura('fecha_nacimiento','text');
        $this->captura('sexo','int4');
        $this->captura('jubilado','int4');
        $this->captura('clasificacion_laboral','varchar');
        $this->captura('cargo','varchar');
        $this->captura('fecha_ingreso','text');
        $this->captura('modalidad_contrato','int4');
        $this->captura('fecha_finalizacion','text');
        $this->captura('horas_dia','int4');
        $this->captura('codigo_columna','varchar');
        $this->captura('valor','numeric');
        $this->captura('oficina','varchar');
        $this->captura('discapacitado','varchar');

        $this->captura('edad','integer');
        $this->captura('lugar','varchar');


        //Ejecuta la instruccion
		$this->armarConsulta();

		$this->ejecutarConsulta();
		
		
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarReporteSegAguinaldoMinisterio(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPSEGAGUI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		$this->setParametro('id_gestion','id_gestion','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('fila','int4');		
		$this->captura('ci','varchar');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');		
		$this->captura('nombre','varchar');		
		$this->captura('nacionalidad','varchar');
		$this->captura('fecha_nacimiento','text');
		$this->captura('sexo','varchar');
		$this->captura('cargo','varchar');
		$this->captura('fecha_ingreso','text');
		$this->captura('codigo_columna','varchar');
		$this->captura('valor','numeric');
		$this->captura('jubilado','integer');
		$this->captura('discapacitado','varchar');
		
					
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
		

	function listarReporteMinisterioCabecera(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPMINCABE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion	
		
		$this->setParametro('id_depto','id_depto','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('nombre_entidad','varchar');		
		$this->captura('nit','varchar');
		$this->captura('identificador_min_trabajo','varchar');
		$this->captura('identificador_caja_salud','varchar');
				
					
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();

		
		
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('nro_planilla','nro_planilla','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_depto','id_depto','integer');
		$this->setParametro('fecha_planilla','fecha_planilla','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('nro_planilla','nro_planilla','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_planilla','fecha_planilla','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function generarDescuentoCheque(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_GENDESCHE_PRO';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function ejecutarProcesoPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		if ($this->arreglo['accion'] == 'horasGenerar'){
			$this->transaccion='PLA_PLANIGENHOR_MOD';
		} else if ($this->arreglo['accion'] == 'horasValidar') {
			$this->transaccion='PLA_PLANIVALHOR_MOD';
		} else if ($this->arreglo['accion'] == 'columnasCalcular') {
			$this->transaccion='PLA_PLANICALCOL_MOD';
		} else if ($this->arreglo['accion'] == 'columnasValidar') {
			$this->transaccion='PLA_PLANIVALCOL_MOD';
		} else if ($this->arreglo['accion'] == 'presupuestosGenerar') {
			$this->transaccion='PLA_PLANIGENPRE_MOD';
		} else if ($this->arreglo['accion'] == 'presupuestosValidar') {
			$this->transaccion='PLA_PLANIVALPRE_MOD';
		} else if ($this->arreglo['accion'] == 'obligacionesGenerar') {
			$this->transaccion='PLA_PLANIGENOBLI_MOD';
		} else if ($this->arreglo['accion'] == 'obligacionesValidar') {
			$this->transaccion='PLA_PLANIVALOBLI_MOD';
		} else if ($this->arreglo['accion'] == 'obligacionesEnviar') {
			$this->transaccion='PLA_PLANIENVOBLI_MOD';
		}
		
		
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function siguienteEstadoPlanilla(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_planilla_ime';
        $this->transaccion='PLA_SIGEPLA_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function anteriorEstadoPlanilla(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_planilla_ime';
        $this->transaccion='PLA_ANTEPLA_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_plan_pago','id_plan_pago','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('operacion','operacion','varchar');
        
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('obs','obs','text');
		
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

	//Reporte Certificaciòn Presupuestaria Planilla(F.E.A) 28/02/2018
	function reporteCertificacionP(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_REPCERPRE_SEL';
		$this->tipo_procedimiento='SEL';

		//Define los parametros para la funcion
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');


		$this->captura('id_cp', 'int4');
		$this->captura('centro_costo', 'varchar');
		$this->captura('codigo_programa', 'varchar');
		$this->captura('codigo_proyecto', 'varchar');
		$this->captura('codigo_actividad', 'varchar');
		$this->captura('codigo_fuente_fin', 'varchar');
		$this->captura('codigo_origen_fin', 'varchar');

		$this->captura('codigo_partida', 'varchar');
		$this->captura('nombre_partida', 'varchar');
		$this->captura('codigo_cg', 'varchar');
		$this->captura('nombre_cg', 'varchar');
		$this->captura('precio_total', 'numeric');
		$this->captura('codigo_moneda', 'varchar');
		$this->captura('num_tramite', 'varchar');
		$this->captura('nombre_entidad', 'varchar');
		$this->captura('direccion_admin', 'varchar');
		$this->captura('unidad_ejecutora', 'varchar');
		$this->captura('firmas', 'varchar');
		$this->captura('justificacion', 'varchar');
		$this->captura('codigo_transf', 'varchar');
		$this->captura('unidad_solicitante', 'varchar');
		$this->captura('funcionario_solicitante', 'varchar');
		$this->captura('codigo_proceso', 'varchar');

		$this->captura('fecha_soli', 'date');
		$this->captura('gestion', 'integer');
		$this->captura('codigo_poa', 'varchar');
		$this->captura('codigo_descripcion', 'varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo($this->consulta);exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    //(f.e.a)13/3/2017 modificar datos poa de planilla
    function modificarObsPoa(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_planilla_ime';
        $this->transaccion='PLA_MODOBSPOA_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_planilla','id_planilla','int4');
        $this->setParametro('obs_poa','obs_poa','varchar');
        $this->setParametro('codigo_poa','codigo_poa','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPartidaObjetivo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_planilla_ime';
        $this->transaccion='PLA_PAR_OBJ_IME';
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Definicion de la lista del resultado del query
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('obs_poa','obs_poa','varchar');



        $this->captura('detalle_descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    //Reporte Certificaciòn Presupuestaria Planilla(F.E.A) 28/02/2018
    function reporteFuncionarioCatProgra(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_planilla_sel';
        $this->transaccion='PLA_REPCLACATPRO_SEL';
        $this->tipo_procedimiento='SEL';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->captura('codigo_categoria', 'varchar');
        $this->captura('presupuesto', 'varchar');
        $this->captura('desc_funcionario', 'varchar');
        $this->captura('cargo', 'varchar');
        $this->captura('oficina', 'varchar');
        $this->captura('codigo_moneda', 'varchar');
        $this->captura('num_tramite', 'varchar');

        $this->captura('nombre_entidad', 'varchar');
        $this->captura('direccion_admin', 'varchar');
        $this->captura('unidad_ejecutora', 'varchar');
        $this->captura('firmas', 'varchar');
        $this->captura('justificacion', 'varchar');
        $this->captura('codigo_transf', 'varchar');
        $this->captura('unidad_solicitante', 'varchar');
        $this->captura('funcionario_solicitante', 'varchar');
        $this->captura('codigo_proceso', 'varchar');

        $this->captura('fecha_soli', 'date');
        $this->captura('gestion', 'integer');
        $this->captura('codigo_poa', 'varchar');
        $this->captura('codigo_descripcion', 'varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>