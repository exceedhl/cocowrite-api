require 'util/em-popen3'

module Cocowrite
  module DocumentConverter

    LATEX_TEMPLATE_DIR = CONFIG['document']['latex_template_dir']
    TARGET_DIR = CONFIG['document']['target_dir']
    LATEX_ENGINE = CONFIG['document']['latex_engine']

    def self.run_pandoc(source, target, template)
      f = Fiber.current
      status = :pending
      log = ''
      p = EM.popen3("pandoc -N --template=#{LATEX_TEMPLATE_DIR}/#{template}.tex --latex-engine=#{LATEX_ENGINE} --toc -o #{TARGET_DIR}/#{target}", {
          :stdout => Proc.new { |data| log += data },
          :stderr => Proc.new { |data| log += data }
        })
      p.callback do
        status = :compilation_succeed
        f.resume
      end
      p.errback do |err_code|
        status = :compilation_fail
        f.resume
      end
      p.send_data_and_close_stdin source
      Fiber.yield
      return [status, log]
    end
  end
end
