/********************************************************************************
** Copyright TOTVS S.A. (2019)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: AssertFieldCollection.cls
** Data.....: 14/04/2019
** Cria‡Æo..: Ezequiel Gandolfi
** Objetivo.: Colecao de campos para utilizacao na classe GpsAssert
********************************************************************************/

class classes.test.AssertFieldCollection:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttFields no-undo
        field fromField             as char
        field toField               as char
        field ignore                as log
        field valueConvFunction     as char
        field valueConvProcHandle   as handle.
    
    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */

    /* --- Variaveis externas (publicas) ------------------------------------------------------------------- */
    def public property returnSameFieldWhenNotFound as log
    get. set.

    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    constructor public AssertFieldCollection():
        this-object:clear().
        this-object:returnSameFieldWhenNotFound = false.
    end.
    
    destructor public AssertFieldCollection():
    end.

    /* --- Metodos privados -------------------------------------------------------------------------------- */

    /* --- Metodos publicos -------------------------------------------------------------------------------- */

    /**
     * Limpa os dados
     */
    method public void clear():
        empty temp-table ttFields.
    end method.

    /**
     * Adiciona uma traducao
     */
    method public void add(input fromField as char):
        this-object:add(fromField, ?, ?, ?).
    end method.

    method public void add(input fromField as char, input toField as char):
        this-object:add(fromField, toField, ?, ?).
    end method.

    method public void add(input fromField as char, input toField as char, input valueConvFunction as char, input valueConvProcHandle as handle):
        create ttFields.
        assign ttFields.fromField           = fromField
               ttFields.toField             = toField
               ttFields.ignore              = false
               ttFields.valueConvFunction   = valueConvFunction
               ttFields.valueConvProcHandle = valueConvProcHandle.
    end method.

    /**
     * Adiciona o campo na lista de campos que nao devem ser comparados automaticamente
     * Obs: utilizar este metodo para quando a propriedade returnSameFieldWhenNotFound for verdadeira, e um campo nao pode ser diretamente comparado
     */
    method public void ignore(input fromField as char):
        create ttFields.
        assign ttFields.fromField = fromField
               ttFields.ignore    = true.
    end method.

    /**
     * Retorna o campo traduzido (ou o proprio campo de origem, caso nao tenha traducao)
     */
    method public char get(input fromField as char):
        def var c-result as char no-undo.
        this-object:get(fromField, output c-result).
        return c-result.
    end method.

    method public void get(input fromField as char, output resultField as char):
        def var o-conv-func as char   no-undo.
        def var o-conv-hndl as handle no-undo.
        this-object:get(fromField, output resultField, output o-conv-func, output o-conv-hndl).
    end method.

    method public void get(input fromField as char, output resultField as char, output resultConvFunction as char, output resultConvProcHandle as handle):
        assign resultField          = ?
               resultConvFunction   = ?
               resultConvProcHandle = ?.

        for first ttFields where ttFields.fromField = fromField:
            if not ttFields.ignore
            then do:
                assign resultField          = ttFields.toField
                       resultConvFunction   = ttFields.valueConvFunction
                       resultConvProcHandle = ttFields.valueConvProcHandle.

                if resultField = ?
                or resultField = ""
                then assign resultField = fromField.
            end.

            return.
        end.

        if this-object:returnSameFieldWhenNotFound
        then assign resultField = fromField.

    end method.

end class.
