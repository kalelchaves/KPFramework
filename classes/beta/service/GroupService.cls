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
using OpenEdge.Core.String.
using Progress.Lang.*.
using classes.beta.model.*.


class classes.beta.service.GroupService:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    
    define property oGroupModel as classes.beta.model.Group get. set.

    constructor public GroupService():
        
    end constructor.

    method public class classes.beta.model.Group getById(input cdn-grupo-par as integer):
        define variable oGroup as classes.beta.model.Group no-undo.

        oGroup = new classes.beta.model.Group().
        oGroup:cdn-grupo = cdn-grupo-par.
        oGroup:find().
        return oGroup.
    end method.

    method public class classes.beta.model.Group save(input ttGroupHandle as handle):
        define variable oGroup as classes.beta.model.Group no-undo.

        oGroup = new classes.beta.model.Group().
        oGroup:find(ttGroupHandle).
        oGroup:assign(ttGroupHandle).
        log-manager:write-message(string(oGroup:nom-grupo),"MY-LOG").
        
        oGroup:dat-atualiz = today.
        oGroup:cod-usuar-ult-atualiz = "super".
        oGroup:save().
        return oGroup.
    end method.

    // method public classes.beta.model.Group getByFilter():
    // end method.


end class.
