gem 'rspec'
require_relative 'symbol'
require_relative 'estrategias'
require_relative 'trait'
require_relative 'class'
require_relative 'metodo_simple'
require_relative 'metodo_conflictivo'

#definimos un trait...
Trait.define do
  nombrar :MiTrait

  metodo :metodo1 do
    "hola"
  end

  metodo :metodo2 do |un_numero|
    un_numero * 0 + 42
  end

end

#estre trait tiene el mismo 'metodo1' que el trait definido arriba
Trait.define do
  nombrar :TraitConMetodoRepetido

  metodo :metodo1 do
    "mundo"
  end
end

#estre trait tiene el mismo 'metodo1' que el trait definido arriba
Trait.define do
  nombrar :TraitConOtroMetodoRepetido

  metodo :metodo1 do
    "mundirijillo"
  end
end

#el chiste de este trait es que llama a un metodo 'requerimiento' sin definirlo
Trait.define do
  nombrar :TraitConRequerimiento

  metodo :metodoConRequerimiento do
    requerimiento
  end
end

#otro trait con un metodo que devuelve un string, va a jugar con el trait de arriba
Trait.define do
  nombrar :TraitQueLlenaRequerimiento

  metodo :requerimiento do
    "requerimiento cumplido"
  end
end

Trait.define do
  nombrar :TraitUno

  metodo :a do
    'Estoy en el trait uno'
  end
end

Trait.define do
  nombrar :TraitDos

  metodo :a do
    'Estoy en el trait dos'
  end
end

Trait.define do
  nombrar :TraitParaRestarUno

  metodo :decrementar do
    self.var=self.var-1
  end
end

Trait.define do
  nombrar :TraitParaRestarDos

  metodo :decrementar do
    self.var=self.var-2
  end
end

Trait.define do
  nombrar :TraitRestarGenerico

  metodo :decrementar do |sustraendo,minuendo|
    @resultado=minuendo-sustraendo
  end
end

Trait.define do
  nombrar :TraitRestaFalsa

  metodo :decrementar do |sustraendo,minuendo|
    @resultado=@resultado*2
  end
end

