CREATE OR REPLACE FUNCTION plani.ft_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
  /**************************************************************************
   SISTEMA:		Sistema de Planillas
   FUNCION: 		plani.ft_reporte_sel
   DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.treporte'
   AUTOR: 		 (admin)
   FECHA:	        17-01-2014 22:07:28
   COMENTARIOS:
  ***************************************************************************
   HISTORIAL DE MODIFICACIONES:

   DESCRIPCION:
   AUTOR:
   FECHA:
  ***************************************************************************/

  DECLARE

    v_consulta    		varchar;
    v_parametros  		record;
    v_nombre_funcion   	text;
    v_resp				varchar;

    v_ordenar_por		varchar;
    v_where				varchar;
	v_tipo_contrato		varchar;

    --Reporte General
    v_mes				integer;
    v_fechas			record;
    v_id_gestion 		integer;
    v_filtro			varchar = '';

    --categoria programatica
    v_funcionario			record;
    v_asignacion			record;
    v_codigo_pres			varchar = '';
    v_cont_pres				integer = 0;
    v_id_funcionario		integer = -1;
  BEGIN

    v_nombre_funcion = 'plani.ft_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PLA_REPO_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		admin
     #FECHA:		17-01-2014 22:07:28
    ***********************************/

    if(p_transaccion='PLA_REPO_SEL')then

      begin
        --Sentencia de la consulta
        v_consulta:='select
						repo.id_reporte,
						repo.id_tipo_planilla,
						repo.numerar,
						repo.hoja_posicion,
						repo.mostrar_nombre,
						repo.mostrar_codigo_empleado,
						repo.mostrar_doc_id,
						repo.mostrar_codigo_cargo,
						repo.agrupar_por,
						repo.ordenar_por,
						repo.estado_reg,
						repo.ancho_utilizado,
						repo.ancho_total,
						repo.titulo_reporte,
						repo.fecha_reg,
						repo.id_usuario_reg,
						repo.id_usuario_mod,
						repo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						repo.control_reporte,
						repo.tipo_reporte
						from plani.treporte repo
						inner join segu.tusuario usu1 on usu1.id_usuario = repo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repo.id_usuario_mod
				        where  ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
     #TRANSACCION:  'PLA_REPO_CONT'
     #DESCRIPCION:	Conteo de registros
     #AUTOR:		admin
     #FECHA:		17-01-2014 22:07:28
    ***********************************/

    elsif(p_transaccion='PLA_REPO_CONT')then

      begin
        --Sentencia de la consulta de conteo de registros
        v_consulta:='select count(id_reporte)
					    from plani.treporte repo
					    inner join segu.tusuario usu1 on usu1.id_usuario = repo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repo.id_usuario_mod
					    where ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;

        --Devuelve la respuesta
        return v_consulta;

      end;
    /*********************************
 	#TRANSACCION:  'PLA_REPOMAES_SEL'
 	#DESCRIPCION:	Reporte Generico de planilla de sueldos maestro
 	#AUTOR:		admin
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

    elsif(p_transaccion='PLA_REPOMAES_SEL')then

      begin


        --Sentencia de la consulta
        v_consulta:='select
            				repo.numerar,
                            repo.hoja_posicion,
                            repo.mostrar_nombre,
                            repo.mostrar_codigo_empleado,
                            repo.mostrar_doc_id,
                            repo.mostrar_codigo_cargo,
                            repo.agrupar_por,
                            repo.ordenar_por,
                            repo.titulo_reporte,

                            plani.nro_planilla,
                            per.periodo,
                            ges.gestion,
                            uo.nombre_unidad,
                            dep.nombre_corto,
                            (select count(*) from plani.treporte_columna where id_reporte = repo.id_reporte)::integer

						from plani.tplanilla plani
						inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
                        left join orga.tuo uo on uo.id_uo = plani.id_uo
                        inner join param.tdepto dep on dep.id_depto = plani.id_depto
				        where ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
  #TRANSACCION:  'PLA_REPOPREV_SEL'
  #DESCRIPCION:	Reporte de previsiones
  #AUTOR:		admin
  #FECHA:		17-01-2014 22:07:28
 ***********************************/

    elsif(p_transaccion='PLA_REPOPREV_SEL')then

      begin
        v_where = '';
        if (v_parametros.id_tipo_contrato <> -1) then
          v_where = v_where || ' and tc.id_tipo_contrato = ' || v_parametros.id_tipo_contrato;
        else
          v_where = v_where || ' and tc.id_tipo_contrato IN (1,4)';
        end if;

        if (v_parametros.id_uo <> -1) then
          v_where = v_where || ' and ger.id_uo = ' || v_parametros.id_uo;
        end if;


        raise notice '%',v_where;
        --Sentencia de la consulta
        v_consulta:='with detalle as(

              select
                              ger.nombre_unidad as Gerencia,
                              car.nombre as NombreCargo,
                              datos.desc_funcionario2 as NombreCompleto,

                              (case when uofun.id_funcionario = 10 then
                                  ''27/12/2013''::date
                              else
                                  plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)
                              END)  as FechaIncorp,

                              (case when uofun.id_funcionario = 10 then
                                   (''' || v_parametros.fecha ||'''::date - ''27/12/2013''::date) + 1
                              else
                                 (''' || v_parametros.fecha ||'''::date - plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)) + 1 - plani.f_get_dias_licencia_funcionario(datos.id_funcionario,''' || v_parametros.fecha ||'''::Date)
                              END)::integer  as diastrabajados,

                          (case when ' || v_parametros.id_uo ||' <>-1 then
                              ger.nombre_unidad
                          ELSE
                              ''Boliviana de Aviacion''::varchar
                          END)  as NombreDepartamento,
                          (case when ' || v_parametros.id_tipo_contrato ||'<>-1 then
                              tc.nombre
                          ELSE
                              ''TODOS''::varchar
                          END)  as NombreContrato,
                          ''' || v_parametros.fecha ||'''::Date as FechaPrev ,
                          orga.f_get_haber_basico_a_fecha(escala.id_escala_salarial,''' || (case when v_parametros.fecha > now()::date then now()::date else v_parametros.fecha end) ||'''::date) as haberbasico,
                          fun.antiguedad_anterior,
                          plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) as fechaAntiguedad,
                          (case when ofi.frontera =''si'' then
                          	0.2
                          else
                          	0
                          end) as frontera,
                          pre.descripcion as presupuesto
                          from orga.tuo_funcionario uofun
                          INNER JOIN orga.vfuncionario datos ON datos.id_funcionario=uofun.id_funcionario
                          inner join orga.tcargo car ON car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo and
                          	cp.fecha_ini <= ''' || v_parametros.fecha ||'''::date and cp.id_gestion = (select po_id_gestion from param.f_get_periodo_gestion(''' || v_parametros.fecha ||'''::date))
                          left join pre.vpresupuesto_cc pre on pre.id_centro_costo = cp.id_centro_costo
                          inner join orga.toficina ofi ON ofi.id_oficina = car.id_oficina
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tescala_salarial escala ON escala.id_escala_salarial=car.id_escala_salarial
                          inner join orga.tfuncionario fun on fun.id_funcionario = datos.id_funcionario
                          inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,''' || v_parametros.fecha ||'''::date)
                          where uofun.estado_reg != ''inactivo'' and uofun.fecha_asignacion <= ''' || v_parametros.fecha ||'''::date and
                          (uofun.fecha_finalizacion >= ''' || v_parametros.fecha ||'''::date or uofun.fecha_finalizacion is null) ' || v_where ||'
                          order by ger.prioridad::INTEGER,datos.desc_funcionario2)

                          select Gerencia::varchar,NombreCargo::varchar,NombreCompleto::text,
                          round(haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior),2) as HaberBasico,
                          to_char(FechaIncorp::date,''DD/MM/YYYY'')::varchar,
                          diastrabajados::integer,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior))/365,8) as indemdia,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior))/365,8)*diastrabajados as Indem,
                          presupuesto
                          from detalle
                          where diastrabajados >= 90';

        --raise exception '%',v_consulta;
        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
     #TRANSACCION:  'PLA_REPOMAESBOL_SEL'
     #DESCRIPCION:	Reporte Generico de boleta de sueldos maestro
     #AUTOR:		admin
     #FECHA:		17-01-2014 22:07:28
    ***********************************/

    elsif(p_transaccion='PLA_REPOMAESBOL_SEL')then

      begin
        if (not exists(	select 1
                         from plani.treporte r
                         where r.id_tipo_planilla = v_parametros.id_tipo_planilla and r.estado_reg = 'activo' and
                               r.tipo_reporte = 'boleta')) then
          raise exception 'No existe una configurado un reporte de boleta de pago para este tipo de planilla';
        end if;

        --Sentencia de la consulta
        v_consulta:='select
                            repo.titulo_reporte,
                            plani.nro_planilla,
                            param.f_literal_periodo(per.id_periodo),
                            ges.gestion,
                            emp.nit,
                            ent.identificador_caja_salud::varchar as numero_patronal,
                            fun.desc_funcionario1::varchar as nombre,
                            (case when sum(ht.id_horas_trabajadas) is null then
                            	car.nombre
                            else
                            	pxp.list(carht.nombre || ''  ('' ||round(ht.horas_normales/8,0) || '' dias)'')
                            end)::varchar as cargo,
                            (case when sum(ht.id_horas_trabajadas) is null then
                            	car.codigo
                            else
                            	pxp.list(carht.codigo)
                            end)::varchar as item,
                            fun.codigo as codigo_empleado,
                            sum(ht.horas_normales)::integer,
                            fun.ci,fun.id_funcionario

						from plani.tplanilla plani
                        inner join param.tdepto dep on  dep.id_depto = plani.id_depto
                        inner join param.tentidad ent on  ent.id_entidad = dep.id_entidad
						inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
                        inner join param.tempresa emp on emp.estado_reg = ''activo''
                        inner join plani.tfuncionario_planilla planifun  on planifun.id_planilla = plani.id_planilla
                        inner join orga.vfuncionario fun on fun.id_funcionario = planifun.id_funcionario
				        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = planifun.id_uo_funcionario
				        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
				        left join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = planifun.id_funcionario_planilla
				        left join orga.tuo_funcionario uofunht on uofunht.id_uo_funcionario = ht.id_uo_funcionario
				        left join orga.tcargo carht on carht.id_cargo = uofunht.id_cargo
				        where repo.tipo_reporte = ''boleta'' and ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' group by
							repo.titulo_reporte,
							plani.nro_planilla,
                            per.id_periodo,
                            ges.gestion,
                            emp.nit,
                            fun.desc_funcionario1,
                            car.nombre,
                            car.codigo,
                            fun.codigo,
                            fun.ci,
                            fun.id_funcionario,
                            ent.identificador_min_trabajo
			';


        return v_consulta;

      end;
    /*********************************
     #TRANSACCION:  'PLA_REPODETBOL_SEL'
     #DESCRIPCION:	Reporte Generico de planilla de sueldos detalle
     #AUTOR:		admin
     #FECHA:		17-01-2014 22:07:28
    ***********************************/

    elsif(p_transaccion='PLA_REPODETBOL_SEL')then

      begin


        --Sentencia de la consulta
        v_consulta:='select

                            repcol.titulo_reporte_superior,
                            repcol.titulo_reporte_inferior,
                            repcol.tipo_columna,
                            colval.codigo_columna,
                            colval.valor

						from plani.tfuncionario_planilla planifun
                        inner join plani.tplanilla plani on plani.id_planilla = planifun.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = planifun.id_funcionario_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte and
                        											repcol.codigo_columna = colval.codigo_columna

				        where repo.tipo_reporte = ''boleta'' and repcol.estado_reg = ''activo'' and colval.estado_reg = ''activo'' and ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by repcol.tipo_columna,repcol.orden asc';

        --Devuelve la respuesta
        return v_consulta;

      end;



    /*********************************
 	#TRANSACCION:  'PLA_REPODET_SEL'
 	#DESCRIPCION:	Reporte Generico de planilla de sueldos detalle
 	#AUTOR:		admin
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

    elsif(p_transaccion='PLA_REPODET_SEL')then

      begin
        --para obtener la columna de ordenacion para el reporte
        execute	'select repo.ordenar_por
           			from plani.tplanilla plani
					inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla
           			where '||v_parametros.filtro into v_ordenar_por;
        if (v_ordenar_por = 'nombre')then
          v_ordenar_por = 'fun.desc_funcionario2';
        elsif (v_ordenar_por = 'doc_id') then
          v_ordenar_por = 'fun.ci';
        elsif (v_ordenar_por = 'codigo_cargo') then
          v_ordenar_por = 'car.codigo';
        else
          v_ordenar_por = 'fun.codigo';
        end if;

		if pxp.f_existe_parametro(p_tabla , 'tipo_contrato')then
        	v_tipo_contrato = 'tcon.codigo = '''||v_parametros.tipo_contrato||''' and ';
        else
        	v_tipo_contrato = '';
      	end if;

        --Sentencia de la consulta
        v_consulta:='select
                            fun.id_funcionario,
                            substring(fun.desc_funcionario2 from 1 for 38),
                            cat.descripcion::varchar,
                            car.codigo,
                            fun.ci,
                            uo.id_uo,
                            uo.nombre_unidad,
                            repcol.sumar_total,
                            repcol.ancho_columna,
                            repcol.titulo_reporte_superior,
                            repcol.titulo_reporte_inferior,
                            colval.codigo_columna,
                            colval.valor,
                            tcon.nombre
						from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte and
                        											repcol.codigo_columna = colval.codigo_columna
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        left join orga.tcargo_presupuesto cp on car.id_cargo = cp.id_cargo and cp.id_gestion = 15
                        left join pre.vpresupuesto_cc pre on pre.id_centro_costo = cp.id_centro_costo
                        left join pre.tcategoria_programatica cat on cat.id_categoria_programatica = pre.id_categoria_prog
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL,NULL)
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = car.id_tipo_contrato
				        where '||v_tipo_contrato;

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by uo.prioridad::integer, uo.id_uo,' || v_ordenar_por || ', fun.id_funcionario,repcol.orden asc';
		raise notice 'v_consulta: %', v_consulta;
        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
 	#TRANSACCION:  'PLA_REPOACIT_SEL'
 	#DESCRIPCION:	Reporte Planilla actualizada Item
 	#AUTOR:		admin
 	#FECHA:		13-09-2016 17:90:28
	***********************************/

    elsif(p_transaccion='PLA_REPOACIT_SEL')then

      begin
        v_where = '';
        if (v_parametros.id_tipo_contrato <> -1) then
          v_where = v_where || ' and tc.id_tipo_contrato = ' || v_parametros.id_tipo_contrato;
        end if;

        if (v_parametros.id_uo <> -1) then
          v_where = v_where || ' and ger.id_uo = ' || v_parametros.id_uo;
        end if;
        --raise notice '%',v_where;

        --Sentencia de la consulta
        v_consulta:='SELECT es.nombre AS escala,
    					i.nombre AS cargo,
    					i.codigo AS nro_item,
    					COALESCE(initcap(e.desc_funcionario2), ''ACEFALO''::text) AS nombre_empleado,
                        	CASE
           			 			WHEN per.genero::text = ANY (ARRAY[''varon''::character varying,''VARON''::character varying, ''Varon''::character varying]::text[]) THEN ''M''::text
            					WHEN per.genero::text = ANY (ARRAY[''mujer''::character varying,''MUJER''::character varying, ''Mujer''::character varying]::text[]) THEN ''F''::text
           					ELSE ''''::text
        					END::character varying AS genero,es.haber_basico,
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(ha.id_uo_funcionario, ha.id_funcionario, ha.fecha_asignacion), ''' || v_parametros.fecha ||'''::date, f.antiguedad_anterior), 2)
           		 			ELSE NULL::numeric
        					END AS bono_antiguedad,
        					CASE
            					WHEN ofi.frontera = ''si'' AND e.id_funcionario IS NOT NULL THEN es.haber_basico * 0.2
            				ELSE NULL::numeric
        					END AS bono_frontera,es.haber_basico +
        					CASE
            				WHEN ofi.frontera = ''si'' AND e.id_funcionario IS NOT NULL THEN es.haber_basico * 0.2
            				ELSE 0::numeric
        					END +
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(ha.id_uo_funcionario, ha.id_funcionario, ha.fecha_asignacion), ''' || v_parametros.fecha ||'''::date, f.antiguedad_anterior), 2)
            				ELSE 0::numeric
        					END AS sumatoria,
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN orga.f_get_fechas_ini_historico(e.id_funcionario, ''' || v_parametros.fecha ||'''::date)
            				ELSE NULL::text
        					END AS "case",
    						per.ci,
    						per.expedicion,
    						lu.codigo,
   							ofi.nombre,
    						((ger.codigo::text || '' - ''::text) || ger.nombre_unidad::text)::character
        					varying AS "varchar",
    						dep.nombre_unidad,
    						i.id_tipo_contrato,
                            ger.prioridad AS prioridad_gerencia,
                            ger.nombre_unidad AS gerencia,
                            dep.prioridad AS prioridad_depto,
                            --dep.nombre_unidad AS departamento,
                            (case when i.id_uo = any (string_to_array(btrim(''9979,''||orga.f_get_arbol_uo(9979),'',''),'','')::integer[]) then orga.f_get_depto_arbol_uo(i.id_uo) else dep.nombre_unidad end)::varchar AS departamento,
                            (case
                            when lower(ger.nombre_unidad) like ''%cobija%'' then
                            	''5.CIJ''
                            when i.codigo = ''0'' then
                            	''6.EVE''
                            when ca.codigo = ''SUPER'' and (f.id_funcionario != 10 or f.id_funcionario is null)  then
                            	''3.ESP''
                            when (catp.desc_programa ilike ''%ADM%'' or (ca.codigo = ''SUPER'' and f.id_funcionario = 10)) then
                            	''1.ADM''
                            when catp.desc_programa ilike ''%OPE%'' then
                            	''2.OPE''
                            when catp.desc_programa ilike ''%COM%'' then
                            	''4.COM''
                            else
                            	''SINCAT''
                            end
                            )::varchar as categoria_programatica,
                            to_char(ha.fecha_finalizacion,''DD/MM/YYYY'')::varchar as fecha_finalizacion
							FROM orga.tcargo i
                            inner join param.tgestion ges on (''01/01/''||ges.gestion)::date <= ''' || v_parametros.fecha ||'''::date and
                            						(''31/12/''||ges.gestion)::date >= ''' || v_parametros.fecha ||'''::date
                            LEFT JOIN orga.tcargo_presupuesto cp on cp.id_cargo = i.id_cargo and cp.id_gestion = ges.id_gestion
                            										and cp.estado_reg = ''activo'' and (cp.fecha_fin >= ''' || v_parametros.fecha ||'''::date or cp.fecha_fin is NULL)
                            LEFT JOIN pre.tpresupuesto cc on cc.id_presupuesto = cp.id_centro_costo

                            LEFT JOIN pre.vcategoria_programatica catp on catp.id_categoria_programatica = cc.id_categoria_prog
                            JOIN orga.tescala_salarial es ON es.id_escala_salarial = i.id_escala_salarial
                            JOIN orga.tcategoria_salarial ca ON ca.id_categoria_salarial = es.id_categoria_salarial
   							LEFT JOIN orga.tuo_funcionario ha ON ha.id_cargo = i.id_cargo AND ha.estado_reg::text = ''activo''::text AND
                            		(ha.fecha_finalizacion IS NULL OR ha.fecha_finalizacion >= ''' || v_parametros.fecha ||'''::date) AND ha.fecha_asignacion <= ''' || v_parametros.fecha ||'''::date AND
                                    ha.tipo=''oficial''
                            LEFT JOIN orga.vfuncionario e ON e.id_funcionario = ha.id_funcionario
                            LEFT JOIN orga.tfuncionario f ON e.id_funcionario = f.id_funcionario
                            LEFT JOIN segu.tpersona per ON per.id_persona = f.id_persona
                            LEFT JOIN orga.toficina ofi ON i.id_oficina = ofi.id_oficina
                            LEFT JOIN param.tlugar lu ON lu.id_lugar = ofi.id_lugar
   							JOIN orga.f_get_uo_prioridades(9418) uo(out_id_uo, out_nombre_unidad, out_prioridad) ON uo.out_id_uo = i.id_uo
   							JOIN orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uo.out_id_uo, NULL::integer, NULL::date)
   							JOIN orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uo.out_id_uo, NULL::integer, NULL::date)
							WHERE i.estado_reg::text = ''activo''::text AND (i.id_tipo_contrato = 1 OR
                            	(i.id_tipo_contrato = 4 and e.id_funcionario is not null)) AND  ';

          /*v_consulta = '
          				SELECT

                        es.nombre AS escala,
    					i.nombre AS cargo,
    					i.codigo AS nro_item,
    					COALESCE(initcap(e.desc_funcionario2), ''ACEFALO''::text) AS nombre_empleado,
                        	CASE
           			 			WHEN per.genero::text = ANY (ARRAY[''varon''::character varying,''VARON''::character varying, ''Varon''::character varying]::text[]) THEN ''M''::text
            					WHEN per.genero::text = ANY (ARRAY[''mujer''::character varying,''MUJER''::character varying, ''Mujer''::character varying]::text[]) THEN ''F''::text
           					ELSE ''''::text
        					END::character varying AS genero,
                            es.haber_basico,
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(ha.id_uo_funcionario, ha.id_funcionario, ha.fecha_asignacion), ''' || v_parametros.fecha ||'''::date, f.antiguedad_anterior), 2)
           		 			ELSE NULL::numeric
        					END AS bono_antiguedad,
        					CASE
            					WHEN ofi.frontera = ''si'' AND e.id_funcionario IS NOT NULL THEN es.haber_basico * 0.2
            				ELSE NULL::numeric
        					END AS bono_frontera,es.haber_basico +
        					CASE
            				WHEN ofi.frontera = ''si'' AND e.id_funcionario IS NOT NULL THEN es.haber_basico * 0.2
            				ELSE 0::numeric
        					END +
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(ha.id_uo_funcionario, ha.id_funcionario, ha.fecha_asignacion), ''' || v_parametros.fecha ||'''::date, f.antiguedad_anterior), 2)
            				ELSE 0::numeric
        					END AS sumatoria,
        					CASE
            					WHEN e.id_funcionario IS NOT NULL THEN orga.f_get_fechas_ini_historico(e.id_funcionario, ''' || v_parametros.fecha ||'''::date)
            				ELSE NULL::text
        					END AS "case",
    						per.ci,
    						per.expedicion,
    						lu.codigo,
   							ofi.nombre,
    						((ger.codigo::text || '' - ''::text) || ger.nombre_unidad::text)::varchar AS "varchar",
    						dep.nombre_unidad,
    						i.id_tipo_contrato,
                            ger.prioridad AS prioridad_gerencia,
                            ger.nombre_unidad AS gerencia,
                            dep.prioridad AS prioridad_depto,
                            --dep.nombre_unidad AS departamento,
                            orga.f_get_depto_arbol_uo(tuo1.id_uo)::varchar as departamento,
                            (case
                            when lower(ger.nombre_unidad) like ''%cobija%'' then
                            	''5.CIJ''
                            when i.codigo = ''0'' then
                            	''6.EVE''
                            when ca.codigo = ''SUPER'' and f.id_funcionario != 10 then
                            	''3.ESP''
                            when (catp.desc_programa ilike ''%ADM%'' or (ca.codigo = ''SUPER'' and f.id_funcionario = 10)) then
                            	''1.ADM''
                            when catp.desc_programa ilike ''%OPE%'' then
                            	''2.OPE''
                            when catp.desc_programa ilike ''%COM%'' then
                            	''4.COM''
                            else
                            	''SINCAT''
                            end
                            )::varchar as categoria_programatica,
                            to_char(ha.fecha_finalizacion,''DD/MM/YYYY'')::varchar as fecha_finalizacion,
                            tnor.numero_nivel as nivel,
                            (''(''||ttc.codigo||'')''||ttc.descripcion)::varchar as centro_costo,
                            catp.codigo_categoria::varchar as categoria_codigo
							FROM orga.tcargo i
                            inner join param.tgestion ges on (''01/01/''||ges.gestion)::date <= ''' || v_parametros.fecha ||'''::date and
                            						(''31/12/''||ges.gestion)::date >= ''' || v_parametros.fecha ||'''::date
                            LEFT JOIN orga.tcargo_presupuesto cp on cp.id_cargo = i.id_cargo and cp.id_gestion = ges.id_gestion
                            										and cp.estado_reg = ''activo'' and (cp.fecha_fin >= ''' || v_parametros.fecha ||'''::date or cp.fecha_fin is NULL)
                            LEFT JOIN pre.tpresupuesto cc on cc.id_presupuesto = cp.id_centro_costo

                            LEFT JOIN pre.vcategoria_programatica catp on catp.id_categoria_programatica = cc.id_categoria_prog
                            INNER JOIN orga.tescala_salarial es ON es.id_escala_salarial = i.id_escala_salarial
                            INNER JOIN orga.tcategoria_salarial ca ON ca.id_categoria_salarial = es.id_categoria_salarial
   							LEFT JOIN orga.tuo_funcionario ha ON ha.id_cargo = i.id_cargo AND ha.estado_reg::text = ''activo''::text AND
                            		(ha.fecha_finalizacion IS NULL OR ha.fecha_finalizacion >= ''' || v_parametros.fecha ||'''::date) AND ha.fecha_asignacion <= ''' || v_parametros.fecha ||'''::date AND
                                    ha.tipo=''oficial''

                            LEFT join param.tcentro_costo tcc on tcc.id_centro_costo = cp.id_centro_costo --and tcc.id_gestion = 16
							LEFT join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc

                            LEFT JOIN orga.vfuncionario e ON e.id_funcionario = ha.id_funcionario
                            LEFT JOIN orga.tfuncionario f ON f.id_funcionario = e.id_funcionario
                            LEFT JOIN segu.tpersona per ON per.id_persona = f.id_persona
                            LEFT JOIN orga.toficina ofi ON ofi.id_oficina =  i.id_oficina
                            LEFT JOIN param.tlugar lu ON lu.id_lugar = ofi.id_lugar
   							--JOIN orga.f_get_uo_prioridades(9418) uo(out_id_uo, out_nombre_unidad, out_prioridad) ON uo.out_id_uo = i.id_uo
                            inner join unnest(string_to_array(btrim(''9419,''||orga.f_get_arbol_uo(9419),'',''),'','')::integer[]) tu2 on tu2.* = i.id_uo
                            inner join orga.tuo tuo1 on tuo1.id_uo = tu2.*
                            LEFT JOIN orga.tnivel_organizacional tnor on tnor.id_nivel_organizacional = tuo1.id_nivel_organizacional
   							LEFT JOIN orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(tuo1.id_uo, NULL::integer, NULL::date)
   							LEFT JOIN orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(tuo1.id_uo, NULL::integer, NULL::date)
							WHERE i.estado_reg::text = ''activo''::text AND (i.id_tipo_contrato = 1 OR
                            	(i.id_tipo_contrato = 4 and e.id_funcionario is not null)) AND ';*/


        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        if (v_parametros.agrupar_por = 'Organigrama') then
          v_consulta:=v_consulta||'ORDER BY categoria_programatica, uo.out_prioridad, es.haber_basico DESC, e.desc_funcionario2';
          --v_consulta = v_consulta||'ORDER BY categoria_programatica, centro_costo, es.haber_basico DESC , tnor.numero_nivel';
        elsif (v_parametros.agrupar_por = 'Regional') then
          v_consulta:=v_consulta||'ORDER BY categoria_programatica, lu.codigo, e.desc_funcionario2';
        else
          v_consulta:=v_consulta||'ORDER BY categoria_programatica, lu.codigo,ofi.nombre, e.desc_funcionario2';
        end if;

        /*if (v_parametros.agrupar_por = 'Organigrama') then
          v_consulta:=v_consulta||'ORDER BY tuo.categoria_programatica, tuo.centro_costo, tuo.haber_basico DESC , tuo.nivel, tuo.haber_basico DESC';
        end if;*/


        --Devuelve la respuesta
        raise notice '%',v_consulta;
        return v_consulta;

      end;
    /*********************************
 	#TRANSACCION:  'PLA_REP_CONTACT_SEL'
 	#DESCRIPCION:	reporte de datos de contacto Funcionarios
 	#AUTOR:		f.e.a
 	#FECHA:		31-7-2018 17:29:14
	***********************************/

	elsif(p_transaccion='PLA_REP_CONTACT_SEL')then

    	begin

        	create temp table tt_repo_filtro(
              id_funcionario integer,
              fecha_asignacion date
       		)on commit drop;


            v_consulta = 'insert into tt_repo_filtro
            select  tuo.id_funcionario, max(tuo.fecha_asignacion)
            from orga.tuo_funcionario tuo
            group by  tuo.id_funcionario';

            if(v_parametros.oficina != '0')then
            	v_filtro = ' and tl.id_lugar in ('||v_parametros.oficina||')';
            end if;

            v_mes = date_part('month', current_date);

            select tg.id_gestion
            into v_id_gestion
            from param.tgestion tg
            where tg.gestion = date_part('year', current_date);

            select tp.fecha_ini, tp.fecha_fin
            into v_fechas
            from param.tperiodo tp
            where tp.periodo = v_mes and tp.id_gestion = v_id_gestion;


    		--Sentencia de la consulta
			v_consulta:='select distinct (''(''||tuo.codigo||'')''||tuo.nombre_unidad)::varchar as gerencia,
             ttc.nombre as contrato ,
             tf.desc_funcionario2::varchar AS desc_funcionario,
             tc.nombre as cargo,
             tl.nombre as lugar,
             tl.codigo,
             tf.email_empresa,
             tpe.correo,
             (tpe.telefono1 || coalesce('' - ''||tpe.telefono2, ''''))::varchar as telefonos,
             (tpe.celular1 || coalesce('' - ''||tpe.celular2, ''''))::varchar as celulares,
             (tpe.ci ||'' ''||tpe.expedicion)::varchar as documento,
             tl.nombre as lugar_trabajo
             from orga.vfuncionario_persona tf
             inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario
             AND current_date < coalesce (uof.fecha_finalizacion, ''31/12/9999''::date) /*AND
             uof.fecha_asignacion  in (select fecha_asignacion
                                                        from tt_repo_filtro where id_funcionario = tf.id_funcionario)*/
             inner JOIN orga.tuo tuo on tuo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,uof.id_funcionario,current_date)
             inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo
             inner join param.tlugar tl on tl.id_lugar = tc.id_lugar
             inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato
             INNER JOIN segu.tpersona tpe ON tpe.id_persona = tf.id_persona
             where tc.estado_reg = ''activo'' and ttc.codigo in (''PLA'',''EVE'',''PEXT'', ''PEXTE'') and uof.tipo IN (''oficial'') '||v_filtro||'
             order by tl.codigo, gerencia, desc_funcionario';

            RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'PLA_REP_CONTACT_SEL'
 	#DESCRIPCION:	Reporte Presupuesto por categoria Programatica
 	#AUTOR:		f.e.a
 	#FECHA:		10-8-2018 17:29:14
	***********************************/

	elsif(p_transaccion='PLA_REP_PRE_CP_SEL')then

    	begin

        	create temp table tt_plani_filtro (
    			id_uo_funcionario 			integer,
                id_cargo					integer,
                id_funcionario_planilla 	integer,
                id_centro_costo 			integer,
                id_funcionario				integer,
                fecha_ini					date,
                fecha_fin					date
    		) on commit drop;

            for v_funcionario in select
                                    --vf.desc_funcionario1,

                                    tuo.id_uo_funcionario,
                                    tuo.id_funcionario,
                                    tuo.id_cargo,
                                    tfp.id_funcionario_planilla,
                                    tcc.id_centro_costo,
                                    ttc.id_tipo_cc,
                                    --tcon.nombre,
                                    --vcp.descripcion as categoria_prog,
                                    ttc.codigo as codigo_pres,
                                    tuo.fecha_asignacion,
                                    tuo.fecha_finalizacion
                                  from plani.tplanilla tp
                                  inner join plani.tfuncionario_planilla tfp on tfp.id_planilla = tp.id_planilla
                                  --inner join plani.thoras_trabajadas tht on tht.id_funcionario_planilla = tfp.id_funcionario_planilla
                                  --inner join plani.tcolumna_valor tcv on tcv.id_funcionario_planilla = tfp.id_funcionario_planilla
                                  --inner join plani.tcolumna_detalle tcd on tcd.id_columna_valor = tcv.id_columna_valor
                                  --inner join orga.vfuncionario vf on vf.id_funcionario = tfp.id_funcionario
                                  inner join orga.tuo_funcionario tuo on tuo.id_funcionario = tfp.id_funcionario and
                                  ((tuo.fecha_finalizacion between '1/1/2018'::date and '10/8/2018'::date) or tuo.fecha_finalizacion is null)

                                  inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuo.id_cargo and
                                  tcp.id_gestion =  (select (case when tg.id_gestion >=15 then tg.id_gestion else (select tge.id_gestion from param.tgestion tge where tge.gestion = extract(year from current_date)) end)  from param.tgestion tg where tg.gestion = extract(year from tuo.fecha_asignacion))
                                  --inner join orga.tcargo tca on tca.id_cargo = tcp.id_cargo
                                  --inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tca.id_tipo_contrato

                                  inner join param.tcentro_costo tcc on tcc.id_centro_costo = tcp.id_centro_costo
                                  inner join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc

                                  --INNER JOIN pre.tpresupuesto	tpre ON tpre.id_presupuesto = tcc.id_centro_costo
                                  --INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tpre.id_categoria_prog
                                  where tp.id_planilla = 528 and tuo.tipo = 'oficial' and tuo.estado_reg = 'activo' order by tfp.id_funcionario, tuo.fecha_asignacion ASC loop


                /*if v_funcionario.id_funcionario = 596 then
                	RAISE EXCEPTION 'RESULTADO: %', ((((v_funcionario.fecha_asignacion between '1/1/2018'::date and '31/7/2018'::date) or (v_funcionario.fecha_finalizacion between '1/1/2018'::date and '10/8/2018'::date)) or v_funcionario.fecha_finalizacion is null) or (v_id_funcionario != v_funcionario.id_funcionario or v_codigo_pres != v_funcionario.codigo_pres)) ;

                end if;*/

                if((((v_funcionario.fecha_asignacion between '1/1/2018'::date and '31/7/2018'::date) or (v_funcionario.fecha_finalizacion between '1/1/2018'::date and '10/8/2018'::date)) or v_funcionario.fecha_finalizacion is null) or (v_id_funcionario != v_funcionario.id_funcionario or v_codigo_pres != v_funcionario.codigo_pres))then
                  --if(v_codigo_pres != v_funcionario.codigo_pres)then
                  /*if(v_funcionario.id_funcionario  = 2035 and v_funcionario.id_uo_funcionario = 9335)then
                      RAISE EXCEPTION 'id_funcionario: %, %', v_funcionario.id_funcionario, v_funcionario.id_uo_funcionario;
                  end if;*/
                      v_cont_pres  = v_cont_pres + 1;
                      insert into tt_plani_filtro(
                          id_uo_funcionario,
                          id_cargo,
                          id_funcionario_planilla,
                          id_centro_costo,
                          id_funcionario,
                          fecha_ini,
                          fecha_fin
                      ) values (
                          v_funcionario.id_uo_funcionario,
                          v_funcionario.id_cargo,
                          v_funcionario.id_funcionario_planilla,
                          v_funcionario.id_centro_costo,
                          v_funcionario.id_funcionario,
                          v_funcionario.fecha_asignacion,
                          v_funcionario.fecha_finalizacion
                      );
                  --end if;

                end if;
                v_codigo_pres = v_funcionario.codigo_pres;
                v_id_funcionario = v_funcionario.id_funcionario;
            end loop;
            raise notice 'v_cont_pres: %', v_cont_pres;
    		--Sentencia de la consulta
			v_consulta:=' select
            				tcon.codigo as tipo_contrato,
                          	vcp.descripcion::varchar as categoria_prog,
                            ttc.codigo::varchar as codigo_pres,
                            ttc.descripcion::varchar as presupuesto,
                            vf.desc_funcionario2::varchar as desc_func,
                            vf.ci,
                            tca.nombre as nombre_cargo,
                            tp.fecha_ini,
                            case when tp.fecha_fin is null then ''31/7/2018''::date else tp.fecha_fin end as fecha_fin,
                            EXTRACT(month from tht.fecha_ini::date)::varchar as periodo,
                            tcv.codigo_columna,
                            tcd.valor
                          from tt_plani_filtro tp
                          inner join orga.vfuncionario vf on vf.id_funcionario = tp.id_funcionario

                          inner join orga.tcargo tca on tca.id_cargo = tp.id_cargo
                          inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tca.id_tipo_contrato

                          inner join param.tcentro_costo tcc on tcc.id_centro_costo = tp.id_centro_costo
                          inner join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc

                          inner join plani.tcolumna_valor tcv on tcv.id_funcionario_planilla = tp.id_funcionario_planilla and tcv.codigo_columna IN (''REISUELDOBA'', ''REINBANT'',''BONFRONTERA'')

                          inner join plani.tcolumna_detalle tcd on tcd.id_columna_valor = tcv.id_columna_valor

                          inner join plani.thoras_trabajadas tht on  tht.id_horas_trabajadas = tcd.id_horas_trabajadas and tht.id_uo_funcionario = tp.id_uo_funcionario

                          --inner join param.tperiodo tper on (tper.fecha_ini BETWEEN (''1/''||EXTRACT(MONTH FROM tht.fecha_ini)||''/''||EXTRACT(YEAR FROM tht.fecha_ini))::DATE AND tht.fecha_ini) and tper.fecha_fin BETWEEN (''1/''||EXTRACT(MONTH FROM tht.fecha_fin)||''/''||EXTRACT(YEAR FROM tht.fecha_fin))::DATE AND tht.fecha_fin
        				  INNER JOIN param.tperiodo tper on to_char(tper.fecha_ini ,''mm/YYYY'')  = to_char(tht.fecha_ini ,''mm/YYYY'') and  to_char(tper.fecha_fin ,''mm/YYYY'') = to_char(tht.fecha_fin, ''mm/YYYY'')

                          INNER JOIN pre.tpresupuesto tpre ON tpre.id_presupuesto = tcc.id_centro_costo
                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tpre.id_categoria_prog

                          ORDER BY tcon.codigo, vcp.descripcion, ttc.descripcion, vf.desc_funcionario2, tcv.codigo_columna, periodo asc
                        	--left join plani.tfuncionario_planilla tfp on tfp.id_funcionario_planilla = tp.id_funcionario_planilla
                          ';

            RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

    else

      raise exception 'Transaccion inexistente';

    end if;

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