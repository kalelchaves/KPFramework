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
using Progress.Json.ObjectModel.*.
using classes.beta.model.*.

class classes.beta.model.Beneficiary inherits Model:   

    constructor public Beneficiary():
        super(buffer usuario:handle).
        this-object:className = "classes.beta.model.Beneficiary".        

        this-object:person = new Person().
        this-object:proposal = new Proposal().
        this-object:contract = new Contract().
        this-object:cards = new Card().
        this-object:beneficiaryComplement = new BeneficiaryComplement().

        this-object:jsonSerializeModel = new JsonObject().
        this-object:jsonSerializeModel:add("cd-modalidade", "modality").
        this-object:jsonSerializeModel:add("nr-proposta", "proposal").
        this-object:jsonSerializeModel:add("cd-usuario", "code").
        this-object:jsonSerializeModel:add("nm-usuario", "name").
        this-object:jsonSerializeModel:add("cd-cpf", "taxPayerRegistryNumber").
    end constructor. 

    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa","id-pessoa"), this-object:person:className).
    end method.      

    method public class Proposal proposal():        
        return dynamic-cast(this-object:hasOne(this-object:proposal, "cd-modalidade,nr-proposta"), this-object:proposal:className).
    end method.    

    method public class Contract Contract():        
        return dynamic-cast(this-object:hasOne(this-object:contract, "cd-modalidade,nr-ter-adesao"), this-object:contract:className).
    end method.

    method public class BeneficiaryComplement BeneficiaryComplement():
        return dynamic-cast(this-object:hasOne(this-object:beneficiaryComplement, "cdn-modalid,nr-proposta,cdn-usuario", "cd-modalidade,nr-proposta,cd-usuario"), this-object:beneficiaryComplement:className).
    end method.    

    method public class Card cards():
        this-object:cards:keys = "cd-unimed,cd-modalidade,nr-ter-adesao,cd-usuario".
        this-object:cards:hasMany(this-object).
        return this-object:cards.
    end method.

    /*Opcional*/
    method public classes.beta.model.Beneficiary extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.  

    define property person as Person get. set.
    define property proposal as Proposal get. set.
    define property contract as Contract get. set.
    define property cards as Card get. set.
    define property beneficiaryComplement as BeneficiaryComplement get. set.
        
    define property cd-modalidade as integer get. set.
    define property nr-proposta as integer get. set.
    define property cd-usuario as integer get. set.
    define property nr-ter-adesao as integer get. set.
    define property nm-usuario as character get. set.
    define property in-est-civil as decimal get. set.
    define property cd-cpf as character get. set.
    define property cd-cbo as integer get. set.
    define property lg-sexo as logical get. set.
    define property dt-nascimento as date get. set.
    define property nr-identidade as character get. set.
    define property en-rua as character get. set.
    define property en-bairro as character get. set.
    define property uf-emissor-doc as character get. set.
    define property en-cep as character get. set.
    define property en-uf as character get. set.
    define property dt-inclusao-plano as date get. set.
    define property dt-exclusao-plano as date get. set.
    define property cd-unimed as integer get. set.
    define property cd-grau-parentesco as integer get. set.
    define property cd-titular as integer get. set.
    define property dt-atualizacao as date get. set.
    define property cd-userid as character get. set.
    define property cd-sit-cadastro as integer get. set.
    define property lg-carencia as logical get. set.
    define property cd-funcionario as character get. set.
    define property aa-ult-fat as integer get. set.
    define property mm-ult-fat as integer get. set.
    define property cd-sit-usuario as integer get. set.
    define property ds-observacao as character get. set.
    define property dt-mov-inclusao as date get. set.
    define property dt-mov-exclusao as date get. set.
    define property cd-userid-inclusao as character get. set.
    define property cd-userid-exclusao as character get. set.
    define property aa-pri-fat as integer get. set.
    define property mm-pri-fat as integer get. set.
    define property nm-email as character get. set.
    define property cd-padrao-cob-ant as character get. set.
    define property cd-identific-orig-resp as decimal get. set.
    define property dec-2 as decimal get. set.
    define property lg-reimp-carteira-rep as logical get. set.
    define property dt-senha as date get. set.
    define property nm-usuario-cartao as character get. set.
    define property dt-mvto-alteracao as date get. set.
    define property ds-especifico1 as character get. set.
    define property ds-especifico2 as character get. set.
    define property ds-especifico3 as character get. set.
    define property ds-especifico4 as character get. set.
    define property dt-inclusao-seguro as date get. set.
    define property dt-exclusao-seguro as date get. set.
    define property in-seguro as character get. set.
    define property cd-cidade as integer get. set.
    define property int-6 as integer get. set.
    define property int-7 as integer get. set.
    define property dt-admissao-empresa as date get. set.
    define property int-4 as integer get. set.
    define property dt-falecimento-titular as date get. set.
    define property nm-internacional as character get. set.
    define property cd-identific-uni-origem as decimal get. set.
    define property cd-identific-fed-origem as decimal get. set.
    define property cd-unimed-origem as integer get. set.
    define property cd-federacao-origem as integer get. set.
    define property cd-departamento as integer get. set.
    define property cd-identific-uni-destino as decimal get. set.
    define property cd-setor as integer get. set.
    define property cd-secao as integer get. set.
    define property nr-pasta as integer get. set.
    define property cd-identific-fed-destino as decimal get. set.
    define property cd-unimed-destino as integer get. set.
    define property cd-unidade-atendimento as integer get. set.
    define property dt-aprovacao as date get. set.
    define property cd-plano-origem as character get. set.
    define property nm-plano as character get. set.
    define property cd-transacao as character get. set.
    define property cd-departamento-ant as integer get. set.
    define property cd-setor-ant as integer get. set.
    define property cd-secao-ant as integer get. set.
    define property cd-cbo-ant as integer get. set.
    define property lg-insc-fatura as logical get. set.
    define property lg-insc-repasse as logical get. set.
    define property dt-inclusao-intercambio as date get. set.
    define property lg-imp-carta-inter as logical get. set.
    define property u-log-1 as logical get. set.
    define property cd-padrao-cobertura as character get. set.
    define property cd-carteira-trabalho as character get. set.
    define property char-3 as character get. set.
    define property dt-alt-ans as date get. set.
    define property dt-emissao-doc as date get. set.
    define property dec-3 as decimal get. set.
    define property lg-sofreu-suspensao as logical get. set.
    define property u-log-2 as logical get. set.
    define property u-log-3 as logical get. set.
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
    define property cd-motivo-cancel as integer get. set.
    define property dt-atualizacao-carencia as date get. set.
    define property cd-userid-carencia as character get. set.
    define property nr-dias as integer get. set.
    define property lg-bonifica-penaliza as logical get. set.
    define property lg-cobra-fator-moderador as logical get. set.
    define property cd-modalidade-anterior as integer get. set.
    define property nr-proposta-anterior as integer get. set.
    define property cd-usuario-anterior as integer get. set.
    define property dt-inicio-vinculo-unidade as date get. set.
    define property cd-senha as integer get. set.
    define property aa-mm-sem-reaj-troca-fx as integer get. set.
    define property in-via-transferencia as character get. set.
    define property dt-fim-seguro-assitencial as date get. set.
    define property cd-carteira-antiga as decimal get. set.
    define property in-tipo-movto-carta as character get. set.
    define property ct-nova-carteira as integer get. set.
    define property cd-userid-reativa as character get. set.
    define property dt-data-reativa as date get. set.
    define property ds-nacionalidade as character get. set.
    define property ds-natureza-doc as character get. set.
    define property date-4 as date get. set.
    define property dt-primeira-consulta-mig as date get. set.
    define property dec-4 as decimal get. set.
    define property dec-5 as decimal get. set.
    define property int-5 as integer get. set.
    define property log-4 as logical get. set.
    define property log-5 as logical get. set.
    define property ds-cob-esp-unid-orig as character get. set.
    define property ds-origem-movimentacao as character get. set.
    define property dt-origem-movimentacao as date get. set.
    define property cd-unidade-orig-resp as integer get. set.
    define property in-emissao-relat as integer get. set.
    define property int-3 as integer get. set.
    define property lg-cobertura-esp as logical get. set.
    define property log-2 as logical get. set.
    define property date-5 as date get. set.
    define property cod-esp-antecipacao as character get. set.
    define property nr-serie-antecipacao as character get. set.
    define property nr-docto-antecipacao as character get. set.
    define property nr-parcela-antecipacao as character get. set.
    define property cd-vendedor as integer get. set.
    define property aa-ult-compl as integer get. set.
    define property mm-ult-compl as integer get. set.
    define property aa-fim-compl as integer get. set.
    define property mm-fim-compl as integer get. set.
    define property dec-1 as decimal get. set.
    define property cd-pis-pasep as decimal get. set.
    define property cd-cartao-nacional-saude as decimal get. set.
    define property nm-mae as character get. set.
    define property nm-pai as character get. set.
    define property in-segmento-assistencial as integer get. set.
    define property qt-taxa-transferencia as integer get. set.
    define property dt-inclusao-origem as date get. set.
    define property cd-registro-plano as integer get. set.
    define property nr-telefone1 as character get. set.
    define property nr-telefone2 as character get. set.
    define property cd-userid-alt-ans as character get. set.
    define property cd-plano-operadora as character get. set.
    define property dt-falecimento as date get. set.
    define property int-2 as integer get. set.
    define property lg-capturar-biometria as logical get. set.
    define property ds-orgao-emissor-ident as character get. set.
    define property nm-pais as character get. set.
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
    define property cd-modalidade-mae as integer get. set.
    define property nr-proposta-mae as integer get. set.
    define property cd-usuario-mae as integer get. set.
    define property char-16 as character get. set.
    define property char-17 as character get. set.
    define property char-18 as character get. set.
    define property char-19 as character get. set.
    define property log-16 as logical get. set.
    define property log-17 as logical get. set.
    define property date-16 as date get. set.
    define property cd-ident-bio-griaule as character get. set.
    define property id-pessoa as decimal get. set.
    define property char-20 as character get. set.
    define property char-21 as character get. set.
    define property char-22 as character get. set.
    define property char-23 as character get. set.
    define property char-24 as character get. set.
    define property char-25 as character get. set.
    define property char-26 as character get. set.
    define property char-27 as character get. set.
    define property char-28 as character get. set.
    define property char-29 as character get. set.
    define property date-17 as date get. set.
    define property date-18 as date get. set.
    define property date-19 as date get. set.
    define property date-20 as date get. set.
    define property date-21 as date get. set.
    define property date-22 as date get. set.
    define property date-23 as date get. set.
    define property date-24 as date get. set.
    define property date-25 as date get. set.
    define property date-26 as date get. set.
    define property log-18 as logical get. set.
    define property log-19 as logical get. set.
    define property log-20 as logical get. set.
    define property log-21 as logical get. set.
    define property log-22 as logical get. set.
    define property log-23 as logical get. set.
    define property log-24 as logical get. set.
    define property log-25 as logical get. set.
    define property log-26 as logical get. set.
    define property log-27 as logical get. set.
    define property int-16 as integer get. set.
    define property int-17 as integer get. set.
    define property int-18 as integer get. set.
    define property int-19 as integer get. set.
    define property int-20 as integer get. set.
    define property int-21 as integer get. set.
    define property int-22 as integer get. set.
    define property int-23 as integer get. set.
    define property int-24 as integer get. set.
    define property int-25 as integer get. set.
    define property cd-controle-oper-ans as decimal get. set.
    define property int-26 as integer get. set.
    define property int-27 as integer get. set.
    define property int-28 as integer get. set.
    define property int-29 as integer get. set.
    define property int-30 as integer get. set.
    define property char-30 as character get. set.
    define property char-31 as character get. set.
    define property char-32 as character get. set.
    define property char-33 as character get. set.
    define property char-34 as character get. set.
    define property char-35 as character get. set.
    define property int-31 as integer get. set.
    define property int-32 as integer get. set.
    define property int-33 as integer get. set.
    define property int-34 as integer get. set.
    define property int-35 as integer get. set.
    define property log-28 as logical get. set.
    define property log-29 as logical get. set.
    define property log-30 as logical get. set.
    define property date-28 as date get. set.
    define property date-29 as date get. set.
    define property date-30 as date get. set.
    define property dec-16 as decimal get. set.
    define property dec-17 as decimal get. set.
    define property dec-18 as decimal get. set.
    define property idi-plano-ans as integer get. set.
    define property cdn-lotac as integer get. set.
    define property cdn-respons-financ as integer get. set.
    define property cdn-lotac-ant as integer get. set.


end class.
