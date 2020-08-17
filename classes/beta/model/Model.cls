using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.


class classes.beta.model.Model:
    define property tableHandle as handle get. set.
    define property tableName as character get. set.
    define property rowId as rowid get. set.
    define property dsQuery as character get. set.
    define property inQueryControl as int get. set.
    define property inTakeControl as int get. set.
    define property inSkipControl as int get. set.
    define property lgGroupControl as log get. set.
    define property className as character get. set.
    define property keys as character get. set.
    define property hQuery as handle get. set.  
    define property inQueryEndControl as logical get. set.
    define property jsonSerializeModel as JsonObject get. set.

    define property inRegNumberControl as integer get. set.
    define property inRegIndexControl as integer get. set.

    
    define temp-table ttModel no-undo
        field id as integer
        field oModel as class Object.
    
    constructor public Model(input tableHandle as handle):        
        this-object:tableHandle = tableHandle.
        this-object:tableName = tableHandle:name.
        this-object:dsQuery = "".
        this-object:inQueryControl = 1.
        this-object:inTakeControl = 0.
        this-object:inSkipControl = 0.
        this-object:lgGroupControl = false.
        this-object:keys = tableHandle:keys.
        this-object:inQueryEndControl = false.
    end.

    method private void initQueryProperties():
        assign
            this-object:dsQuery = ""
            this-object:inQueryControl = 1
            this-object:hQuery = ?
            this-object:inSkipControl = 0
            this-object:inTakeControl = 0.
    end method.

    method void assign():
        def var i as integer no-undo.
        this-object:rowId = this-object:tableHandle:rowId. 
        repeat i = 1 to this-object:tableHandle:num-fields:
            dynamic-property(this-object, string(this-object:tableHandle:buffer-field(i):name)) = this-object:tableHandle:buffer-field(i):buffer-value() no-error.
        end.

    end method.

    method void assign(input tableHandle as handle):
        def var i as integer no-undo.
        
        this-object:rowId = tableHandle:rowId. 

        repeat i = 1 to tableHandle:num-fields:
            dynamic-property(this-object, string(tableHandle:buffer-field(i):name)) = tableHandle:buffer-field(i):buffer-value() no-error.
        end.

    end method.


    method public class classes.beta.model.Model find():
        this-object:tableHandle:find-first("where " + this-object:getCondition(this-object:tableHandle), no-lock) no-error.
        if this-object:tableHandle:available
        then this-object:assign().
        return this-object.
    end method.

    method public class classes.beta.model.Model find(input tableHandle as handle):
        this-object:assign(tableHandle).
        this-object:find().
        return this-object.
    end method.

    method public void where(input dsCond1 as character, input dsCond2 as character, input valuePar as character, input operatorPar as character):
          if this-object:lgGroupControl = true
          then assign operatorPar = "".  

          if this-object:inQueryControl = 1
          then assign this-object:dsQuery = "preselect each " + tableName + " where " + dsCond1 + " " + dsCond2 + " " + valuePar
                      this-object:inQueryControl = this-object:inQueryControl + 1.
          else assign this-object:dsQuery = this-object:dsQuery + " " + operatorPar + " " + dsCond1 + " " + dsCond2 + " " + valuePar.

          this-object:lgGroupControl = false.
    end method.

    method public classes.beta.model.Model and(input dsCond1 as character, input dsCond2 as character, input valuePar as character):
        this-object:where(dsCond1, dsCond2, valuePar, "and").
        return this-object.
    end method.

    method public classes.beta.model.Model or(input dsCond1 as character, input dsCond2 as character, input valuePar as character):
        this-object:where(dsCond1, dsCond2, valuePar, "or").
        return this-object.
    end method.

    method public classes.beta.model.Model andGroup():
        this-object:where("(","","","and").
        this-object:lgGroupControl = true.
        return this-object.
    end method.

    method public classes.beta.model.Model orGroup():
        this-object:where("(","","","or").
        this-object:lgGroupControl = true.
        return this-object.
    end method.

    method public classes.beta.model.Model groupClose():
        this-object:lgGroupControl = false.
        this-object:where("","","",")").
        return this-object.
    end method.

    // method public void where(input dsCond1 as character, input dsCond2 as character, input valuePar as integer):
    //       this-object:where(dsCond1, dsCond2, character(valuePar)).
    // end method.

    // method public void where(input dsCond1 as character, input dsCond2 as character, input valuePar as date):
    //       this-object:where(dsCond1, dsCond2, character(valuePar)).
    // end method.

    // method public void where(input dsCond1 as character, input dsCond2 as character, input valuePar as logical):
    //       this-object:where(dsCond1, dsCond2, log(valuePar)).
    // end method.

    // method public void where(input dsCond1 as character, input dsCond2 as character, input valuePar as decimal):
    //       this-object:where(dsCond1, dsCond2, dec(valuePar)).
    // end method.      

    method private void createQuery():
        create query this-object:hQuery.
        this-object:hQuery:add-buffer(this-object:tableHandle).
        this-object:hQuery:query-prepare(this-object:dsQuery).
        this-object:hQuery:query-open().

        if this-object:inSkipControl > 0
        then this-object:hQuery:reposition-to-row(this-object:inSkipControl).
    end method.


    method public classes.beta.model.Model extent getData():
        define var hQuery as handle no-undo.
        define var regNumber as integer no-undo.
        define var dsClassAux as character no-undo.
        define var exReturn as classes.beta.model.Model no-undo extent.
        define var oModelAux as classes.beta.model.Model no-undo.
        define var inRegNumber as integer no-undo.

        assign dsClassAux = this-object:className.

        empty temp-table ttModel.
        
        create query hQuery.
        hQuery:add-buffer(this-object:tableHandle).
        hQuery:query-prepare(this-object:dsQuery).
        hQuery:query-open().

        if this-object:inSkipControl > 0
        then hQuery:reposition-to-row(this-object:inSkipControl).
            
        if hQuery:num-results > this-object:inTakeControl
        and this-object:inTakeControl > 0
        then assign inRegNumber = this-object:inTakeControl. 
        else assign inRegNumber = hQuery:num-results no-error.

        extent(exReturn) = inRegNumber no-error.

        
        assign 
            this-object:inRegNumberControl = inRegNumber
            inRegIndexControl = 1.

        repeat regNumber = 1 to inRegNumber:
            
            hQuery:get-next(no-lock).
    
            if hQuery:query-off-end then leave.

            oModelAux = dynamic-new dsClassAux ().
            oModelAux:assign(hQuery:get-buffer-handle()).
            
            assign exReturn[regNumber] = dynamic-cast(oModelAux, this-object:className).

            create ttModel.
            assign
                ttModel.id = regNumber
                ttModel.oModel = dynamic-cast(oModelAux, this-object:className).
        
        end.

        delete object hQuery.
        this-object:initQueryProperties().

        return exReturn.
    end method.

    method public class classes.beta.model.Model getNext():
        
        if this-object:inQueryEndControl
        then do:
            this-object:inQueryEndControl = false.
            return ?.
        end.

        if this-object:hQuery = ?
        then this-object:createQuery().

        this-object:hQuery:get-next(no-lock).  
        this-object:assign(this-object:hQuery:get-buffer-handle()).
        
        if this-object:hQuery:query-off-end 
        or (    this-object:inTakeControl + this-object:inSkipControl = this-object:hQuery:current-result-row
            and this-object:inTakeControl > 0)
        then do:
            delete object this-object:hQuery.
            this-object:initQueryProperties().
            this-object:inQueryEndControl = true.
        end.

        return this-object.
    end method.

    method public classes.beta.model.Model take(input inTakePar as integer):
        assign this-object:inTakeControl = inTakePar.
        return this-object.
    end method.

    method public classes.beta.model.Model skip(input inSkipPar as integer):
        assign this-object:inSkipControl = inSkipPar + 1.
        return this-object.
    end method.

    method public void find(input x as character extent):
        def var i as integer no-undo.
        def var intAux as integer no-undo.
        def var charAux as character no-undo.
        def var dateAux as date no-undo.
        def var logAux as logical no-undo.
    
        do i = 1 to num-entries(this-object:keys, ","):
            case this-object:tableHandle:buffer-field(i):data-type:
                when "integer"
                then assign intAux = int(x[i]).
                when "date"
                then assign dateAux = date(x[i]).
                when "char"
                then assign charAux = x[i].
                when "logical"
                then assign logAux = logical(x[i]).
            end case.

            dynamic-property(this-object, string(this-object:tableHandle:buffer-field(i):name)) = x[i] no-error.
        end.
        this-object:find().
    end method.

    method public classes.beta.model.Model update(input jDataPar as JsonObject):
        define variable i as integer no-undo.
        define variable jNamesAux as character extent no-undo.
        
        assign jNamesAux = jDataPar:getNames().

        if this-object:rowId <> ?
        then do:

            do transaction:
                this-object:tableHandle:find-by-rowid(this-object:rowId, exclusive-lock).

                repeat i = 1 to extent(jNamesAux):
                    case this-object:tableHandle:buffer-field(jNamesAux[i]):data-type:
                    when "integer"
                    then this-object:tableHandle:buffer-field(jNamesAux[i]):buffer-value() = jDataPar:getInteger(jNamesAux[i]) no-error.
                    when "character"
                    then this-object:tableHandle:buffer-field(jNamesAux[i]):buffer-value() = jDataPar:getCharacter(jNamesAux[i]) no-error.
                    when "date"
                    then this-object:tableHandle:buffer-field(jNamesAux[i]):buffer-value() = jDataPar:getDate(jNamesAux[i]) no-error.
                    when "logical"
                    then this-object:tableHandle:buffer-field(jNamesAux[i]):buffer-value() = jDataPar:getLogical(jNamesAux[i]) no-error.
                    end case.
                end.
                
                this-object:assign().
                this-object:tableHandle:buffer-release().

            end.

        end.

        return this-object.
    end method.

    method public class classes.beta.model.Model find(input oObject as classes.beta.model.Model):
        def var i as integer no-undo.

        do i = 1 to num-entries(this-object:keys, ","):
            dynamic-property(this-object, entry(i, this-object:keys, ",")) = dynamic-property(oObject, entry(i, this-object:keys, ",")).
        end.

        return this-object:find().
    end method.

    method public void save():
        def var i as integer no-undo.

        if this-object:rowId = ?
        then return.

        do transaction:
            this-object:tableHandle:find-by-rowid(this-object:rowId, exclusive-lock).

            repeat i = 1 to tableHandle:num-fields:
                this-object:tableHandle:buffer-field(i):buffer-value() = dynamic-property(this-object, string(this-object:tableHandle:buffer-field(i):name)) no-error.
            end.
            this-object:tableHandle:buffer-release().
        end.
    end method.

    method private character getCondition(input tableHandle as handle):
        define variable i as integer no-undo.
        define variable dsCondition as character no-undo.
        define variable dsField as character no-undo.

        do i = 1 to num-entries(this-object:keys, ","):
            assign dsField = entry(i, this-object:keys, ",").

            if i = 1
            then assign dsCondition = this-object:tableName + "." + tableHandle:buffer-field(dsField):name + " = " + string(dynamic-property(this-object, tableHandle:buffer-field(dsField):name)).
            else assign dsCondition = dsCondition + " and " + this-object:tableName + "." + tableHandle:buffer-field(dsField):name + " = " + string(dynamic-property(this-object, tableHandle:buffer-field(dsField):name)).
        end. 

        return dsCondition.
    end method. 

    method public class classes.beta.model.Model set(input fieldPar as character, valuePar as integer):
        dynamic-property(this-object, fieldPar) = valuePar.
        return this-object.
    end method.

    method public class classes.beta.model.Model set(input fieldPar as character, valuePar as character):
        dynamic-property(this-object, fieldPar) = valuePar.
        return this-object.
    end method.

    method public class classes.beta.model.Model set(input fieldPar as character, valuePar as date):
        dynamic-property(this-object, fieldPar) = valuePar.
        return this-object.
    end method.

    method public class classes.beta.model.Model set(input fieldPar as character, valuePar as logical):
        dynamic-property(this-object, fieldPar) = valuePar.
        return this-object.
    end method.

    method public logical matchKeys(input oModel as classes.beta.model.Model):
        def var i as integer no-undo.
        def var lgReturn as logical no-undo initial true.
        def var dsField as character no-undo.
        def var dsLocalField as character no-undo.

        do i = 1 to num-entries(oModel:keys, ","):
            assign 
                dsLocalField = entry(i, this-object:keys, ",")
                dsField = entry(i, oModel:keys, ",").
            
            if dynamic-property(this-object, dsLocalField) <> dynamic-property(oModel, dsField) 
            then assign lgReturn = false.
        end.

        return lgReturn.
    end method.

    method public class classes.beta.model.Model belongsTo(input oModel as classes.beta.model.Model):
    
        def var i as integer no-undo.
        def var lgReturn as logical no-undo initial true.
        def var dsField as character no-undo.

        if valid-object(oModel)
        and this-object:matchKeys(oModel)
        then return oModel.

        do i = 1 to num-entries(oModel:keys, ","):
            assign dsField = entry(i, oModel:keys, ",").
            
            dynamic-property(oModel, dsField) = dynamic-property(this-object, dsField). 
        end.

        return oModel:find().
    
    end method.

    method public class classes.beta.model.Model hasOne(input oModel as classes.beta.model.Model):
    
        def var i as integer no-undo.
        def var dsField as character no-undo.
        def var dsLocalField as character no-undo.

        if valid-object(oModel)
        and this-object:matchKeys(oModel)
        then return oModel.

        do i = 1 to num-entries(oModel:keys, ","):
            assign                 
                dsField = entry(i, oModel:keys, ",")
                dsLocalField = entry(i, this-object:keys, ",").
            
            dynamic-property(oModel, dsField) = dynamic-property(this-object, dsLocalField). 
        end.

        return oModel:find().
    
    end method.

    method public class classes.beta.model.Model hasOne(input oModel as classes.beta.model.Model, input dsForeignKeys as character):                
        def var dsLocalKeys as character no-undo.
        def var oModelAux as classes.beta.model.Model no-undo.

        assign 
            dsLocalKeys = this-object:keys
            this-object:keys = dsForeignKeys.

        oModel:keys = dsForeignKeys.
        oModelAux = this-object:hasOne(oModel).                

        assign this-object:keys = dsLocalKeys.

        return oModelAux.
    end method.


    method public class classes.beta.model.Model hasOne(input oModel as classes.beta.model.Model, input dsForeignKeys as character, input dsLocalKeys as character):            
        def var dsThisKeys as character no-undo.        
        def var oModelAux as classes.beta.model.Model no-undo.
        
        dsThisKeys = this-object:keys.
        this-object:keys = dsLocalKeys.
        
        oModel:keys = dsForeignKeys.
        oModelAux = this-object:hasOne(oModel).

        this-object:keys = dsThisKeys.

        return oModelAux.
    
    end method.

    method public void hasMany(input oModel as classes.beta.model.Model):
        
        def var i as integer no-undo.
        def var dsField as character no-undo.

        assign 
            this-object:dsQuery = ""
            this-object:inQueryControl = 1.

        do i = 1 to num-entries(this-object:keys, ","):
            assign dsField = entry(i, this-object:keys, ",").
            this-object:and(dsfield, "=", string(dynamic-property(oModel, dsField))). 
        end.

    end method.

    method public Progress.Json.ObjectModel.JsonObject toJson(input oJsonPar as JsonObject):
        def var i as integer no-undo.
        def var oJsonReturn as Progress.Json.ObjectModel.JsonObject no-undo.

        oJsonReturn = new JsonObject().

        repeat i = 1 to this-object:tableHandle:num-fields:
            if oJsonPar:has(string(this-object:tableHandle:buffer-field(i):name))
            then oJsonReturn:add(oJsonPar:getCharacter(string(this-object:tableHandle:buffer-field(i):name)) , this-object:tableHandle:buffer-field(i):buffer-value()).            
        end.

        return oJsonReturn.
        
    end method.

    method public Progress.Json.ObjectModel.JsonObject toJson():
        if not valid-object(this-object:jsonSerializeModel)
        then this-object:jsonSerializeModel = new JsonObject().
        return this-object:toJson(this-object:jsonSerializeModel).
    end method.
end class.