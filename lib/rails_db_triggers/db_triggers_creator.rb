class RailsDbTriggers::DbTriggersCreator
  attr_reader :triggers

  def initialize
    @triggers = {}
  end

  def register_files files
    files.each do |file|
      trigger_name = File.basename(file, File.extname(file))

      content = File.read(file)
      content_lines = content.split("\n")

      # Reject the commented lines from the file
      sql_content = content_lines.reject{ |x| x.strip =~ /^--/ || x.strip =~ /^#/ }.join("\n")

      file_obj = { path: file, sql_content: sql_content, status: :none, requires: [] }

      # Detect directives in commentary
      directives = content_lines.select{ |x| x.strip =~ /^--/ || x.strip =~ /^#/ }.map(&:strip).map{ |x| 
        x =~ /^--/ ? x[2..-1] : x[1..-1]
      }.select{|x| x =~ /^!/ }

      directives.each do |directive|
        if directive =~ /^!require / #Currently only the require directive exists.
          file_obj[:requires] += directive.split(" ")[1..-1]
        end
      end

      if @triggers[trigger_name]
        puts "WARNING: #{trigger_name} already defined in `#{@triggers[trigger_name][:path]}`. Will be ignored and we use `#{file_obj[:path]}`..."
      end

      @triggers[trigger_name] = file_obj
    end
  end

  def drop_triggers
    reset_triggers_status!
    @triggers.each{ |name, trigger|
      drop_trigger name, trigger
    }
  end

  def create_triggers
    reset_triggers_status!
    @triggers.each{ |name, trigger|
      create_trigger name, trigger
    }
  end

private
  def reset_triggers_status!
    @triggers.each{ |name, trigger|
      trigger[:status] = :none
    }
  end


  def drop_trigger name, trigger
    return if trigger[:status] == :loaded

    if trigger[:status] == :inprogress
      raise "Error: Circular file reference! (trigger #{name})"
    end

    trigger[:requires].each do |other_trigger|
      drop_trigger other_trigger, @triggers[other_trigger]
    end

    table_name = (Rails.configuration.rails_db_triggers[:triggers_dbschema] || []).clone
    table_name << "[#{name}]"
    full_name = table_name.join('.')

    sql = "DROP TRIGGER #{full_name}"
    begin
      ActiveRecord::Base.connection.execute(sql)
      puts "DROP TRIGGER #{full_name}... OK"
    rescue
      puts "WARNING: DROP TRIGGER #{full_name}... ERROR"
    end

    trigger[:status] = :loaded
  end

  def create_trigger name, trigger
    # skip empty sql content
    if trigger[:sql_content].strip.blank?
      puts "TRIGGER #{name} EMPTY... SKIPPING"
      return
    end

    # trigger already loaded.
    return if trigger[:status] == :loaded

    if trigger[:status] == :inprogress
      raise "Error: Circular file reference! (trigger #{name})"
    end

    trigger[:status] = :inprogress

    trigger[:requires].each do |other_trigger|
      create_trigger other_trigger, @triggers[other_trigger]
    end

    table_name = (Rails.configuration.rails_db_triggers[:triggers_dbschema] || []).clone
    table_name << "[#{name}]"
    full_name = table_name.join('.')
    sql = "CREATE TRIGGER #{full_name} #{trigger[:sql_content]}"
    ActiveRecord::Base.connection.execute(sql)
    puts "CREATE TRIGGER #{full_name} ... OK"

    trigger[:status] = :loaded
  end

end
