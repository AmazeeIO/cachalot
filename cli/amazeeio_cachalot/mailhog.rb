require_relative 'docker_service'

class Mailhog < DockerService

  def image_name
    'mailhog/mailhog'
  end

  def name
    'mailhog'
  end

  def container_name
    'mailhog.docker.amazee.io'
  end

  def domain
    'docker.amazee.io'
  end

  def run_cmd
    "docker run --restart=always -d -p 1025:1025 --expose 80 -u 0 --name=#{Shellwords.escape(self.container_name)} " \
    '-e MH_UI_BIND_ADDR=0.0.0.0:80 ' \
    '-e MH_API_BIND_ADDR=0.0.0.0:80 ' \
    '-e "AMAZEEIO=AMAZEEIO" ' \
    "#{Shellwords.escape(self.image_name)}"
  end
end
