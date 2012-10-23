module Databasedotcom
  module Sobject
    # Parent class of dynamically created sobject types. Interacts with Force.com through a Client object that is passed in during materialization.
    class Sobject
      cattr_accessor :client
      extend ActiveModel::Naming if defined?(ActiveModel::Naming)

      def ==(other)
        return false unless other.is_a?(self.class)
        self.Id == other.Id
      end

      # Returns a new Sobject. The default values for all attributes are set based on its description.
      def initialize(attrs = {})
        super()
        self.class.description["fields"].each do |field|
          self.send("#{field["name"]}=", field["defaultValueFormula"])
        end
        self.attributes=(attrs)
      end

      # Returns a hash representing the state of this object
      def attributes
        self.class.attributes.inject({}) do |hash, attr|
          hash[attr] = self.send(attr.to_sym)
          hash
        end
      end
      
      # Set attributes of this object, from a hash, in bulk
      def attributes=(attrs)
        attrs.each do |key, value|
          self.send("#{key}=", value)
        end
      end

      # Returns true if the object has been persisted in the Force.com database.
      def persisted?
        !self.Id.nil?
      end

      # Returns true if this record has not been persisted in the Force.com database.
      def new_record?
        !self.persisted?
      end

      # Returns self.
      def to_model
        self
      end

      # Returns a unique object id for self.
      def to_key
        [object_id]
      end

      # Returns the Force.com Id for this instance.
      def to_param
        self.Id
      end

      # Updates the corresponding record on Force.com by setting the attribute +attr_name+ to +attr_value+.
      #
      #    client.materialize("Car")
      #    c = Car.new
      #    c.update_attribute("Color", "Blue")
      def update_attribute(attr_name, attr_value)
        update_attributes(attr_name => attr_value)
      end

      # Updates the corresponding record on Force.com with the attributes specified by the +new_attrs+ hash.
      #
      #    client.materialize("Car")
      #    c = Car.new
      #    c.update_attributes {"Color" => "Blue", "Year" => "2012"}
      def update_attributes(new_attrs)
        if self.client.update(self.class, self.Id, new_attrs)
          new_attrs = new_attrs.is_a?(Hash) ? new_attrs : JSON.parse(new_attrs)
          new_attrs.each do |attr, value|
            self.send("#{attr}=", value)
          end
        end
        self
      end

      # Updates the corresponding record on Force.com with the attributes of self.
      #
      #    client.materialize("Car")
      #    c = Car.find_by_Color("Yellow")
      #    c.Color = "Green"
      #    c.save
      def save
        attr_hash = {}
        selection_attr = self.Id.nil? ? "createable" : "updateable"
        self.class.description["fields"].select { |f| f[selection_attr] }.collect { |f| f["name"] }.each { |attr| attr_hash[attr] = self.send(attr) }

        if self.Id.nil?
          self.Id = self.client.create(self.class, attr_hash).Id
        else
          self.client.update(self.class, self.Id, attr_hash)
        end
      end

      # Deletes the corresponding record from the Force.com database. Returns self.
      #
      #    client.materialize("Car")
      #    c = Car.find_by_Color("Yellow")
      #    c.delete
      def delete
        if self.client.delete(self.class, self.Id)
          self
        end
      end

      # Reloads the record from the Force.com database. Returns self.
      #
      #    client.materialize("Car")
      #    c = Car.find_by_Color("Yellow")
      #    c.reload
      def reload
        self.attributes = self.class.find(self.Id).attributes
        self
      end

      # Get a named attribute on this object
      def [](attr_name)
        self.send(attr_name) rescue nil
      end

      # Set a named attribute on this object
      def []=(attr_name, value)
        raise ArgumentError.new("No attribute named #{attr_name}") unless self.class.attributes.include?(attr_name)
        self.send("#{attr_name}=", value)
      end

      # Returns an Array of attribute names that this Sobject has.
      #
      #    client.materialize("Car")
      #    Car.attributes               #=> ["Id", "Name", "Color", "Year"]
      def self.attributes
        self.description["fields"].collect { |f| [f["name"], f["relationshipName"]] }.flatten.compact
      end

      # Materializes the dynamically created Sobject class by adding all attribute accessors for each field as described in the description of the object on Force.com
      def self.materialize(sobject_name)
        self.cattr_accessor :description
        self.cattr_accessor :type_map
        self.cattr_accessor :sobject_name

        self.sobject_name = sobject_name
        self.description = self.client.describe_sobject(self.sobject_name)
        self.type_map = {}

        self.description["fields"].each do |field|

          # Register normal fields
          name = field["name"]
          register_field( field["name"], field )

          # Register relationship fields.
          if( field["type"] == "reference" and field["relationshipName"] )
            register_field( field["relationshipName"], field )
          end

        end
      end

      # Returns the Force.com type of the attribute +attr_name+. Raises ArgumentError if attribute does not exist.
      #
      #    client.materialize("Car")
      #    Car.field_type("Color")    #=> "string"
      def self.field_type(attr_name)
        self.type_map_attr(attr_name, :type)
      end

      # Returns the label for the attribute +attr_name+. Raises ArgumentError if attribute does not exist.
      def self.label_for(attr_name)
        self.type_map_attr(attr_name, :label)
      end

      # Returns the possible picklist options for the attribute +attr_name+. If +attr_name+ is not of type picklist or multipicklist, [] is returned. Raises ArgumentError if attribute does not exist.
      def self.picklist_values(attr_name)
        self.type_map_attr(attr_name, :picklist_values)
      end

      # Returns true if the attribute +attr_name+ can be updated. Raises ArgumentError if attribute does not exist.
      def self.updateable?(attr_name)
        self.type_map_attr(attr_name, :updateable?)
      end

      # Returns true if the attribute +attr_name+ can be created. Raises ArgumentError if attribute does not exist.
      def self.createable?(attr_name)
        self.type_map_attr(attr_name, :createable?)
      end

      # Delegates to Client.find with arguments +record_id+ and self
      #
      #    client.materialize("Car")
      #    Car.find("rid")    #=>   #<Car @Id="rid", ...>
      def self.find(record_id)
        self.client.find(self, record_id)
      end

      # Returns all records of type self as instances.
      #
      #    client.materialize("Car")
      #    Car.all    #=>   [#<Car @Id="1", ...>, #<Car @Id="2", ...>, #<Car @Id="3", ...>, ...]
      def self.all
        self.client.query("SELECT #{self.field_list} FROM #{self.sobject_name}")
      end

      # Returns a collection of instances of self that match the conditional +where_expr+, which is the WHERE part of a SOQL query.
      #
      #    client.materialize("Car")
      #    Car.query("Color = 'Blue'")    #=>   [#<Car @Id="1", @Color="Blue", ...>, #<Car @Id="5", @Color="Blue", ...>, ...]
      def self.query(where_expr)
        self.client.query("SELECT #{self.field_list} FROM #{self.sobject_name} WHERE #{where_expr}")
      end

      # Delegates to Client.search
      def self.search(sosl_expr)
        self.client.search(sosl_expr)
      end

      # Find the first record. If the +where_expr+ argument is present, it must be the WHERE part of a SOQL query
      def self.first(where_expr=nil)
        where = where_expr ? "WHERE #{where_expr} " : ""
        self.client.query("SELECT #{self.field_list} FROM #{self.sobject_name} #{where}ORDER BY Id ASC LIMIT 1").first
      end

      # Find the last record. If the +where_expr+ argument is present, it must be the WHERE part of a SOQL query
      def self.last(where_expr=nil)
        where = where_expr ? "WHERE #{where_expr} " : ""
        self.client.query("SELECT #{self.field_list} FROM #{self.sobject_name} #{where}ORDER BY Id DESC LIMIT 1").first
      end

      #Delegates to Client.upsert with arguments self, +field+, +values+, and +attrs+
      def self.upsert(field, value, attrs)
        self.client.upsert(self.sobject_name, field, value, attrs)
      end

      # Delegates to Client.delete with arguments +record_id+ and self
      def self.delete(record_id)
        self.client.delete(self.sobject_name, record_id)
      end

      # Get the total number of records
      def self.count
        self.client.query("SELECT COUNT() FROM #{self.sobject_name}").total_size
      end

      # Sobject objects support dynamic finders similar to ActiveRecord.
      #
      #    client.materialize("Car")
      #    Car.find_by_Color("Blue")
      #    Car.find_all_by_Year("2011")
      #    Car.find_by_Color_and_Year("Blue", "2011")
      #    Car.find_or_create_by_Year("2011")
      #    Car.find_or_initialize_by_Name("Foo")
      def self.method_missing(method_name, *args, &block)
        if method_name.to_s =~ /^find_(or_create_|or_initialize_)?by_(.+)$/ || method_name.to_s =~ /^find_(all_)by_(.+)$/
          named_attrs = $2.split('_and_')
          attrs_and_values_for_find = {}
          hash_args = args.length == 1 && args[0].is_a?(Hash)
          attrs_and_values_for_write = hash_args ? args[0] : {}

          named_attrs.each_with_index do |attr, index|
            value = hash_args ? args[0][attr] : args[index]
            attrs_and_values_for_find[attr] = value
            attrs_and_values_for_write[attr] = value unless hash_args
          end

          limit_clause = method_name.to_s.include?('_all_by_') ? "" : " LIMIT 1"

          results = self.client.query("SELECT #{self.field_list} FROM #{self.sobject_name} WHERE #{soql_conditions_for(attrs_and_values_for_find)}#{limit_clause}")
          results = limit_clause == "" ? results : results.first rescue nil

          if results.nil?
            if method_name.to_s =~ /^find_or_create_by_(.+)$/
              results = self.client.create(self, attrs_and_values_for_write)
            elsif method_name.to_s =~ /^find_or_initialize_by_(.+)$/
              results = self.new
              attrs_and_values_for_write.each { |attr, val| results.send("#{attr}=", val) }
            end
          end

          results
        else
          super
        end
      end

      # Delegates to Client.create with arguments +object_attributes+ and self
      def self.create(object_attributes)
        self.client.create(self, object_attributes)
      end

      # Coerce values submitted from a Rails form to the values expected by the database
      # returns a new hash with updated values
      def self.coerce_params(params)
        params.each do |attr, value|
          case self.field_type(attr)
            when "boolean"
              params[attr] = value.is_a?(String) ? value.to_i != 0 : value
            when "currency", "percent", "double"
              params[attr] = value.to_f
            when "date"
              params[attr] = Date.parse(value) rescue Date.today
            when "datetime"
              params[attr] = DateTime.parse(value) rescue DateTime.now
          end
        end
      end

      private

      def self.register_field( name, field )
        public
        attr_accessor name.to_sym
        private
        self.type_map[name] = {
          :type => field["type"],
          :label => field["label"],
          :picklist_values => field["picklistValues"],
          :updateable? => field["updateable"],
          :createable? => field["createable"]
        }
      end

      def self.field_list
        self.description['fields'].collect { |f| f['name'] }.join(',')
      end

      def self.type_map_attr(attr_name, key)
        raise ArgumentError.new("No attribute named #{attr_name}") unless self.type_map.has_key?(attr_name)
        self.type_map[attr_name][key]
      end

      def self.soql_conditions_for(params)
        params.inject([]) do |arr, av|
          case av[1]
            when String
              value_str = "'#{av[1].gsub("'", "\\\\'")}'"
            when DateTime, Time
              value_str = av[1].strftime(RUBY_VERSION.match(/^1.8/) ? "%Y-%m-%dT%H:%M:%S.000%z" : "%Y-%m-%dT%H:%M:%S.%L%z").insert(-3, ":")
            else
              value_str = av[1].to_s
          end

          arr << "#{av[0]} = #{value_str}"
          arr
        end.join(" AND ")
      end
    end
  end
end
