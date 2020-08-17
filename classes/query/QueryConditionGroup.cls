/********************************************************************************
** Programa.: QueryConditionGroup.cls
** Data.....: 13/03/2020
** Objetivo.: Classe para agrupamento de diversas condicoes
********************************************************************************/

using progress.lang.*.
using classes.query.*.

class classes.query.QueryConditionGroup implements IQueryCondition:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttQueryCondition no-undo
        field conditionHandle as Object
        field conditionType   as int.

    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */

    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    def public property tableName    as char init "" get. set.

    def public property CONDITION_AND as int init 1 get.
    def public property CONDITION_OR  as int init 2 get.

    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public QueryConditionGroup():
        this-object:clear().
    end.
    
    destructor public QueryConditionGroup():
        this-object:clearObjects().
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private void clearObjects():
        for each ttQueryCondition:
            delete object ttQueryCondition.conditionHandle no-error.
        end.
    end method.

    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public classes.query.QueryConditionGroup clear():
        this-object:clearObjects().
        empty temp-table ttQueryCondition.

        return this-object.
    end method.

    method public char conditionStatement(input condition as int):
        if condition = this-object:CONDITION_AND
        then return " AND ".
        else return " OR ".
    end method.

    method public classes.query.QueryCondition and():
        def var obj as QueryCondition no-undo.
        assign obj             = new QueryCondition()
               obj:tableName   = this-object:tableName.

        create ttQueryCondition.
        assign ttQueryCondition.conditionHandle = obj
               ttQueryCondition.conditionType   = obj:CONDITION_AND.

        return obj.
    end method.

    method public classes.query.QueryCondition or():
        def var obj as QueryCondition no-undo.
        assign obj             = new QueryCondition()
               obj:tableName   = this-object:tableName.

        create ttQueryCondition.
        assign ttQueryCondition.conditionHandle = obj
               ttQueryCondition.conditionType   = obj:CONDITION_OR.

        return obj.
    end method.

    // Monta a clausula de selecao (WHERE)
    method public char select():
        def var cResult as char init "" no-undo.
        def var isFirst as log          no-undo.
        def var oCondition as QueryCondition no-undo.
        def var cAux as char no-undo.

        assign isFirst = true.

        for each ttQueryCondition:
            assign oCondition = cast(ttQueryCondition.conditionHandle, QueryCondition)         
                   cAux = oCondition:select().

            if cAux <> ""
            then do:
                if not isFirst
                then assign cResult = cResult + this-object:conditionStatement(ttQueryCondition.conditionType).

                assign cResult = cResult + "(" + cAux + ")"
                       isFirst = false.
            end.
            
        end.

        return cResult.
    end method.

end class.
