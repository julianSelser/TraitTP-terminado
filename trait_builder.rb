class TraitBuilder

  #variables de clase
  @@Nombre; @@Metodos

  def self.name nombre
    @@Nombre = nombre
  end

  def self.method nombreMetodo, &bloque
    #guardamos los metodos como clave valor
    @@Metodos[nombreMetodo] = bloque
  end

  def self.build &bloque

    #inicializa la coleccion de metodos
    self.class_variable_set("@@Metodos", Hash.new)

    #evalua el bloque, llamando los metodos de clase "name" y "method"
    #que lo que hace es setear variables de clase para luego construir un trait
    instance_eval(&bloque)

    #devuelve el trait armado
    Trait.new(@@Nombre, @@Metodos)

  end

end