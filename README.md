# KPFramework

**Documentação em breve...**

## Proposta de estrutura a ser utilizada.
> Controller - nossos atuais fontes de endpoints inicialmente não orientado.
>> Services - consomem Models e Repositories.
>>> Models - Entidades de negócio que irão refletir e acessar o banco de dados.  
>>> Repositories - Repositório de consultas mais complexas.
          
## Model
Qualquer classe modelo pode herdar a classe **Model** e no construtor da classe enviar para o construtor da classe Model o handle da tabela que você quer mapear para realizar operações de consulta e persistência no banco de dados. Também é necessário informar o nome completo da classe na propriedade className da classe Model `this-object:className`.

```
using classes.beta.model.*.

class classes.beta.model.Person inherits Model:

    constructor public Person():
        super(buffer pessoa-fisica:handle).
        this-object:className = "classes.beta.model.Person".        
    end constructor.

end class.
```

Você deve também informar todos os atributos pertinentes, os atributos devem refletir os campos da tabela do banco.

```
class classes.beta.model.Person inherits Model:
    
    constructor public Person():
        super(buffer pessoa-fisica:handle).
        this-object:className = "classes.beta.model.Person".        
    end constructor.

    method public classes.beta.model.Person extent get():
        return dynamic-cast(super:getData(), this-object:className).
    end method.        

    define property id-pessoa-old as integer get. set.
    define property nm-pessoa as character get. set.
    define property cd-cpf as character get. set.
    define property dt-nascimento as date get. set.
    define property in-estado-civil as integer get. set.
    define property nome-abrev as character get. set.
    define property cd-cbo as integer get. set.
    define property lg-sexo as logical get. set.
    define property nr-identidade as character get. set.
    define property uf-emissor-ident as character get. set.
    define property nm-cartao as character get. set.
    define property nm-internacional as character get. set.
    define property ds-nacionalidade as character get. set.
    define property ds-natureza-doc as character get. set.
    define property nr-pis-pasep as decimal get. set.
    define property nm-mae as character get. set.
    define property nm-pai as character get. set.
    define property ds-orgao-emissor-ident as character get. set.
    define property nm-pais-emissor-ident as character get. set.
    define property dt-emissao-ident as date get. set.

end class.
```
***
Para auxiliar na geração das propriedades você pode utilizar o script abaixo. Ele irá imprimir as propriedades em um arquivo texto a ser definido na primeiro linha do código.
```
output to "C:/temp/properties.person.txt".
def var i as integer no-undo.
def var tableHandle as handle.

for first person no-lock: end.
assign tableHandle = buffer person:handle.

repeat i = 1 to tableHandle:num-fields:
    put unformatted 
        "define property " 
        tableHandle:buffer-field(i):name 
        " as "
        tableHandle:buffer-field(i):data-type
        " get. set." skip.
end.

output close.
```
### Relacionamentos
Com a herança da classe Model é possível realizar um relacionamento das classes conforme se relacionam no banco de dados.

#### Um para um
Relacionamentos um para um são os mais simples, no exemplo abaixo vemos um relacionamento da classe `Beneficiary` com a classe `Person`. É necessário declarar uma propriedade para a classe person ficar instanciada assim como utilizar o método `hasOne` para realizar o mapeamento.

```
using classes.beta.model.*.

class classes.beta.model.Beneficiary inherits Model:   

    constructor public Beneficiary():
        super(buffer usuario:handle).
        this-object:className = "classes.beta.model.Beneficiary".  
    end constructor.

    define property person as Person get. set.

    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa","id-pessoa"), this-object:person:className).
    end method. 

end class.
```
Você pode definir um relacionamento com o método `hasOne` de duas formas, apenas mapeando as duas classes e as chaves o qual se relacionam, apenas uma vez caso os campos utilizados no relacionamento sejam os mesmos em ambas as classes.
```
    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa"), this-object:person:className).
    end method. 
```
E definindo qual é a chave origem e destino caso sejam chaves distintas.
```
    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa","cd-pessoa"), this-object:person:className).
    end method. 
```

Caso você tenha uma composta basta definir a ordem dos campos separados por vírgula.
```
    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa,cd-cpf"), this-object:person:className).
    end method. 
```
Em caso de chaves diferentes.
```
    method public class Person person():
        return dynamic-cast(this-object:hasOne(this-object:person,"id-pessoa,cd-cpf","cd-pessoa,cd-cpf"), this-object:person:className).
    end method. 
```

#### Um para muitos
Exemplo mapeando a classe `Beneficiary` com a classe `Cards`, no caso um Beneficiary possui muitos Cards.
```
    method public class Card cards():
        this-object:cards:keys = "cd-unimed,cd-modalidade,nr-ter-adesao,cd-usuario".
        this-object:cards:hasMany(this-object).
        return this-object:cards.
    end method.
```
### Realizando consultas
Após definido as classes e relacionamentos, é possível realizar consultas.

#### Find()
Abaixo segue exemplo de consulta de apenas um registro unico do banco de dados.
```
using classes.beta.model.*.
using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.

define variable oPerson as Person no-undo.

oPerson = new Person().
oPerson:id-pessoa = 250.
oPerson:find().
```

#### Queries
Abaixo segue forma de consulta para mais de um registro.

##### And e AndGroup
```
using classes.beta.model.*.
using Progress.Json.ObjectModel.*.
using OpenEdge.Core.String.
using Progress.Lang.*.

def variable oBenef as Beneficiary no-undo.

oBenef = new Beneficiary().

oBenef
    :and("cd-modalidade", "=", "20")
    :and("nr-proposta", "=", "22110")
    :and("cd-sit-usuario", ">=", "5")
    :and("cd-sit-usuario", "<=", "7").

do while(oBenef:getNext() <> ?):

          //código

end.
```
AndGroup pode ser utilizado para agrupar cláusulas `and`.
```
oBenef
    :andGroup()
    :and("cd-modalidade", "=", "20").
    :and("nr-proposta", "=", "22110")
    :and("cd-sit-usuario", ">=", "5")
    :and("cd-sit-usuario", "<=", "7")
    :groupClose().
```

