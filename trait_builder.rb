class TraitBuilder

  #variables de clase
  @@Nombre; @@Metodos

  def self.nombre nombre
    @@Nombre = nombre
  end

  def self.metodo nombreMetodo, &bloque

    #chequeamos que se le este pasando un bloque
    raise "No puede definirse un metodo sin pasarle un bloque en #{nombreMetodo}" if !block_given?

    #chequeamos que no se repita el metodo (se repite si tiene mismo nombre y aridad)
    raise "El metodo #{nombreMetodo} se encuentra repetido" if @@Metodos.has_key?(nombreMetodo)

    #guardamos los metodos como clave valor, la clave es [nombre, aridad]
    @@Metodos[nombreMetodo] = bloque
  end

  def self.build
    raise 'No puede crearse un trait sin nombre' if @@Nombre.nil?

    trait = Trait.new(@@Nombre, @@Metodos)

    @@Nombre, @@Metodos = nil, nil #reestablecemos el valor de las variables de clase

    return trait
  end

  def self.renombrandoMetodos trait, nombres
    #creo un nuevo hash con el del trait pasado y reemplazo la key con el nombre nuevo
    metodosTraitElegido = Hash.new.merge(trait.metodos)
    metodosTraitElegido[nombres.nombreNuevo] = metodosTraitElegido.delete(nombres.nombreAnterior)

    @@Nombre, @@Metodos = trait.nombre, metodosTraitElegido

    self.build
  end

  def self.sinMetodo trait, metodo
    #sacamos del hash la clve con el nombre del metodo...el nombre no cambia, ya que es le mismo trait
    @@Nombre, @@Metodos = trait.nombre, trait.metodos.reject{|nombreMetodo, bloque| nombreMetodo == metodo}

    self.build
  end

  def self.conBloque &bloque

    #inicializa la coleccion de metodos
    self.class_variable_set("@@Metodos", Hash.new)

    #evalua el bloque, llamando los metodos de clase "name" y "method"
    #que lo que hace es setear variables de clase para luego construir un trait
    instance_eval(&bloque)

    #devuelve el trait armado
    self.build
  end

end