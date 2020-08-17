using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Net.MultipartEntity.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
 
class classes.rest.GpsRestClient:
    
    /* Definicoes internas */
    define private variable AUTH_NONE   as character initial "none"     no-undo.
    define private variable AUTH_URL    as character initial "url"      no-undo.
    define private variable AUTH_BASIC  as character initial "basci"    no-undo.
    define private variable AUTH_OAUTH  as character initial "oatuh"    no-undo.

    /* Controles internos */
    define private variable authenticateMethod       as character          no-undo.
    define private variable oHttpClient              as IHTTPClient        no-undo.
    define private variable oCredentials             as Credentials        no-undo.    
    define private variable oAuthToken               as character          no-undo. 

    define private temp-table headersTable no-undo
        field headerKey   as char
        field headerValue as char.

    /* Propriedades */
    define public property url as character
    get. set.
    
    define public property methodPath as character
    get. set.
    
    define public property authenticationPath as character
    get. set.

    define public property userName as character
    get. set.
    
    define public property password as character
    private get. set.
    
    define public property response as IHTTPResponse
    get. private set.
    
    define public property requestTimeout as decimal
    get. set.

    define public property acceptJsonHeader as logical
    get. set.

    /* Somente para AUTH_OAUTH */
    define public property requestBodyComplement as character
    get. set.
    
    constructor public GpsRestClient():
        THIS-OBJECT("http://localhost").
    end.

    constructor public GpsRestClient(input urlInput as char):
        assign url                = urlInput
               methodPath         = ""
               authenticationPath = "/dts/datasul-rest/resources/login"
               authenticateMethod = AUTH_NONE
               requestTimeout     = 120000
               acceptJsonHeader   = false.
        
        oHttpClient = getRESTClient().
    end.
    
    destructor public GpsRestClient():
    end.

    /* Cria conexao */
    method private IHTTPClient getRESTClient():
        define variable oClient as IHTTPClient no-undo.
        define variable oClientBuilder as ClientBuilder no-undo.

        oClientBuilder = ClientBuilder:Build():KeepCookies(CookieJarBuilder:Build():CookieJar).

        if index(url,"https") > 0 
        then oClientBuilder:UsingLibrary(this-object:getClientLibraryBuilder()).

        oClient = oClientBuilder:Client.

        return oClient.
    end method.

        /* metodo que retorna ClientLibraryBuilder */
    method private IHttpClientLibrary getClientLibraryBuilder():
        DEFINE VARIABLE cSSLProtocols AS CHARACTER EXTENT 2  NO-UNDO.
        DEFINE VARIABLE cSSLCiphers   AS CHARACTER EXTENT 10 NO-UNDO. // the size and values of the SSL protocols and ciphers depend on the server

        // Supported ciphers and protocols at https://documentation.progress.com/output/ua/OpenEdge_latest/gscsv/supported-protocols,-ciphers,-and-certificates-f.html# 
        ASSIGN cSSLProtocols[1] = 'TLSv1.2'
               cSSLProtocols[2] = 'TLSv1.1'
               cSSLCiphers[1]   = 'AES128-SHA256'
               cSSLCiphers[2]   = 'DHE-RSA-AES128-SHA256'
               cSSLCiphers[3]   = 'AES128-GCM-SHA256' 
               cSSLCiphers[4]   = 'DHE-RSA-AES128-GCM-SHA256'
               cSSLCiphers[5]   = 'ADH-AES128-SHA256'
               cSSLCiphers[6]   = 'ADH-AES128-GCM-SHA256'
               cSSLCiphers[7]   = 'ADH-AES256-SHA256'
               cSSLCiphers[8]   = 'AES256-SHA256' 
               cSSLCiphers[9]   = 'DHE-RSA-AES256-SHA256'
               cSSLCiphers[10]  = 'AES128-SHA'.

        return ClientLibraryBuilder:Build()
                                   :sslVerifyHost(NO)
                                   :SetSSLProtocols(cSSLProtocols)
                                   :SetSSLCiphers(cSSLCiphers)
                                   :ServerNameIndicator(replace(replace(url,"/",""),"https:",""))
                                   :library.                                             

    end method.
    
    /* Autenticacao Datasul */
    method public logical urlAuthenticate():
        define variable encodedPassword as character        no-undo.
        define variable oURI            as URI              no-undo.
        define variable oRequest        as IHttpRequest     no-undo.
        define variable oResponse       as IHttpResponse    no-undo.
        
        assign encodedPassword    = OpenEdge.Net.URI:encode(string(base64-encode(sha1-digest(lc(password)))), OpenEdge.Net.UriEncodingTypeEnum:Query)
               authenticateMethod = AUTH_URL.
        
        oURI = OpenEdge.Net.URI:parse(url + authenticationPath).
        oURI:addquery("username", userName).
        oURI:addquery("password", encodedPassword).
        
        oRequest = RequestBuilder:Get(oURI):request.
        oResponse = ResponseBuilder:Build():Response.
        oHttpClient:execute(oRequest, oResponse).
        
        return (oResponse:StatusCode = 200).
        
    end method.

    /* Autenticacao OAuth */
    method public logical getOAuthToken():
        define variable encodedPassword as character        no-undo.
        define variable oURI            as URI              no-undo.
        define variable oRequest        as IHttpRequest     no-undo.
        define variable oResponse       as IHttpResponse    no-undo.
        define variable oRequestBody    as string           no-undo.
        define variable oJsonEntity     as JsonObject       no-undo.
        define variable requestBody     as character        no-undo. 
        
        assign authenticateMethod = AUTH_OAUTH.
        
        if authenticationPath begins "http"
        then oURI = OpenEdge.Net.URI:parse(authenticationPath).
        else oURI = OpenEdge.Net.URI:parse(url + authenticationPath). 
        
        requestBody = "grant_type=password" +
                      "&username=" + userName +
                      "&password=" + password.
                     
        if requestBodyComplement <> ?
        then requestBody = requestBody +
                           requestBodyComplement.

        oRequestBody = new String(requestBody).
        
        oRequest = RequestBuilder:Post(oURI, oRequestBody):ContentType('application/x-www-form-urlencoded'):AcceptJson():Request.
        oResponse = ResponseBuilder:Build():Response.
        oHttpClient:execute(oRequest, oResponse).
        
        if oResponse:StatusCode = 200 
        then do:
                oJsonEntity = CAST(oResponse:Entity, JsonObject).

                if oJsonEntity:has("access_token")  
                then do:
                        oAuthToken = oJsonEntity:GetCharacter("access_token").
                        return true.
                     end.
             end.
        /* coloca na variavel que pode ser acessada externamente, 
        caso o programa chamador necessite fazer algum tratamento quando a autenticacao nao for bem sucedida */
        else response = oResponse. 
        
        return false.
        
    end method.
    
    /* Autenticacao Basica */
    method public void basicAuthenticate():
        oCredentials = new Credentials('GPS', userName, password). 
        assign authenticateMethod = AUTH_BASIC.
    end method.
    
    /* Metodo GET */
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
    
    /* Metodo POST */
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
    
    /* Metodo PUT */
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
    
    /* Metodo DELETE */
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

    method public void addHeaderToNextRequest(input headerKey as character, input headerValue as character):
        create headersTable.
        assign headersTable.headerKey   = headerKey
               headersTable.headerValue = headerValue.
        
    end method.


    method public void clearNextRequestHeader():
        for each headersTable:
            delete headersTable.
        end.
    end method.
    
    method public longchar getRequestResponseAsLongchar():
    
        def var oEntity as object no-undo.
    
        oEntity = this-object:response:Entity.
    
        IF type-of(oEntity, String) THEN
           return CAST(oEntity, String):Value.
        ELSE
           return oEntity:ToString().
    
    end method.
    
    method public JsonObject getRequestResponseAsJsonObject():

        def var jsonOutput as JsonObject        no-undo.
        def var objParse   as ObjectModelParser no-undo.
    
        assign jsonOutput = new JsonObject()
               objParse   = new ObjectModelParser()
               jsonOutput = cast(objParse:Parse(this-object:getRequestResponseAsLongchar()), JsonObject).
    
        delete object objParse.
    
        return jsonOutput.
    end method.
    
    /* Metodos internos */
    method protected JsonObject execute(input reqMethod as character, input path as character, input jsonData as JsonConstruct):
        define variable oURI as URI no-undo.

        oURI = OpenEdge.Net.URI:parse(url + methodPath + path).
        return this-object:execute(reqMethod, oURI, jsonData).
    end method.
    
    method protected JsonObject execute(input reqMethod as character, input oURI as URI, input jsonData as JsonConstruct):
        define variable oRequest        as RequestBuilder   no-undo.
        define variable oResponse       as IHttpResponse    no-undo.
        define variable jsonNames       as character extent no-undo.
       
        define variable oJsonObject     as jsonObject       no-undo.
        define variable oJsonArray      as jsonArray        no-undo.

        if acceptJsonHeader
        then oRequest = RequestBuilder:Build(reqMethod, oURI):acceptJson().
        else oRequest = RequestBuilder:Build(reqMethod, oURI).

        if this-object:isJsonArray(jsonData)
        then oRequest = oRequest:WithData(cast(jsonData, JsonArray)).
        else if this-object:isJsonObject(jsonData)
             then oRequest = oRequest:AddJsonData(cast(jsonData, JsonObject)).

        if authenticateMethod = AUTH_BASIC
        then oRequest = oRequest:UsingBasicAuthentication(oCredentials).
        else if authenticateMethod = AUTH_OAUTH
             then oRequest = oRequest:AddHeader("Authorization", "Bearer " + oAuthToken).

        for each headersTable:
            oRequest:AddHeader(new HTTPHeader(headersTable.headerKey, headersTable.headerValue)).
        end.        
        
        oHttpClient:Options:RequestTimeout = this-object:requestTimeout.
        oResponse = ResponseBuilder:Build():Response.
        oHttpClient:execute(oRequest:request, oResponse).

        assign response = oResponse.
        
        if  oResponse:StatusCode >= 200
        and oResponse:StatusCode <= 299
        and this-object:isJsonObject(oResponse:entity)
        then return cast(oResponse:entity, JsonObject).
        else return new JsonObject().
    end method.   
    
    method protected logical isJsonArray(input jsonData as object):
        define variable oJsonArray as JsonArray no-undo.
    
        assign oJsonArray = cast(jsonData, JsonArray).
        return true.
    
        catch eAnyError as Progress.Lang.Error:
            return false.
        end catch.
    end method.
    
    method protected logical isJsonObject(input jsonData as object):
        define variable oJsonObject as JsonObject no-undo.
    
        assign oJsonObject = cast(jsonData, JsonObject).
        return true.
    
        catch eAnyError as Progress.Lang.Error:
            return false.
        end catch.
    end method.    
	
	method public IHttpResponse requestRestFormData(input type-request-par      as char,
										            input url-par               as char,
                                                    input request-header-par    as HTTPHeader extent,
                                                    input request-form-data-par as MultipartEntity):
	
		define variable oClient         as IHttpClient        no-undo.
		define variable oUri            as URI                no-undo.
        define variable oRequestBuilder as RequestBuilder     no-undo.
        define variable oRequest        as IHttpRequest       no-undo.
        define variable oResponse       as IHttpResponse      no-undo.
        define variable i               as int                no-undo.	
	
		assign oClient   = ClientBuilder:Build():Client
			   oUri      = OpenEdge.Net.URI:parse(url-par).			   

        /* Cria tipo da requisicao POST ou GET */
        oRequestBuilder = RequestBuilder:Build(type-request-par, oUri).
        
		do i = 1 to extent(request-header-par):
			if request-header-par[i] <> ?
			then oRequestBuilder:AddHeader(request-header-par[i]).
		end.

        /* Adiciona o FORM-DATA a requisicao */
        if request-form-data-par <> ?
		then do:
			oRequestBuilder:WithData(request-form-data-par).
		end.		

        oRequest = oRequestBuilder:request.

        oResponse = oClient:Execute(oRequest).

        return oResponse.
        
    end method.

    method public IHttpResponse requestRestHeader(input type-request-par   as char,
                                                  input url-par         as char,									             
                                                  input request-header-par as HTTPHeader extent):
	
		define variable oClient         as IHttpClient        no-undo.
		define variable oUri            as URI                no-undo.
        define variable oRequestBuilder as RequestBuilder     no-undo.
        define variable oRequest        as IHttpRequest       no-undo.
        define variable oResponse       as IHttpResponse      no-undo.
        define variable i               as int                no-undo.
			   
		assign oClient   = ClientBuilder:Build():Client			   
			   oUri      = OpenEdge.Net.URI:parse(url-par).

        /* Cria tipo da requisicao POST ou GET */
        oRequestBuilder = RequestBuilder:Build(type-request-par, oUri).             

		do i = 1 to extent(request-header-par):
			if request-header-par[i] <> ?
			then oRequestBuilder:AddHeader(request-header-par[i]).
		end.

        oRequest = oRequestBuilder:request.

        oResponse = oClient:Execute(oRequest).

        return oResponse.
        
    end method.
    
