class TraitBuilder
  def initialize
    @metodos=Hash.new
  end

  def metodo nombreMetodo, &bloque

    #chequeamos que se le este pasando un bloque
    raise "No puede definirse un metodo sin pasarle un bloque en #{nombreMetodo}" if !block_given?

    #chequeamos que no se repita el metodo (se repite si tiene mismo nombre y aridad)
    raise "El metodo #{nombreMetodo} se encuentra repetido" if @metodos.has_key?(nombreMetodo)

    #guardamos los metodos como clave valor, la clave es [nombre, aridad]
    @metodos[nombreMetodo] = bloque
  end

  def nombre unNombre
    @nombre=unNombre
  end

  def build
    raise 'No puede crearse un trait sin nombre' if @nombre.nil?

    trait = Trait.new(@nombre, @metodos)
  end

  def renombrandoMetodos trait, nombres
    #creo un nuevo hash con el del trait pasado y reemplazo la key con el nombre nuevo
    metodosTraitElegido = Hash.new.merge(trait.metodos)
    metodosTraitElegido[nombres.nombreNuevo] = metodosTraitElegido.delete(nombres.nombreAnterior)

    @nombre, @metodos = trait.nombre, metodosTraitElegido

    self.build
  end

  def sinMetodo trait, metodo
    #sacamos del hash la clve con el nombre del metodo...el nombre no cambia, ya que es le mismo trait
    @nombre,@metodos = trait.nombre, trait.metodos.reject{|nombreMetodo, bloque| nombreMetodo == metodo}

    self.build
  end

  def conBloque &bloque

    #inicializa la coleccion de metodos
    self.instance_variable_set("@Metodos", Hash.new)

    #evalua el bloque, llamando los metodos de clase "name" y "method"
    instance_eval(&bloque)
    #devuelve el trait armado
    self.build
  end

end