using classes.beta.model.*.
using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.

def variable cBenef as Beneficiary no-undo.
def var i as int no-undo.
def var x as character extent init ["20", "7626", "1"].
def var cBenefExt as Beneficiary extent no-undo.
def var myParser as ObjectModelParser no-undo.  
def var jAux as JsonObject no-undo.

etime(true).

// output to "\\cxs-squad-sus01\quarentena\dados.csv".

cBenef = new Beneficiary().
cBenef
    :and("cd-modalidade", "=", "20").
    :and("nr-proposta", "=", "22110")
    :and("cd-sit-usuario", ">=", "5")
    :and("cd-sit-usuario", "<=", "7")
    :take(10)
    :skip(5).

jAux = new JsonObject().
jAux:add("cd-modalidade", "modality").
jAux:add("nr-proposta", "proposal").
jAux:add("cd-usuario", "code").
jAux:add("nm-usuario", "personName").
jAux:add("dt-atualizacao", "updateDate").

do while(cBenef:getNext() <> ?):

    // cBenef:nm-usuario = "TESTE NOME".
    // cBenef:person():nm-pessoa = cBenef:nm-usuario.
    // cBenef:save().
    // cBenef:person():save().    

    put unformatted
        cBenef:nm-usuario ";"
        cBenef:nr-ter-adesao ";"
        cBenef:person():nm-pessoa ";"
        cBenef:proposal():nr-ter-adesao ";"
        cBenef:proposal():nr-proposta ";"
        cBenef:contract():dt-inicio ";"
        cBenef:contract():dt-fim ";"
        cBenef:beneficiaryComplement():cod-usuar-ult-atualiz ";" skip.
        
        do while(cBenef:cards():getNext() <> ?):
            
            if cBenef:cards:cd-carteira-inteira <> ?
            then put unformatted "      " string(cBenef:cards:cd-carteira-inteira) ";" skip.

        end.

    //cBenef:toJson(jAux):writeFile("\\cxs-squad-sus01\quarentena\dados.json", true).
    cBenef:toJson():writeFile("\\cxs-squad-sus01\quarentena\dados.json", true).
        
end.

etime(false).

delete object cBenef.

MESSAGE etime
    VIEW-AS ALERT-BOX TITLE "Atencao!".

pause.

// output close.

/*
Ideias

ver getClass() no this-object:className

*/

// cBenef = new Beneficiary().
// cBenef:set("cd-modalidade", 20):set("nr-proposta", 22110):set("cd-usuario", 1):find().


// put unformatted
//     cBenef:nm-usuario ";"
//     string(cBenef:card(1):cd-carteira-inteira) ";"
//     cBenef:person():nm-pessoa ";"
//     cBenef:proposal():nr-ter-adesao ";"
//     cBenef:proposal():nr-proposta ";"
//     cBenef:contract():dt-atualizacao ";" skip.

// assign cBenefExt = cBenef:get().


// do i = 1 to extent(cBenefExt):    
    
//     put unformatted
//     cBenefExt[i]:nm-usuario ";"
//     string(cBenefExt[i]:card(1):cd-carteira-inteira) ";"
//     cBenefExt[i]:person():nm-pessoa ";"
//     cBenefExt[i]:proposal():nr-ter-adesao ";"
//     cBenefExt[i]:proposal():nr-proposta ";"
//     cBenefExt[i]:contract():dt-atualizacao ";" skip.

// end.


// put unformatted "____________________________________________" skip.


// put unformatted "_________________________________________" skip.

// cBenef
//     :and("cd-modalidade", "=", "20")
//     :and("nr-proposta", "=", "22110")
//     :take(20)
//     :skip(5).

// do while(cBenef:getNext() <> ?):

//     put unformatted
//     cBenef:nm-usuario ";"
//     string(cBenef:card(1):cd-carteira-inteira) ";"
//     cBenef:person():nm-pessoa ";"
//     cBenef:proposal():nr-ter-adesao ";"
//     cBenef:proposal():nr-proposta ";"
//     cBenef:contract():dt-atualizacao ";" skip.

// end.

// put unformatted skip(2).

// cBenef = new Beneficiary().
// cBenef:and("cd-modalidade", "=", "20").
// cBenef:and("nr-proposta", "=", "22110").
// cBenef:take(10).
// cBenef:get().

// do while(cBenef:getNext() <> ?):

//     put unformatted    
//     cBenef:nm-usuario ";"
//     string(cBenef:card(1):cd-carteira-inteira) ";"
//     cBenef:person():nm-pessoa ";"
//     cBenef:proposal():nr-ter-adesao ";"
//     cBenef:proposal():nr-proposta ";"
//     cBenef:contract():dt-atualizacao ";" skip.

// end.

// cBenef:set("cd-modalidade", 20):set("nr-proposta", 22110):set("cd-usuario", 1):find().

// jAux = new JsonObject().
// jAux:add("nm-usuario", replace(cBenef:nm-usuario, "Teste", "")).

// cBenef:update(jAux).

// jAux = new JsonObject().
// jAux:add("nm-pessoa", cBenef:nm-usuario).

// cBenef:person():update(jAux).

// disp 
//     cBenef:nm-usuario
//     string(cBenef:card(1):cd-carteira-inteira)
//     cBenef:person():nm-pessoa
//     cBenef:proposal():nr-ter-adesao
//     cBenef:proposal():nr-proposta
//     cBenef:contract():dt-atualizacao.

// MESSAGE cBenef:nm-usuario
//     SKIP cBenef:person():nm-pessoa
//     VIEW-AS ALERT-BOX INFO BUTTONS OK.

// myParser = new ObjectModelParser().
// cBenef:update(cast(myParser:parse('~{"nm-usuario": }'),JsonObject)).

// disp 
//     cBenef:nm-usuario
//     string(cBenef:card(1):cd-carteira-inteira)
//     cBenef:person():nm-pessoa
//     cBenef:proposal():nr-ter-adesao
//     cBenef:proposal():nr-proposta
//     cBenef:contract():dt-atualizacao.

// MESSAGE cBenef:nm-usuario SKIP
//     cBenef:person():nm-pessoa
//     VIEW-AS ALERT-BOX TITLE "Atencao!".

// cBenef:nm-usuario = cBenef:nm-usuario + " Teste".
// cBenef:person():nm-pessoa = cBenef:nm-usuario.
// cBenef:save().
// cBenef:person():save().

// MESSAGE cBenef:nm-usuario SKIP
//     cBenef:person():nm-pessoa
//     VIEW-AS ALERT-BOX INFO BUTTONS OK.

//cBenef:andGroup().


//cBenef:groupClose().

// cBenef:take(5).
// cBenef:skip(5).


/*
- ideia getNext verificar se esta nulo
- get por index

- serialize-name
- visibles e hiddens

*/