describe 'Tests de traits' do #son tests de integracion...

  it 'Uso un trait en una clase y pruebo llamar a uno de sus metodos con parametros' do

    class A
      uses MiTrait
    end

    o = A.new

    #el metodo2 tomando el paramatro...siempre devuelve 42
    o.metodo2(1000).should == 42

  end


  it 'Un trait queda definido como constante para las clases' do

    #una clase de prueba para ver si puedo usar los traits como constantes
    class B
      def trait
        MiTrait
      end
    end

    #instanciamos la UnaClase
    o = B.new

    #el trait devuelto es el mismo
    o.trait.nombre.should == :MiTrait

  end

  it 'No puedo llamar a "define" de un trait sin un bloque' do

    #usando "define" sin un bloque...
    expect{ Trait.define }.to raise_error 'Define invocado sin un bloque'

  end

  it 'Puedo llamar uses desde una clase' do #ya se que es un test boludo, no me juzguen

    class C
      uses MiTrait
    end

  end


  it 'Llamamos a un metodo de un trait usado por una clase' do

    class D
      uses MiTrait
    end

    o = D.new

    o.metodo1.should == "hola"

  end

  it 'Si defino un metodo en la clase y un trait tiene ese mismo metodo, el que cuenta es el de la clase' do

    class E
      uses MiTrait

      #el trait 'MiTrait' tambien define el 'metodo1' que devuelve "hola"
      def metodo1
        "metodo definido en la clase"
      end

    end

    o = E.new

    o.metodo1.should == "metodo definido en la clase"

  end

  it 'NO puedo llamar uses desde cualquier lado' do

    expect{ uses MiTrait }.to raise_error NoMethodError

  end

  it 'Los metodos quedan definidos en un trait de scope global' do

    MiTrait.nombre.should == :MiTrait

  end

  it 'Metodo con otro metodo como requerimiento, pincha si no esta definido' do

    class H
      uses TraitConRequerimiento
    end

    o = H.new

    #el 'name error' es una excepcion para cuando no esta definido un metodo
    expect{ o.metodoConRequerimiento }.to raise_error NameError

  end

  #de paso vemos si se puede complir un requerimiento entre traits
  it 'Puedo llamar a "uses" con cualquier numero de traits' do

    class I
      uses TraitConRequerimiento + TraitQueLlenaRequerimiento
    end

    o = I.new

    o.metodoConRequerimiento.should == "requerimiento cumplido"


  end

  it 'Puedo sumar traits' do

    class J; uses TraitConRequerimiento + TraitQueLlenaRequerimiento; end

    o = J.new

    o.requerimiento.should == "requerimiento cumplido"

  end

  it 'La resta remueve metodos' do

    class K
      uses MiTrait - :metodo1
    end

    o = K.new

    #el metodo nunca queda definido...
    expect{ o.metodo1 }.to raise_error NoMethodError
  end

  it 'Cambiar selectores cambia el nombre del metodo definido' do

    class L
      uses MiTrait << (:metodo1 >> :saludo)
    end

    o = L.new

    o.metodo1.should == "hola"
    o.saludo.should == "hola"

  end

  it 'Se suman reiteradamente traits conflictivos' do
    class M
      uses TraitUno+TraitDos+TraitUno+TraitDos+TraitDos+TraitUno
    end
    o = M.new
    expect{o.a}.to raise_error 'Hay metodos conflictivos entre traits'
  end

  it 'Prueba basica de agregar un trait.' do
    class N
      uses TraitUno
    end
    o = N.new
    o.a.should =='Estoy en el trait uno'
  end

  it 'Pruebo si prioriza los metodos ya establecidos en la clase.' do
    class O
      def a
        "Salio bien."
      end
      uses TraitUno
    end
    o=O.new
    o.a.should=="Salio bien."
  end

  it 'Pruebo si prioriza los metodos definidos por un trait previo.' do
    class P
      uses TraitUno
      uses TraitDos
    end
    o=P.new
    o.a.should=="Estoy en el trait uno"
  end

  it 'Prueba de la estrategia secuencial' do
    class Q
      attr_accessor :var
      estrategia EstrategiaSecuencial
      uses TraitParaRestarUno+TraitParaRestarDos
    end
    o = Q.new
    o.var=3
    o.decrementar
    o.var.should==0
  end

  it 'Prueba que se secuencializen 3.' do
    class R
      attr_accessor :var
      estrategia EstrategiaSecuencial
      uses TraitParaRestarUno+TraitParaRestarDos+TraitParaRestarUno
    end
    o = R.new
    o.var=4
    o.decrementar
    o.var.should==0
  end

  it 'Pruebo secuencial con argumentos.' do
    class S
      attr_accessor :resultado
      estrategia EstrategiaSecuencial
      uses TraitRestarGenerico+TraitRestaFalsa
    end
    o = S.new
    o.decrementar 15,20
    o.resultado.should==10
  end

  it 'En ejecucion le agrego un metodo al trait' do
    TraitParaRestarUno.metodo :nuevoMetodo do
      'Soy un metodo hecho al vuelo.'
    end
    class T
      uses TraitParaRestarUno
    end
    o=T.new
    o.nuevoMetodo.should=='Soy un metodo hecho al vuelo.'
  end

  it 'En ejecucion se agrega un metodo al trait y la clase se corresponde.' do
    class U
      uses TraitParaRestarUno
    end
    TraitParaRestarUno.metodo :arrepentirse do
      'Perdon no te quise restar uno.'
    end
    o=U.new
    o.arrepentirse.should=='Perdon no te quise restar uno.'
  end

  it 'En ejecucion se modifica un metodo de un trait y la clase se corresponde.' do
    class V
      uses TraitParaRestarUno
    end
    o=V.new

    TraitParaRestarUno.modificarMetodo :arrepentirse do
      'No resto mas.'
    end

    o.arrepentirse.should=='No resto mas.'
  end

  it 'Rompe al intentar modificar un metodo inexistente' do
    expect{TraitParaRestarUno.modificarMetodo :metodoInexistente do'Hello World!'end}.to raise_error 'Se pide modificar un metodo inexistente.'
  end

  it 'Especifico como quiero que se resuelva un resultado de operacion.' do
    class W
      attr_accessor :var
      uses (TraitParaRestarUno+TraitParaRestarDos).resolver_conflictos_con EstrategiaSecuencial
    end
    o=W.new
    o.var=10
    o.decrementar
    o.var.should==7
  end

  it 'usa estrategiaFold' do
      class X
        estrategia EstrategiaFold.con_funcion {|n,m| n*m }
        uses MiTrait+MiTrait+MiTrait
      end

    o = X.new
    o.metodo2(123).should == 74088
  end

  it ' usa EstrategiaAnySatisfy y devuelve el segundo' do
    class Y
      estrategia EstrategiaAnySatisfy.con_funcion {|n| n.length > 4 }
      uses MiTrait+TraitConMetodoRepetido
    end

    o = Y.new
    o.metodo1.should == "mundo"
  end

  it ' usa EstrategiaAnySatisfy devuelve el primero siempre' do
    #ponemos dos traits con metodos repetidos, con funcion que da true tiene que traer el primero
    class Z
      estrategia EstrategiaAnySatisfy.con_funcion {|n| true }
      uses MiTrait+TraitConMetodoRepetido
    end

    o = Z.new
    o.metodo1.should == "hola"

    #cambiamos el orden y vemos que efectivamente trae el primero
    class ZA
      estrategia EstrategiaAnySatisfy.con_funcion {|n| true }
      uses TraitConMetodoRepetido+MiTrait
    end

    o = ZA.new
    o.metodo1.should == "mundo"
  end

  it ' usa EstrategiaAnySatisfy devuelve el tercero' do
    class ZB
      estrategia EstrategiaAnySatisfy.con_funcion {|n| n.length >6}

      uses MiTrait+TraitConMetodoRepetido+TraitConOtroMetodoRepetido
    end

    o = ZB.new
    o.metodo1.should == "mundirijillo"
  end

  it 'usar "con_funcion" en una estrategia no la modifica a nivel global' do
    class ZC
      estrategia EstrategiaAnySatisfy.con_funcion {  }
    end

    EstrategiaAnySatisfy.instance_variable_defined?(:@funcion).should == false
  end

end


