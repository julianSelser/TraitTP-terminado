require_relative 'modulo_definidor'

class Trait
  extend Definidor
  attr_accessor :nombre, :metodos, :clasesQueLoUsan

  def - metodo
    #retiramos del hash el metodo si es 'nombreMetodo'
    metodosSinMetodo = self.metodos.reject{|nombreMetodo, bloque| nombreMetodo == metodo}

    Trait.new(self.nombre, metodosSinMetodo)
  end

  def + otroTrait

    metodosAAgregarPropios=self.metodos.clone
    metodosAAgregarAjenos=otroTrait.metodos.clone

    traitResultante=Trait.new(:nuevo,metodosAAgregarPropios)
    metodosAAgregarAjenos.each{|mensaje,metodoClasificado| traitResultante.agregarMetodoClasificado(mensaje,metodoClasificado)}

    traitResultante
  end

  def << nombres
    #creo un nuevo hash con el del trait y pongo otra key con el nombre nuevo y el cuerpo del metodo elegido
    metodosTraitElegido = Hash.new.merge(self.metodos)
    metodosTraitElegido[nombres.nombreNuevo] = metodosTraitElegido[nombres.nombreAnterior]

    #devuelvo un nuevo trait con el mismo nombre pero con el metodo renombrado
    Trait.new(self.nombre, metodosTraitElegido)
  end

  def initialize nombre = nil, metodosHash = Hash.new
    self.nombre = nombre
    self.metodos = metodosHash
    self.clasesQueLoUsan=[]
  end

  def metodo nombreMetodo, &bloque
    #chequeamos que se le este pasando un bloque
    raise "No puede definirse un metodo sin pasarle un bloque en #{nombreMetodo}" if !block_given?

    self.clasesQueLoUsan.each{|clase| clase.actualizarMetodo nombreMetodo,bloque}
    metodo_nuevo=Metodo_simple.new(nombreMetodo, bloque)
    agregarMetodoClasificado(nombreMetodo,metodo_nuevo)
  end

  def agregarMetodoClasificado (mensaje,metodoClasificado)
   if @metodos.has_key?(mensaje)
     @metodos[mensaje]=Metodo_conflictivo.new(mensaje,@metodos[mensaje],metodoClasificado)
   else
     @metodos[mensaje]=metodoClasificado
   end
  end

  def nombrar nombre
    self.nombre = nombre
  end

  def sosUsadoPor unaClase
    self.clasesQueLoUsan<<unaClase
  end

  def modificarMetodo mensaje, &bloque
    raise 'Se pide modificar un metodo inexistente.' unless self.metodos.has_key? mensaje

    self.metodos[mensaje]=Metodo_simple.new(mensaje,bloque)
    self.clasesQueLoUsan.each{|clase|clase.actualizarMetodo mensaje,self.metodos[mensaje].bloqueFinal}
  end

  def resolver_conflictos_con estrategia
    self.metodos.each{|mensaje,metodo|self.metodos[mensaje]=self.metodos[mensaje].simplificate_con estrategia}
    self
  end

end