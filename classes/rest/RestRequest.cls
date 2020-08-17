class classes.rest.RestRequest:

    def public property authorizationToken as char
    get. set.

    def public property accept as char
    get. set.

    def public property accept-encoding as char
    get. set.

    def public property cache-control as char
    get. set.

    def public property content-type as char
    get. set.

    def public property content-length as int64
    get. set.

    def public property body as longchar
    get. set.
    
    constructor public RestRequest():
        assign this-object:authorizationToken = ""
               this-object:accept = "*/*"
               this-object:accept-encoding = "identity;q=0"
               this-object:cache-control = "no-cache"
               this-object:content-type = ""
               this-object:content-length = 0
               this-object:body = "".
    end.

    method public void setBody(input lcBodyPar as longchar):
        if lcBodyPar = ""
        then assign this-object:content-type   = ""
                    this-object:content-length = 0.
        else assign this-object:content-type   = "application/json"
                    this-object:content-length = length(lcBodyPar).
        assign this-object:body = lcBodyPar.
    end method.

    method public char getHeaderText():
        def var cResult as char init "" no-undo.

        if this-object:authorizationToken <> ""
        then assign cResult = cResult + "Authorization: " + this-object:authorizationToken + "~r~n".

        if this-object:accept <> ""
        then assign cResult = cResult + "Accept: " + this-object:accept + "~r~n".

        if this-object:accept-encoding <> ""
        then assign cResult = cResult + "Accept-Encoding: " + this-object:accept-encoding + "~r~n".

        if this-object:cache-control <> ""
        then assign cResult = cResult + "Cache-Control: " + this-object:cache-control + "~r~n".

        if this-object:content-type <> ""
        then assign cResult = cResult + "Content-Type: " + this-object:content-type + "~r~n".

        if this-object:content-length > 0
        then assign cResult = cResult + "Content-Length: " + string(this-object:content-length) + "~r~n".

        return cResult.
    end method.

    method public longchar getMessage():
        return this-object:getHeaderText() + "~r~n"
             + this-object:body + "~r~n".
    end method.

end class.
