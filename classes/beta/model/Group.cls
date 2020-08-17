/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: 
** Data.....: 
** Criacao..: 
** Objetivo.: 
********************************************************************************/

using Progress.Json.ObjectModel.*.
using classes.beta.model.*.

class classes.beta.model.Group inherits classes.beta.model.Model:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    
    constructor public Group():
        super(buffer grp:handle).
        this-object:className = "classes.beta.model.Group".

        this-object:jsonSerializeModel = new JsonObject().
        this-object:jsonSerializeModel:add("cdn-grupo", "code").
        this-object:jsonSerializeModel:add("nom-grupo","description").
        this-object:jsonSerializeModel:add("log-livre-1","chemotherapeutic").
        this-object:jsonSerializeModel:add("cod-usuar-ult-atualiz","updateUser").
        this-object:jsonSerializeModel:add("dat-atualiz","updateDate").
    end constructor.

    define property cdn-grupo as integer get. set.
    define property nom-grupo as character get. set.
    define property dat-atualiz as date get. set.
    define property dat-exc as date get. set.
    define property cod-livre-1 as character get. set.
    define property cod-livre-2 as character get. set.
    define property cod-livre-3 as character get. set.
    define property cod-livre-4 as character get. set.
    define property cod-livre-5 as character get. set.
    define property dat-livre-1 as date get. set.
    define property dat-livre-2 as date get. set.
    define property dat-livre-3 as date get. set.
    define property dat-livre-4 as date get. set.
    define property dat-livre-5 as date get. set.
    define property val-livre-1 as decimal get. set.
    define property val-livre-2 as decimal get. set.
    define property val-livre-3 as decimal get. set.
    define property val-livre-4 as decimal get. set.
    define property val-livre-5 as decimal get. set.
    define property log-livre-1 as logical get. set.
    define property log-livre-2 as logical get. set.
    define property log-livre-3 as logical get. set.
    define property log-livre-4 as logical get. set.
    define property log-livre-5 as logical get. set.
    define property num-livre-1 as integer get. set.
    define property num-livre-2 as integer get. set.
    define property num-livre-3 as integer get. set.
    define property num-livre-4 as integer get. set.
    define property num-livre-5 as integer get. set.
    define property cod-livre-usuar-1 as character get. set.
    define property cod-livre-usuar-2 as character get. set.
    define property cod-livre-usuar-3 as character get. set.
    define property dat-livre-usuar-1 as date get. set.
    define property dat-livre-usuar-2 as date get. set.
    define property dat-livre-usuar-3 as date get. set.
    define property val-livre-usuar-1 as decimal get. set.
    define property val-livre-usuar-2 as decimal get. set.
    define property val-livre-usuar-3 as decimal get. set.
    define property num-livre-usuar-1 as integer get. set.
    define property num-livre-usuar-2 as integer get. set.
    define property num-livre-usuar-3 as integer get. set.
    define property log-livre-usuar-1 as logical get. set.
    define property log-livre-usuar-2 as logical get. set.
    define property log-livre-usuar-3 as logical get. set.
    define property dat-ult-atualiz as date get. set.
    define property hra-ult-atualiz as character get. set.
    define property cod-usuar-ult-atualiz as character get. set.



end class.
