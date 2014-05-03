class Class

  def estrategiaResolucion

    return EstrategiaStandard if @estrategiaResolucion.nil?

    @estrategiaResolucion
  end

  def estrategia estrategia
    @estrategiaResolucion = estrategia
  end

  def uses *traits

    #si se llama a uses sin argumentos quiero que se rompa
    raise 'No se puede llamar uses sin argumentos' if traits.empty?
    #todo: hacer que se rompa si algun argumento no es un trait

    #consigo los metodos de los traits como hash {nombre=>bloqueMetodo}
    metodosDeTraits = aplanar traits

    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods(false)

    #solo quiero definir en la clase los metodos que no esten en la clase
    metodosSeleccionados = metodosDeTraits.keys - metodosDeClase

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosDeTraits.each{ |nombreMetodo, cuerpoMetodo|
      define_method nombreMetodo, cuerpoMetodo if metodosSeleccionados.include? nombreMetodo
    }

  end

  #aplana los traits para devolver un hash de {:NombreMetodo => {..BloqueMetodo}}
  #ve si hay conflicto entre métodos y lo maneja segun la estrategia seteada...
  def aplanar traits

    #consigo los metodos de los traits como un array de tipo: [[nombre, aridad]...]
    metodosDeTraits = traits.inject([]){ |nombres,trait| nombres + trait.metodos.keys}

    #si un par de traits repiten el nombre y aridad, hay conflicto
    if metodosDeTraits.uniq.size!=metodosDeTraits.size
      #devolver los metodos, resultado de resolver el conflicto
      return self.estrategiaResolucion.resolver(traits)
    end

    #si no hubo conflicto devolvemos un hash de metodos
    #producto de mergear todos los hashes de metodos de los traits
    return traits.inject(Hash.new){|aplanamiento, trait| aplanamiento.merge(trait.metodos)}
  end

end