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


class classes.beta.model.Contract inherits classes.beta.model.Model:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    
    constructor public Contract():
        super(buffer ter-ade:handle).
        this-object:className = "classes.beta.model.Contract".
    end constructor.

    method public classes.beta.model.Contract extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.

    define property cd-modalidade as integer get. set.
    define property nr-ter-adesao as integer get. set.
    define property cd-armario as character get. set.
    define property cd-prateleira as character get. set.
    define property nr-pasta as character get. set.
    define property dt-inicio as date get. set.
    define property dt-fim as date get. set.
    define property dt-aprovacao as date get. set.
    define property cd-sit-adesao as integer get. set.
    define property ds-observacao as character get. set.
    define property dt-atualizacao as date get. set.
    define property cd-userid as character get. set.
    define property aa-ult-fat as integer get. set.
    define property mm-ult-fat as integer get. set.
    define property dt-mov-inclusao as date get. set.
    define property cd-userid-inclusao as character get. set.
    define property dt-mov-exclusao as date get. set.
    define property cd-userid-exclusao as character get. set.
    define property dt-cancelamento as date get. set.
    define property aa-pri-fat as integer get. set.
    define property mm-pri-fat as integer get. set.
    define property char-1 as character get. set.
    define property char-2 as character get. set.
    define property dec-1 as decimal get. set.
    define property dec-2 as decimal get. set.
    define property lg-mantem-senha-benef as logical get. set.
    define property date-1 as date get. set.
    define property lg-faturar as logical get. set.
    define property cod-esp as character get. set.
    define property nr-docto as integer get. set.
    define property parcela as integer get. set.
    define property lg-comissao as logical get. set.
    define property vl-inscricao-implant as decimal get. set.
    define property vl-inscricao-apos as decimal get. set.
    define property vl-comissao as decimal get. set.
    define property vl-indenizacao as decimal get. set.
    define property dt-pagto-comissao as date get. set.
    define property in-seguro as character get. set.
    define property cd-userid-inc-seguro as character get. set.
    define property cd-userid-exc-seguro as character get. set.
    define property dt-inclusao-seguro as date get. set.
    define property dt-exclusao-seguro as date get. set.
    define property cod-esp-comissao as character get. set.
    define property nr-docto-comissao as integer get. set.
    define property parcela-comissao as integer get. set.
    define property nr-usuarios-implant as integer get. set.
    define property nr-usuarios-apos as integer get. set.
    define property vl-mensalidade-1 as decimal get. set.
    define property vl-mensalidade-atu as decimal get. set.
    define property nr-usuarios-atu as integer get. set.
    define property dt-renovacao as date get. set.
    define property vl-inscricao-base as decimal get. set.
    define property vl-mensalidade-base as decimal get. set.
    define property dt-validade-cart as date get. set.
    define property cd-forma-pagto-cm as integer get. set.
    define property cd-tipo-proposta-cm as integer get. set.
    define property lg-habilitado-gp as logical get. set.
    define property lg-autorizacao-gp as logical get. set.
    define property lg-bloqueia-atendimento as logical get. set.
    define property cd-classe-mens as integer get. set.
    define property cd-motivo-cancel as integer get. set.
    define property lg-sit-anormal as logical get. set.
    define property dt-inicio-sit-anormal as date get. set.
    define property dt-fim-sit-anormal as date get. set.
    define property char-3 as character get. set.
    define property dt-inicio-bloqueio as date get. set.
    define property date-3 as date get. set.
    define property dec-3 as decimal get. set.
    define property cd-senha as integer get. set.
    define property log-2 as logical get. set.
    define property log-3 as logical get. set.
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
    define property log-4 as logical get. set.
    define property in-contratante-mensalidade as integer get. set.
    define property in-contratante-participacao as integer get. set.
    define property in-contratate-co as integer get. set.
    define property date-2 as date get. set.
    define property char-4 as character get. set.
    define property char-5 as character get. set.
    define property date-4 as date get. set.
    define property date-5 as date get. set.
    define property dec-4 as decimal get. set.
    define property dec-5 as decimal get. set.
    define property in-contratante-inadim as integer get. set.
    define property int-5 as integer get. set.
    define property log-5 as logical get. set.
    define property in-gera-senha as integer get. set.
    define property in-emissao-relat as integer get. set.
    define property in-contratante-custo-op as integer get. set.
    define property log-1 as logical get. set.
    define property in-negociacao-participacao as integer get. set.
    define property lg-desconta-plano-producao as logical get. set.
    define property cd-unidade-prestador as integer get. set.
    define property cd-prestador as integer get. set.
    define property int-6 as integer get. set.
    define property int-7 as integer get. set.
    define property aa-ult-fat-period as integer get. set.
    define property mm-ult-fat-period as integer get. set.
    define property in-regra-intercambio as integer get. set.
    define property in-habilitado-gp as integer get. set.
    define property char-11 as character get. set.
    define property char-12 as character get. set.
    define property char-13 as character get. set.
    define property char-14 as character get. set.
    define property char-15 as character get. set.
    define property dec-11 as decimal get. set.
    define property dec-12 as decimal get. set.
    define property dec-13 as decimal get. set.
    define property dec-14 as decimal get. set.
    define property dec-15 as decimal get. set.
    define property date-11 as date get. set.
    define property date-12 as date get. set.
    define property date-13 as date get. set.
    define property date-14 as date get. set.
    define property date-15 as date get. set.
    define property int-11 as integer get. set.
    define property int-12 as integer get. set.
    define property int-13 as integer get. set.
    define property int-14 as integer get. set.
    define property int-15 as integer get. set.
    define property log-11 as logical get. set.
    define property log-12 as logical get. set.
    define property log-13 as logical get. set.
    define property log-14 as logical get. set.
    define property log-15 as logical get. set.
    define property des-observacao as character get. set.




end class.
