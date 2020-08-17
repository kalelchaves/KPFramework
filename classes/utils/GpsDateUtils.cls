/********************************************************************************
** Programa.: GpsDateUtils.cls
**
** Data.....: 18/10/2019
**
** Criacao..: Contratos
**
** Objetivo.: Metodos para tratamentos de data
********************************************************************************/

class classes.utils.GpsDateUtils:
    
    /* --- Metodos privados -------------------------------------------------------------------------------- */

    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public log intersection (input initialDate1 as date, input finalDate1 as date, initialDate2 as date, finalDate2 as date):
        
        if finalDate2 < initialDate1
        then return false.

        if initialDate2 > finalDate1
        then return false.

        return true.

    end method.

end class.