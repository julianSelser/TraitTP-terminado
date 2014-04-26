require 'rspec'
require '.\trait_builder'
require '.\trait'
require '.\class'

#definimos un trait...
Trait.define do
  name :MiTrait

  method :metodo1 do
    "hola"
  end

  method :metodo2 do |un_numero|
    un_numero * 0 + 42
  end

end

#estre trait tiene el mismo 'metodo1' que el trait definido arriba
Trait.define do
  name :TraitConMetodoRepetido

  method :metodo1 do
    "mundo"
  end
end

#el chiste de este trait es que llama a un metodo 'requerimiento' sin definirlo
Trait.define do
  name :TraitConRequerimiento

  method :metodoConRequerimiento do
    requerimiento
  end

end

#otro trait con un metodo que devuelve un string, va a jugar con el trait de arriba
Trait.define do
  name :TraitQueLlenaRequerimiento

  method :requerimiento do
    "requerimiento cumplido"
  end
end


describe 'Tests de traits' do

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

    #recordar que 'los metodos' son un diccionario clave valor
    #y que estan definidos como constante en Object (con scope global)
    MiTrait.metodos.has_key?(:metodo1).should == true
    MiTrait.metodos.has_key?(:metodo2).should == true

  end

  it 'No se puede llamar "uses" sin argumentos definiendo una clase' do

    expect{

    class F
      uses #no le mando nada por parametro
    end

    }.to raise_error 'No se puede llamar uses sin argumentos'

  end

  it 'Cuando se repite el nombre de un metodo en un trait hay una excepcion' do

    expect{

      class G
        uses MiTrait, TraitConMetodoRepetido
      end

    }.to raise_error 'Hay metodos conflictivos entre traits'


  end

  it 'Metodo con otro metodo como requerimiento, pincha si no esta definido' do

    class H
      uses TraitConRequerimiento
    end

    objeto = H.new

    #el 'name error' es una excepcion para cuando no esta definido un metodo
    expect{ objeto.metodoConRequerimiento }.to raise_error NameError

  end

  it 'Puedo llamar a "uses" con cualquier numero de traits traits' do

    class Y
      uses TraitConRequerimiento, TraitQueLlenaRequerimiento
    end

    objeto = Y.new

    objeto.metodoConRequerimiento.should == "requerimiento cumplido"


  end

end