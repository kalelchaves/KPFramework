/********************************************************************************
** Programa.: QueryCondition.cls
** Data.....: 12/06/2019
** Objetivo.: Classe para agrupamento condicoes (where) na execucao de queries
********************************************************************************/

using classes.query.*.

class classes.query.QueryCondition implements IQueryCondition:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttWhere no-undo
        field propertyName  as char
        field propertyValue as char
        field condition     as int
        field operator      as int.

    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */

    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    def public property tableName    as char init "" get. set.
    def public property tableFields  as char init "" get. set.

    def public property CONDITION_AND as int init 1 get.
    def public property CONDITION_OR  as int init 2 get.

    def public property OPERATOR_EQ   as int init 1 get. // = (equal)
    def public property OPERATOR_NE   as int init 2 get. // <> (not equal)
    def public property OPERATOR_GT   as int init 3 get. // > (greater than)
    def public property OPERATOR_GE   as int init 4 get. // >= (greater than or equal)
    def public property OPERATOR_LT   as int init 5 get. // < (less than)
    def public property OPERATOR_LE   as int init 6 get. // <= (less than or equal)
    //
    def public property OPERATOR_BG   as int init 101 get. // begins
    def public property OPERATOR_MT   as int init 102 get. //matches

    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public QueryCondition():
        this-object:clear().
    end.
    
    destructor public QueryCondition():
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private void append(input condition as int, input propertyName as char, input propertyValue as char, input operator as int):
        create ttWhere.
        assign ttWhere.condition     = condition
               ttWhere.propertyName  = propertyName
               ttWhere.propertyValue = propertyValue
               ttWhere.operator      = operator.
    end method.

    method private char dateStr(input dateParam as date):
        if (dateParam = ?)
        then return ?.
        return string(dateParam, "99/99/9999").
    end method.

    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public classes.query.QueryCondition clear():
        empty temp-table ttWhere.

        return this-object.
    end method.

    method public char conditionStatement(input condition as int):
        if condition = this-object:CONDITION_AND
        then return " AND ".
        else return " OR ".
    end method.

    method public char operatorStatement(input operator as int):
        case operator:
            when this-object:OPERATOR_EQ
            then return " = ".

            when this-object:OPERATOR_NE
            then return " <> ".

            when this-object:OPERATOR_GT
            then return " > ".

            when this-object:OPERATOR_GE
            then return " >= ".

            when this-object:OPERATOR_LT
            then return " < ".

            when this-object:OPERATOR_LE
            then return " <= ".

            when this-object:OPERATOR_MT
            then return " matches ".

            when this-object:OPERATOR_BG
            then return " begins ".
        end case.

        return " = ".
    end method.

    // Variacoes do AND
    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as char):
        return this-object:and(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as char, input operator as int):
        if operator = this-object:OPERATOR_MT
        then assign propertyValue = "*" + propertyValue + "*".
        return this-object:and(propertyName, propertyValue, operator, false).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as char, input operator as int, input supressQuotes as log):
        if supressQuotes
        then this-object:append(this-object:CONDITION_AND, propertyName, propertyValue, operator).
        else this-object:append(this-object:CONDITION_AND, propertyName, "'" + propertyValue + "'", operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as int):
        return this-object:and(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as int, input operator as int):
        this-object:append(this-object:CONDITION_AND, propertyName, string(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as dec):
        return this-object:and(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as dec, input operator as int):
        this-object:append(this-object:CONDITION_AND, propertyName, string(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as date):
        return this-object:and(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as date, input operator as int):
        this-object:append(this-object:CONDITION_AND, propertyName, this-object:dateStr(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as log):
        return this-object:and(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition and(input propertyName as char, input propertyValue as log, input operator as int):
        this-object:append(this-object:CONDITION_AND, propertyName, string(propertyValue, "true/false"), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition andIsNull(input propertyName as char):
        this-object:append(this-object:CONDITION_AND, propertyName, "?", this-object:OPERATOR_EQ).
        return this-object.
    end method.

    method public classes.query.QueryCondition andIsNotNull(input propertyName as char):
        this-object:append(this-object:CONDITION_AND, propertyName, "?", this-object:OPERATOR_NE).
        return this-object.
    end method.

    // Variacoes do OR
    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as char):
        return this-object:or(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.
    
    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as char, input operator as int):
        if operator = this-object:OPERATOR_MT
        then assign propertyValue = "*" + propertyValue + "*".
        return this-object:or(propertyName, propertyValue, operator, false).
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as char, input operator as int, input supressQuotes as log):
        if supressQuotes
        then this-object:append(this-object:CONDITION_OR, propertyName, propertyValue, operator).
        else this-object:append(this-object:CONDITION_OR, propertyName, "'" + propertyValue + "'", operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as int):
        return this-object:or(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as int, input operator as int):
        this-object:append(this-object:CONDITION_OR, propertyName, string(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as dec):
        return this-object:or(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as dec, input operator as int):
        this-object:append(this-object:CONDITION_OR, propertyName, string(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as date):
        return this-object:or(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as date, input operator as int):
        this-object:append(this-object:CONDITION_OR, propertyName, this-object:dateStr(propertyValue), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as log):
        return this-object:or(propertyName, propertyValue, this-object:OPERATOR_EQ).
    end method.

    method public classes.query.QueryCondition or(input propertyName as char, input propertyValue as log, input operator as int):
        this-object:append(this-object:CONDITION_OR, propertyName, string(propertyValue, "true/false"), operator).
        return this-object.
    end method.

    method public classes.query.QueryCondition orIsNull(input propertyName as char):
        this-object:append(this-object:CONDITION_OR, propertyName, "?", this-object:OPERATOR_EQ).
        return this-object.
    end method.

    method public classes.query.QueryCondition orIsNotNull(input propertyName as char):
        this-object:append(this-object:CONDITION_OR, propertyName, "?", this-object:OPERATOR_NE).
        return this-object.
    end method.


    // Monta a clausula de selecao (WHERE)
    method public char select():
        def var cResult as char init "" no-undo.
        def var isFirst as log          no-undo.

        assign isFirst = true.

        for each ttWhere:
            if not isFirst
            then assign cResult = cResult + this-object:conditionStatement(ttWhere.condition).

            assign cResult = cResult + ttWhere.propertyName + this-object:operatorStatement(ttWhere.operator) + ttWhere.propertyValue
                   isFirst = false.
            
        end.

        return cResult.
    end method.

end class.
