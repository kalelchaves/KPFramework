/*
    Classe para uso com servicos REST.
    Objetivo eh substituir a classe GpsRestClient para processos onde eh necessario performance, 
    devido ao tempo que as classes OpenEdge.Net levam para terminar a requisicao.
*/

using Progress.Json.ObjectModel.*.
using Progress.Lang.*.
using classes.rest.*.
 
class classes.rest.GpsRest:
    
    /* Definicoes internas */
    def private var hConnection as handle no-undo.

    /* Propriedades */
    def public property url as character
    get. set.
    
    def public property methodPath as character
    get. set.
    
    def public property requestTimeout as decimal
    get. set.

    def public property request as RestRequest
    get. set.

    def public property response as RestResponse
    get. set.

    constructor public GpsRest():
        assign this-object:url                = "http://localhost"
               this-object:methodPath         = ""
               this-object:requestTimeout     = 60
               this-object:request            = new RestRequest()
               this-object:response           = new RestResponse().
    end.
    
    destructor public GpsRest():
        this-object:closeConnection().

        if valid-object(this-object:request)
        then delete object this-object:request.
        if valid-object(this-object:response)
        then delete object this-object:response.
    end.

    //
    method private void parseServerUrl(input cUrl as char, output cServer as char, output cPort as char, output cPath as char):
        
        assign cUrl = replace(cUrl, "http://", "").

        if num-entries(cUrl, "/") = 1
        then assign cUrl = entry(1, cUrl, "/")
                    cPath = "/".
        else assign cPath = substring(cUrl, index(cUrl, "/"))
                    cUrl = entry(1, cUrl, "/").

        if num-entries(cUrl, ":") = 1
        then assign cServer = entry(1, cUrl, ":")
                    cPort   = "80".
        else assign cServer = entry(1, cUrl, ":")
                    cPort   = entry(2, cUrl, ":").

    end method.

    method private longchar copyMemptrToLongchar (input mSource as memptr):
        def var lcResultAux as longchar init "" no-undo.
        def var iSize as int no-undo.

        // realiza a copia para o longchar
        // caso de erro, vai copiando menos caracteres ate dar certo
        // motivo: ao realizar o copy-lob para um longchar, no caso de haver um caracter nulo na memoria, gera erro progress
        assign iSize = get-size(mSource).
        do while iSize > 0:
            copy-lob from mSource starting at 1 for iSize to lcResultAux convert source codepage 'utf-8' no-error.
            if error-status:error
            then assign iSize = iSize - 1.
            else leave.
        end.

        return lcResultAux.
    end method.

    // Autenticacao basica
    method public char basicAuthenticate(input userName as char, input password as char):
        def var cToken as char no-undo.
        def var mToken as memptr no-undo.

        assign cToken = userName + ":" + password
               set-size(mToken) = 0
               set-size(mToken) = length(cToken)
               put-string(mToken, 1, length(cToken)) = cToken
               cToken = "Basic " + string(base64-encode(mToken))
               set-size(mToken) = 0.

        this-object:request:authorizationToken = cToken.

        return cToken.
    end method.

    // Metodo GET
    method public JsonObject get():
        return this-object:get("", new JsonObject()).
    end method.
    
    method public JsonObject get(input json as JsonConstruct):
        return this-object:get("", json).
    end method.
    
    method public JsonObject get(input path as character):
        return this-object:get(path, new JsonObject()).
    end method.
    
    method public JsonObject get(input path as character, input json as JsonConstruct):
        return this-object:execute("get", path, json).
    end method.
    
    // Metodo POST
    method public JsonObject post():
        return this-object:post("", new JsonObject()).
    end method.
    
    method public JsonObject post(input json as JsonConstruct):
        return this-object:post("", json).
    end method.
    
    method public JsonObject post(input path as character):
        return this-object:post(path, new JsonObject()).
    end method.
    
    method public JsonObject post(input path as character, input json as JsonConstruct):
        return this-object:execute("post", path, json).
    end method.
    
    // Metodo PUT
    method public JsonObject put():
        return this-object:put("", new JsonObject()).
    end method.
    
    method public JsonObject put(input json as JsonConstruct):
        return this-object:put("", json).
    end method.
    
    method public JsonObject put(input path as character):
        return this-object:put(path, new JsonObject()).
    end method.
    
    method public JsonObject put(input path as character, input json as JsonConstruct):
        return this-object:execute("put", path, json).
    end method.
    
    // Metodo DELETE
    method public JsonObject delete():
        return this-object:delete("", new JsonObject()).
    end method.
    
    method public JsonObject delete(input json as JsonConstruct):
        return this-object:delete("", json).
    end method.
    
    method public JsonObject delete(input path as character):
        return this-object:delete(path, new JsonObject()).
    end method.
    
    method public JsonObject delete(input path as character, input json as JsonConstruct):
        return this-object:execute("delete", path, json).
    end method.

    method private void closeConnection():
        if valid-handle(hConnection)
        then do:
            hConnection:disconnect() no-error.
            delete object hConnection.
        end.
    end method.

    method private JsonObject longcharToJsonObject(input lcJson as longchar):
        def var oJsonOutput as JsonObject no-undo.
        def var oJsonOutputArray as JsonArray no-undo.
        def var oParse as ObjectModelParser no-undo.

        if lcJson = ?
        or lcJson = ""
        then return ?.

        assign lcJson = replace(lcJson, "\n", "").
        assign lcJson = replace(lcJson, "~r", "").
        assign lcJson = replace(lcJson, "~n", "").

        assign oJsonOutput = new JsonObject()
               oParse      = new ObjectModelParser()
               oJsonOutput = cast(oParse:Parse(lcJson), JsonObject) no-error.

        if error-status:error
        then do:            
            assign oJsonOutputArray = new JsonArray()                   
                   oJsonOutputArray = cast(oParse:Parse(lcJson), JsonArray) no-error.

            if error-status:error
            then oJsonOutput = ?.
            else oJsonOutput:add("items", oJsonOutputArray).
        end.

        delete object oParse.

        return oJsonOutput.
    end method.
    
    method protected JsonObject execute(input cMethodPar as character, input cPathPar as character, input oJsonData as JsonConstruct):

        def var cServerAux as char no-undo.
        def var cPortAux as char no-undo.
        def var cPathAux as char no-undo.
        def var mRequestAux as memptr no-undo.
        def var lcRequestAux as longchar no-undo.
        def var lcBodyAux as longchar no-undo.
        def var oJsonResult as JsonObject no-undo.
        def var hSocketHelperAux as handle no-undo.
        def var lcResponseAux as longchar no-undo.
        def var iAttemptAux as int no-undo.

        this-object:parseServerUrl(this-object:url, output cServerAux, output cPortAux, output cPathAux).
        assign cPathAux = cPathAux + this-object:methodPath + cPathPar.

        // derruba qualquer conexao aberta
        this-object:closeConnection().
        // abre nova conexao
        create socket hConnection no-error.
        if not error-status:error
        then do:
            hConnection:connect("-H " + cServerAux + " -S " + cPortAux) no-error.
            if not hConnection:connected()
            then delete object hConnection.
        end.

        if (not valid-handle(hConnection))
        or (not hConnection:connected())
        then do:
            // retornar erro?
            return ?.
        end.

        // Instancia metodo para receber a resposta -------------------------------------

        run classes/rest/RestSocketHelper.p persistent set hSocketHelperAux no-error.
        if (error-status:error)
        or (not valid-handle(hSocketHelperAux))
        then do:
            // retornar erro?
            return ?.
        end.
        run reset in hSocketHelperAux.

        // Monta a requisicao -------------------------------------

        if oJsonData <> ?
        then do:
            assign lcBodyAux = "".
            oJsonData:write(input-output lcBodyAux).
            this-object:request:setBody(lcBodyAux).
        end.
        else this-object:request:setBody("").

        hConnection:set-read-response-procedure("onReadResponse", hSocketHelperAux).
        if this-object:requestTimeout > 0
        then hConnection:set-socket-option("SO-RCVTIMEO", string(this-object:requestTimeout)).

        assign lcRequestAux = upper(cMethodPar) + " " + cPathAux + " HTTP/1.0~r~n"
                            + this-object:request:getMessage().

        set-size(mRequestAux) = 0.
        set-size(mRequestAux) = length(lcRequestAux).
        set-byte-order(mRequestAux) = big-endian.
        put-string(mRequestAux, 1, length(lcRequestAux)) = lcRequestAux.
        hConnection:write(mRequestAux, 1, length(lcRequestAux)).
        set-size(mRequestAux) = 0.

        // Aguarda retorno -------------------------------------

        repeat:
            wait-for read-response of hConnection.
            if (not valid-handle(hConnection))
            or (not hConnection:connected())
            or (hConnection:get-bytes-available() = 0)
            then leave.
        end.

        // Resposta -------------------------------------
        
        assign iAttemptAux = 1.
        READ_SOCKET_RETURN:
        repeat:
            run responseAsMemptr in hSocketHelperAux (output mRequestAux).
            assign lcResponseAux = this-object:copyMemptrToLongchar(mRequestAux).            
            
            this-object:response:parseResponse(lcResponseAux).

            assign oJsonResult = this-object:longcharToJsonObject(this-object:response:body) no-error.
            if error-status:error
            or oJsonResult = ?
            then do:
                // realiza uma nova tentativa de leitura dos dados do socket (maximo 10)
                // Obs: somente se o retorno nao for vazio (204) e se o socket ainda estiver ativo
                if  (this-object:response:status <> 204)
                and (iAttemptAux < 10)
                and (valid-handle(hConnection))
                and (hConnection:connected())
                then do:
                    assign iAttemptAux = iAttemptAux + 1.
                    wait-for read-response of hConnection pause 0.010.
                    next READ_SOCKET_RETURN.
                end.
            end.

            return oJsonResult.
        end.

        finally:
            this-object:closeConnection() no-error.

            if valid-handle(hSocketHelperAux)
            then delete procedure hSocketHelperAux.
        end finally.

    end method.   

end class.
