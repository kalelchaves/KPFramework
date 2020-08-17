etime(true).

output to "\\cxs-squad-sus01\quarentena\dadosN.csv"

for each usuario
    where usuario.cd-modalidade = 20
    no-lock:

    find first propost 
        where propost.cd-modalidade = usuario.cd-modalidade
        and propost.nr-proposta = usuario.nr-proposta no-lock no-error.

    find first ter-ade
        where ter-ade.cd-modalidade = usuario.cd-modalidade
        and ter-ade.nr-ter-adesao = usuario.nr-ter-adesao no-lock no-error.

    find first pessoa-fisica
        where pessoa-fisica.id-pessoa = usuario.id-pessoa no-lock no-error.
    
    find first usuario-compl
        where usuario-compl.cdn-modalid = usuario.cd-modalidade
        and usuario-compl.nr-proposta = usuario.nr-proposta
        and usuario-compl.cdn-usuario = usuario.cd-usuario no-lock no-error.
    
    for each car-ide
        where car-ide.cd-modalidade = usuario.cd-modalidade
        and car-ide.nr-ter-adesao = usuario.nr-ter-adesao
        and car-ide.cd-usuario = usuario.cd-usuario no-lock:
    end.

    put unformatted
        usuario.cd-modalidade ";"
        usuario.nm-usuario ";"
        pessoa-fisica.nm-pessoa ";"
        propost.nr-proposta ";"
        ter-ade.nr-ter-adesao ";"
        car-ide.cd-carteira-inteira ";".



end.

output close.

etime(false).


MESSAGE etime
    VIEW-AS ALERT-BOX TITLE "Atencao!".