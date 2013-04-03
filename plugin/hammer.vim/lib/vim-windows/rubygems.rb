# Vim on Windows cannot find any gems, without this hack.
Gem.source_index.find_name(//).each do |spec|
  spec.require_paths.each do |require_path|
    $LOAD_PATH.push File.join(spec.full_gem_path, require_path)
  end
end	

