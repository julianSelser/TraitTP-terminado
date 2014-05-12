require_relative 'modulo_definidor'

class Estrategia
  extend Definidor
  attr_accessor :nombre, :comportamiento

  def forma_de_resolver &bloque
    define_singleton_method(:resolver,bloque)
  end

  def evaluar metodo
    metodo.resolveteCon self
  end

  def nombrar nombre
    self.nombre =nombre
  end

end

Estrategia.define do

  nombrar :EstrategiaSecuencial

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1=evaluar unMetodo
    metodo2=evaluar otroMetodo

    proc {|*args|
      instance_exec(*args,&metodo1)
      instance_exec(*args,&metodo2)
    }
  end

end

Estrategia.define do

  nombrar :EstrategiaDefault

  forma_de_resolver do |unMetodo,otroMetodo|
    proc {raise 'Hay metodos conflictivos entre traits'}
  end

end


