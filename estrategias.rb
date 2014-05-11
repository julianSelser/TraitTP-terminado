# Todas las estrategias deben devolver un hash con los nombres de todos los metodos
# de los traits inplicados en la resolucion del conflicto. la forma del hash es:
#     { nombreMetodo1 => bloqueMetodo1, nombreMetodo2 => bloqueMetodo2, ...}
#
# Esto se logra en el metodo resolver que es llamado en la deteccion de conflictos.
# El metodo resolver recibe todos los traits que va a usar una clase luego de
# haber aplicado algebras, etc.


class EstrategiaDefault

  #se puede refinar esto para que diga entre cuales hay conflicto
  def self.resolver(metodos)
    metodos.clone
  end

end