*---------------------------------------------------------------------------*
*Módulo de explosão de itens em ABAP4 / SAP. 								*	
*Módulo para programa de calculo de matéria prima em estoque x	necessidade *
*de matéria prima para fabricação de equipamentos.							*
*								PT-BR											*
*Programa realizado por: Leonardo M. Miguel 						  		*
*e-mail: melinmiguel@gmail.com	em caso de duvidas, entre em contato! 		*
*Prog. nº 7															     	*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*Module for explosion itens in ABAP4 / SAP. 								*	
*Module from program of calculated Raw Material in Stock x	Necessit	    *
*of raw material to manufacture new itens.									*
*								EN-US											*
*Programa realizado por: Leonardo M. Miguel 						  		*
*e-mail: melinmiguel@gmail.com	em caso de duvidas, entre em contato! 		*
*Prog. nº 7															     	*
*---------------------------------------------------------------------------*

FORM recalcular_itens tables tp_saida
                    USING cod_comp TYPE stpo-idnrk
                          w_flag  TYPE c
                          QTD  TYPE mard-labst
                          HRKFT TYPE c.

DO.
   LOOP AT TI_SAIDA WHERE flagprc = ' ' AND flagimp = ' '. "o loop vai ler apenas itens não processados ou que não atendem as regras de item final. - PT-BR
     w_linha  = SY-TABIX.								   "the loop read itens not processed or not aggre final rule item. - EN-US

     IF ti_saida-falta > 0.
       IF HRKFT = 'EF'. "somente itens do tipo EF possuem explosões afim de chegar na matéria prima. - PT-BR
						"Only itens type EF have explosion to check raw material. - EN-US
           ti_saida-flagprc = 'S'.
           MODIFY ti_saida INDEX w_linha. "Salvando a item que esta ocorrendo a explosão para identificação do flag final. - PT-BR
										  "Saving the item that is occurring the explosion to identify the final flag. - EN-US
		  CLEAR ti_saida-flagprc. "Precisamos limpar a variável, pois do contrário ele assume como valor para as reexplosões recursivas. - PT-BR
								  "We need to clear the variable, otherwise it assumes the value for recursive reexplosions. - EN-US

           "Explode lista técnica - PT-BR
		   "Technical list explosion - EN-US
           PERFORM expl_lista_tecnica TABLES ti_stb USING ti_saida-idnrk ti_saida-FALTA ' '. "Função Standard - EXP_MAT_V2.

           "busca estoque - PT-BR
		   "stock search - EN-US
           PERFORM busca_estoque TABLES ti_stb.

           "trata item fantasma - PT-BR
		   "treats ghost item - EN-US
           PERFORM trata_item_fantasma TABLES ti_STB.

           "Preenche tabela de saida da ALV - PT-BR
		   "Fills ALV exit table - EN-US
           PERFORM preench_tab_saida TABLES ti_STB.
       ELSE. 
          ti_saida-flagimp = 'S'.
          MODIFY ti_saida INDEX w_linha.
          CLEAR ti_saida-flagimp.
		  "Precisamos limpar a variável, pois do contrário ele assume como valor para as reexplosões recursivas. - PT-BR
		  "We need to clear the variable, otherwise it assumes the value for recursive reexplosions. - EN-US
      ENDIF.

      ELSE. "pois ele pode ser um item de materia prima que não está em falta, mas é necesária para fabricar um item do tipo EF que está em falta. - PT-BR
			"as it may be a non-missing raw material item but is required to manufacture a missing EF type item. - EN-US
        ti_saida-flagimp = 'S'.
        MODIFY ti_saida INDEX w_linha.
        CLEAR ti_saida-flagimp.
		"Precisamos limpar a variável, pois do contrário ele assume como valor para as reexplosões recursivas. - PT-BR
		"We need to clear the variable, otherwise it assumes the value for recursive reexplosions. - EN-US
  ENDIF.
  ENDLOOP.

  data: c_normal type i,
        c_quali  type i,
        c_tranf  type i,
        c_consig type i,
        c_benef  type i,
        c_chaof  type i.

  IF NOT sy-subrc IS INITIAL.
    exit.
    ENDIF.
 ENDDO.

    LOOP AT ti_saida WHERE flagimp = 'S'.
     w_linha  = SY-TABIX.

        IF p_normal EQ 'X'.
          clear c_normal.
          c_normal = ti_saida-qtde_1.
        endif.

        IF p_qualid EQ 'X'.
          clear c_quali.
          c_quali = ti_saida-qtde_2.
        ENDIF.

        IF p_transf EQ 'X'.
          clear c_tranf.
          c_tranf = ti_saida-qtde_3.
        ENDIF.

        IF p_consig EQ 'X'.
          clear c_consig.
          c_consig = ti_saida-qtde_4.
        ENDIF.

        IF p_benefe EQ 'X'.
          clear c_benef.
          c_benef = ti_saida-qtde_5.
        ENDIF.

        IF p_chaofa EQ 'X'.
          clear c_chaof.
          c_chaof = ti_saida-qtde_6.
        ENDIF.
*A tela de seleção inicial possui um Radiobutton, por isso da seleção acima.- PT-BR
*The selection initial screen have one Radiobutton, because this have above itens. - EN-US
        ti_saida-falta = ti_saida-mnglg - c_normal - c_quali - c_tranf - c_consig - c_benef - c_chaof.

        IF ti_saida-falta < 0.
          ti_saida-falta = 0.
        ENDIF.

        MODIFY ti_saida index w_linha. "salva os flags na linha que foi processada no loop.- PT-BR
										"save the flags in processed line in loop. - EN-US
     ENDLOOP.

	 DELETE TI_SAIDA WHERE FLAGIMP = ' '. "Removo todos os itens que possui estoque suficiente, pois o relatório só precisa dos itens que necessitam de compra.- PT-BR
										  "Remove all itens it have sufficient stock, because the report need onlye material dont have stock and need buy. - EN-US

ENDFORM.