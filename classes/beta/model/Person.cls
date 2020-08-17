/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: Person.cls
** Data.....: 28/07/2020
** Criacao..: Kalel Branco Chaves
** Objetivo.: 
********************************************************************************/

using classes.beta.model.*.


class classes.beta.model.Person inherits Model:
    
    
    constructor public Person():
        super(buffer pessoa-fisica:handle).
        this-object:className = "classes.beta.model.Person".        
    end constructor.

    method public classes.beta.model.Person extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.        

    define property id-pessoa-old as integer get. set.
    define property nm-pessoa as character get. set.
    define property cd-cpf as character get. set.
    define property dt-nascimento as date get. set.
    define property in-estado-civil as integer get. set.
    define property nome-abrev as character get. set.
    define property cd-cbo as integer get. set.
    define property lg-sexo as logical get. set.
    define property nr-identidade as character get. set.
    define property uf-emissor-ident as character get. set.
    define property nm-cartao as character get. set.
    define property nm-internacional as character get. set.
    define property ds-nacionalidade as character get. set.
    define property ds-natureza-doc as character get. set.
    define property nr-pis-pasep as decimal get. set.
    define property nm-mae as character get. set.
    define property nm-pai as character get. set.
    define property ds-orgao-emissor-ident as character get. set.
    define property nm-pais-emissor-ident as character get. set.
    define property dt-emissao-ident as date get. set.
    define property char-1 as character get. set.
    define property char-2 as character get. set.
    define property char-3 as character get. set.
    define property char-4 as character get. set.
    define property char-5 as character get. set.
    define property date-1 as date get. set.
    define property date-2 as date get. set.
    define property date-3 as date get. set.
    define property date-4 as date get. set.
    define property date-5 as date get. set.
    define property dec-1 as decimal get. set.
    define property dec-2 as decimal get. set.
    define property dec-3 as decimal get. set.
    define property dec-4 as decimal get. set.
    define property dec-5 as decimal get. set.
    define property log-1 as logical get. set.
    define property log-2 as logical get. set.
    define property log-3 as logical get. set.
    define property log-4 as logical get. set.
    define property log-5 as logical get. set.
    define property int-1 as integer get. set.
    define property int-2 as integer get. set.
    define property int-3 as integer get. set.
    define property int-4 as integer get. set.
    define property int-5 as integer get. set.
    define property u-char-1 as character get. set.
    define property u-char-2 as character get. set.
    define property u-char-3 as character get. set.
    define property u-date-1 as date get. set.
    define property u-date-2 as date get. set.
    define property u-date-3 as date get. set.
    define property u-dec-1 as decimal get. set.
    define property u-dec-2 as decimal get. set.
    define property u-dec-3 as decimal get. set.
    define property u-int-1 as integer get. set.
    define property u-int-2 as integer get. set.
    define property u-int-3 as integer get. set.
    define property u-log-1 as logical get. set.
    define property u-log-2 as logical get. set.
    define property u-log-3 as logical get. set.
    define property nm-conjuge as character get. set.
    define property nr-cei as character get. set.
    define property cd-cartao-nacional-saude as decimal get. set.
    define property id-pessoa as decimal get. set.
    define property cd-userid as character get. set.
    define property dt-atualizacao as date get. set.
    define property id-pessoa-crm as integer get. set.
    define property dt-integracao-crm as date get. set.
    define property ds-integracao-crm as character get. set.
    define property int-6 as integer get. set.
    define property int-7 as integer get. set.
    define property int-8 as integer get. set.
    define property int-9 as integer get. set.
    define property int-10 as integer get. set.
    define property int-11 as integer get. set.
    define property int-12 as integer get. set.
    define property int-13 as integer get. set.
    define property int-14 as integer get. set.
    define property int-15 as integer get. set.
    define property log-6 as logical get. set.
    define property log-7 as logical get. set.
    define property log-8 as logical get. set.
    define property log-9 as logical get. set.
    define property log-10 as logical get. set.
    define property dec-6 as decimal get. set.
    define property dec-7 as decimal get. set.
    define property dec-8 as decimal get. set.
    define property dec-9 as decimal get. set.
    define property dec-10 as decimal get. set.
    define property date-6 as date get. set.
    define property date-7 as date get. set.
    define property date-8 as date get. set.
    define property date-9 as date get. set.
    define property date-10 as date get. set.
    define property char-6 as character get. set.
    define property char-7 as character get. set.
    define property char-8 as character get. set.
    define property char-9 as character get. set.
    define property char-10 as character get. set.
    define property char-11 as character get. set.
    define property char-12 as character get. set.
    define property char-13 as character get. set.
    define property char-14 as character get. set.
    define property char-15 as character get. set.
    define property nom-prim as character get. set.
    define property log-unif-pessoa as logical get. set.
    define property log-descons-unif-pessoa as logical get. set.
    define property cod-nit as character get. set.
    define property idi-raca as integer get. set.
    define property nom-social as character get. set.
    define property cod-pais-nasc as character get. set.
    define property cod-pais-nacion as character get. set.
    define property dat-chegad-bra as date get. set.
    define property cdn-classif-ingresso as integer get. set.
    define property log-casad-bras as logical get. set.
    define property log-possui-filho-bras as logical get. set.
    define property log-def-fisica as logical get. set.
    define property log-def-auditiva as logical get. set.
    define property log-def-mental as logical get. set.
    define property log-def-intelectual as logical get. set.
    define property log-reabil as logical get. set.
    define property log-incap as logical get. set.
    define property cod-ctps as character get. set.
    define property cod-serie-ctps as character get. set.
    define property cod-uf-ctps as character get. set.
    define property cod-ric as character get. set.
    define property nom-orgao-emissor-ric as character get. set.
    define property dat-expedicao-ric as date get. set.
    define property cod-rne as character get. set.
    define property nom-orgao-emissor-rne as character get. set.
    define property dat-expedicao-rne as date get. set.
    define property cod-cnh as character get. set.
    define property cod-uf-cnh as character get. set.
    define property dat-expedicao-cnh as date get. set.
    define property dat-valid-cnh as date get. set.
    define property dat-primeira-cnh as date get. set.
    define property cod-categ-cnh as character get. set.
    define property log-def-visual as logical get. set.
    define property cdn-grau-instrucao as integer get. set.
    define property idi-genero-social as integer get. set.
    define property cod-cartao-social as character get. set.
    define property cod-caepf as character get. set.
    define property log-troca-sexo as logical get. set.


end class.
