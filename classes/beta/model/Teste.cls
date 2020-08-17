
class classes.beta.model.Teste:
    define property cd-modalidade as integer get. set.
    define property nr-proposta as integer get. set.
    define property cd-usuario as integer get. set.

    define property class-name as character get. set.

    constructor public Teste():
        this-object:class-name = program-name(1).
    end constructor.
end class.