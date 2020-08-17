/********************************************************************************
** Programa.: GpsQuery.cls
** Data.....: 12/06/2019
** Objetivo.: Classe para execucao de queries
********************************************************************************/

using progress.lang.*.
using classes.query.*.

class classes.query.GpsQuery:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttCondition no-undo
        field bufferName      as char
        field conditionHandle as Object
        field conditionType   as int.

    def temp-table ttBuffer no-undo
        field bufferHandle as handle
        field fieldsList as char
        field indexName as char.

    def temp-table ttBreakBy no-undo
        field breakGroup as char.

    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */
    def private property intHasNext as log init false get. set.
    def private property intNumRecords as int init 0 get. set.
    def private property intCallMethod as char   init "" get. set.
    def private property intCallSource as handle get. set.
    def private property intValidateMethod as char   init "" get. set.
    def private property intValidateSource as handle get. set.    
    def private property intCountNumRegisters as log init false get. set.   

    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    def public property startRow as int get. set.
    def public property pageSize as int get. set.
    def public property hasNext  as log
        get:
            return this-object:intHasNext.
        end get.
    def public property breakByLevel as int get. set.
    def public property numRegisters as int get. set.    
    def public property numRecords  as int
        get:
            return this-object:intNumRecords.
        end get.
    def public property countNumRegisters as log init false
        get:
            return this-object:intCountNumRegisters.
        end get.
    

    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public GpsQuery():
        this-object:clear().
    end.
    
    destructor public GpsQuery():
        this-object:clearObjects().
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private void clearObjects():
        for each ttCondition:
            delete object ttCondition.conditionHandle no-error.
        end.
    end method.

    method private log validateRecord():
        if this-object:intValidateMethod <> ""
        and valid-handle(this-object:intValidateSource)
        then return dynamic-function(this-object:intValidateMethod in this-object:intValidateSource).

        return true.
    end method.

    method private void createRecord():
        if this-object:intCallMethod <> ""
        and valid-handle(this-object:intCallSource)
        then run value(this-object:intCallMethod) in this-object:intCallSource.
        //then run value(this-object:intCallMethod) in source-procedure.
    end method.

    method private char appendEach (input bufferName as char, input fieldsList as char, input indexName as char):
        def var cResult as char no-undo.

        assign cResult = " EACH " + bufferName.

        if  fieldsList <> ?
        and fieldsList <> ""
        then assign cResult = cResult + " FIELDS (" + fieldsList + ")".

        if  indexName <> ?
        and indexName <> ""
        then assign cResult = cResult + " USE-INDEX " + indexName.

        return cResult.
    end method.

    /* --- Metodos publicos -------------------------------------------------------------------------------- */

    method public classes.query.GpsQuery clear():
        this-object:clearObjects().
        empty temp-table ttCondition.
        empty temp-table ttBuffer.
        empty temp-table ttBreakBy.
        assign this-object:intCallMethod = ""
               this-object:intCallSource = ?
               this-object:breakByLevel    = 0.

        return this-object.
    end method.

    method public classes.query.GpsQuery setStartRow(input startRow as int):
        this-object:startRow = startRow.
        return this-object.
    end method.

    method public classes.query.GpsQuery setPageSize(input pageSize as int):
        this-object:pageSize = pageSize.
        return this-object.
    end method.

    method public classes.query.GpsQuery setMethod(input methodName as char, input methodHandle as handle):
        assign this-object:intCallMethod = methodName
               this-object:intCallSource = methodHandle.
        return this-object.
    end method.

    method public classes.query.GpsQuery setValidate(input methodName as char, input methodHandle as handle):
        assign this-object:intValidateMethod = methodName
               this-object:intValidateSource = methodHandle.
        return this-object.
    end method.

    method public classes.query.GpsQuery addBuffer(input bufferHandle as handle):
        return this-object:addBuffer(bufferHandle, ?).
    end method.

    method public classes.query.GpsQuery addBuffer(input bufferHandle as handle, input fieldsList as char):
        return this-object:addBuffer(bufferHandle, fieldsList, ?).
    end method.

    method public classes.query.GpsQuery addBuffer(input bufferHandle as handle, input fieldsList as char, input indexName as char):
        create ttBuffer.
        assign ttBuffer.bufferHandle = bufferHandle
               ttBuffer.fieldsList   = fieldsList
               ttBuffer.indexName    = indexName.

        return this-object.
    end method.

    method public classes.query.GpsQuery breakBy(input breakGroup as char):
        create ttBreakBy.
        assign ttBreakBy.breakGroup = breakGroup.

        return this-object.
    end method.

    method public classes.query.QueryCondition and():
        for first ttBuffer:
            return this-object:and(ttBuffer.bufferHandle:name).
        end.
        return ?.
    end method.

    method public classes.query.QueryCondition and(input tableName as char):
        def var obj as QueryCondition no-undo.
        assign obj             = new QueryCondition()
               obj:tableName   = tableName.

        create ttCondition.
        assign ttCondition.bufferName      = tableName
               ttCondition.conditionHandle = obj
               ttCondition.conditionType   = obj:CONDITION_AND.

        return obj.
    end method.

    method public classes.query.QueryConditionGroup andGroup():
        for first ttBuffer:
            return this-object:andGroup(ttBuffer.bufferHandle:name).
        end.
        return ?.
    end method.

    method public classes.query.QueryConditionGroup andGroup(input tableName as char):
        def var obj as QueryConditionGroup no-undo.
        assign obj             = new QueryConditionGroup()
               obj:tableName   = tableName.

        create ttCondition.
        assign ttCondition.bufferName      = tableName
               ttCondition.conditionHandle = obj
               ttCondition.conditionType   = obj:CONDITION_AND.

        return obj.
    end method.

    method public classes.query.QueryCondition or():
        for first ttBuffer:
            return this-object:or(ttBuffer.bufferHandle:name).
        end.
        return ?.
    end method.

    method public classes.query.QueryCondition or(input tableName as char):
        def var obj as QueryCondition no-undo.
        assign obj             = new QueryCondition()
               obj:tableName   = tableName.

        create ttCondition.
        assign ttCondition.bufferName      = tableName
               ttCondition.conditionHandle = obj
               ttCondition.conditionType   = obj:CONDITION_OR.

        return obj.
    end method.

    method public classes.query.QueryConditionGroup orGroup():
        for first ttBuffer:
            return this-object:orGroup(ttBuffer.bufferHandle:name).
        end.
        return ?.
    end method.

    method public classes.query.QueryConditionGroup orGroup(input tableName as char):
        def var obj as QueryConditionGroup no-undo.
        assign obj             = new QueryConditionGroup()
               obj:tableName   = tableName.

        create ttCondition.
        assign ttCondition.bufferName      = tableName
               ttCondition.conditionHandle = obj
               ttCondition.conditionType   = obj:CONDITION_OR.

        return obj.
    end method.

    method public classes.query.GpsQuery setCountNumRegisters(input countNumRegisters as log):
        this-object:intCountNumRegisters = countNumRegisters.
        return this-object.
    end method.

    method public char statement():
        def var oCondition   as IQueryCondition no-undo.
        def var cSelect      as char init "" no-undo.
        def var cAux         as char         no-undo.
        def var isFirstTable as log          no-undo.
        def var isFirstCond  as log          no-undo.

        assign isFirstTable = true
               isFirstCond  = true.

        for each ttBuffer:
            // se nao tem nenhuma condicao de where, apenas adiciona no preselect
            if not can-find(first ttCondition where ttCondition.bufferName = ttBuffer.bufferHandle:name)
            then do:
                if isFirstTable
                then assign cSelect = cSelect + "PRESELECT".
                else assign cSelect = cSelect + " ,".

                assign cSelect = cSelect + this-object:appendEach(ttBuffer.bufferHandle:name, ttBuffer.fieldsList, ttBuffer.indexName)
                       isFirstTable = false.
            end.
            // caso contrario, adiciona no preselect na primeira condicao (first-of)
            for each ttCondition
                where ttCondition.bufferName = ttBuffer.bufferHandle:name
                break by ttCondition.bufferName:

                assign oCondition = cast(ttCondition.conditionHandle, IQueryCondition).

                if first-of(ttCondition.bufferName)
                then do:
                    if isFirstTable
                    then assign cSelect = cSelect + "PRESELECT".
                    else assign cSelect = cSelect + " ,".
                    assign cSelect = cSelect + this-object:appendEach(ttBuffer.bufferHandle:name, ttBuffer.fieldsList, ttBuffer.indexName).

                    assign isFirstTable = false
                           isFirstCond  = true.
                end.
                
                assign cAux = oCondition:select().

                if cAux <> ""
                then do:
                    if isFirstCond
                    then assign cAux        = " WHERE (" + cAux + ") "
                                isFirstCond = false.
                    else assign cAux = oCondition:conditionStatement(ttCondition.conditionType) + " (" + cAux + ") ".
                end.

                assign cSelect = cSelect + cAux.
            end.
        end.

        assign isFirstCond = true.
        for each ttBreakBy:
            if isFirstCond
            then assign cSelect     = cSelect + " BREAK"
                        isFirstCond = false.
            assign cSelect = cSelect + " BY " + ttBreakBy.breakGroup.
        end.

        return cSelect.
    end method.

    method public void execute():

        def var cSelect                as char     no-undo.
        def var pageSize               as int      no-undo.

        def var hQuery                 as handle   no-undo.
        def var registerNumber         as int      no-undo.
        def var lgGroupCountAux        as log      no-undo.
        def var lgValidRecordAux       as log      no-undo.
        def var ctRegistersAux         as int      no-undo.
        def var ctIncludedRegistersAux as int      no-undo.
        def var ctNextAux              as int      no-undo.

        assign cSelect                   = this-object:statement()
               this-object:intHasNext    = false
               this-object:intNumRecords = 0.

        create query hQuery.
        for each ttBuffer:
            if not valid-handle(ttBuffer.bufferHandle)
            then next.
            hQuery:add-buffer(ttBuffer.bufferHandle).
        end.

        if not hQuery:query-prepare(cSelect)
        then return.

        if this-object:intCountNumRegisters
        then assign this-object:numRegisters = this-object:getNumRegisters(hQuery).

        hQuery:query-open().

        // se tem funcao de validacao, sera necessario validar antes se o metodo deve ser considerado
        // e para isso eh necessario percorrer todos registros do inicio
        if this-object:startRow > 1
        then do:
            if this-object:intValidateMethod = ""
            and this-object:breakByLevel = 0
            then hQuery:reposition-to-row(this-object:startRow).
            else do:
                // considera na contagem somente as linhas que passam pela rotina de validacao
                assign registerNumber = 1.
                repeat:
                    hQuery:get-next(no-lock).
                    if hQuery:query-off-end then leave.

                    if this-object:breakByLevel = 0
                    or hQuery:first-of(this-object:breakByLevel)
                    then assign lgGroupCountAux = true.

                    if this-object:intValidateMethod = ""
                    then assign lgValidRecordAux = true.
                    else assign lgValidRecordAux = this-object:validateRecord().

                    if lgValidRecordAux
                    then do:
                        if lgGroupCountAux
                        then do:
                            assign lgGroupCountAux = false
                                   registerNumber  = registerNumber + 1.
                            if registerNumber >= this-object:startRow
                            then do:
                                // pula ate o ultimo registro de break no mesmo nivel
                                if this-object:breakByLevel > 0
                                then repeat:
                                    if not hQuery:last-of(this-object:breakByLevel)
                                    then hQuery:get-next(no-lock).
                                    else leave.
                                end.
                                leave.
                            end.
                        end.
                    end.
                end.
            end.
        end.

        // tamanho da pagina
        assign pageSize = this-object:pageSize.
        if pageSize <= 0
        then assign pageSize = 2147483647. /*MAX INT*/

        //
        assign registerNumber = 0.
        repeat:
            hQuery:get-next(no-lock).
            if hQuery:query-off-end 
            then leave.

            if this-object:breakByLevel = 0
            or hQuery:first-of(this-object:breakByLevel)
            then assign lgGroupCountAux = true.

            if  lgGroupCountAux
            and registerNumber >= pageSize
            then leave.

            if not this-object:validateRecord()
            then next.

            if lgGroupCountAux
            then assign lgGroupCountAux = false
                        registerNumber  = registerNumber + 1.
            this-object:createRecord().
            
            if this-object:breakByLevel = 0
            or hQuery:last-of(this-object:breakByLevel)
            then do:
                if registerNumber >= pageSize
                then do:
                    // verifica se existe proximo registro
                    hQuery:get-next(no-lock).
                    if hQuery:query-off-end
                    then assign this-object:intHasNext = false.
                    else assign this-object:intHasNext = true.
                    leave.
                end.
            end.
        end.
        this-object:intNumRecords = registerNumber.

        delete object hQuery.

    end method.

method private int getNumRegisters(input hQuery as handle):

    def var registerNumber         as int      no-undo.

    hQuery:query-open().
    hQuery:reposition-to-row(0).

    repeat:
        hQuery:get-next(no-lock).

        if hQuery:query-off-end then leave.        
        
        if this-object:validateRecord()
        then do:
            assign registerNumber = registerNumber + 1.
        end.
    end.

    hQuery:query-close().

    return registerNumber.

end method.

end class.
