def var m-response-aux as memptr no-undo.

procedure reset:
    set-size(m-response-aux) = 0.
    set-byte-order(m-response-aux) = big-endian.
end procedure.

procedure onReadResponse:
    def var m-temp-aux as memptr no-undo.
    def var m-swap-aux as memptr no-undo.
    def var lc-temp-response-aux as longchar no-undo.
    def var i-qtd-bytes-lidos-aux as int no-undo.
    def var i-qtd-bytes-disp-aux as int no-undo.

    do while (valid-handle(self)) and (self:connected()) and (self:get-bytes-available() > 0):
        assign self:sensitive = false.
        run doReadResponse no-error.
        assign self:sensitive = true.
        process events.
    end.

    finally:
        assign self:sensitive = true.
    end finally.

end procedure.

procedure doReadResponse private:
    def var m-temp-aux as memptr no-undo.
    def var m-swap-aux as memptr no-undo.
    def var lc-temp-response-aux as longchar no-undo.
    def var i-qtd-bytes-lidos-aux as int no-undo.
    def var i-qtd-bytes-disp-aux as int no-undo.

    assign i-qtd-bytes-disp-aux = self:get-bytes-available().
    
    // logica abaixo forca a leitura da resposta por diversas vezes,
    // dando tempo para chegar toda a mensagem na porta de conexao
    if i-qtd-bytes-disp-aux > 1024
    then assign i-qtd-bytes-disp-aux = 1024.
    else pause 0.001 no-message.
    
    set-size(m-temp-aux) = 0.
    set-size(m-temp-aux) = i-qtd-bytes-disp-aux.
    set-byte-order(m-temp-aux) = big-endian.
    self:read(m-temp-aux, 1, i-qtd-bytes-disp-aux, read-available).

    assign i-qtd-bytes-lidos-aux = self:bytes-read.

    set-size(m-swap-aux) = 0.
    set-size(m-swap-aux) = get-size(m-response-aux) + i-qtd-bytes-lidos-aux.
    copy-lob from m-response-aux to m-swap-aux overlay at 1.
    copy-lob from m-temp-aux to m-swap-aux overlay at (get-size(m-response-aux) + 1).

    set-size(m-response-aux) = 0.
    set-size(m-response-aux) = get-size(m-swap-aux).
    copy-lob from m-swap-aux to m-response-aux.

end procedure.

procedure responseAsLongchar:
    def output param lc-response-par as longchar no-undo.
    assign lc-response-par = get-string(m-response-aux, 1).
end procedure.

procedure responseAsMemptr:
    def output param m-response-par as memptr no-undo.
    assign m-response-par = m-response-aux.
end procedure.
