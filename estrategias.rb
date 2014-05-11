# La estrategia debe definir el bloqueFinal de cada objeto metodo.
class Estrategia
  attr_accessor :name, :comportamiento
  def self.define &bloque
    raise 'Define invocado sin un bloque' unless block_given?

    estrategia = self.new
    estrategia.instance_eval &bloque

    Object.const_set(estrategia.name, estrategia)
  end

  def forma_de_resolver &bloque
    define_singleton_method(:resolver,bloque)
  end

  def evaluar metodo
    metodo.resolveteCon self
  end

  def nombre algo
    self.name= algo
  end
end

Estrategia.define do

  nombre :EstrategiaSecuencial

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1=evaluar unMetodo
    metodo2=evaluar otroMetodo

    proc {|*args|
      instance_eval(&metodo1)
      instance_eval(&metodo2)
    }
  end

end

Estrategia.define do

  nombre :EstrategiaDefault

  forma_de_resolver do |unMetodo,otroMetodo|
    proc {raise 'Hay metodos conflictivos entre traits'}
  end

end


