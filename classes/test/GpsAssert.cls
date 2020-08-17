/********************************************************************************
** Copyright TOTVS S.A. (2019)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: GpsAssert.cls
** Data.....: 14/04/2019
** Cria��o..: Ezequiel Gandolfi
** Objetivo.: Classe para validacao de dados de casos de teste
********************************************************************************/

using classes.test.*.

class classes.test.GpsAssert:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttMessage no-undo
        field errorMessage as char.
    
    
    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */
    
    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    def public property passed as log
    get:
        return not can-find(first ttMessage).
    end get.

    def public property errorMessage as char
    get:
        return this-object:getMessages(this-object:maxErrors).
    end get.

    def public property maxErrors as int
    get. set.

    def public property spoolDirectory as char
    get. set.

    def public property spoolFileName as char
    get. set.

    /*def public property maxJsonLength as int
    get. set.*/

    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public GpsAssert():
        this-object:clearError().
        this-object:maxErrors = 0.
        //this-object:maxJsonLength = 255.
    end.
    
    destructor public GpsAssert():
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private void setError(input errorMessage as char):
        create ttMessage.
        assign ttMessage.errorMessage = errorMessage.
    end method.

    method private char getMessages(input maxMessages as int):
        def var lc-result as char init "" no-undo.
        def var i-count   as int init 0 no-undo.

        for each ttMessage:
            assign i-count = i-count + 1.

            if maxMessages > 0
            and i-count > maxMessages
            then leave.

            if i-count = 1
            then assign lc-result = ttMessage.errorMessage.
            else assign lc-result = lc-result + "; " + ttMessage.errorMessage.
        end.

        return lc-result.
    end method.

    method private void validateBuffer(input expectedBuffer as handle, input actualBuffer as handle, input fieldCollection as AssertFieldCollection, output valid as log, output errorField as char):
        // var
        def var isOk as log no-undo.
        def var i-num-fields as int no-undo.
        def var i-field as int no-undo.
        def var h-actual-field as handle no-undo.
        def var c-expected-field as char no-undo.
        def var h-expected-field as handle no-undo.
        def var fnc-conv-name as char   no-undo.
        def var fnc-conv-hndl as handle no-undo.
        def var c-message as char no-undo.

        assign valid = true.
        
        // validacao dos campos
        assign i-num-fields = actualBuffer:num-fields.
        do i-field = 1 to i-num-fields:
            assign h-actual-field = actualBuffer:buffer-field(i-field) no-error.
            if error-status:error
            or h-actual-field = ?
            or not valid-handle(h-actual-field)
            then next.

            fieldCollection:get(h-actual-field:name, output c-expected-field, output fnc-conv-name, output fnc-conv-hndl).
            // se retornar nulo, campo nao deve ser validado
            if c-expected-field = ?
            then next.

            assign h-expected-field = expectedBuffer:buffer-field(c-expected-field) no-error.
            if error-status:error
            or h-expected-field = ?
            or not valid-handle(h-expected-field)
            then next.

            if fnc-conv-name <> ?
            and valid-handle(fnc-conv-hndl)
            then assign isOk = dynamic-function(fnc-conv-name in fnc-conv-hndl, h-actual-field:buffer-value()) = h-expected-field:buffer-value().
            else assign isOk = h-actual-field:buffer-value() = h-expected-field:buffer-value().

            if not isOk
            then do:
                assign valid      = false
                       errorField = h-actual-field:name.
                return.
            end.
        end.

    end method.

    /* --- Metodos publicos -------------------------------------------------------------------------------- */

    /**
     * Limpa os erros do caso de teste
     */
    method public void clearError():
        empty temp-table ttMessage.
    end method.

    /**
     * Atribui erro para o caso de teste
     */
    method public void fail(input errorMessage as char):
        this-object:setError(errorMessage).
    end method.

    /**
     * Verifica o error-status
     */
    method public void checkError():
        this-object:checkError("").
    end method.

    method public void checkError(input errorMessage as char):
        if error-status:error
        then this-object:setError(if errorMessage = ""
                                  then error-status:get-message(error-status:num-messages)
                                  else (errorMessage + " - " + substr(error-status:get-message(error-status:num-messages),1,72))).
    end method.

    /**
     * Compara dois buffers
     */
    method public void compareBuffer(input expectedBuffer as handle, input actualBuffer as handle):
        this-object:compareBuffer(expectedBuffer, actualBuffer, ?, ?).
    end method.

    method public void compareBuffer(input expectedBuffer as handle, input actualBuffer as handle, input fieldCollection as AssertFieldCollection):
        this-object:compareBuffer(expectedBuffer, actualBuffer, fieldCollection, ?).
    end method.

    method public void compareBuffer(input expectedBuffer as handle, input actualBuffer as handle, input fieldCollection as AssertFieldCollection, input errorMessage as char):
        // var
        def var isValid as log no-undo.
        def var cMessage as char no-undo.
        def var cErrorField as char no-undo.
        
        
        // valida os handles
        if not valid-handle(actualBuffer)
        then do:
            this-object:fail("compareBuffer() - buffer invalido (atual)").
            return.
        end.
        if not valid-handle(expectedBuffer)
        then do:
            this-object:fail("compareBuffer() - buffer invalido (esperado)").
            return.
        end.

        if fieldCollection = ?
        then do:
            fieldCollection = new AssertFieldCollection().
            fieldCollection:returnSameFieldWhenNotFound = true.
        end.

        this-object:validateBuffer(expectedBuffer, actualBuffer, fieldCollection, output isValid, output cErrorField).

        if not isValid
        then do:
            assign cMessage = "Valores divergentes para o campo " + cErrorField + " na tabela " + actualBuffer:name.

            if errorMessage <> ?
            and errorMessage <> ""
            then assign cMessage = errorMessage + " - " + cMessage.
            
            this-object:fail(cMessage).
        end.

    end method.

    /**
     * Compara duas temp-tables completas
     */
    method public void matchTable(input expectedTable as handle, input actualTable as handle):
        this-object:matchTable(expectedTable, actualTable, ?, ?).
    end method.

    method public void matchTable(input expectedTable as handle, input actualTable as handle, input fieldCollection as AssertFieldCollection):
        this-object:matchTable(expectedTable, actualTable, fieldCollection, ?).
    end method.

    method public void matchTable(input expectedTable as handle, input actualTable as handle, input fieldCollection as AssertFieldCollection, input errorMessage as char):
        // var
        def var expectedQh as handle no-undo.
        def var actualQh as handle no-undo.
        
        def var isValid as log no-undo.
        def var iRecord as int no-undo.
        def var cMessage as char no-undo.
        def var cErrorField as char no-undo.
        
        // valida os handles
        if not valid-handle(actualTable)
        then do:
            this-object:fail("matchTable() - buffer invalido (atual)").
            return.
        end.
        if not valid-handle(expectedTable)
        then do:
            this-object:fail("matchTable() - buffer invalido (esperado)").
            return.
        end.

        if fieldCollection = ?
        then do:
            fieldCollection = new AssertFieldCollection().
            fieldCollection:returnSameFieldWhenNotFound = true.
        end.

        // abre as queries
        create query expectedQh.
        expectedQh:set-buffers(expectedTable).
        expectedQh:query-prepare("preselect each " + expectedTable:name).
        expectedQh:query-open().

        create query actualQh.
        actualQh:set-buffers(actualTable).
        actualQh:query-prepare("preselect each " + actualTable:name).
        actualQh:query-open().

        // verifica se todos o numero de registros encontrados bate com o total
        if expectedQh:num-results <> actualQh:num-results
        then do:
            assign cMessage = "Numero de registros divergentes para a tabela " + actualTable:name + ". Atual = " + string(actualQh:num-results) + ", Esperado = " + string(expectedQh:num-results).

            if errorMessage <> ?
            and errorMessage <> ""
            then assign cMessage = errorMessage + " - " + cMessage.
            
            this-object:fail(cMessage).
            this-object:writeTempTable(actualTable).
            return.
        end.

        // percorre registros realizando a comparacao
        assign iRecord = 0
               isValid = true.
        expectedQh:get-first().
        repeat:
            if expectedQh:query-off-end
            then leave.

            assign iRecord = iRecord + 1
                   isValid = false.

            actualQh:get-first().
            repeat:
                if actualQh:query-off-end
                then leave.

                this-object:validateBuffer(expectedTable, actualTable, fieldCollection, output isValid, output cErrorField).

                if isValid
                then leave.
                else actualQh:get-next().
            end.

            if not isValid
            then do:
                assign cMessage = "Registro " + string(iRecord) + " nao possui equivalente na tabela " + actualTable:name.

                if errorMessage <> ?
                and errorMessage <> ""
                then assign cMessage = errorMessage + " - " + cMessage.
                
                this-object:fail(cMessage).
                this-object:writeTempTable(actualTable).
                leave.
            end.

            expectedQh:get-next().
        end.

        // limpa memoria
        finally:
            if valid-handle(expectedQh)
            then do:
                expectedQh:query-close().
                delete object expectedQh.
            end.
            if valid-handle(actualQh)
            then do:
                actualQh:query-close().
                delete object actualQh.
            end.
        end finally.

    end method.

    method private void writeTempTable(input actualTable as handle):

        if this-object:spoolDirectory <> ""
        and this-object:spoolDirectory <> ?
        and this-object:spoolFileName <> ""
        and this-object:spoolFileName <> ?
        then actualTable:write-json("file", replace(this-object:spoolDirectory, "~\", "/") + "/" + this-object:spoolFileName + "-" + actualTable:name + ".json", true).

    end method.
    /**
     * Compara duas temp-tables completas, aceitando mais registros na tabela atual
     */
    method public void atLeast(input expectedTable as handle, input actualTable as handle):
        this-object:atLeast(expectedTable, actualTable, ?, ?).
    end method.

    method public void atLeast(input expectedTable as handle, input actualTable as handle, input fieldCollection as AssertFieldCollection):
        this-object:atLeast(expectedTable, actualTable, fieldCollection, ?).
    end method.

    method public void atLeast(input expectedTable as handle, input actualTable as handle, input fieldCollection as AssertFieldCollection, input errorMessage as char):
        // var
        def var expectedQh as handle no-undo.
        def var actualQh as handle no-undo.
        
        def var isValid as log no-undo.
        def var iRecord as int no-undo.
        def var cMessage as char no-undo.
        def var cErrorField as char no-undo.
        
        // valida os handles
        if not valid-handle(actualTable)
        then do:
            this-object:fail("atLeast() - buffer invalido (atual)").
            return.
        end.
        if not valid-handle(expectedTable)
        then do:
            this-object:fail("atLeast() - buffer invalido (esperado)").
            return.
        end.

        if fieldCollection = ?
        then do:
            fieldCollection = new AssertFieldCollection().
            fieldCollection:returnSameFieldWhenNotFound = true.
        end.

        // abre as queries
        create query expectedQh.
        expectedQh:set-buffers(expectedTable).
        expectedQh:query-prepare("preselect each " + expectedTable:name).
        expectedQh:query-open().

        create query actualQh.
        actualQh:set-buffers(actualTable).
        actualQh:query-prepare("preselect each " + actualTable:name).
        actualQh:query-open().

        // percorre registros realizando a comparacao
        assign iRecord = 0
               isValid = true.
        expectedQh:get-first().
        repeat:
            if expectedQh:query-off-end
            then leave.

            assign iRecord = iRecord + 1
                   isValid = false.

            actualQh:get-first().
            repeat:
                if actualQh:query-off-end
                then leave.

                this-object:validateBuffer(expectedTable, actualTable, fieldCollection, output isValid, output cErrorField).

                if isValid
                then leave.
                else actualQh:get-next().
            end.

            if not isValid
            then do:
                assign cMessage = "Registro " + string(iRecord) + " nao possui equivalente na tabela " + actualTable:name.

                if errorMessage <> ?
                and errorMessage <> ""
                then assign cMessage = errorMessage + " - " + cMessage.
                
                this-object:fail(cMessage).
                this-object:writeTempTable(actualTable).
                leave.
            end.

            expectedQh:get-next().
        end.

        // limpa memoria
        finally:
            if valid-handle(expectedQh)
            then do:
                expectedQh:query-close().
                delete object expectedQh.
            end.
            if valid-handle(actualQh)
            then do:
                actualQh:query-close().
                delete object actualQh.
            end.
        end finally.

    end method.

    /**
     * Compara dois valores do mesmo tipo
     */
    method public void equal(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue <> expectedValue
        then this-object:fail("Valores divergentes para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado = " + string(expectedValue)).
    end method.

    method public void equal(input fieldName as char, input expectedValue as char, input thisValue as char):
        if thisValue <> expectedValue
        then this-object:fail("Valores divergentes para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado = " + string(expectedValue)).
    end method.

    method public void equal(input fieldName as char, input expectedValue as log, input thisValue as log):
        if thisValue <> expectedValue
        then this-object:fail("Valores divergentes para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado = " + string(expectedValue)).
    end method.
    
    method public void notEqual(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue = expectedValue
        then this-object:fail("Valores iguais para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado != " + string(expectedValue)).
    end method.

    method public void notEqual(input fieldName as char, input expectedValue as char, input thisValue as char):
        if thisValue = expectedValue
        then this-object:fail("Valores iguais para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado != " + string(expectedValue)).
    end method.
	
	method public void notEqual(input fieldName as char, input expectedValue as log, input thisValue as log):
        if thisValue = expectedValue
        then this-object:fail("Valores iguais para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado != " + string(expectedValue)).
    end method.

    /**
     * Compara valores booleanos
     */
    method public void true(input fieldName as char, input thisValue as log):
        if thisValue <> true
        then this-object:fail("Valores divergentes para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado = " + string(true)).
    end method.

    method public void false(input fieldName as char, input thisValue as log):
        if thisValue <> false
        then this-object:fail("Valores divergentes para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado = " + string(false)).
    end method.

    /**
     * Compara valores
     */
    method public void less(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue >= expectedValue
        then this-object:fail("Valor maior do que o esperado para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado < " + string(expectedValue)).
    end method.

    method public void lessOrEqual(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue > expectedValue
        then this-object:fail("Valor maior do que o esperado para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado <= " + string(expectedValue)).
    end method.

    method public void greater(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue <= expectedValue
        then this-object:fail("Valor menor do que o esperado para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado > " + string(expectedValue)).
    end method.

    method public void greaterOrEqual(input fieldName as char, input expectedValue as int, input thisValue as int):
        if thisValue < expectedValue
        then this-object:fail("Valor menor do que o esperado para o campo " + fieldName + ". Atual = " + string(thisValue) + ", Esperado >= " + string(expectedValue)).
    end method.

end class.
