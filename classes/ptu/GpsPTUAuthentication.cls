/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: GpsPTUAuthentication.cls
** Data.....: 27/01/20120
** Criacao..: Joao Reva
** Objetivo.: Classe responsavel pela autenticacao com a unimed do brasil
********************************************************************************/

using OpenEdge.Core.Memptr.
using classes.rest.GpsRestClient.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.HTTPHeader.
using classes.json.GpsJsonUtils.

class classes.ptu.GpsPTUAuthentication inherits classes.error.GpsErrorMessage:

    def public  var token      as char            no-undo.
    def private var gpsRest    as GpsRestClient   no-undo. 
    def private var authType   as char            no-undo. 

    constructor public GpsPTUAuthentication(input authTypeParam as char):
        authType = authTypeParam.
        this-object:getToken(). 
    end constructor.

    method private void getToken():

        def var ds-url as char no-undo.
        def var i-aux  as int  no-undo.
        def var response-aux as IHttpResponse no-undo.
        def var request-header-aux  as HTTPHeader extent no-undo.

        for first param-integr-unimed-gps fields(cod-token-cmb 
                                                 cod-token-software-pcte 
                                                 cod-token-classif-rede
                                                 cod-endpoint-cmb
                                                 cod-endpoint-software-pcte
                                                 cod-endpoint-classif-rede
                                                 cod-usuario
                                                 cod-senha
                                                 dsl-autentic-cmb
                                                 dsl-autentic-software-pcte
                                                 dsl-autentic-classif-rede
                                                 dtm-token-cmb
                                                 dtm-token-software-pcte
                                                 dtm-token-classif-rede)
                  no-lock:
        end.

        if not this-object:getVerifyParams()
        then return.

        case authType:
            when "CMB"
            then do:
                if getTokenFromTable(param-integr-unimed-gps.dsl-autentic-cmb, param-integr-unimed-gps.dtm-token-cmb)
                then return.
                
                ds-url = getAuthUrl(param-integr-unimed-gps.cod-token-cmb, param-integr-unimed-gps.cod-endpoint-cmb).
            end.
            when "SOFT_PCTE"
            then do:
                if getTokenFromTable(param-integr-unimed-gps.dsl-autentic-software-pcte, param-integr-unimed-gps.dtm-token-software-pcte)
                then return.

                ds-url = getAuthUrl(param-integr-unimed-gps.cod-token-software-pcte, param-integr-unimed-gps.cod-endpoint-software-pcte).
            end.
            when "CLASS_REDE"
            then do:
                if getTokenFromTable(param-integr-unimed-gps.dsl-autentic-classif-rede, param-integr-unimed-gps.dtm-token-classif-rede)
                then return.

                ds-url = getAuthUrl(param-integr-unimed-gps.cod-token-classif-rede, param-integr-unimed-gps.cod-endpoint-classif-rede).
            end.
        end case.

        gpsRest = new GpsRestClient().

        /* Obtem o token de autorizacao */
        do i-aux = 1 to 4:
            response-aux = gpsRest:requestRestHeader("POST",                                                      
                                                     ds-url,
                                                     request-header-aux).

            if response-aux:StatusCode = 200
            then leave.

            pause 2.
        end.

        if response-aux:StatusCode = 500
        then do:
            this-object:insertError("Servico da Brasil esta fora! Status: " + string(response-aux:StatusCode)).
            return.
        end.
        else if response-aux:StatusCode <> 200
        then do:   
            this-object:insertError("Nao foi possivel gerar o token de acesso. Verificar os Parametros! Status: " + string(response-aux:StatusCode)).
            return.
        end.

        assign token = CAST(response-aux:Entity, OpenEdge.Core.Memptr):GetString(2).

        /* Retira os objetos da memoria */
        delete object gpsRest no-error.

        saveToken().

    end method.

    method private char getAuthUrl(input sessionToken as char, input endpoint as char):

        find first paramecp no-lock no-error.

        return endpoint 
             + "/idp/portal/" 
             + sessionToken
             + "?username=" + param-integr-unimed-gps.cod-usuario
             + "&password=" + param-integr-unimed-gps.cod-senha
             + "&unimed=" + string(paramecp.cd-unimed, "9999").

    end method.

    method private log getVerifyParams():

        if authType <> "CMB"
        and authType <> "SOFT_PCTE"
        and authType <> "CLASS_REDE"
        then do:
            this-object:insertError("Tipo de autenticacao invalido").
            return no.
        end.

        if not avail param-integr-unimed-gps
        or param-integr-unimed-gps.cod-usuario = ""
        then do:  
            this-object:insertError("Parametros nao estao informados!").
            return no.
        end.

        return yes.
    end method.

    method private log getTokenFromTable(tokenPar as char, authenticationDate as datetime):
        if interval(datetime(today,mtime), authenticationDate, "hours") >= 7
        or trim(tokenPar) = ""
        or tokenPar = ?
        then return no.

        assign token = tokenPar.
        return yes.

    end method.

    method private void saveToken():
        find current param-integr-unimed-gps exclusive-lock no-wait no-error.
        
        if not avail param-integr-unimed-gps
        then return.

        case authType:
            when "CMB"
            then assign param-integr-unimed-gps.dsl-autentic-cmb = token
                        param-integr-unimed-gps.dtm-token-cmb = datetime(today, mtime).
            when "SOFT_PCTE"
            then assign param-integr-unimed-gps.dsl-autentic-software-pcte = token
                        param-integr-unimed-gps.dtm-token-software-pcte = datetime(today, mtime).
            when "CLASS_REDE"
            then assign param-integr-unimed-gps.dsl-autentic-classif-rede = token
                        param-integr-unimed-gps.dtm-token-classif-rede = datetime(today, mtime).
        end case.
    end method.

end class.
