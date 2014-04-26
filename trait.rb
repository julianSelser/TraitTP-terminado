class Trait

  attr_accessor :nombre, :metodos

  def Trait.define &bloque

    #excepcion si no se pasa un bloque - no se deberia llamar sin bloque
    raise 'Define invocado sin un bloque' if !block_given?

    trait = TraitBuilder.build &bloque

    #setea el trait como una constante para poder ser usado en las clases
    Object.const_set(trait.nombre, trait)

  end

  def initialize (nombre, metodosHash)
    self.nombre  = nombre
    self.metodos = metodosHash
  end

end