class Class

  def estrategiaResolucion

    return EstrategiaStandard if @estrategiaResolucion.nil?

    @estrategiaResolucion
  end

  def estrategia estrategia
    @estrategiaResolucion = estrategia
  end

  def uses *argumentos

    #si se llama a uses sin argumentos quiero que se rompa
    raise 'No se puede llamar uses sin argumentos' if argumentos.empty?
    #todo: hacer que se rompa si algun argumento no es un trait

    #consigo los metodos del trait  como hash {nombre=>bloqueMetodo}
    metodosDeTrait = *argumentos.first.metodos

    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods()

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosDeTrait.each do |nombreMetodo, cuerpoMetodo|
      define_method nombreMetodo,cuerpoMetodo
      end

  end

end