end class.

/**
Exemplo de uso:

--- INICIO -----------------------------------
using classes.rest.GpsRestClient.

def var gpsRest as GpsRestClient no-undo.

gpsRest = new GpsRestClient().
gpsRest:url = "http://cxs-squad-sus01:8080".
gpsRest:methodPath = "/dts/datasul-rest/resources/prg/hcg/v1/creditStatus".
gpsRest:userName = "super".
gpsRest:password = "super".

if gpsRest:urlAuthenticate()
then do:
    gpsRest:delete("/7").
    message "Status code:" gpsRest:response:StatusCode view-as alert-box.
end.
else message "Erro de autenticacao" view-as alert-box.

--- FIM --------------------------------------

Métodos de requisicao:
get/post/put/delete
Aceitam as variacoes de parametros (), (PATH), (JSON), (PATH, JSON).
O PATH eh complementar a url do servidor (:url) e o path do metodo (:methodPath).
O JSON eh o objeto que pode ser enviado no payload da requisicao.
Retorna um JsonObject.
O retorno completo pode ser acessado pela propriedade :response.

Autenticação pode ser feita pelos metodos:
urlAuthenticate() para produto datasul (jboss4)
basicAuthenticate() para credenciais com basic authentication

A propriedade methodPath serve para definir a url base que sera incluida antes de cada requisicao.
Ela nao tem um valor atribuido por padrao.

*/
