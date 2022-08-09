module AttentiveSidekiq
  module Middleware
    module Server
      class Attentionist
        def call(worker_instance, item, queue)
          reliable_job = item["attentive_reliable"]

          if reliable_job
            AttentiveSidekiq.logger.info("AttentiveSidekiq will monitor job: #{item}")
            Suspicious.add(item)
          end

          yield
        ensure
          if reliable_job
            Suspicious.remove(item['jid'])
            Disappeared.remove(item['jid'])
          end
        end
      end
    end
  end
end
