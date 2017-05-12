class Pgcalc

	def initialize(ram, connections)
		@ram = ram
		@ram_in_kb = ram * 1073741824
		@connections = connections
		@settings = {
				max_connections: @connections,
				shared_buffers: (@ram_in_kb.to_f / 4.to_f).floor.to_i / 1048576,
				effective_cache_size: (@ram_in_kb.to_f * 0.75).floor.to_i / 1048576,
				work_mem: 0,
				maintenance_work_mem: (@ram_in_kb.to_f / 16.to_f).floor.to_i / 1048576,
				min_wal_size: '1GB',
				max_wal_size: '2GB',
				checkpoint_completion_target: '0.7',
				wal_buffers: 0,
				default_statistics_target: '100'
		}
		@metrics = { 'MB': [:shared_buffers, :effective_cache_size, :maintenance_work_mem], 'kB': [:wal_buffers, :work_mem] }
		calculate
	end

	def calculate
		wal_buffers = ((0.03 * @settings[:shared_buffers].to_f) * 1024).to_i
		if wal_buffers > 15000
			@settings[:wal_buffers] = '16MB'
		else
			@settings[:wal_buffers] = wal_buffers
		end
		work_mem = (@ram_in_kb - @settings[:shared_buffers]) / 2
		@settings[:work_mem] = work_mem / (@settings[:max_connections] * 2) / 1024
	end

	def to_s
		s = []
		@settings.each do |k,v|
			str = "#{k} = #{v}"
			if ['kb', 'gb', 'mb'].include?(str.downcase[-2, 2])
				s << str
				next
			end
			met = nil
			@metrics.each do |m, ary|
				if ary.include?(k)
					met = m
					break
				end
			end
			s << "#{str}#{met}"
		end
		s.join("\n")
	end

end
