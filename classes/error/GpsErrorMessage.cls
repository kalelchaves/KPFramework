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

class classes.error.GpsErrorMessage:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    def temp-table ttMessage no-undo
        field errorMessage as char.
    
    /* --- Metodos privados -------------------------------------------------------------------------------- */

    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public void cleanErrors():
        empty temp-table ttMessage.
    end method.

    method public void insertError(input dsError as char):
        create ttMessage.
        assign ttMessage.errorMessage = dsError.
    end method.

    method public logical hasAnyError():
        return can-find(first ttMessage).
    end method.

    method public character getErrorMessage():
        find first ttMessage no-error.
        if avail ttMessage
        then return ttMessage.errorMessage.
        return "".
    end method.

end class.
