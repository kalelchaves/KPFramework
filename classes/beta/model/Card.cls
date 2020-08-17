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

using classes.beta.model.*.


class classes.beta.model.Card inherits classes.beta.model.Model:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    
    constructor public Card():
        super(buffer car-ide:handle).
        this-object:className = "classes.beta.model.Card".
    end constructor.

    method public classes.beta.model.Card extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.

    define property cd-unimed as integer get. set.
    define property cd-modalidade as integer get. set.
    define property nr-ter-adesao as integer get. set.
    define property cd-usuario as integer get. set.
    define property nr-carteira as integer get. set.
    define property dv-carteira as integer get. set.
    define property dt-validade as date get. set.
    define property dt-emissao as date get. set.
    define property lg-devolucao as logical get. set.
    define property dt-devolucao as date get. set.
    define property cd-sit-carteira as integer get. set.
    define property ds-observacao as character get. set.
    define property dt-atualizacao as date get. set.
    define property cd-userid as character get. set.
    define property cd-carteira-antiga as decimal get. set.
    define property nr-impressao as integer get. set.
    define property dt-renovacao as date get. set.
    define property dt-cancelamento as date get. set.
    define property int-6 as integer get. set.
    define property char-1 as character get. set.
    define property char-2 as character get. set.
    define property char-3 as character get. set.
    define property date-1 as date get. set.
    define property date-2 as date get. set.
    define property date-3 as date get. set.
    define property int-1 as integer get. set.
    define property int-2 as integer get. set.
    define property int-3 as integer get. set.
    define property log-1 as logical get. set.
    define property log-2 as logical get. set.
    define property log-3 as logical get. set.
    define property dec-1 as decimal get. set.
    define property dec-2 as decimal get. set.
    define property dec-3 as decimal get. set.
    define property u-char-1 as character get. set.
    define property u-char-2 as character get. set.
    define property u-char-3 as character get. set.
    define property u-int-1 as integer get. set.
    define property u-int-2 as integer get. set.
    define property u-int-3 as integer get. set.
    define property u-date-1 as date get. set.
    define property u-date-2 as date get. set.
    define property u-date-3 as date get. set.
    define property u-dec-1 as decimal get. set.
    define property u-dec-2 as decimal get. set.
    define property u-dec-3 as decimal get. set.
    define property u-log-1 as logical get. set.
    define property u-log-2 as logical get. set.
    define property u-log-3 as logical get. set.
    define property char-4 as character get. set.
    define property date-4 as date get. set.
    define property date-5 as date get. set.
    define property dec-4 as decimal get. set.
    define property dec-5 as decimal get. set.
    define property int-4 as integer get. set.
    define property int-5 as integer get. set.
    define property log-4 as logical get. set.
    define property log-5 as logical get. set.
    define property cd-carteira-inteira as decimal get. set.
    define property char-5 as character get. set.
    define property des-observacao as character get. set.



end class.
