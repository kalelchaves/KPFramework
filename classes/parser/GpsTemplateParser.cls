/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: GpsTemplateParser.cls
**
** Data.....: 21/02/2019
**
** Criação..: Ezequiel Gandolfi
**
** Objetivo.: Classe de manipulação de templates
********************************************************************************/

class classes.parser.GpsTemplateParser:
    
    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */
    define private variable ch-text-template  as longchar no-undo.
    define private variable ch-text-result    as longchar no-undo.

    // definicoes das tags de abertura do template
    define private property GPS_TAGINI_PREFIX as char init "<gps:"  get.
    define private property GPS_TAGINI_SUFIX  as char init ">"      get.
    define private property GPS_TAGFIM_PREFIX as char init "</gps:" get.
    define private property GPS_TAGFIM_SUFIX  as char init ">"      get.

    // definicoes das tags internas
    define private property GPS_TAG_HEADER_INI  as char init "<header>"   get.
    define private property GPS_TAG_HEADER_FIN  as char init "</header>"  get.
    define private property GPS_TAG_FOOTER_INI  as char init "<footer>"   get.
    define private property GPS_TAG_FOOTER_FIN  as char init "</footer>"  get.
    define private property GPS_TAG_CONTENT_INI as char init "<content>"  get.
    define private property GPS_TAG_CONTENT_FIN as char init "</content>" get.
    define private property GPS_TAG_NODATA_INI  as char init "<nodata>"   get.
    define private property GPS_TAG_NODATA_FIN  as char init "</nodata>"  get.
    // definicoes das tags dos campos
    define private property GPS_TAGFIELD_INI as char init "<value>"  get.
    define private property GPS_TAGFIELD_FIN as char init "</value>" get.
    
    // temp-tables de handles de dados
    define temp-table dataRelation no-undo
        field attributeName as character
        field tableHandle   as handle.

    define temp-table dataRecords no-undo
        field attributeName as character
        field bufferHandle  as handle.
    
    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    
    
    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public GpsTemplateParser():
        empty temp-table dataRelation.
        assign ch-text-template = ""
               ch-text-result   = "".
    end.
    
    destructor public GpsTemplateParser():
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private logical loadFile(input fileName as character):
        copy-lob file search(fileName) to ch-text-template no-error.
        return (not error-status:error).
    end method.

    method private longchar processTables(input fileContent as longchar):
        def var i-pos-ini        as int      no-undo.
        def var i-pos-fin        as int      no-undo.
        def var i-pos-tagini-fin as int      no-undo.
        def var i-pos-tagfim-ini as int      no-undo.
        def var i-pos-tagfim-fin as int      no-undo.
        def var lc-result-aux    as longchar no-undo.
        def var lc-subtext-aux   as longchar no-undo.
        def var ch-filter-aux    as char     no-undo.
        def var ch-table-aux     as char     no-undo.

        assign lc-result-aux = fileContent.

        // Varre o texto ate que nao tenha mais a tag de controle para ser processada
        assign i-pos-ini = index(lc-result-aux, this-object:GPS_TAGINI_PREFIX).
        do while i-pos-ini > 0:
            // busca fechamento da tag inicial
            assign i-pos-tagini-fin = index(lc-result-aux, this-object:GPS_TAGINI_SUFIX, i-pos-ini).
            if i-pos-tagini-fin = 0
            then leave.

            // processa tag inicial
            assign lc-subtext-aux = substring(lc-result-aux, i-pos-ini, i-pos-tagini-fin - i-pos-ini)
                   lc-subtext-aux = trim(substring(lc-subtext-aux, length(this-object:GPS_TAGINI_PREFIX) + 1)).
            
            /*if num-entries(lc-subtext-aux, " ") > 0
            then*/ do:
                assign ch-table-aux  = entry(1, lc-subtext-aux, " ")
                       ch-filter-aux = trim(substring(lc-subtext-aux, length(ch-table-aux) + 1)).

                // busca tag final
                assign i-pos-tagfim-ini = index(lc-result-aux, this-object:GPS_TAGFIM_PREFIX + ch-table-aux, i-pos-tagini-fin).
                if i-pos-tagfim-ini = 0
                then leave.

                assign i-pos-tagfim-fin = index(lc-result-aux, this-object:GPS_TAGFIM_SUFIX, i-pos-tagfim-ini).
                if i-pos-tagfim-fin = 0
                then leave.

                // busca texto interno da tag e processa o mesmo
                assign lc-subtext-aux = substring(lc-result-aux, i-pos-tagini-fin + 1, i-pos-tagfim-ini - i-pos-tagini-fin - 1).

                // processa resultado
                assign lc-result-aux = substring(lc-result-aux, 1, i-pos-ini - 1) 
                                      + this-object:parseTable(ch-table-aux, ch-filter-aux, lc-subtext-aux)
                                      + substring(lc-result-aux, i-pos-tagfim-fin + 1).
            end.
            //else leave.

            assign i-pos-ini = index(lc-result-aux, this-object:GPS_TAGINI_PREFIX).
        end.

        return lc-result-aux.
    end method.

    method private longchar parseText(input fileContent as longchar):

        empty temp-table dataRecords.
        return this-object:processTables(fileContent).

    end method.

    method private longchar OLDparseText(input fileContent as longchar):
        def var i-pos-ini        as int      no-undo.
        def var i-pos-fin        as int      no-undo.
        def var i-pos-tagini-fin as int      no-undo.
        def var i-pos-tagfim-ini as int      no-undo.
        def var i-pos-tagfim-fin as int      no-undo.
        def var lc-result-aux    as longchar no-undo.
        def var lc-subtext-aux   as longchar no-undo.
        def var ch-filter-aux    as char     no-undo.
        def var ch-table-aux     as char     no-undo.

        assign lc-result-aux = fileContent.

        // Varre o texto ate que nao tenha mais a tag de controle para ser processada
        assign i-pos-ini = index(lc-result-aux, this-object:GPS_TAGINI_PREFIX).
        do while i-pos-ini > 0:
            // busca fechamento da tag inicial
            assign i-pos-tagini-fin = index(lc-result-aux, this-object:GPS_TAGINI_SUFIX, i-pos-ini).
            if i-pos-tagini-fin = 0
            then leave.

            // processa tag inicial
            assign lc-subtext-aux = substring(lc-result-aux, i-pos-ini, i-pos-tagini-fin - i-pos-ini)
                   lc-subtext-aux = trim(substring(lc-subtext-aux, length(this-object:GPS_TAGINI_PREFIX) + 1)).
            
            if num-entries(lc-subtext-aux, " ") > 0
            then do:
                assign ch-table-aux  = entry(1, lc-subtext-aux, " ")
                       ch-filter-aux = trim(substring(lc-subtext-aux, length(ch-table-aux) + 1)).

                // busca tag final
                assign i-pos-tagfim-ini = index(lc-result-aux, this-object:GPS_TAGFIM_PREFIX + ch-table-aux, i-pos-tagini-fin).
                if i-pos-tagfim-ini = 0
                then leave.

                assign i-pos-tagfim-fin = index(lc-result-aux, this-object:GPS_TAGFIM_SUFIX, i-pos-tagfim-ini).
                if i-pos-tagfim-fin = 0
                then leave.

                // busca texto interno da tag e processa o mesmo
                assign lc-subtext-aux = substring(lc-result-aux, i-pos-tagini-fin + 1, i-pos-tagfim-ini - i-pos-tagini-fin - 1).

                // processa resultado
                assign lc-result-aux = substring(lc-result-aux, 1, i-pos-ini - 1) 
                                      + this-object:parseTable(ch-table-aux, ch-filter-aux, lc-subtext-aux)
                                      + substring(lc-result-aux, i-pos-tagfim-fin + 1).
            end.
            else leave.

            assign i-pos-ini = index(lc-result-aux, this-object:GPS_TAGINI_PREFIX).
        end.

        return lc-result-aux.
    end method.

    method private longchar parseTable(input ttName as char, input filter as char, input subText as longchar):
        
        def var tt-handle            as handle   no-undo.
        def var qy-handle            as handle   no-undo.
        def var ch-text-header-aux   as longchar no-undo.
        def var ch-text-content-aux  as longchar no-undo.
        def var ch-text-footer-aux   as longchar no-undo.
        def var ch-result-aux        as longchar no-undo.
        def var lg-query-prepare-aux as log      no-undo.

        // localiza a tabela
        find first dataRelation where dataRelation.attributeName = ttName no-error.
        if not avail dataRelation
        then return "".
        if not valid-handle(dataRelation.tableHandle)
        then return "".

        // cria temp-table em memoria
        create temp-table tt-handle.
        tt-handle:create-like(dataRelation.tableHandle).
        tt-handle:temp-table-prepare(dataRelation.attributeName).

        // copia todos os dados, para depois aplicar o filtro
        tt-handle:copy-temp-table(dataRelation.tableHandle).

        // aplica filtros
        assign filter = this-object:getFilterStatement(tt-handle:default-buffer-handle, filter).

        create query qy-handle.
        qy-handle:set-buffers(tt-handle:default-buffer-handle).
        assign lg-query-prepare-aux = qy-handle:query-prepare("for each " + tt-handle:default-buffer-handle:name + " " + filter) no-error.
        
        if  not error-status:error
        and lg-query-prepare-aux
        then do:
            qy-handle:query-open().
            qy-handle:get-next().

            // verifica se tem dados ou nao
            if not qy-handle:query-off-end
            then do:
                // busca tags header e content
                assign ch-text-header-aux  = this-object:getInnerText(subText, this-object:GPS_TAG_HEADER_INI, this-object:GPS_TAG_HEADER_FIN)
                       ch-text-content-aux = this-object:getInnerText(subText, this-object:GPS_TAG_CONTENT_INI, this-object:GPS_TAG_CONTENT_FIN)
                       ch-text-footer-aux  = this-object:getInnerText(subText, this-object:GPS_TAG_FOOTER_INI, this-object:GPS_TAG_FOOTER_FIN).

                // processa resultados
                assign ch-result-aux = ch-text-header-aux.

                // cria referencia ao registro atual
                create dataRecords.
                assign dataRecords.attributeName = ttName
                       dataRecords.bufferHandle  = tt-handle:default-buffer-handle.

                qy-handle:get-first().            
                repeat:
                    if qy-handle:query-off-end
                    then leave.

                    assign ch-result-aux = ch-result-aux 
                                         + this-object:parseRecord(ch-text-content-aux, tt-handle:default-buffer-handle).

                    qy-handle:get-next().
                end.

                // apaga referencia do registro
                for each dataRecords where dataRecords.attributeName = ttName:
                    delete dataRecords.
                end.

                assign ch-result-aux = ch-result-aux
                                     + ch-text-footer-aux.

                delete object qy-handle.
                delete object tt-handle.

                return ch-result-aux.
            end.
            else do:
                delete object qy-handle.
                delete object tt-handle.

                // busca tag nodata
                return this-object:getInnerText(subText, this-object:GPS_TAG_NODATA_INI, this-object:GPS_TAG_NODATA_FIN).
            end.
        end.

        delete object qy-handle.
        delete object tt-handle.
        return "".

    end method.

    method private longchar parseRecord(input subText as longchar, input ttHandle as handle):
        def var ch-fieldname-aux as char no-undo.
        def var ch-fieldvalue-aux as longchar no-undo.

        subText = this-object:processTables(subText).

        repeat:
            if index(subText, this-object:GPS_TAGFIELD_INI) = 0
            then leave.

            // busca a primeira tag de valor ainda nao convertida
            assign ch-fieldname-aux = string(this-object:getInnerText(subText, this-object:GPS_TAGFIELD_INI, this-object:GPS_TAGFIELD_FIN)).
            // busca nome do campo
            assign ch-fieldvalue-aux = this-object:getFieldValue(ttHandle, ch-fieldname-aux).
            // substitui o valor
            subText = this-object:setInnerText(subText, this-object:GPS_TAGFIELD_INI, this-object:GPS_TAGFIELD_FIN, ch-fieldvalue-aux, true).
        end.

        return subText.
    end method.

    method private char getFilterStatement(input ttHandle as handle, input filter as char):
        def var ch-text-aux as char init "" no-undo.
        def var ch-param-aux as char no-undo.
        def var ch-value-aux as char no-undo.
        def var ch-operator-aux as char no-undo.
        def var ch-result-aux as char init "" no-undo.
        def var i-pos-ini as int no-undo.
        def var i-pos-fim as int no-undo.
        def var ix as int no-undo.
        def var lg-string-aux as log init false no-undo.
        def var ch-placeholder-space as char init "_GPS|SPACE_" no-undo.
        def var ch-placeholder-equal as char init "_GPS|EQUAL_" no-undo.
        def var h-field-aux as handle no-undo.
        def var h-compareField-aux as handle no-undo.

        //remove
        assign i-pos-ini = index(filter, "~"").
        do while i-pos-ini > 0:
            assign i-pos-fim = index(filter, "~"", i-pos-ini + 1).

            if i-pos-fim > 0
            then do:
                assign ch-text-aux = substring(filter, i-pos-ini + 1, i-pos-fim - i-pos-ini - 1)
                       ch-text-aux = replace(ch-text-aux, " ", ch-placeholder-space)
                       ch-text-aux = replace(ch-text-aux, "=", ch-placeholder-equal)
                       filter      = substring(filter, 1, i-pos-ini)
                                   + ch-text-aux
                                   + substring(filter, i-pos-fim).
            end.
            else leave.

            assign i-pos-ini = index(filter, "~"", i-pos-fim + 1).
        end.

        assign i-pos-ini = index(filter, "~'").
        do while i-pos-ini > 0:
            assign i-pos-fim = index(filter, "~'", i-pos-ini + 1).

            if i-pos-fim > 0
            then do:
                assign ch-text-aux = substring(filter, i-pos-ini + 1, i-pos-fim - i-pos-ini - 1)
                       ch-text-aux = replace(ch-text-aux, " ", ch-placeholder-space)
                       ch-text-aux = replace(ch-text-aux, "=", ch-placeholder-equal)
                       filter      = substring(filter, 1, i-pos-ini)
                                   + ch-text-aux
                                   + substring(filter, i-pos-fim).
            end.
            else leave.

            assign i-pos-ini = index(filter, "~'", i-pos-fim + 1).
        end.

        repeat ix = 1 to num-entries(filter, " "):
            assign ch-text-aux = trim(entry(ix, filter, " ")).

            if num-entries(ch-text-aux, "=") <> 2
            then next.

            // trata o parametro e traz o resultado "limpo"
            assign ch-param-aux    = entry(1, ch-text-aux, "=")
                   ch-value-aux    = entry(2, ch-text-aux, "=")
                   ch-value-aux    = replace(ch-value-aux, ch-placeholder-space, " ")
                   ch-value-aux    = replace(ch-value-aux, ch-placeholder-equal, "=")
                   ch-operator-aux = "=".
            if ch-value-aux begins "~""
            or ch-value-aux begins "~'"
            then assign ch-value-aux = substring(ch-value-aux, 2, length(ch-value-aux) - 2).

            // trata modificador de operadores
            if ch-param-aux matches ("*-not")
            then assign ch-operator-aux = "<>"
                        ch-param-aux    = substring(ch-param-aux, 1, length(ch-param-aux) - 4).
            else if ch-param-aux matches ("*-greater")
            then assign ch-operator-aux = ">"
                        ch-param-aux    = substring(ch-param-aux, 1, length(ch-param-aux) - 8).
            else if ch-param-aux matches ("*-lesser")
            then assign ch-operator-aux = "<"
                        ch-param-aux    = substring(ch-param-aux, 1, length(ch-param-aux) - 7).
            else if ch-param-aux matches ("*-match")
            then assign ch-operator-aux = "matches"
                        ch-param-aux    = substring(ch-param-aux, 1, length(ch-param-aux) - 6).
            else if ch-param-aux matches ("*-begin")
            then assign ch-operator-aux = "begins"
                        ch-param-aux    = substring(ch-param-aux, 1, length(ch-param-aux) - 6).

            // verifica o tipo de campo da tabela
            assign ch-param-aux = this-object:getFieldName(ttHandle, ch-param-aux).

            if ch-param-aux = ""
            then next.

            assign h-field-aux        = ttHandle:buffer-field(ch-param-aux)
                   h-compareField-aux = this-object:getFieldHandle(?, ch-value-aux).

            if valid-handle(h-compareField-aux)
            then assign ch-value-aux = string(h-compareField-aux:buffer-value()).

            if this-object:isCharacterType(h-field-aux)
            then assign ch-value-aux = "~"" + ch-value-aux + "~"".
            else if this-object:isLogicalType(h-field-aux)
            then assign ch-value-aux = string(this-object:asLogical(ch-value-aux)).

            // monta clausula
            if ch-result-aux = ""
            then assign ch-result-aux = " WHERE ".
            else assign ch-result-aux = ch-result-aux + " AND ".

            assign ch-result-aux = ch-result-aux
                                 + ch-param-aux
                                 + " "
                                 + ch-operator-aux
                                 + " "
                                 + ch-value-aux.
            
        end.

        return ch-result-aux.
    end method.

    method private char getFieldName (input ttHandle as handle, input fieldName as char):
        define variable ix as integer no-undo.
        
        repeat ix = 1 to ttHandle:num-fields:
            if ttHandle:buffer-field(ix):serialize-name = fieldName
            then return ttHandle:buffer-field(ix):name.
            if ttHandle:buffer-field(ix):name = fieldName
            then return fieldName.
        end.

        return "".
    end method.

    method private handle getFieldHandle (input defaultHandle as handle, input fieldName as char):
        define variable ix as integer no-undo.
        define variable ch-table-name as char no-undo.
        define variable ch-field-name as char no-undo.
        
        if num-entries(fieldName, ".") = 1
        then do:
            if valid-handle(defaultHandle)
            then do:
                assign ch-field-name = this-object:getFieldName(defaultHandle, fieldName).
                if ch-field-name <> ""
                then return defaultHandle:buffer-field(ch-field-name).
            end.
        end.
        else do:
            assign ch-table-name = entry(1, fieldName, ".")
                   ch-field-name = entry(2, fieldName, ".").
            for first dataRecords where dataRecords.attributeName = ch-table-name:
                assign ch-field-name = this-object:getFieldName(dataRecords.bufferHandle, ch-field-name).
                if ch-field-name <> ""
                then return dataRecords.bufferHandle:buffer-field(ch-field-name).
            end.
        end.

        return ?.
    end method.

    method private char getFieldValue(input ttHandle as handle, input fieldName as char):
        def var fd-handle as handle no-undo.
        def var ch-result-aux as char no-undo.

        assign fd-handle = this-object:getFieldHandle(ttHandle, fieldName) no-error.

        if  not error-status:error
        and valid-handle(fd-handle)
        then do:
            assign ch-result-aux = string(fd-handle:buffer-value()) no-error.
            if ch-result-aux = ?
            then return "".
            else do:
                //assign ch-result-aux = codepage-convert(ch-result-aux, session:charset, "utf-8").
                return ch-result-aux.
            end.
        end.

        return "".
    end method.

    method private logical isCharacterType(input fieldHandle as handle):
        if fieldHandle:data-type matches "*char*"
        then return true.
        else return false.
    end method.

    method private logical isLogicalType(input fieldHandle as handle):
        if fieldHandle:data-type matches "*log*"
        then return true.
        else return false.
    end method.

    method private logical asLogical(input chValue as char):
        def var lg-result-aux as log no-undo.
        
        assign chValue = trim(chValue).        
        assign lg-result-aux = logical(chValue) no-error.
        if not error-status:error
        then return lg-result-aux.

        if chValue begins "S" //sim
        or chValue begins "Y" //yes
        or chValue begins "T" //true
        or chValue = "1"
        then return true.
        else return false.
    end method.

    method private longchar getInnerText(input subText as longchar, input tagStart as char, input tagEnd as char):
        def var i-pos-ini as int no-undo.
        def var i-pos-fim as int no-undo.
        def var qt-tag-ini as int no-undo.
        def var qt-tag-fim as int no-undo.
        def var lc-result as longchar no-undo.

        assign i-pos-ini = index(subText, tagStart).
        if i-pos-ini = 0
        then return "".

        assign i-pos-fim = index(subText, tagEnd, i-pos-ini).
        if i-pos-fim = 0
        then return "".

        assign lc-result = substring(subText, i-pos-ini + length(tagStart), i-pos-fim - i-pos-ini - length(tagStart)).

        // expande o conteudo enquanto existirem tags iguais em aberto dentro do conteudo
        repeat:
            assign qt-tag-ini = this-object:countOccurrences(lc-result, tagStart)
                   qt-tag-fim = this-object:countOccurrences(lc-result, tagEnd).

            if qt-tag-ini = qt-tag-fim
            then leave.

            assign i-pos-fim = index(subText, tagEnd, i-pos-fim + 1).
            if i-pos-fim = 0
            then return "".

            assign lc-result = substring(subText, i-pos-ini + length(tagStart), i-pos-fim - i-pos-ini - length(tagStart)).
        end.

        return lc-result.
    end method.

    method private void setInnerText(input subText as longchar, input tagStart as char, input tagEnd as char, input newText as longchar):
        this-object:setInnerText(subText, tagStart, tagEnd, newText, false).
    end method.

    method private longchar setInnerText(input subText as longchar, input tagStart as char, input tagEnd as char, input newText as longchar, input removeTags as log):
        def var i-pos-ini as int no-undo.
        def var i-pos-fim as int no-undo.

        assign i-pos-ini = index(subText, tagStart).
        if i-pos-ini = 0
        then return subText.

        assign i-pos-fim = index(subText, tagEnd, i-pos-ini).
        if i-pos-fim = 0
        then return subText.

        if not removeTags
        then assign i-pos-ini = i-pos-ini + length(tagStart)
                    i-pos-fim = i-pos-fim - 1.
        else assign i-pos-fim = i-pos-fim + length(tagEnd) - 1.

        return substring(subText, 1, i-pos-ini - 1)
             + newText
             + substring(subText, i-pos-fim + 1).
    end method.

    method private int countOccurrences(input lcText as longchar, input subText as char):
        def var in-qtd   as int init 0 no-undo.
        def var in-index as int init 0 no-undo.

        repeat:
            assign in-index = index(lcText, subText, in-index + 1).

            if in-index = 0
            then return in-qtd.
            else assign in-qtd = in-qtd + 1.
        end.
        
    end method.
    
    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public logical setText(input chText as longchar):
        assign ch-text-template = chText.
               ch-text-result   = "".
        return true.
    end method.

    method public logical setFile(input fileName as character):
        assign ch-text-template = ""
               ch-text-result   = "".
        return this-object:loadFile(fileName).
    end method.

    method public logical addTempTable(input attrName as character, input ttHandle as handle):
        if can-find(first dataRelation where dataRelation.attributeName = attrName)
        then return false.

        create dataRelation.
        assign dataRelation.attributeName = attrName
               dataRelation.tableHandle   = ttHandle.
        return true.
    end method.

    method public longchar getResult():
        return ch-text-result.
    end method.

    method public longchar parse():
        assign ch-text-result = this-object:parseText(ch-text-template).
        return ch-text-result.
    end method.
    
end class.
