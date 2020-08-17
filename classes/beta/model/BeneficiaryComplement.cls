/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: Beneficiary.cls
** Data.....: 28/07/2020
** Criacao..: Kalel Branco Chaves
** Objetivo.: 
********************************************************************************/

using classes.beta.model.*.

class classes.beta.model.BeneficiaryComplement inherits Model:   

    constructor public BeneficiaryComplement():
        super(buffer usuario-compl:handle).
        this-object:className = "classes.beta.model.BeneficiaryComplement".        
    end constructor.

    define property cdn-modalid as integer get. set.
    define property nr-proposta as integer get. set.
    define property cdn-usuario as integer get. set.
    define property des-observacao as character get. set.
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
    define property dat-carg-central-obrgs as date get. set.
    define property cdn-unid-prestdor-familia as integer get. set.
    define property cdn-prestdor-familia as integer get. set.


end class.