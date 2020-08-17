class classes.rest.RestResponse:

    def public property status as int
    get. set.

    def public property body as longchar
    get. set.

    constructor public RestResponse():
        this-object:reset().
    end.

    method private void reset():
        assign this-object:status = 0
               this-object:body = "".
        fix-codepage(this-object:body) = 'utf-8'.
    end method.

    method public void parseResponse(input lcResponsePar as longchar):
        def var iLine as int no-undo.
        def var lcLineAux as longchar no-undo.
        def var lcKeyAux as longchar no-undo.
        def var lcValueAux as longchar no-undo.
        def var lHeaderDoneAux as log init false no-undo.

        this-object:reset().

        do iLine = 1 to num-entries(lcResponsePar, chr(13)):
            assign lcLineAux = trim(entry(iLine, lcResponsePar, chr(13))).
            
            if lHeaderDoneAux
            then do:
                if this-object:body <> ""
                then assign this-object:body = this-object:body + "~r~n" + lcLineAux.
                else assign this-object:body = lcLineAux.
            end.
            else do:
                if lcLineAux = ""
                then assign lHeaderDoneAux = true.
                else do:
                    if num-entries(lcLineAux, ":") = 2
                    then do:
                        assign lcKeyAux = trim(entry(1, lcLineAux, ":"))
                               lcValueAux = trim(entry(2, lcLineAux, ":")).
                        //
                        if lcKeyAux = "Status"
                        then this-object:status = int(substring(lcValueAux, 1, 3)) no-error.
                    end.
                end.
            end.
        end.

        assign this-object:body = trim(this-object:body).
    end method.

end class.
