module Definidor
  def define &bloque
    raise 'Define invocado sin un bloque' unless block_given?

    instancia = self.new
    instancia.instance_eval &bloque

    Object.const_set(instancia.nombre, instancia)
  end
end