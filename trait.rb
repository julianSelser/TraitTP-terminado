class Trait

  attr_accessor :nombre, :metodos

  def Trait.define &bloque

    raise 'Define invocado sin un bloque' unless block_given?

    trait = Trait.new

    #el trait evalua el bloque pasado al define(con su nombre y metodos)
    trait.instance_eval &bloque

    #setea el trait como una constante para poder ser usado en las clases
    Object.const_set(trait.nombre, trait)
  end

  def - metodo
    #retiramos del hash el metodo si es 'nombreMetodo'
    metodosSinMetodo = self.metodos.reject{|nombreMetodo, bloque| nombreMetodo == metodo}

    Trait.new(self.nombre, metodosSinMetodo)
  end

  def + otroTrait
    #mergeamos los metodos del trait con el del trait pasado
    #todo: hay que acumular conflictos de alguna forma
    Trait.new(:nuevo, self.metodos.merge(otroTrait.metodos))
  end

  def << nombres
    #creo un nuevo hash con el del trait y reemplazo la key con el nombre nuevo
    metodosTraitElegido = Hash.new.merge(self.metodos)
    metodosTraitElegido[nombres.nombreNuevo] = metodosTraitElegido.delete(nombres.nombreAnterior)

    #devuelvo un nuevo trait con el mismo nombre pero con el metodo renombrado
    Trait.new(self.nombre, metodosTraitElegido)
  end

  def initialize nombre = nil, metodosHash = Hash.new
    self.nombre = nombre
    self.metodos = metodosHash
  end

  def metodo nombreMetodo, &bloque

    #chequeamos que se le este pasando un bloque
    raise "No puede definirse un metodo sin pasarle un bloque en #{nombreMetodo}" if !block_given?

    #chequeamos que no se repita el metodo
    raise "El metodo #{nombreMetodo} se encuentra repetido" if @metodos.has_key?(nombreMetodo)

    #guardamos los metodos como clave valor, la clave es [nombre, aridad]
    @metodos[nombreMetodo] = bloque
  end

  def nombrar nombre
    self.nombre = nombre
  end

end