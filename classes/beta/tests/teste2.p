//C:\DLC116\bin\prowin32.exe -cpterm iso8859-1 -cpstream ibm850 -basekey "ini" -ininame C:\totvs\datasul\dts-0\ERP\scripts-8080\rpw\DIFlex.ini -pf C:\totvs\datasul\dts-0\ERP\scripts-8080\rpw\contratos\datasul.pf -p C:\totvs\datasul\dts-0\ERP\scripts-8080\rpw\alias.p -param TEC,BTB,rpwCntrt,super,super

output to "C:/temp/properties.grp.txt".
def var i as integer no-undo.
def var tableHandle as handle.

for first grp no-lock: end.
assign tableHandle = buffer grp:handle.

repeat i = 1 to tableHandle:num-fields:
    put unformatted 
        "define property " 
        tableHandle:buffer-field(i):name 
        " as "
        tableHandle:buffer-field(i):data-type
        " get. set." skip.
end.

output close.