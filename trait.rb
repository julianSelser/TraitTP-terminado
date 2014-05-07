class Trait

  attr_accessor :nombre, :metodos

  def Trait.define &bloque

    #excepcion si no se pasa un bloque - no se deberia llamar sin bloque
    raise 'Define invocado sin un bloque' unless block_given?

    trait = TraitBuilder.new.conBloque &bloque

    #setea el trait como una constante para poder ser usado en las clases
    Object.const_set(trait.nombre, trait)

  end

  def - symboloMetodo
    TraitBuilder.new.sinMetodo(self, symboloMetodo)
  end

  def + otroTrait
    metodosPropios = self.metodos
    metodosForaneos = otroTrait.metodos

    metodosUnidos=metodosPropios.merge(metodosForaneos)

    if (metodosPropios.size+metodosForaneos.size)!=metodosUnidos.size
      #devolver los metodos, resultado de resolver el conflicto
      raise 'Hay metodos conflictivos entre traits'
    end

    nuevoTrait= Trait.new(:nuevo,self.metodos.merge(otroTrait.metodos))
    nuevoTrait
  end

  def << simbolos
    TraitBuilder.new.renombrandoMetodos(self, simbolos)
  end

  def initialize (nombre, metodosHash)
    self.nombre  = nombre
    self.metodos = metodosHash
  end

end