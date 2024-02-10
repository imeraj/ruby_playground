module Rulers
  class Routing
    def self.get_controller_and_action(env)
      _, cont, action, _ = env['PATH_INFO'].split('/', 4)
      cont = cont.capitalize + "Controller"

      [Object.const_get(cont), action]
    end
  end
end