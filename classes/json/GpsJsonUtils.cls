/********************************************************************************
** Copyright TOTVS S.A. (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/

/********************************************************************************
** Programa.: GpsJsonUtils.cls
**
** Data.....: 28/09/2018
**
** Cria??o..: Ezequiel Gandolfi
**
** Objetivo.: Tratamentos de objetos Json utilizados nas APIs
********************************************************************************/

using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.
using com.totvs.framework.api.*.
using classes.json.*.

class classes.json.GpsJsonUtils:
    
    /* --- Variaveis internas (privadas) ------------------------------------------------------------------- */
    /* relacionamento mastre/detalhe */
    define private variable mdr-attribute   as character no-undo.
    define private variable mdr-master      as character no-undo.
    define private variable mdr-detail      as character no-undo.
    define private variable mdr-expand      as logical   no-undo.
    /* relacionamento de agrupadores */
    define private variable grp-attribute   as character no-undo.
    define private variable grp-keys        as character no-undo.
    define private variable grp-fields      as character no-undo.
    
    define temp-table dataRelation no-undo
        field attributeName              as character
        field tableHandle                as handle
        field masterFields               as character
        field detailFields               as character
        field removeDetailRelationFields as logical
        field expandAsArray              as logical
        field resultJson                 as Progress.Lang.Object.
    
    define temp-table arrayFields no-undo
        field attributeName         as character
        field prefix                as character.
    
    /* --- Constantes internas ----------------------------------------------------------------------------- */
    define private property unexpandedAttribute as char init "_expandables" get.

    /* --- Propriedades externas (publicas) ---------------------------------------------------------------- */
    define public property outputFields as character
    get. set.
    
    define public property outputExpandables as character
    get. set.
    
    define public property outputOrder as character
    get. set.
    
    define public property outputPage as integer
    get. set.
    
    define public property outputPageSize as integer
    get. set.
    
    define public property expandableFields as character
    get. set.
    
    define public property autoExpandFields as character
    get. set.
    
    define public property jsonVersion as int
    get. set.

    /* --- Valores estaticos para configuracao ------------------------------------------------------------- */
    define public static property JSON_V1 as int init 1 get.
    define public static property JSON_V2 as int init 2 get.
    
    /* --- Construtor/destrutor ---------------------------------------------------------------------------- */
    
    constructor public GpsJsonUtils():
        assign mdr-attribute = ""
               mdr-master    = ""
               mdr-detail    = ""
               mdr-expand    = true.
        assign this-object:outputFields      = ""
               this-object:outputExpandables = ""
               this-object:expandableFields  = ""
               this-object:autoExpandFields  = ""
               this-object:jsonVersion       = GpsJsonUtils:JSON_V1.
        empty temp-table dataRelation.
        empty temp-table arrayFields.
    end.
    
    destructor public GpsJsonUtils():
    end.
    
    /* --- Metodos privados -------------------------------------------------------------------------------- */
    method private void appendToString(input-output sOriginal as character, input sText as character):
        if sOriginal <> ""
        then assign sOriginal = sOriginal + ",".
        
        assign sOriginal = sOriginal + sText.
    end method.

    method private logical shouldExpand(input fieldname as character):
        return this-object:shouldExpand(fieldname, "").
    end method.
    
    method private logical shouldExpand(input fieldname as character, input baseName as char):
        
        if not this-object:shouldExport(fieldname, baseName)
        then return false.

        if baseName <> ""
        then assign fieldname = baseName + "." + fieldname.
        
        if lookup(fieldname, this-object:outputExpandables) > 0
        or lookup(fieldname, this-object:autoExpandFields) > 0
        then return true.
        else return false.

    end method.

    method private logical shouldExport(input fieldname as character):
        return this-object:shouldExport(fieldname, "").
    end method.
    
    method private logical shouldExport(input fieldname as character, input baseName as char):
        
        if this-object:outputFields <> ""
        then do:
            if baseName <> ""
            then return lookup(baseName + "." + fieldname, this-object:outputFields) > 0.
            else return lookup(fieldname, this-object:outputFields) > 0.
        end.
             
        return true.
        
    end method.

    method private void storeDataRelationJson():
        def var lcAux as longchar no-undo.
        def buffer b-dataRelation for dataRelation.
        
        for each b-dataRelation:
            do on error undo, next:
                b-dataRelation.tablehandle:write-json("longchar", lcAux).
                b-dataRelation.resultJson = cast(this-object:longcharToJsonObject(lcAux):GetJsonArray(b-dataRelation.tablehandle:serialize-name), JsonArray).
            end.
        end.
    end method.

    method private void clearDataRelationJson():
        def buffer b-dataRelation for dataRelation.

        for each b-dataRelation:
            if valid-object(b-dataRelation.resultJson)
            then b-dataRelation.resultJson.
        end.
    end method.
    
    method private JsonArray buildResponse(input oJsonInput as JsonArray):
    
        define variable oJsonOutput  as JsonArray         no-undo.
        define variable oJsonRelat   as JsonArray         no-undo.
        define variable ixRecord     as integer           no-undo.
        define variable ixMaster     as integer           no-undo.
        define variable ixField      as integer           no-undo.
        define variable oMaster      as JsonObject        no-undo.
        define variable oRecord      as JsonObject        no-undo.
        define variable hasDetailRec as logical           no-undo.
        define variable isEqual      as logical           no-undo.
        define variable attrNames    as character  extent no-undo.
        define variable fld-names    as character         no-undo.

        def buffer b-dataRelation for dataRelation.
        
        assign oJsonOutput  = new JsonArray()
               hasDetailRec = false.

        if can-find(first b-dataRelation)
        then this-object:storeDataRelationJson().
        
        /* Filtra os registros mestre, e remove campos desnecessarios dos detalhes (relacionamento Master x Detail) */
        repeat ixRecord = 1 to oJsonInput:length:
            assign oRecord = oJsonInput:getjsonobject(ixRecord).
            
            if this-object:isMasterRecord(oRecord)
            then do:
                /* Expande os registros */
                repeat ixField = 1 to num-entries(this-object:expandableFields):
                    this-object:expandField(input entry(ixField, this-object:expandableFields),
                                            input-output oRecord).
                end.
                repeat ixField = 1 to num-entries(this-object:autoExpandFields):
                    this-object:expandField(input entry(ixField, this-object:autoExpandFields),
                                            input-output oRecord).
                end.

                oJsonOutput:add(oRecord).
            end.
            else do:
                /* Expande os registros, caso esteja especificado */
                repeat ixField = 1 to num-entries(this-object:expandableFields):
                    // expande o campo se ele for um agrupador pai x filho
                    if (this-object:mdr-expand)
                    then this-object:expandField(input entry(ixField, this-object:expandableFields),
                                                 input-output oRecord).
                    // remove campos, exceto se tiverem marcados como auto expansiveis
                    else if (lookup(entry(ixField, this-object:expandableFields), this-object:autoExpandFields) = 0)
                         then this-object:reduceField(input entry(ixField, this-object:expandableFields) + "_*",
                                                      input-output oRecord).
                end.
                /* Expande os registros auto expansiveis */
                repeat ixField = 1 to num-entries(this-object:autoExpandFields):
                    this-object:expandField(input entry(ixField, this-object:autoExpandFields),
                                            input-output oRecord).
                end.

                assign hasDetailRec = true.
            end.
        end.
        
        /* Busca os registro de detalhes (master x detail) */
        if  hasDetailRec
        and this-object:shouldExpand(mdr-attribute)
        then do:
            repeat ixMaster = 1 to oJsonOutput:length:
                assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                
                repeat ixRecord = 1 to oJsonInput:length:
                    assign oRecord = oJsonInput:getjsonobject(ixRecord).
                    
                    if  this-object:isDetailRecord(oMaster, oRecord)
                    then do:
                        if not oMaster:has(mdr-attribute)
                        then oMaster:add(mdr-attribute, new JsonArray()).
                        
                        /* Transforma campos especificados como array */
                        this-object:transformFields(input-output oRecord).
                        
                        /* Remove campos que nao estao especificados para retorno */
                        this-object:reduceFields(input-output oRecord, mdr-attribute).
                        
                        oMaster:getjsonarray(mdr-attribute):add(oRecord).
                    end.
                end.
            end.
            // cria expandable do registro detalhe (no processo normal, faz a partir do registro mestre)
            if this-object:hasInnerRelation(mdr-attribute)
            then do:
                repeat ixMaster = 1 to oJsonOutput:length:
                    assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                    if oMaster:has(mdr-attribute)
                    then this-object:expandRelation(oMaster:getJsonArray(mdr-attribute), mdr-attribute).
                end.
            end.
        end.
        // se campo esta listado para exportar, mas nao esta listado para expandir, adiciona na lista de nao expandidos
        else if not this-object:shouldExpand(mdr-attribute)
        and this-object:shouldExport(mdr-attribute)
        then do:
            repeat ixMaster = 1 to oJsonOutput:length:
                assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                if not oMaster:has(this-object:unexpandedAttribute)
                then oMaster:add(this-object:unexpandedAttribute, new JsonArray()).
                oMaster:getjsonarray(this-object:unexpandedAttribute):add(mdr-attribute).
            end.
        end.

        /* Adicionar agrupador */
        if  (grp-attribute    <> "")
        and (grp-keys         <> "")
        and (oJsonOutput:length > 0)
        then do:
            /* Se nao especificou nenhum campo para os detalhes, considera todos */
            assign fld-names = grp-fields.
            if grp-fields = ""
            then do:
                assign oMaster   = oJsonOutput:getjsonobject(1)
                       attrNames = oMaster:getnames().
                
                repeat ixField = 1 to extent(attrNames):
                    if (lookup(attrNames[ixField], grp-keys) = 0)
                    then this-object:appendToString(input-output fld-names, input attrNames[ixField]).
                end.
            end.
        
            assign ixMaster = 0.
            do while ixMaster < oJsonOutput:length:
                assign ixMaster   = ixMaster + 1
                       oMaster    = oJsonOutput:getjsonobject(ixMaster)
                       oJsonRelat = new JsonArray().
                
                oMaster:add(grp-attribute, oJsonRelat).
                oRecord = new JsonObject().
                oJsonRelat:add(oRecord).
                
                /* Adiciona os detalhes no atributo adequado, e remove do registro principal */
                repeat ixField = 1 to num-entries(fld-names):
                    this-object:copyJsonAttribute(entry(ixField, fld-names), oMaster, oRecord).
                    if (lookup(entry(ixField, fld-names), grp-keys) = 0)
                    then oMaster:remove(entry(ixField, fld-names)).
                end.
                
                /* Busca nos registros seguintes se algum se encaixa no agrupamento */
                assign ixRecord = ixMaster + 1.
                do while ixRecord <= oJsonOutput:length:
                    assign oRecord  = oJsonOutput:getjsonobject(ixRecord)
                           isEqual  = true.
                    
                    /* compara os campos da chave */
                    repeat ixField = 1 to num-entries(grp-keys):
                        if oMaster:getjsontext(entry(ixField, grp-keys)) <> oRecord:getjsontext(entry(ixField, grp-keys))
                        then do:
                            assign isEqual = false.
                            leave.
                        end.
                    end.
                    
                    if isEqual
                    then do:
                        /* remove o registro que foi agrupado */
                        oJsonOutput:remove(ixRecord).
                        
                        /* remove os atributos que nao serao adicionados no grupo */
                        assign attrNames = oRecord:getnames().
                        repeat ixField = 1 to extent(attrNames):
                            if (lookup(attrNames[ixField], fld-names) = 0)
                            then oRecord:remove(attrNames[ixField]).
                        end.
                        oJsonRelat:add(oRecord).
                    end.
                    else assign ixRecord = ixRecord + 1.
                end.
            end.
        end.

        /* Adicionar relacionamentos */
        this-object:expandRelation(oJsonOutput).

        /* Transforma campos */
        if can-find(first arrayFields)
        then do:
            repeat ixMaster = 1 to oJsonOutput:length:
                assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                /* Transforma campos especificados como array */
                this-object:transformFields(input-output oMaster).
            end.
        end.
        
        /* Remove campos que nao devem aparecer na selecao de fields */
        if this-object:outputFields <> ""
        then do:
            repeat ixMaster = 1 to oJsonOutput:length:
                assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                /* Remove campos que nao devem retornar para o backend */
                this-object:reduceFields(input-output oMaster).
            end.
        end.
        
        return oJsonOutput.

        finally:
            if can-find(first b-dataRelation)
            then this-object:clearDataRelationJson().
        end finally.
    
    end method.

    method private log hasInnerRelation(input cAttribute as char):
        def buffer b-dataRelation for dataRelation.

        if cAttribute = ""
        then return can-find(first b-dataRelation).

        assign cAttribute = cAttribute + ".".
        return can-find(first b-dataRelation where b-dataRelation.attributeName begins cAttribute).
        
    end method.

    method private void expandRelation(input oJsonOutput as JsonArray):
        this-object:expandRelation(oJsonOutput, "").
    end method.

    method private void expandRelation(input oJsonOutput as JsonArray, input cAttributeBase as char):

        define variable oJsonRelat      as JsonArray         no-undo.
        define variable ixRecord        as integer           no-undo.
        define variable ixMaster        as integer           no-undo.
        define variable ixField         as integer           no-undo.
        define variable oMaster         as JsonObject        no-undo.
        define variable oRecord         as JsonObject        no-undo.
        define variable iAttributeLevel as integer           no-undo.
        define variable cThisAttribute  as character         no-undo.

        def buffer b-dataRelation for dataRelation.
        

        if cAttributeBase = ?
        then assign cAttributeBase = "".

        if cAttributeBase = ""
        then assign iAttributeLevel = 1.
        else assign iAttributeLevel = num-entries(cAttributeBase, ".") + 1.

        for each b-dataRelation:

            if  (cAttributeBase <> "")
            and (not b-dataRelation.attributeName begins (cAttributeBase + "."))
            then next.

            if not valid-handle(b-dataRelation.tablehandle)
            then next.

            // desconsidera nivel de expansao maiores do que o atual
            if num-entries(b-dataRelation.attributeName, ".") <> iAttributeLevel
            then next.

            assign cThisAttribute = entry(iAttributeLevel, b-dataRelation.attributeName, ".").
            
            if  this-object:shouldExpand(cThisAttribute, cAttributeBase)
            then do:
                repeat ixMaster = 1 to oJsonOutput:length:
                    assign oMaster = oJsonOutput:getjsonobject(ixMaster).

                    if valid-object(b-dataRelation.resultJson)
                    then assign oJsonRelat = cast(b-dataRelation.resultJson, JsonArray).
                    else assign oJsonRelat = new JsonArray().
                    
                    repeat ixRecord = 1 to oJsonRelat:length:
                        assign oRecord = oJsonRelat:getjsonobject(ixRecord).
                        
                        if this-object:isDetailRecord(oMaster, oRecord, b-dataRelation.masterfields, b-dataRelation.detailfields)
                        then do:
                            if b-dataRelation.removeDetailRelationFields
                            then do:
                                repeat ixField = 1 to num-entries(b-dataRelation.detailFields):
                                    this-object:reduceField(input entry(ixField, b-dataRelation.detailFields),
                                                            input-output oRecord).
                                end.
                            end.
                            this-object:reduceFields(input-output oRecord, b-dataRelation.attributeName).
                            
                            if b-dataRelation.expandAsArray
                            then do:
                                if not oMaster:has(cThisAttribute)
                                then oMaster:add(cThisAttribute, new JsonArray()).
                                
                                oMaster:getjsonarray(cThisAttribute):add(oRecord).
                            end.
                            else do:
                                if not oMaster:has(cThisAttribute)
                                then do:
                                    if this-object:jsonVersion = GpsJsonUtils:JSON_V1
                                    then oMaster:add(cThisAttribute, oRecord:getjsontext()).
                                    else
                                    if this-object:jsonVersion = GpsJsonUtils:JSON_V2
                                    then oMaster:add(cThisAttribute, oRecord).
                                end.
                            end.
                        end.
                    end.

                    // Se nao tem nenhum registro na tabela relacionada, expande com valor padrao
                    if not oMaster:has(cThisAttribute)
                    then do:
                        if b-dataRelation.expandAsArray
                        then oMaster:add(cThisAttribute, new JsonArray()).
                        else oMaster:addnull(cThisAttribute).
                    end.
                    // Se tem registro de tabela relacionada, verifica se tem sub-atributo de expansao
                    else do:
                        if  b-dataRelation.expandAsArray
                        then this-object:expandRelation(oMaster:getJsonArray(cThisAttribute), b-dataRelation.attributeName).
                    end.
                end.
            end.
            else if this-object:shouldExport(cThisAttribute, cAttributeBase)
            then do:
                repeat ixMaster = 1 to oJsonOutput:length:
                    assign oMaster = oJsonOutput:getjsonobject(ixMaster).
                    if not oMaster:has(this-object:unexpandedAttribute)
                    then oMaster:add(this-object:unexpandedAttribute, new JsonArray()).
                    oMaster:getjsonarray(this-object:unexpandedAttribute):add(cThisAttribute).
                end.
            end.
        end.

    end method.
    
    method private logical isMasterRecord(input oJsonObject as JsonObject):
        return this-object:isMasterRecord(oJsonObject, mdr-master, mdr-detail).
    end method.
    
    method private logical isMasterRecord(input oJsonObject as JsonObject, input masterFields as character, input detailFields as character):
        define variable ix      as integer no-undo.
        
        repeat ix = 1 to num-entries(masterFields):
            if (not oJsonObject:has(entry(ix, masterFields)))
            or (not oJsonObject:has(entry(ix, detailFields)))
            or (oJsonObject:getjsontext(entry(ix, masterFields)) <> oJsonObject:getjsontext(entry(ix, detailFields)))
            then return false.
        end.
        return true.
    end method.
    
    method private logical isDetailRecord(input oJsonMaster as JsonObject, input oJsonDetail as JsonObject):
        return this-object:isDetailRecord(oJsonMaster, oJsonDetail, mdr-master, mdr-detail).
    end method.
    
    method private logical isDetailRecord(input oJsonMaster as JsonObject, input oJsonDetail as JsonObject, input masterFields as character, input detailFields as character):

        define variable ix      as integer no-undo.
        
        // desconsidera quando o objeto eh o mesmo
        if oJsonMaster:getjsontext() = oJsonDetail:getjsontext()
        then return false.
        
        repeat ix = 1 to num-entries(masterFields):
            if (not oJsonMaster:has(entry(ix, masterFields)))
            or (not oJsonDetail:has(entry(ix, detailFields)))
            or (oJsonMaster:getjsontext(entry(ix, masterFields)) <> oJsonDetail:getjsontext(entry(ix, detailFields)))
            then return false.
        end.
        
        return true.
        
    end method.
    
    method private void expandField(input fieldName as character, input-output oJsonRecord as JsonObject):
        
        define variable oExpand         as JsonObject       no-undo.
        define variable ix              as integer          no-undo.
        define variable attrList        as character extent no-undo.
        define variable attrName        as character        no-undo.
        define variable isValid         as logical          no-undo.
        define variable isExpandable    as logical          no-undo.
        define variable isVisible       as logical          no-undo.
        
        assign oExpand      = new JsonObject()
               attrList     = oJsonRecord:getnames()
               isValid      = false
               isExpandable = this-object:shouldExpand(fieldName)
               isVisible    = this-object:shouldExport(fieldName).
        
        repeat ix = 1 to extent(attrList):
            
            if attrList[ix] begins (fieldName + "_")
            then do:
                assign attrName = substring(attrList[ix], length(fieldName) + 2). 
                
                if isExpandable
                then do:
                    this-object:copyJsonAttribute(attrList[ix], substring(attrList[ix], length(fieldName) + 2), oJsonRecord, oExpand).
                    assign isValid = true.
                end.
                
                oJsonRecord:remove(attrList[ix]).
            end.
            
        end.
        
        if isValid
        then do:
            if this-object:jsonVersion = GpsJsonUtils:JSON_V1
            then oJsonRecord:add(fieldName, oExpand:getjsontext()).
            else
            if this-object:jsonVersion = GpsJsonUtils:JSON_V2
            then oJsonRecord:add(fieldName, oExpand).
        end.
        else if isVisible
             then oJsonRecord:addnull(fieldName).

    end method.
    
    method private void reduceField(input fieldNamePattern as character, input-output oJsonRecord as JsonObject):
        define variable ix          as integer          no-undo.
        define variable attrNames   as character extent no-undo.
            
        assign attrNames = oJsonRecord:getnames().
            
        repeat ix = 1 to extent(attrNames):
            if attrNames[ix] matches (fieldNamePattern)
            then oJsonRecord:remove(attrNames[ix]).
        end.

    end method.

    method private void reduceFields(input-output oJsonRecord as JsonObject):
        this-object:reduceFields(input-output oJsonRecord, "").
    end method.
    
    method private void reduceFields(input-output oJsonRecord as JsonObject, input baseName as char):

        define variable ix          as integer          no-undo.
        define variable attrNames   as character extent no-undo.
        define variable thisAttr    as character        no-undo.
        define variable lHasFields  as log              no-undo.
            
        if this-object:outputFields <> ""
        then do:
            // caso seja um campo expandable, so aplica a regra se algum dos campos dele estiver no fields
            if baseName <> ""
            then do:
                assign lHasFields = false.
                do ix = 1 to num-entries(this-object:outputFields):
                    if entry(ix, this-object:outputFields) begins (baseName + ".")
                    then do:
                        assign lHasFields = true.
                        leave.
                    end.
                end.
                if not lHasFields
                then return.
            end.

            assign attrNames = oJsonRecord:getnames().
            
            repeat ix = 1 to extent(attrNames):
                // ignora o campo de referencia aos expansiveis
                if attrNames[ix] = this-object:unexpandedAttribute
                then next.
                // remove o campo caso nao esteja na lista
                if baseName <> ""
                then assign thisAttr = baseName + "." + attrNames[ix].
                else assign thisAttr = attrNames[ix].
                //
                if (lookup(thisAttr, this-object:outputFields) = 0)
                then oJsonRecord:remove(attrNames[ix]).
            end.
        end.

    end method.
    
    method private void transformFields(input-output oJsonRecord as JsonObject):

        define variable ix          as integer          no-undo.
        define variable attrNames   as character extent no-undo.
        define variable aValues     as JsonArray        no-undo.
        define variable hasAttr     as logical          no-undo.
        
        assign attrNames = oJsonRecord:getnames().

        for each arrayFields:
            assign hasAttr = false
                   aValues = new JsonArray().
            
            repeat ix = 1 to extent(attrNames):
                if (attrNames[ix] begins arrayFields.prefix)
                then do:
                    assign hasAttr = true.
                    
                    if oJsonRecord:isNull(attrNames[ix])
                    then aValues:addnull().
                    else do:
                        case oJsonRecord:gettype(attrNames[ix]):
                            when JsonDataType:Boolean
                            then aValues:add(oJsonRecord:getlogical(attrNames[ix])).
                            
                            when JsonDataType:String
                            then aValues:add(oJsonRecord:getcharacter(attrNames[ix])).
                            
                            when JsonDataType:Number
                            then do:
                                oJsonRecord:getinteger(attrNames[ix]) no-error.
                                
                                if not error-status:error
                                then aValues:add(oJsonRecord:getinteger(attrNames[ix])).
                                else aValues:add(oJsonRecord:getdecimal(attrNames[ix])).
                            end.
                            
                            otherwise aValues:addnull().
                        end case.
                    end.
                    oJsonRecord:remove(attrNames[ix]).
                end.
            end.
            
            if hasAttr
            then oJsonRecord:add(arrayFields.attributeName, aValues).
        end.

    end method.

    method private void copyJsonAttribute(input attrName as character, input oJsonFrom as JsonObject, input oJsonTo as JsonObject):
        
        this-object:copyJsonAttribute(attrName, attrName, oJsonFrom, oJsonTo).
        
    end method.
    
    method private void copyJsonAttribute(input attrName as character, input toAttrName as character, input oJsonFrom as JsonObject, input oJsonTo as JsonObject):
    
        if oJsonFrom:isNull(attrName)
        then oJsonTo:addnull(toAttrName).
        else do:
            case oJsonFrom:gettype(attrName):
                
                when JsonDataType:Boolean
                then oJsonTo:add(toAttrName, oJsonFrom:getlogical(attrName)).
                
                when JsonDataType:String
                then oJsonTo:add(toAttrName, oJsonFrom:getcharacter(attrName)).
                
                when JsonDataType:Number
                then do:
                    oJsonFrom:getinteger(attrName) no-error.
                    
                    if not error-status:error
                    then oJsonTo:add(toAttrName, oJsonFrom:getinteger(attrName)).
                    else oJsonTo:add(toAttrName, oJsonFrom:getdecimal(attrName)).
                end.
                
            end case.
        end.
    
    end method.

    
    
    /* --- Metodos publicos -------------------------------------------------------------------------------- */
    method public JsonObject longcharToJsonObject(input lcJson as longchar):
        define variable oJsonOutput as JsonObject        no-undo.
        define variable oParse   as ObjectModelParser no-undo.

        assign oJsonOutput = new JsonObject()
               oParse      = new ObjectModelParser()
               oJsonOutput = cast(oParse:Parse(lcJson), JsonObject).

        delete object oParse.

        return oJsonOutput.
    end method.
    
    /*
        getJsonArrayFromTable
        ---------------------
        Converte uma temp-table em um array de objetos json
    */
    method public JsonArray getJsonArrayFromTable(input hTempTable as handle):
        define variable lcAux as longchar no-undo.
        define variable oJsonArray as JsonArray no-undo.
        
        hTempTable:write-json("longchar", lcAux).

        assign oJsonArray = this-object:longcharToJsonObject(lcAux):GetJsonArray(hTempTable:serialize-name)
               oJsonArray = this-object:buildResponse(oJsonArray).
        
        return oJsonArray.
        
    end method.

    /*
        getSimpleJsonArrayFromTable
        ---------------------
        Converte uma temp-table em um array de objetos json
        Sem utilizar expandables e agregacoes de objetos
    */
    method public JsonArray getSimpleJsonArrayFromTable(input hTempTable as handle):
        define variable lcAux as longchar no-undo.
        define variable oJsonArray as JsonArray no-undo.
        
        hTempTable:write-json("longchar", lcAux).

        assign oJsonArray = this-object:longcharToJsonObject(lcAux):GetJsonArray(hTempTable:serialize-name).
        
        return oJsonArray.
        
    end method.
    
    /*
        getJsonObjectFromTable
        ----------------------
        Converte uma temp-table em um objeto json (de um unico registro)
    */
    method public JsonObject getJsonObjectFromTable(input hTempTable as handle):
        define variable oJsonArray as JsonArray no-undo.
        
        assign oJsonArray = this-object:getJsonArrayFromTable(input hTempTable).
        
        if oJsonArray:length > 0
        then return oJsonArray:getjsonobject(1).
        else return ?.

    end method.

    /*
        getSimpleJsonObjectFromTable
        ----------------------
        Converte uma temp-table em um objeto json (de um unico registro)
        Sem utilizar expandables e agregacoes de objetos
    */
    method public JsonObject getSimpleJsonObjectFromTable(input hTempTable as handle):
        define variable oJsonArray as JsonArray no-undo.
        
        assign oJsonArray = this-object:getSimpleJsonArrayFromTable(input hTempTable).
        
        if oJsonArray:length > 0
        then return oJsonArray:getjsonobject(1).
        else return ?.

    end method.

    
    
    /*
        createJsonResponse
        ------------------
        Cria um json de retorno 
    */

    method public JsonObject createJsonResponse(input jsonInput as JsonConstruct):
        return this-object:createJsonResponse(jsonInput, ?, false, ?).
    end method.

    method public JsonObject createJsonResponse(input jsonInput as JsonConstruct, input hRowErrors as handle):
        return this-object:createJsonResponse(jsonInput, hRowErrors, false, ?).
    end method.

    method public JsonObject createJsonResponse(input jsonInput as JsonConstruct, input hRowErrors as handle, input hasNext as logical):
        return this-object:createJsonResponse(jsonInput, hRowErrors, hasNext, ?).
    end method.
    
    method public JsonObject createJsonResponse(input jsonInput as JsonConstruct, input hRowErrors as handle, input hasNext as logical, input statusCode as integer):

        define variable oResponse  as JsonAPIResponse no-undo.
        define variable jsonOutput as JsonObject      no-undo.

        oResponse = new JsonAPIResponse(jsonInput).
        oResponse:setHasNext(hasNext).
        if valid-handle(hRowErrors)
        then oResponse:setRowErrors(JsonAPIUtils:convertTempTableToJsonObject(hRowErrors):getJsonArray("RowErrors")).
        if statusCode <> ?
        then oResponse:setStatus(statusCode).

        jsonOutput = oResponse:createJsonResponse().
        
        return jsonOutput.

        finally:
            if valid-object(oResponse)
            then delete object oResponse.
        end finally.

    end method.
    
    /*
        createErrorResponse
        -------------------
        Retorna o json sem conteudo com status informado por parametros
    */
    method public JsonObject createErrorResponse(input statusCode as int):
        return JsonAPIResponseBuilder:empty(statusCode).
    end method.

    method public JsonObject createErrorResponse(input statusCode as int, input hRowErrors as handle):
        return JsonAPIResponseBuilder:asError(JsonAPIUtils:convertTempTableToJsonArray(hRowErrors), statusCode).
    end method.

    /*
        createEmptyResponse
        -------------------
        Retorna o json sem conteudo com status 204
    */
    method public JsonObject createEmptyResponse():
        return this-object:createErrorResponse(204).
    end method.

    /*
        createNotFoundResponse
        -------------------
        Retorna o json sem conteudo com status 404
    */
    method public JsonObject createNotFoundResponse():
        return this-object:createErrorResponse(404).
    end method.
    
    /*
        setMasterDetail
        --------------
        Atribui os campos para fazer o relacionamento pai x filho nos registros de uma temp-table.
        Os registros filhos sao movidos para dentro de um atributo do registro pai.
    */
    method public void setMasterDetail(input attrName as character, input masterFields as character, input detailFields as character):
        this-object:setMasterDetail(attrName, masterFields, detailFields, false).
    end method.
    
    method public void setMasterDetail(input attrName as character, input masterFields as character, input detailFields as character, input expandDetail as logical):
    
        if num-entries(masterFields) <> num-entries(detailFields)
        then undo, throw new Progress.Lang.AppError("Parametros incorretos", 1).
    
        assign mdr-attribute = attrName
               mdr-master    = masterFields
               mdr-detail    = detailFields
               mdr-expand    = expandDetail.

    end method.
    
    /*
        setGroup
        --------
        Cria um agrupamento de registros que tenham campos chave repetidos, adicionando os demais campos em outro atributo.
        Caso n?o informado quais s?o os campos de detalhe, ser?o considerados todos os campos que nao estao na chave informada.
        Os campos de detalhe serao movidos para dentro do atributo, e removidos do registro principal.
    */
    method public void setGroup(input attributeName as character, input keyFields as character):
        this-object:setGroup(attributeName, keyFields, "").
    end method.
    
    method public void setGroup(input attributeName as character, input keyFields as character, input detailFields as character):
        assign grp-attribute = attributeName
               grp-keys      = keyFields
               grp-fields    = detailFields.
    end method.
    
    /*
        clearRelations
        --------------
        Apaga os relacionamentos criados pelo metodo addRelation()
    */
    method public void clearRelations():
        this-object:clearDataRelationJson().
        empty temp-table dataRelation.
    end method.
    
    /*
        addRelation
        -----------
        Cria um relacionamento entre tabelas, que sera considerado na hora de transformar uma tabela em Json.
        Sera criado um atributo na tabela principal, com um array contendo os registros da tabela relacionada (adicionada neste metodo).
        O comportamento eh similar a de um dataset, relacionando tabelas dentro de uma propriedade da tabela principal.
    */
    method public void addRelation(input attributeName as character, input tableHandle as handle, input masterFields as character, input detailFields as character):
        this-object:addRelation(attributeName, tableHandle, masterFields, detailFields, false).
    end method.
    
    method public void addRelation(input attributeName as character, input tableHandle as handle, input masterFields as character, input detailFields as character, input removeDetailRelationFields as logical):
        this-object:addRelation(attributeName, tableHandle, masterFields, detailFields, removeDetailRelationFields, true).
    end method.
    
    method public void addRelation(input attributeName as character, input tableHandle as handle, input masterFields as character, input detailFields as character, input removeDetailRelationFields as logical, input expandAsArray as logical):
        
        if num-entries(masterFields) <> num-entries(detailFields)
        or attributeName = ""
        then undo, throw new Progress.Lang.AppError("Parametros incorretos", 1).
    
        create dataRelation.
        assign dataRelation.attributename              = attributeName
               dataRelation.tablehandle                = tableHandle
               dataRelation.masterfields               = masterFields
               dataRelation.detailfields               = detailFields
               dataRelation.removeDetailRelationFields = removeDetailRelationFields
               dataRelation.expandAsArray              = expandAsArray.

    end method.
    
    /*
        addArrayField
        -------------
        Atribui um campo para retornar como array.
        Todos os campos que tiverem o prefixo determinado, serao convertidos para um array de valores.
    */
    method public void addArrayField(input attributeName as character, input prefix as character):
        create arrayFields.
        assign arrayFields.attributeName = attributeName
               arrayFields.prefix        = prefix.
    end method.
    
    method public void clearArrayFields():
        empty temp-table arrayFields.
    end method.
    
    /*
        getQueryParam
        -------------
        Retorna a propriedade de um query param recebido por parametro.
        Realiza o tratamento para verificar se recebeu o valor ou nao nos parametros.
    */
    method public character getQueryParam(input oJsonInput as JsonObject, input attributeName as character):
        
        if oJsonInput = ?
        then return ?.
        
        if not oJsonInput:has(attributeName)
        then return ?.
        
        return oJsonInput:getjsonarray(attributeName):getcharacter(1).
        
        catch eAnyError as Progress.Lang.Error:
            return ?.
        end catch.
        
    end method.

    method public void mergeJson(oSource as JsonObject,oTarget as JsonObject):

        define variable i               as integer          no-undo.
        
        define variable jsonNames       as character extent no-undo.

        if oSource = ?
        or oTarget = ?
        or not valid-object(oSource)
        or not valid-object(oTarget)
        then return.
        
        /** get all the defined properties of the source object */
        assign jsonNames = oSource:getnames().
        
        /** loop through all properties of the source object
        *  and try to add the property to the target object
        *  using no-error to supress any error if the target
        *  object already has the property defined
        */
        do i = 1 to extent(jsonNames):
            this-object:mergeJsonValue(jsonNames[i], oSource, oTarget).
            /** add to the target object using the appropriate getter on the source object */
        end.

    end method.
    
    method public void mergeJsonValue(jsonProperty as character,oSource as JsonObject,oTarget as JsonObject):

        define variable integerValue    as integer          no-undo.
        define variable dateValue       as date             no-undo.

        case oSource:GetType(jsonProperty):
            when JsonDataType:ARRAY   
            then do:
                if not oTarget:has(jsonProperty)
                then oTarget:add(jsonProperty,oSource:GetJsonArray(jsonProperty))  no-error.
                else oTarget:set(jsonProperty,oSource:GetJsonArray(jsonProperty))  no-error.
            end.
            when JsonDataType:BOOLEAN 
            then do:
                if not oTarget:has(jsonProperty)
                then oTarget:add(jsonProperty,oSource:GetLogical(jsonProperty))  no-error.
                else oTarget:set(jsonProperty,oSource:GetLogical(jsonProperty))  no-error.
            end.
            when JsonDataType:OBJECT  
            then do:
                if not oTarget:has(jsonProperty)
                then oTarget:add(jsonProperty,oSource:GetJsonObject(jsonProperty)) no-error.
                else oTarget:set(jsonProperty,oSource:GetJsonObject(jsonProperty)) no-error.
            end.
            when JsonDataType:string  
            then do:
                if not oTarget:has(jsonProperty)
                then oTarget:add(jsonProperty,oSource:GetCharacter(jsonProperty))  no-error.
                else oTarget:set(jsonProperty,oSource:GetCharacter(jsonProperty))  no-error.
            end.
            when JsonDataType:NUMBER  
            then do:
                integerValue = ?.
                integerValue =  oSource:GetInt64(jsonProperty) no-error.
                if integerValue <> ? 
                then do:
                    if not oTarget:has(jsonProperty)
                    then oTarget:add(jsonProperty,integerValue).
                    else oTarget:set(jsonProperty,integerValue)  no-error.
                end.
                else do:
                    if not oTarget:has(jsonProperty)
                    then oTarget:add(jsonProperty,oSource:GetDecimal(jsonProperty)).
                    else oTarget:set(jsonProperty,oSource:GetDecimal(jsonProperty))  no-error.
                end.
            end.
            otherwise do:
                dateValue = oSource:GetDate(jsonProperty) no-error.

                if not error-status:error  
                then oTarget:add(jsonProperty,dateValue) no-error.
                else undo, throw new AppError(substitute("Unknown json datatype &1",oSource:GetType(jsonProperty)),0).
            end.
        end case.
    end method.
    
end class.
