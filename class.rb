class Class

  #todo: hay que refactorear este metodo fuerte
  def uses *traits

    #si se llama a uses sin argumentos quiero que se rompa
    raise 'No se puede llamar uses sin argumentos' if traits.empty?
    #todo: hacer que se rompa si algun argumento no es un trait

    #consigo los metodos de los traits
    metodosDeTraits = traits.collect{ |trait| trait.metodos.keys}.flatten

    #si un par de traits repiten el nombre, levantar una excepcion
    raise 'Hay metodos conflictivos entre traits' if metodosDeTraits.uniq.size!=metodosDeTraits.size

    #consigo los metodos de la clase
    metodosActuales = self.methods(true)

    #solo quiero definir en la clase los metodos que no esten en la clase
    metodosSeleccionados = metodosDeTraits.uniq - metodosActuales

    #busco los bloques de los metodos seleccionados en los diccionarios de los traits
    metodosImplementables = traits.collect { |trait|
      trait.metodos.reject {|clave, valor| !metodosSeleccionados.include?(clave)}
      }.reduce(:merge)

    #define metodos con los nombres y los bloques del hash resultante
    metodosImplementables.each{ |nombreMetodo, cuerpoMetodo|
      define_method nombreMetodo, cuerpoMetodo
    }

  end

end