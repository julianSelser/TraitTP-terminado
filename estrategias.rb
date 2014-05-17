require_relative 'modulo_definidor'

class Estrategia
  extend Definidor
  attr_accessor :nombre

  def forma_de_resolver &bloque
    define_singleton_method(:resolver,bloque)
  end

  def evaluar metodo
    metodo.resolveteCon self
  end

  def nombrar nombre
    self.nombre =nombre
  end

  def con_funcion &funcion
    nuevaEstrategia = self.clone
    nuevaEstrategia.instance_variable_set(:@funcion, funcion)
    return nuevaEstrategia
  end

end

Estrategia.define do

  nombrar :EstrategiaSecuencial

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1 = evaluar unMetodo
    metodo2 = evaluar otroMetodo

    proc {|*args|
      instance_exec(*args,&metodo1)
      instance_exec(*args,&metodo2)
    }
  end

end

Estrategia.define do

  nombrar :EstrategiaAnySatisfy

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1 = evaluar unMetodo
    metodo2 = evaluar otroMetodo
    funcion = @funcion

    proc {|*args|
      resultado1 = instance_exec(*args,&metodo1)
      resultado2 = instance_exec(*args,&metodo2)

      return resultado1 if !resultado1.nil? && instance_exec(resultado1, &funcion)
      return resultado2 if !resultado2.nil? && instance_exec(resultado2, &funcion)
    }
  end

end


Estrategia.define do

  nombrar :EstrategiaFold

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1 = evaluar unMetodo
    metodo2 = evaluar otroMetodo
    funcion = @funcion

    proc {|*args|
      resultado1 = instance_exec(*args,&metodo1)
      resultado2 = instance_exec(*args,&metodo2)
      instance_exec(resultado1, resultado2, &funcion)
    }
  end

end

Estrategia.define do

  nombrar :EstrategiaDefault

  forma_de_resolver do |unMetodo,otroMetodo|
    proc {raise 'Hay metodos conflictivos entre traits'}
  end

end


