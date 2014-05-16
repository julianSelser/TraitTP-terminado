require_relative 'modulo_definidor'

class Estrategia
  extend Definidor
  attr_accessor :nombre, :comportamiento

  def forma_de_resolver &bloque
    define_singleton_method(:resolver,bloque)
  end

  def evaluar metodo
    metodo.resolveteCon self
  end

  def nombrar nombre
    self.nombre =nombre
  end

end

Estrategia.define do

  nombrar :EstrategiaSecuencial

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1=evaluar unMetodo
    metodo2=evaluar otroMetodo

    proc {|*args|
      instance_exec(*args,&metodo1)
      instance_exec(*args,&metodo2)
    }
  end

end

Estrategia.define do

  nombrar :EstrategiaFold

  forma_de_resolver do |unMetodo,otroMetodo|
    metodo1=evaluar unMetodo
    metodo2=evaluar otroMetodo
    comporta=self.comportamiento

  proc {|*args|
      elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Uno_EsElQueSigueAContinuacion=instance_exec(*args,&metodo1)
      elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Dos_EsElQueSigueAContinuacion=instance_exec(*args,&metodo2)
      instance_exec(elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Uno_EsElQueSigueAContinuacion,
                    elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Dos_EsElQueSigueAContinuacion,
                    &comporta)
    }#clarisimo y funciona =D con nombres mnemotécnicos
  end

end

#
# Estrategia.define do
# #fixme EstrategiaUntil requiere una recursividad que como esta pensada aca pincha y no llega al tercer item
#   nombrar :EstrategiaUntil
#
#   forma_de_resolver do |unMetodo,otroMetodo|
#     metodo1=evaluar unMetodo
#     metodo2=evaluar otroMetodo
#     comporta=self.comportamiento
#
#     #Que vaya llamando los metodos con
#     #flictivos pero aplicando una condicion con el ultimo valor de retorno para
#     #saber si devolver ese valor o si probar con el siguiente metodo. Por ejemplo: Se puede pasar una funcion que
#     #compare si un numero es positivo. Entonces si tenemos un con
#     #flicto con 3 mensajes t1 m, t2 m, t 3m, se
#     #llamara primero a t1 m y se aplica la funcion. Si t1 m devuelve 5, se devuelve 5. Sino se llamara a t2 m , y
#     #asi sucesivamente
#
#     proc {|*args|
#       elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Uno_EsElQueSigueAContinuacion=instance_exec(*args,&metodo1)
#       elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Dos_EsElQueSigueAContinuacion=instance_exec(*args,&metodo2)
#
#
#
#       if instance_exec( elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Uno_EsElQueSigueAContinuacion,&comporta) then
#         unaVariableLocalYALaMier = elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Uno_EsElQueSigueAContinuacion
#       end
#
#       if instance_exec( elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Dos_EsElQueSigueAContinuacion,&comporta) then
#         unaVariableLocalYALaMier = elResultadoDelMetodoEjecutadoDeFormaLocalParaElMetodo_Dos_EsElQueSigueAContinuacion
#       end
#
#     # rescue NoMethodError
#     #   raise "NoHayMetodoParaNadieYSanSeAcabo"
#
#
#       unaVariableLocalYALaMier
#     }
#
#   end
#
# end



Estrategia.define do

  nombrar :EstrategiaDefault

  forma_de_resolver do |unMetodo,otroMetodo|
    proc {raise 'Hay metodos conflictivos entre traits'}
  end

end


