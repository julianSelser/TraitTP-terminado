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

describe 'Tests de traits' do #son tests de integracion...

  it 'Uso un trait en una clase y pruebo llamar a uno de sus metodos con parametros' do

    class A
      uses MiTrait
    end

    objeto = A.new

    #el metodo2 tomando el paramatro...siempre devuelve 42
    objeto.metodo2(1000).should == 42

  end


  it 'Un trait queda definido como constante para las clases' do

    #una clase de prueba para ver si puedo usar los traits como constantes
    class B
      def trait
        MiTrait
      end
    end

    #instanciamos la UnaClase
    prueba = B.new

    #el trait devuelto es el mismo
    prueba.trait.nombre.should == :MiTrait

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

    objeto = D.new

    objeto.metodo1.should == "hola"

  end

  it 'Si defino un metodo en la clase y un trait tiene ese mismo metodo, el que cuenta es el de la clase' do

    class E
      uses MiTrait

      #el trait 'MiTrait' tambien define el 'metodo1' que devuelve "hola"
      def metodo1
        "metodo definido en la clase"
      end

    end

    objeto = E.new

    objeto.metodo1.should == "metodo definido en la clase"

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

    objeto = H.new

    #el 'name error' es una excepcion para cuando no esta definido un metodo
    expect{ objeto.metodoConRequerimiento }.to raise_error NameError

  end

  #de paso vemos si se puede complir un requerimiento entre traits
  it 'Puedo llamar a "uses" con cualquier numero de traits' do

    class I
      uses TraitConRequerimiento + TraitQueLlenaRequerimiento
    end

    objeto = I.new

    objeto.metodoConRequerimiento.should == "requerimiento cumplido"


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
      laEstrategiaDeResolucionEs EstrategiaSecuencial
      uses TraitParaRestarUno+TraitParaRestarDos
    end
    o = Q.new
    o.var=3
    o.decrementar
    o.var.should==0
  end

end