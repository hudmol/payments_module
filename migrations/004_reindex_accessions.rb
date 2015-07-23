Sequel.migration do

  up do
    now = Time.now
    self[:accession].update(:system_mtime => now)
  end


  down do
    # nothing
  end

end
