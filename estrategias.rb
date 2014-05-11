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
    @comportamiento=bloque
    def self.resolver(unMetodo,otroMetodo)
      @comportamiento.call(unMetodo,otroMetodo)
    end
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
    evaluar unMetodo
    evaluar otroMetodo
  end
end

Estrategia.define do
  nombre :EstrategiaDefault
  forma_de_resolver do |unMetodo,otroMetodo|
    proc {raise 'Hay metodos conflictivos entre traits'}
  end
end


