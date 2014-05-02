class Trait

  attr_accessor :nombre, :metodos

  def Trait.define &bloque

    #excepcion si no se pasa un bloque - no se deberia llamar sin bloque
    raise 'Define invocado sin un bloque' if !block_given?

    trait = TraitBuilder.conBloque &bloque

    #setea el trait como una constante para poder ser usado en las clases
    Object.const_set(trait.nombre, trait)

  end

  def - symboloMetodo
    TraitBuilder.sinMetodo(self, symboloMetodo)
  end

  def + otroTrait
    trait = TraitBuilder.conTraits(self, otroTrait)

    #le ponemos como variables de instancia el nombre de los traits que le dan origen a la composicion
    #nos va a servir para despues identificar ante un conflicto que traits trajeron el problema
    #todo: quizas haya que sumarle los metodos de cada uno...
    trait.instance_variable_set("@nombreTraitA", self.nombre )
    trait.instance_variable_set("@nombreTraitB", otroTrait.nombre )

    return trait
  end

  def << simbolos
    TraitBuilder.renombrandoMetodos(self, simbolos)
  end

  def initialize (nombre, metodosHash)
    self.nombre  = nombre
    self.metodos = metodosHash
  end

end