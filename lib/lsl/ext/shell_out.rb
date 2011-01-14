class String
  def output_to_array
    split("\n").select { |x| x.present? }.map { |x| x.strip }.tap { |x| x.raw_str = self }
  end
end

def ec_array(cmd)
  LSL.my_ec(cmd).output_to_array
end

def ec_all(cmd)
  cmd = "#{cmd} 2>&1"
  `#{cmd}`
end
