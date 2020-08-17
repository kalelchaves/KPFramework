/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: GpsTussConverter.cls
** Data.....: 10/10/2019
** Criacao..: Jeferson Dal Molin
** Objetivo.: Classe que realiza a tratativa dos movimentos TUSS -> GP
********************************************************************************/

class classes.tuss.GpsTussConverter inherits classes.error.GpsErrorMessage:

    /**
     * Busca o tipo de tabela TISS do insumo GP.
     */
    method public integer getTussTable (input cdTipoInsumoPar as int,
                                        input cdInsumoPar     as int):

        this-object:cleanErrors().

        for first insumos fields(int-1)
            where insumos.cd-tipo-insumo = cdTipoInsumoPar
              and insumos.cd-insumo      = cdInsumoPar
                  no-lock:
        end.
        if not avail insumos
        then do:
               this-object:insertError("Insumo nao cadastrado: " + string(cdTipoInsumoPar,"99") + string(cdInsumoPar,"99999999")).
               return ?.
             end.

        find first tip-tab use-index tiptab-id
             where tip-tab.cdn-tab-gest = insumos.int-1                                                    
                   no-lock no-error.                                                                       
        if not avail tip-tab                                                                                    
        then do:
               this-object:insertError("Tipo de tabela nao encontrado para o insumo: " + string(cdTipoInsumoPar,"99") + string(cdInsumoPar,"99999999")).
               return ?.
             end.
            
        return tip-tab.cdn-tabela.
    end method.

    /**
     * Converte o codigo do insumo GP para o codigo PTU
     */
    method public char convertMedicalSupply(input cdTipoInsumoPar as int,
                                            input cdInsumoPar     as int):

        def var tussTable as int no-undo.

        /* Obtem tipo de tabela TISS do insumo */
        assign tussTable = this-object:getTussTable(cdTipoInsumoPar, cdInsumoPar).
        if this-object:hasAnyError()
        then return ?.

        /* Valida tipo de tabela */
        if  tussTable <> 00
        and tussTable <> 18
        and tussTable <> 19
        and tussTable <> 20
        and tussTable <> 22
        and tussTable <> 98
        then do:
               this-object:insertError("Tipo de tabela deve ser igual a 00, 18, 19, 20, 22 ou 98. Insumo: " 
                                       + string(cdTipoInsumoPar,"99") 
                                       + string(cdInsumoPar,"99999999")
                                       + " Tabela: "
                                       + string(tussTable,"99")).
               return ?.
             end.

        /* Localiza associativa insumo GP X insumo PTU */
        for first ptuinsum fields(cd-insumo-ptu int-2) no-lock
            where ptuinsum.cd-tipo-insumo-serious = cdTipoInsumoPar
              and ptuinsum.cd-insumo-serious      = cdInsumoPar
              and ptuinsum.dt-limite             >= today
              and (   ptuinsum.in-tipo-assoc      = "E"
                   or ptuinsum.in-tipo-assoc      = "A")
                   break by ptuinsum.dt-limite:
        end.
        if not avail ptuinsum
        then do:
               this-object:insertError("Associativa insumo PTU nao cadastrada: " + string(cdTipoInsumoPar,"99") + string(cdInsumoPar,"99999999")).
               return ?.
             end.

        /* Regra PTU Online 8.0: quando no insumo o tipo de tabela TISS for > 00 (outras tabelas), entao envia a tabela no campo tipoTabela e o codigo do movimento
         * vai com 8 digitos.
         * Quando o tipo tabela TISS for igual a 00 (outras tabelas), entao localiza a tabela na associativa ptuinsum e envia no ptu tipoTabela
         * igual a zero e no codigo do movimento envia os dois primeiros digitos igual ao tipo de tabela TISS correspondente na ptuinsum e os 
         * 8 digitos restantes o codigo do insumo.
         */
        if tussTable > 0
        then return string(ptuinsum.cd-insumo-ptu, "99999999"). /* Quando tipo de tabela > 0, codigo do movimento deve ter 8 digitos */
        else do:
               for first tip-tab fields(cdn-tabela)
                   where tip-tab.cdn-tab-gest = ptuinsum.int-2 /* Codigo tabela TISS */
                          no-lock:
               end.
               if not avail tip-tab
               then do:
                      this-object:insertError("Tipo de tabela nao encontrado para o insumo: " + string(cdTipoInsumoPar,"99") + string(cdInsumoPar,"99999999")).
                      return ?.
                    end.
               if tip-tab.cdn-tabela = 0
               then do:
                      this-object:insertError("Tipo de tabela nao pode ser igual a 00 na conversao do insumo PTU: " + string(cdTipoInsumoPar,"99") + string(cdInsumoPar,"99999999")).
                      return ?.
                    end.
               
               return string(tip-tab.cdn-tabela,"99") + string(ptuinsum.cd-insumo-ptu,"99999999").
             end.

        return ?.

    end method.

     /**
     * Converte o codigo do insumo PTU para insumo GP.
     */
    method public rowid convertTussToMedicalSupply(input tp-tabela-par  as char,
                                                   input cd-insumo-par  as char,
                                                   input in-tipo-conver as char):

      this-object:cleanErrors().

      if tp-tabela-par = "00"
      then do:
             for first tip-tab fields(cdn-tab-gest)
                 where tip-tab.cdn-tabela = int(substring(cd-insumo-par,1,2))
                       no-lock:
             end.
             if not avail tip-tab
             then do:
                    this-object:insertError("Tipo de tabela nao encontrado: " + substring(cd-insumo-par,1,2)).
                    return ?.
                  end.

             for each  ptuinsum fields(cd-tipo-insumo-serious cd-insumo-serious)
                 where ptuinsum.cd-insumo-ptu = int(substring(cd-insumo-par,3,8))
                   and ptuinsum.int-2         = tip-tab.cdn-tab-gest
                   and ptuinsum.dt-limite    >= today
                   and(ptuinsum.in-tipo-assoc = in-tipo-conver or
                       ptuinsum.in-tipo-assoc = "A")
                       no-lock,
                 first insumos fields()
                 where insumos.cd-tipo-insumo   = ptuinsum.cd-tipo-insumo-serious
                   and insumos.cd-insumo        = ptuinsum.cd-insumo-serious
                   and insumos.dat-inic-vigenc <= today
                   and insumos.dat-fim-vigenc  >= today
                       no-lock:
                 return rowid(insumos).
             end.
           end.
      else do:
             for first tip-tab fields(cdn-tab-gest)
                 where tip-tab.cdn-tabela = int(tp-tabela-par)
                       no-lock:
             end.
             if not avail tip-tab
             then do:
                    this-object:insertError("Tipo de tabela nao encontrado: " + tp-tabela-par).
                    return ?.
                  end.

             for each  ptuinsum fields(cd-tipo-insumo-serious cd-insumo-serious)
                 where ptuinsum.cd-insumo-ptu = int(cd-insumo-par)
                   and ptuinsum.dt-limite    >= today
                   and(ptuinsum.in-tipo-assoc = in-tipo-conver or
                       ptuinsum.in-tipo-assoc = "A")
                       no-lock,
                 first insumos fields()
                 where insumos.cd-tipo-insumo   = ptuinsum.cd-tipo-insumo-serious
                   and insumos.cd-insumo        = ptuinsum.cd-insumo-serious
                   and insumos.dat-inic-vigenc <= today
                   and insumos.dat-fim-vigenc  >= today
                   and insumos.int-1            = tip-tab.cdn-tab-gest
                       no-lock:
                 return rowid(insumos).
             end.
           end.

      return ?.

    end method.

end class.
