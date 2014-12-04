CREATE OR REPLACE FUNCTION plani.f_fun_inicio_planilla_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   JRR
*  DESC:    funcion que actualiza los estados despues del registro de un siguiente en planilla
*  Fecha:   17/10/2014
*
*/

DECLARE

	v_nombre_funcion   	 text;
    v_resp    			 varchar;
    v_mensaje 			 varchar;
    
    v_planilla 			 record;
    v_monto_ejecutar_mo  numeric;
    v_empleados			 record;
    v_columnas			 record;
    v_cantidad_horas_mes integer;
    v_suma_horas			integer;
    v_suma_sueldo			numeric;
    v_suma_porcentaje		numeric;
    v_id_horas_trabajadas	integer;
   
	
    
BEGIN

	 v_nombre_funcion = 'plani.f_fun_inicio_planilla_wf';
    
     select pla.*, pe.fecha_ini, pe.fecha_fin,tp.calculo_horas
      into v_planilla
      from plani.tplanilla pla
      inner join plani.ttipo_planilla tp
      	on tp.id_tipo_planilla = pla.id_tipo_planilla
      left join param.tperiodo pe on pe.id_periodo = pla.id_periodo 
      where id_proceso_wf = p_id_proceso_wf;
          
    -----------------------------------------------------------------------------------
    -- validacion del prorrateo--  (con el codigo actual de estado antes de cambiarlo)   
    -----------------------------------------------------------------------------------
          
     IF p_codigo_estado  in ('registro_horas')  THEN              
            v_resp = (select plani.f_plasue_generar_horas(v_planilla.id_planilla,p_id_usuario));
            
     elsif (p_codigo_estado  in ('calculo_columnas')) then
     	update plani.tplanilla set requiere_calculo = 'no'
           where id_planilla =  v_planilla.id_planilla; 
     	if (v_planilla.calculo_horas = 'si') then
            v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_planilla.fecha_ini)::integer;
            	
                for v_empleados in (select funpla.*,fun.desc_funcionario1 as nombre from plani.tfuncionario_planilla funpla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = funpla.id_funcionario
                                    where id_planilla = v_planilla.id_planilla)loop
            						
                    select sum(horas_normales)::integer, round(sum(sueldo / v_cantidad_horas_mes * horas_normales),2)
                    into v_suma_horas, v_suma_sueldo
                    from plani.thoras_trabajadas
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla;
            		
                    if (v_suma_horas > v_cantidad_horas_mes)then
                        raise exception 'La cantidad de horas trabajadas para el empleado : % , superan las : % horas',
                                        v_empleados.nombre,v_cantidad_horas_mes;
                    end if;
            		
                    if (v_suma_horas < 0 )then
                        raise exception 'La cantidad de horas trabajadas para el empleado : % , es 0 o menor a 0',
                                        v_empleados.nombre;
                    end if;        		
            		
                    update plani.thoras_trabajadas set
                        porcentaje_sueldo = (round((sueldo / v_cantidad_horas_mes * horas_normales),2) / v_suma_sueldo) * 100
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla; 
        			
                    select sum(porcentaje_sueldo),max(id_horas_trabajadas)
                    into v_suma_porcentaje,v_id_horas_trabajadas
                    from plani.thoras_trabajadas
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla; 
        			
                    if (v_suma_porcentaje != 100 ) then
                        update plani.thoras_trabajadas set
                            porcentaje_sueldo = porcentaje_sueldo + (100 - v_suma_porcentaje)
                        where id_horas_trabajadas = v_id_horas_trabajadas; 
                    end if;
            		
            		
                end loop; 
            end if;
        	--calcula columas despues de validar las horas
            v_resp = (select plani.f_planilla_calcular(v_planilla.id_planilla,p_id_usuario));
            
     elsif (p_codigo_estado  in ('calculo_validado')) then
      		
      		if (v_planilla.requiere_calculo = 'si') then
      			raise exception 'Esta planilla debe ser recalculada antes de validar el calculo';
      		end if;
      		
     		for v_empleados in (select * 
            					from plani.tfuncionario_planilla 
                                where id_planilla = v_planilla.id_planilla) loop
            	for v_columnas in (	select db.id_descuento_bono
                					from plani.tcolumna_valor cv
                                    inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                                    inner join plani.tdescuento_bono db on tc.id_tipo_columna = db.id_tipo_columna and
                                    								db.id_funcionario = v_empleados.id_funcionario and db.estado_reg = 'activo'
                                    where cv.id_funcionario_planilla = v_empleados.id_funcionario_planilla and
                                    	tc.tipo_descuento_bono = 'cantidad_cuotas') loop
                	update plani.tdescuento_bono
                    	set monto_total = monto_total - valor_por_cuota
                    where id_descuento_bono = v_columnas.id_descuento_bono;
                end loop;
            end loop;
            
     elsif (p_codigo_estado  in ('presupuestos')) then  
         
     	v_resp = (select plani.f_prorratear_pres_cos_empleados(v_planilla.id_planilla, 'presupuestos', p_id_usuario));            
        v_resp = (select plani.f_consolidar_pres_cos(v_planilla.id_planilla, 'presupuestos',p_id_usuario)); 
     
     elsif (p_codigo_estado  in ('obligaciones')) then  
              
     	v_resp = (select plani.f_generar_obligaciones(v_planilla.id_planilla, p_id_usuario));        	 
        	        
     END IF;     
        
    -- actualiza estado en la solicitud
    update plani.tplanilla  t set 
       id_estado_wf =  p_id_estado_wf,
       estado = p_codigo_estado,
       id_usuario_mod=p_id_usuario,
       id_usuario_ai = p_id_usuario_ai,
       usuario_ai = p_usuario_ai,
       fecha_mod=now()                   
    where id_proceso_wf = p_id_proceso_wf;   

	RETURN   TRUE;

EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;