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


class classes.beta.model.Proposal inherits classes.beta.model.Model:

    /* --- Tipos de dados internos ------------------------------------------------------------------------- */
    
    constructor public Proposal():
        super(buffer propost:handle).
        this-object:className = "classes.beta.model.Proposal".
    end constructor.

    method public classes.beta.model.Proposal extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.

    define property nr-proposta as integer get. set.
    define property cod-estabel as character get. set.
    define property nr-insc-contratante as integer get. set.
    define property cd-forma-pagto as integer get. set.
    define property cd-tipo-proposta as integer get. set.
    define property cd-contratante as integer get. set.
    define property cd-modalidade as integer get. set.
    define property cd-plano as integer get. set.
    define property cd-tipo-plano as integer get. set.
    define property cd-vendedor as integer get. set.
    define property dd-vencimento as integer get. set.
    define property dt-proposta as date get. set.
    define property dt-comercializacao as date get. set.
    define property cd-sit-proposta as integer get. set.
    define property dt-parecer as date get. set.
    define property cd-usuario-diretor as character get. set.
    define property nr-ter-adesao as integer get. set.
    define property ds-observacao as character get. set.
    define property dt-atualizacao as date get. set.
    define property cd-userid as character get. set.
    define property nr-pessoas-titulares as integer get. set.
    define property nr-pessoas-dependentes as integer get. set.
    define property pc-acrescimo as decimal get. set.
    define property pc-desconto as decimal get. set.
    define property lg-medico-empresa as logical get. set.
    define property nr-proposta-anterior as integer get. set.
    define property lg-pea as logical get. set.
    define property qt-anos-pea as integer get. set.
    define property dt-inicio-pea as date get. set.
    define property dt-fim-pea as date get. set.
    define property cd-sit-cred as integer get. set.
    define property lg-participacao as logical get. set.
    define property pc-acrescimo-inscr as decimal get. set.
    define property pc-desconto-inscr as decimal get. set.
    define property cd-parecer-medico as integer get. set.
    define property dt-confirmacao as date get. set.
    define property dt-digitacao as date get. set.
    define property dt-libera-doc as date get. set.
    define property cd-userid-confirmacao as character get. set.
    define property cd-userid-digitacao as character get. set.
    define property cd-userid-libera as character get. set.
    define property in-mensalidade-migracao as integer get. set.
    define property in-validade-doc-ident as integer get. set.
    define property mm-aa-ult-fat-mig as character get. set.
    define property cd-plano-operadora as character get. set.
    define property pc-acres-ant-migracao as decimal get. set.
    define property dec-2 as decimal get. set.
    define property lg-reajuste-migracao as logical get. set.
    define property date-1 as date get. set.
    define property cd-plano-antigo as character get. set.
    define property lg-percentual as logical get. set.
    define property lg-taxa as logical get. set.
    define property pc-comissao as decimal get. set.
    define property vl-comissao as decimal get. set.
    define property pc-desconto-taxa as decimal get. set.
    define property pc-desconto-ch as decimal get. set.
    define property cd-tab-preco as character get. set.
    define property dt-lim-acres-mens as date get. set.
    define property dt-lim-acres-inscr as date get. set.
    define property dt-lim-desc-mens as date get. set.
    define property dt-lim-desc-inscr as date get. set.
    define property lg-inicio-validade as logical get. set.
    define property lg-calculou-comissao as logical get. set.
    define property lg-verif-pagto as logical get. set.
    define property dt-val-prom-pl as date get. set.
    define property dt-val-prom-tax as date get. set.
    define property pc-desc-prom-pl as decimal get. set.
    define property pc-desc-prom-taxa as decimal get. set.
    define property ds-mascara as character get. set.
    define property lg-mascara as logical get. set.
    define property cd-convenio as integer get. set.
    define property nr-insc-contrat-origem as integer get. set.
    define property cd-contrat-origem as integer get. set.
    define property cd-unimed as integer get. set.
    define property cd-federacao as integer get. set.
    define property lg-faixa-etaria-esp as logical get. set.
    define property cd-tipo-vencimento as integer get. set.
    define property lg-cobertura-esp as logical get. set.
    define property cd-tab-preco-proc as character get. set.
    define property in-inicio-validade-usuario as character get. set.
    define property lg-altera-validade-usuario as logical get. set.
    define property lg-altera-inicio-validade as logical get. set.
    define property cd-tipo-participacao as integer get. set.
    define property lg-proc-prestador as logical get. set.
    define property lg-considera-taxa-co as logical get. set.
    define property pc-acresc-taxa as decimal get. set.
    define property nr-oficio-reajuste as character get. set.
    define property cd-procs-excl-cobert as character get. set.
    define property date-2 as date get. set.
    define property date-3 as date get. set.
    define property pc-desc-ant-migracao as decimal get. set.
    define property lg-alt-val-ini-prorroga as logical get. set.
    define property lg-cob-txadm-interc as logical get. set.
    define property in-registro-plano as integer get. set.
    define property u-char-1 as character get. set.
    define property u-char-2 as character get. set.
    define property u-char-3 as character get. set.
    define property u-date-1 as date get. set.
    define property u-date-2 as date get. set.
    define property u-date-3 as date get. set.
    define property u-dec-1 as decimal get. set.
    define property u-dec-2 as decimal get. set.
    define property u-dec-3 as decimal get. set.
    define property u-log-1 as logical get. set.
    define property u-log-2 as logical get. set.
    define property u-log-3 as logical get. set.
    define property u-int-1 as integer get. set.
    define property u-int-2 as integer get. set.
    define property u-int-3 as integer get. set.
    define property dt-aprovacao as date get. set.
    define property cd-tab-preco-proc-cob as character get. set.
    define property lg-altera-fator-moderador as logical get. set.
    define property lg-altera-taxa-inscricao as logical get. set.
    define property vl-proposta-migracao as decimal get. set.
    define property nr-contrato-antigo as character get. set.
    define property lg-dec-calc-nota as logical get. set.
    define property qt-dec-calc-nota as integer get. set.
    define property lg-precproc-cob as logical get. set.
    define property lg-cartao as logical get. set.
    define property lg-seguro-assist-local as logical get. set.
    define property mm-ult-reajuste as integer get. set.
    define property aa-ult-reajuste as integer get. set.
    define property pc-ult-reajuste as decimal get. set.
    define property lg-controle-carencia-cob-ant as logical get. set.
    define property lg-data-excl-benef as logical get. set.
    define property cd-auditor-responsavel as character get. set.
    define property char-5 as character get. set.
    define property date-4 as date get. set.
    define property date-5 as date get. set.
    define property dec-4 as decimal get. set.
    define property dec-5 as decimal get. set.
    define property in-trata-inadimplencia as integer get. set.
    define property int-4 as integer get. set.
    define property cd-registro-plano as integer get. set.
    define property lg-alt-val-usu-prorroga as logical get. set.
    define property lg-prop-regulamentada as logical get. set.
    define property dec-1 as decimal get. set.
    define property dec-3 as decimal get. set.
    define property in-tipo-contratacao as integer get. set.
    define property lg-prorroga-proposta-repasse as logical get. set.
    define property lg-prorroga-benef-repasse as logical get. set.
    define property lg-retroage-proposta-repasse as logical get. set.
    define property lg-retroage-benef-repasse as logical get. set.
    define property in-tipo-natureza as integer get. set.
    define property log-2 as logical get. set.
    define property log-3 as logical get. set.
    define property log-4 as logical get. set.
    define property log-5 as logical get. set.
    define property cod-esp-antecipacao as character get. set.
    define property nr-serie-antecipacao as character get. set.
    define property nr-docto-antecipacao as character get. set.
    define property nr-parcela-antecipacao as character get. set.
    define property qt-validade-termo as integer get. set.
    define property um-validade-termo as character get. set.
    define property qt-validade-cart as integer get. set.
    define property um-validade-cart as character get. set.
    define property qt-validade-cartao as integer get. set.
    define property um-validade-cartao as character get. set.
    define property log-6 as logical get. set.
    define property int-1 as integer get. set.
    define property int-5 as integer get. set.
    define property in-opcao-proposta as integer get. set.
    define property cd-motivo-alt-regulam as integer get. set.
    define property dt-alteracao-regulam as date get. set.
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
    define property nr-prosp-proposta as integer get. set.
    define property nr-atendimento as integer get. set.
    define property aa-atendimento as integer get. set.
    define property nr-seq-atendimento as integer get. set.
    define property id-end-cob as integer get. set.
    define property cd-userid-responsavel as character get. set.
    define property lg-solicita-cpt as logical get. set.
    define property ep-codigo as character get. set.
    define property idi-plano-ans as integer get. set.
    define property des-observacao as character get. set.
    define property num-propost-orig as integer get. set.
    define property log-permite-quest as logical get. set.
    define property log-excec-exc as logical get. set.
    define property idi-dat-exc as integer get. set.
    define property idi-dat-incl as integer get. set.
    define property num-dat-incl as integer get. set.
    define property num-dat-exc as integer get. set.
    define property log-audit-exc as logical get. set.
    define property cdn-modalid-orig-demit as integer get. set.
    define property num-propost-orig-demit as integer get. set.
    define property dat-exc-progda as date get. set.
    define property cdn-motiv-cancel as integer get. set.
    define property cdn-modalid-base-reaj as integer get. set.
    define property num-propost-base-reaj as integer get. set.
    define property log-utiliz-lotac as logical get. set.
    define property des-obs-reajus as character get. set.
    define property log-livre-16 as logical get. set.
    define property log-livre-17 as logical get. set.
    define property log-livre-18 as logical get. set.
    define property log-livre-19 as logical get. set.
    define property log-livre-20 as logical get. set.
    define property cod-livre-16 as character get. set.
    define property cod-livre-17 as character get. set.
    define property cod-livre-18 as character get. set.
    define property cod-livre-19 as character get. set.
    define property cod-livre-20 as character get. set.
    define property val-livre-16 as decimal get. set.
    define property val-livre-17 as decimal get. set.
    define property val-livre-18 as decimal get. set.
    define property val-livre-19 as decimal get. set.
    define property val-livre-20 as decimal get. set.
    define property num-livre-16 as integer get. set.
    define property num-livre-17 as integer get. set.
    define property num-livre-18 as integer get. set.
    define property num-livre-19 as integer get. set.
    define property num-livre-20 as integer get. set.
    define property dat-livre-16 as date get. set.
    define property dat-livre-17 as date get. set.
    define property dat-livre-18 as date get. set.
    define property dat-livre-19 as date get. set.
    define property dat-livre-20 as date get. set.
    define property log-obrig-cod-func as logical get. set.


end class.
