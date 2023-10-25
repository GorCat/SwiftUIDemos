# frozen_string_literal: true

class ResolveFileNamePrefix

  def initialize(origin_file, options = {})
    @origin_file = origin_file
    if options[:exclude_file_ext].nil?
      options[:exclude_file_ext] = %w[.svga .png .gif .jpg .ttf .otf, .framework, .plist]
    end

    @options = options
  end

  def resolve_prefix(prefix, other_prefix)
    resolve_dir_prefix(@origin_file, prefix, other_prefix) if File.directory? @origin_file
    resolve_file_prefix(@origin_file, prefix, other_prefix) if File.file? @origin_file
  end

  def resolve_dir_prefix(dir_path, prefix, other_prefix)
    return if File.basename(dir_path).start_with? '.'

    Dir.foreach dir_path do |file|
      entire_file = File.join(dir_path, file)

      resolve_dir_prefix(entire_file, prefix, other_prefix) if File.directory? entire_file
      resolve_file_prefix(entire_file,prefix, other_prefix)
    end
  end

  def resolve_file_prefix(file_path, prefix, other_prefix)
    return if File.basename(file_path).start_with? '.'

    resolve_file_content(file_path, prefix, other_prefix)

    base_name = File.basename file_path
    dir_name = File.dirname file_path
    new_name = base_name
    if base_name.start_with? prefix.upcase
      new_name = base_name.sub(prefix.upcase, other_prefix.upcase)
    elsif base_name.start_with? prefix.downcase
      new_name = base_name.sub(prefix.downcase, other_prefix.downcase)
    end

    new_path = File.join dir_name, new_name
    File.rename file_path, new_path
  end

  def resolve_file_content(file_path, prefix, other_prefix)
    return unless File.file?(file_path)

    unless @options[:exclude_file_ext].nil?
      exclude_file_ext = @options[:exclude_file_ext]
      extname = File.extname(file_path)
      return if exclude_file_ext.include? extname
    end

    new_file_path = File.join(File.dirname(file_path), ".~#{File.basename(file_path)}")
    new_file = File.open(new_file_path, 'w+')
    file = File.open(file_path)

    handle_file(file, new_file, prefix, other_prefix)

    new_file.close
    file.close
    File.rename new_file_path, file_path
  end

  def handle_file(file, new_file, prefix, other_prefix)
    new_file.write(handle_line(file.readline, prefix, other_prefix)) until file.eof?
  end

  def handle_line(line, prefix, other_prefix)
    new_line = line.gsub(prefix.upcase, other_prefix.upcase)
    new_line.gsub(prefix.downcase, other_prefix.downcase)
  end
end
